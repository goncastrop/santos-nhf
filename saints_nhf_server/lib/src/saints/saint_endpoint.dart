import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import 'dart:convert';

import '../books/book_service.dart';
import '../collection/collection_service.dart';
import '../generated/protocol.dart';
import '../meetings/meeting_service.dart';
import 'saint_mapper.dart';
import 'score_category_x.dart';

/// Public catalog of published saints. No sign-in required.
class SaintEndpoint extends Endpoint {
  /// All published saints, ordered by name. Scores are never included.
  Future<List<SaintInfo>> list(Session session) async {
    final saints = await Saint.db.find(
      session,
      where: (t) => t.status.equals(SaintStatus.published),
      orderBy: (t) => t.name,
    );
    return SaintMapper.toInfos(session, saints);
  }

  /// A published saint by id, with the card when the caller owns it.
  Future<SaintDetail> detail(Session session, int saintId) async {
    final saint = await Saint.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(saintId) & t.status.equals(SaintStatus.published),
    );
    if (saint == null) {
      throw CollectionException(
        message: 'Santo no encontrado.',
        code: CollectionErrorCode.saintNotFound,
      );
    }
    final info = await SaintMapper.toInfo(session, saint);
    final authUserId = session.authenticated?.authUserId;
    CollectedCard? card;
    if (authUserId != null) {
      card = await CollectionService.cardFor(session, authUserId, saint);
    }
    final books = await BookService.listFor(session, saint.id!);
    final metSaints = await MeetingService.publicFor(session, saint.id!);
    return SaintDetail(
      saint: info,
      card: card,
      books: books,
      metSaints: metSaints,
    );
  }

  /// Recent score changes of published saints ("notas del parche"). Exact
  /// values are only included for cards the caller owns.
  Future<List<PatchNoteEntry>> recentChanges(Session session) async {
    final revisions = await SaintRevision.db.find(
      session,
      orderBy: (t) => t.createdAt.desc(),
      limit: 60,
    );
    if (revisions.isEmpty) return const [];
    final saintIds = revisions.map((r) => r.saintId).toSet();
    final saints = await Saint.db.find(
      session,
      where: (t) =>
          t.id.inSet(saintIds) & t.status.equals(SaintStatus.published),
    );
    final saintById = {for (final s in saints) s.id!: s};
    final infos = await SaintMapper.toInfos(session, saints);
    final infoById = {for (final i in infos) i.id: i};

    final authUserId = session.authenticated?.authUserId;
    final owned = <int>{};
    if (authUserId != null) {
      final cards = await UserSaintCard.db.find(
        session,
        where: (t) => t.authUserId.equals(authUserId),
      );
      owned.addAll(cards.map((c) => c.saintId));
    }

    // Revisions are snapshots *before* a change. The state after a change is
    // the next newer snapshot of the same saint, or the saint as it is now.
    final newerBySaint = <int, Saint>{};
    final entries = <PatchNoteEntry>[];
    for (final revision in revisions) {
      final current = saintById[revision.saintId];
      if (current == null) continue; // Draft or deleted saint.
      final before = Saint.fromJson(
        jsonDecode(revision.snapshotJson) as Map<String, dynamic>,
      );
      final after = newerBySaint[revision.saintId] ?? current;
      newerBySaint[revision.saintId] = before;
      final reveal = owned.contains(revision.saintId);
      final changes = [
        for (final c in ScoreCategory.values)
          if (scoreOf(before, c) != scoreOf(after, c))
            ScoreChange(
              category: c,
              increased: scoreOf(after, c) > scoreOf(before, c),
              from: reveal ? scoreOf(before, c) : null,
              to: reveal ? scoreOf(after, c) : null,
            ),
      ];
      if (changes.isEmpty) continue;
      entries.add(
        PatchNoteEntry(
          saint: infoById[revision.saintId]!,
          note: revision.note,
          changedAt: revision.createdAt,
          changes: changes,
        ),
      );
      if (entries.length >= 20) break;
    }
    return entries;
  }
}
