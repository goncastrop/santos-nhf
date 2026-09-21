import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The recommended reading of a saint.
class BookService {
  /// Kinds that are the saint's own writing. The rest were written about
  /// them, and the two groups are shown apart.
  static const byTheSaint = {
    BookKind.obra,
    BookKind.autobiografia,
    BookKind.compilado,
  };

  /// Books of [saintId] in display order: the saint's own writing first, then
  /// each group by `position` and title.
  static Future<List<SaintBook>> listFor(
    Session session,
    int saintId, {
    Transaction? transaction,
  }) async {
    final books = await SaintBook.db.find(
      session,
      where: (t) => t.saintId.equals(saintId),
      transaction: transaction,
    );
    return sorted(books);
  }

  /// Books of many saints at once, keyed by saint id and already ordered.
  static Future<Map<int, List<SaintBook>>> listForAll(
    Session session,
    Iterable<int> saintIds,
  ) async {
    final ids = saintIds.toSet();
    if (ids.isEmpty) return const {};
    final books = await SaintBook.db.find(
      session,
      where: (t) => t.saintId.inSet(ids),
    );
    final bySaint = <int, List<SaintBook>>{};
    for (final book in books) {
      bySaint.putIfAbsent(book.saintId, () => []).add(book);
    }
    return {for (final e in bySaint.entries) e.key: sorted(e.value)};
  }

  static List<SaintBook> sorted(List<SaintBook> books) {
    return [...books]..sort((a, b) {
      final group = _groupOf(a).compareTo(_groupOf(b));
      if (group != 0) return group;
      final position = a.position.compareTo(b.position);
      if (position != 0) return position;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
  }

  static int _groupOf(SaintBook book) => byTheSaint.contains(book.kind) ? 0 : 1;

  static void validate(SaintBook book) {
    if (book.title.trim().isEmpty) {
      throw AdminException(message: 'El libro necesita un título.');
    }
    if (book.year != null && (book.year! < -1000 || book.year! > 2400)) {
      throw AdminException(message: 'El año del libro no parece válido.');
    }
    final url = book.url?.trim();
    if (url != null && url.isNotEmpty) {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        throw AdminException(message: 'El link del libro no es válido.');
      }
    }
  }

  /// Trims the free text and drops the fields left empty.
  static SaintBook clean(SaintBook book) => book.copyWith(
    title: book.title.trim(),
    author: _text(book.author),
    publisher: _text(book.publisher),
    note: _text(book.note),
    url: _text(book.url),
  );

  static String? _text(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
