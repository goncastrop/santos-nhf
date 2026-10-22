import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../questions/contemporary_questions.dart';
import '../saints/saint_mapper.dart';

/// Which saints met in life. Nobody can derive it from the years: living at
/// the same time is not having met, so every pair is loaded by hand.
class MeetingService {
  /// The stored form of a pair: the lower id first, so A–B and B–A are the
  /// same row.
  static (int, int) pair(int a, int b) => a < b ? (a, b) : (b, a);

  /// Why [a] and [b] cannot have met, or null when they may have.
  ///
  /// Only rules out what the years make impossible, with the same margin for
  /// "c." dates as the contemporaries question. A saint missing a year is
  /// given the benefit of the doubt.
  static String? whyNot(Saint a, Saint b) {
    if (a.id == b.id) return 'un santo no puede conocerse a sí mismo';
    final la = Lifetime.of(a);
    final lb = Lifetime.of(b);
    if (la == null || lb == null) return null;
    if (la.possiblyTo < lb.possiblyFrom || lb.possiblyTo < la.possiblyFrom) {
      return '${a.name} y ${b.name} no vivieron en la misma época';
    }
    return null;
  }

  /// Ids of the saints [saintId] met, drafts included.
  static Future<Set<int>> idsFor(
    Session session,
    int saintId, {
    Transaction? transaction,
  }) async {
    final rows = await SaintMeeting.db.find(
      session,
      where: (t) => t.saintAId.equals(saintId) | t.saintBId.equals(saintId),
      transaction: transaction,
    );
    return {
      for (final m in rows) m.saintAId == saintId ? m.saintBId : m.saintAId,
    };
  }

  /// The saints [saintId] met, drafts included, in the order they were born.
  static Future<List<Saint>> saintsFor(
    Session session,
    int saintId, {
    bool publishedOnly = false,
    Transaction? transaction,
  }) async {
    final ids = await idsFor(session, saintId, transaction: transaction);
    if (ids.isEmpty) return const [];
    final saints = await Saint.db.find(
      session,
      where: (t) => publishedOnly
          ? t.id.inSet(ids) & t.status.equals(SaintStatus.published)
          : t.id.inSet(ids),
      transaction: transaction,
    );
    return byBirth(saints);
  }

  /// What the ficha shows: only published saints, as public info.
  static Future<List<SaintInfo>> publicFor(Session session, int saintId) async {
    final saints = await saintsFor(session, saintId, publishedOnly: true);
    return SaintMapper.toInfos(session, saints);
  }

  /// Records that [saintId] and [otherId] met. Already recorded is not an
  /// error: the result is the same.
  static Future<void> add(Session session, int saintId, int otherId) async {
    await session.db.transaction((tx) async {
      final saint = await _saint(session, saintId, tx);
      final other = await _saint(session, otherId, tx);
      final reason = whyNot(saint, other);
      if (reason != null) throw AdminException(message: _sentence(reason));
      final (a, b) = pair(saintId, otherId);
      final existing = await SaintMeeting.db.findFirstRow(
        session,
        where: (t) => t.saintAId.equals(a) & t.saintBId.equals(b),
        transaction: tx,
      );
      if (existing != null) return;
      await SaintMeeting.db.insertRow(
        session,
        SaintMeeting(saintAId: a, saintBId: b),
        transaction: tx,
      );
    });
  }

  /// Undoes [add]. Not recorded is not an error either.
  static Future<void> remove(Session session, int saintId, int otherId) async {
    final (a, b) = pair(saintId, otherId);
    await SaintMeeting.db.deleteWhere(
      session,
      where: (t) => t.saintAId.equals(a) & t.saintBId.equals(b),
    );
  }

  /// Oldest first; a saint without a birth year goes last, then by name.
  static List<Saint> byBirth(Iterable<Saint> saints) {
    return [...saints]..sort((x, y) {
      final bx = x.birthYear;
      final by = y.birthYear;
      if (bx != by) {
        if (bx == null) return 1;
        if (by == null) return -1;
        return bx.compareTo(by);
      }
      return x.name.compareTo(y.name);
    });
  }

  static Future<Saint> _saint(Session session, int id, Transaction tx) async {
    final saint = await Saint.db.findById(session, id, transaction: tx);
    if (saint == null) throw AdminException(message: 'Santo no encontrado.');
    return saint;
  }

  /// The reasons are written to sit inside a CSV error line; on their own
  /// they read as a sentence.
  static String _sentence(String reason) =>
      '${reason[0].toUpperCase()}${reason.substring(1)}.';
}
