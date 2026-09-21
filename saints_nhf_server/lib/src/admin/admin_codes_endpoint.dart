import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'admin_scope.dart';

/// Admin management of unlock codes handed out during the stream.
class AdminCodesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AppScope.admin};

  static const _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final _random = Random.secure();

  Future<List<UnlockCode>> list(Session session) {
    return UnlockCode.db.find(session, orderBy: (t) => t.createdAt.desc());
  }

  /// Creates a code. With an empty [code] a random one is generated.
  Future<UnlockCode> create(
    Session session,
    String code,
    int? saintId,
    int? maxUses,
    DateTime? expiresAt,
    String? note,
  ) async {
    var normalized = code.trim().toUpperCase().replaceAll(' ', '');
    if (normalized.isEmpty) normalized = _generate();
    if (!RegExp(r'^[A-Z0-9-]{4,24}$').hasMatch(normalized)) {
      throw AdminException(
        message: 'El código solo puede tener letras, números y guiones.',
      );
    }
    final exists = await UnlockCode.db.findFirstRow(
      session,
      where: (t) => t.code.equals(normalized),
    );
    if (exists != null) {
      throw AdminException(message: 'Ya existe un código "$normalized".');
    }
    if (saintId != null && await Saint.db.findById(session, saintId) == null) {
      throw AdminException(message: 'Santo no encontrado.');
    }
    if (maxUses != null && maxUses < 1) {
      throw AdminException(message: 'Los usos máximos deben ser al menos 1.');
    }
    return UnlockCode.db.insertRow(
      session,
      UnlockCode(
        code: normalized,
        saintId: saintId,
        maxUses: maxUses,
        expiresAt: expiresAt?.toUtc(),
        note: note?.trim().isEmpty == true ? null : note?.trim(),
      ),
    );
  }

  Future<UnlockCode> setActive(Session session, int codeId, bool active) async {
    final code = await UnlockCode.db.findById(session, codeId);
    if (code == null) throw AdminException(message: 'Código no encontrado.');
    return UnlockCode.db.updateRow(session, code.copyWith(active: active));
  }

  Future<void> delete(Session session, int codeId) async {
    final code = await UnlockCode.db.findById(session, codeId);
    if (code == null) return;
    await UnlockCode.db.deleteRow(session, code);
  }

  String _generate() => List.generate(
    8,
    (_) => _alphabet[_random.nextInt(_alphabet.length)],
  ).join();
}
