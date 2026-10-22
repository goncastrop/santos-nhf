import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../questions/contemporary_questions.dart';
import '../saints/saint_mapper.dart';
import '../saints/saint_revisions.dart';
import 'admin_scope.dart';
import 'illustration_optimizer.dart';

/// Admin CRUD of the saints catalog, with a revision history.
class AdminSaintEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AppScope.admin};

  static const _allowedExtensions = {'png', 'jpg', 'jpeg', 'webp'};

  /// Largest illustration accepted, in bytes.
  static const maxIllustrationBytes = 6 * 1024 * 1024;

  /// Cache header stored with every illustration. A year, and immutable:
  /// replacing an image changes the `?v=` of its public URL, so a stale copy
  /// is never served.
  static const illustrationCacheControl = 'public, max-age=31536000, immutable';

  /// Every saint, drafts included, ordered by name.
  Future<List<Saint>> listAll(Session session) {
    return Saint.db.find(session, orderBy: (t) => t.name);
  }

  /// A saint by id, drafts included.
  Future<Saint> get(Session session, int saintId) async {
    final saint = await Saint.db.findById(session, saintId);
    if (saint == null) throw AdminException(message: 'Santo no encontrado.');
    return saint;
  }

  /// Public URL of the illustration of a saint, if any.
  Future<String?> illustrationUrl(Session session, int saintId) async {
    final saint = await get(session, saintId);
    return SaintMapper.illustrationUrl(session, saint.illustrationPath);
  }

  /// Creates or updates a saint. On update, the previous state is kept as a
  /// [SaintRevision] with [note] describing the change.
  Future<Saint> save(Session session, Saint saint, String? note) async {
    _validate(saint);
    final now = DateTime.now().toUtc();
    if (saint.id == null) {
      await _ensureSlugFree(session, saint.slug, null);
      final created = await Saint.db.insertRow(
        session,
        saint.copyWith(createdAt: now, updatedAt: now),
      );
      await ContemporaryQuestions.refresh(session);
      return created;
    }
    final updated = await session.db.transaction((tx) async {
      final previous = await Saint.db.findById(
        session,
        saint.id!,
        transaction: tx,
      );
      if (previous == null) {
        throw AdminException(message: 'Santo no encontrado.');
      }
      await _ensureSlugFree(session, saint.slug, saint.id, transaction: tx);
      await recordRevision(session, previous, note, transaction: tx);
      return Saint.db.updateRow(
        session,
        saint.copyWith(
          createdAt: previous.createdAt,
          // The illustration is managed through the upload methods.
          illustrationPath: previous.illustrationPath,
          updatedAt: now,
        ),
        transaction: tx,
      );
    });
    // After the commit: the questions are built from what is stored.
    await ContemporaryQuestions.refresh(session);
    return updated;
  }

  /// Deletes a saint and, by cascade, its revisions and collected cards.
  Future<void> delete(Session session, int saintId) async {
    final saint = await get(session, saintId);
    await Saint.db.deleteRow(session, saint);
    // Its own questions go by cascade; the ones that offered it as an option
    // have to be rebuilt.
    await ContemporaryQuestions.refresh(session);
  }

  /// Revision history of a saint, newest first.
  Future<List<SaintRevision>> revisions(Session session, int saintId) {
    return SaintRevision.db.find(
      session,
      where: (t) => t.saintId.equals(saintId),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  /// Decodes the saint stored in a revision.
  Future<Saint> revisionSnapshot(Session session, int revisionId) async {
    final revision = await SaintRevision.db.findById(session, revisionId);
    if (revision == null) {
      throw AdminException(message: 'Revisión no encontrada.');
    }
    return Saint.fromJson(
      jsonDecode(revision.snapshotJson) as Map<String, dynamic>,
    );
  }

  /// Restores a saint to the state stored in [revisionId]. The current state
  /// is saved as a new revision first.
  Future<Saint> restore(Session session, int revisionId, String? note) async {
    final snapshot = await revisionSnapshot(session, revisionId);
    return save(
      session,
      snapshot,
      note ?? 'Restaurado a la revisión $revisionId',
    );
  }

  /// Stores the illustration of a saint, sent as bytes by the admin app.
  ///
  /// The image travels through the server instead of going straight to the
  /// storage bucket. A browser upload directly to the bucket is blocked by
  /// the bucket's cross-origin rules, and routing it here keeps one code
  /// path for every platform and for both the database and cloud storages.
  ///
  /// Keep [maxIllustrationBytes] in sync with the app, and both below the
  /// server's `maxRequestSize`: the bytes are base64 encoded in the request,
  /// which adds about a third to their size.
  Future<Saint> uploadIllustration(
    Session session,
    int saintId,
    String extension,
    ByteData bytes,
  ) async {
    // Checked before converting: ImageMagick would happily turn a PDF into
    // a WebP too.
    _checkExtension(extension);
    if (bytes.lengthInBytes == 0) {
      throw AdminException(message: 'El archivo está vacío.');
    }
    if (bytes.lengthInBytes > maxIllustrationBytes) {
      throw AdminException(
        message:
            'La imagen supera el máximo de '
            '${maxIllustrationBytes ~/ (1024 * 1024)} MB.',
      );
    }
    final saint = await get(session, saintId);
    // The originals come straight from the illustrator, at print size. Only
    // when the conversion is not possible does the original stay.
    final optimized = await IllustrationOptimizer.optimize(
      session,
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );
    final path = await _illustrationPath(
      session,
      saintId,
      optimized == null ? extension : 'webp',
    );
    await session.storage.storeFile(
      storageId: SaintMapper.storageId,
      path: path,
      byteData: optimized == null ? bytes : ByteData.sublistView(optimized),
      options: StoreFileOptions(
        metadata: FileMetadata(
          contentType: _contentTypeOf(path),
          // The path of an illustration never changes, so the bytes behind a
          // URL can only change when the admin replaces the image. The public
          // URL carries `?v=<updatedAt>` (see `SaintMapper`), which changes on
          // every replacement, so the client asks for a new URL instead of
          // revalidating this one. Anything shorter only costs round trips.
          cacheControl: illustrationCacheControl,
        ),
      ),
    );
    final previousPath = saint.illustrationPath;
    final updated = await Saint.db.updateRow(
      session,
      saint.copyWith(illustrationPath: path, updatedAt: DateTime.now().toUtc()),
    );
    if (previousPath != null && previousPath != path) {
      await session.storage.deleteFile(
        storageId: SaintMapper.storageId,
        path: previousPath,
      );
    }
    return updated;
  }

  static String _contentTypeOf(String path) => switch (path.split('.').last) {
    'png' => 'image/png',
    'webp' => 'image/webp',
    _ => 'image/jpeg',
  };

  /// Storage path of a saint's illustration. Deterministic, so replacing an
  /// image overwrites the previous one; the public URL carries a version
  /// query for cache busting.
  Future<String> _illustrationPath(
    Session session,
    int saintId,
    String extension,
  ) async {
    final ext = _checkExtension(extension);
    await get(session, saintId);
    return 'saints/$saintId/illustration.$ext';
  }

  /// The extension, normalized, or an error when it is not an image format
  /// the app takes.
  static String _checkExtension(String extension) {
    final ext = extension.toLowerCase().replaceFirst('.', '');
    if (!_allowedExtensions.contains(ext)) {
      throw AdminException(
        message: 'Formato de imagen no permitido. Usá PNG, JPG o WEBP.',
      );
    }
    return ext;
  }

  Future<void> _ensureSlugFree(
    Session session,
    String slug,
    int? selfId, {
    Transaction? transaction,
  }) async {
    final other = await Saint.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug),
      transaction: transaction,
    );
    if (other != null && other.id != selfId) {
      throw AdminException(message: 'Ya existe un santo con el slug "$slug".');
    }
  }

  /// Lowercase letters, digits and single hyphens between words.
  static bool _isValidSlug(String slug) {
    if (slug.isEmpty) return false;
    final parts = slug.split('-');
    const allowed = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return parts.every(
      (p) => p.isNotEmpty && p.split('').every(allowed.contains),
    );
  }

  void _validate(Saint saint) {
    if (saint.name.trim().isEmpty) {
      throw AdminException(message: 'El nombre es obligatorio.');
    }
    if (!_isValidSlug(saint.slug)) {
      throw AdminException(
        message: 'El slug solo puede tener minúsculas, números y guiones.',
      );
    }
    final month = saint.feastMonth;
    final day = saint.feastDay;
    if ((month == null) != (day == null)) {
      throw AdminException(
        message: 'Completá mes y día de la fiesta, o ninguno.',
      );
    }
    if (month != null && (month < 1 || month > 12)) {
      throw AdminException(
        message: 'El mes de la fiesta debe estar entre 1 y 12.',
      );
    }
    if (day != null && (day < 1 || day > 31)) {
      throw AdminException(
        message: 'El día de la fiesta debe estar entre 1 y 31.',
      );
    }
    final scores = [
      saint.catequesis,
      saint.escritos,
      saint.oracion,
      saint.patronazgos,
      saint.evangelizacion,
      saint.viajes,
    ];
    if (scores.any((s) => s < 0 || s > 99)) {
      throw AdminException(message: 'Los puntajes deben estar entre 0 y 99.');
    }
    if (saint.status == SaintStatus.published && saint.bio.trim().isEmpty) {
      throw AdminException(
        message: 'Para publicar un santo, la biografía no puede estar vacía.',
      );
    }
  }
}
