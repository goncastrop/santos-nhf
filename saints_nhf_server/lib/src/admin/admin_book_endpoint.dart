import 'package:serverpod/serverpod.dart';

import '../books/book_service.dart';
import '../generated/protocol.dart';
import 'admin_scope.dart';

/// Admin management of the recommended reading of each saint.
class AdminBookEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AppScope.admin};

  Future<List<SaintBook>> listFor(Session session, int saintId) =>
      BookService.listFor(session, saintId);

  /// Number of books per saint id, for the admin list.
  Future<Map<int, int>> counts(Session session) async {
    final books = await SaintBook.db.find(session);
    final counts = <int, int>{};
    for (final book in books) {
      counts[book.saintId] = (counts[book.saintId] ?? 0) + 1;
    }
    return counts;
  }

  Future<SaintBook> save(Session session, SaintBook book) async {
    final saint = await Saint.db.findById(session, book.saintId);
    if (saint == null) throw AdminException(message: 'Santo no encontrado.');
    BookService.validate(book);
    final cleaned = BookService.clean(book);
    if (cleaned.id == null) return SaintBook.db.insertRow(session, cleaned);
    return SaintBook.db.updateRow(session, cleaned);
  }

  Future<void> delete(Session session, int bookId) async {
    final book = await SaintBook.db.findById(session, bookId);
    if (book == null) return;
    await SaintBook.db.deleteRow(session, book);
  }

  /// Rewrites the order of a saint's books, [bookIds] listed as they should
  /// read. Ids that are not the saint's are ignored.
  Future<List<SaintBook>> reorder(
    Session session,
    int saintId,
    List<int> bookIds,
  ) async {
    return session.db.transaction((tx) async {
      final books = await SaintBook.db.find(
        session,
        where: (t) => t.saintId.equals(saintId),
        transaction: tx,
      );
      final byId = {for (final b in books) b.id!: b};
      var position = 0;
      for (final id in bookIds) {
        final book = byId[id];
        if (book == null) continue;
        await SaintBook.db.updateRow(
          session,
          book.copyWith(position: position++),
          transaction: tx,
        );
      }
      return BookService.listFor(session, saintId, transaction: tx);
    });
  }
}
