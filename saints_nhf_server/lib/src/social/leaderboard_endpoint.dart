import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'profile_service.dart';

/// Global rankings by cards, streak and duels won.
class LeaderboardEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _limit = 20;

  Future<Leaderboard> top(Session session) async {
    final me = session.authenticated!.authUserId;
    final friendships = await Friendship.db.find(
      session,
      where: (t) => t.playerA.equals(me) | t.playerB.equals(me),
    );
    final friends = friendships
        .map((f) => f.playerA == me ? f.playerB : f.playerA)
        .toSet();

    // Cards: count published cards per player.
    final rows = await session.db.unsafeQuery(
      'SELECT c."authUserId", COUNT(*)::int AS n '
      'FROM user_saint_card c JOIN saint s ON s.id = c."saintId" '
      'WHERE s.status = \'published\' '
      'GROUP BY c."authUserId" ORDER BY n DESC LIMIT $_limit',
    );
    final cardCounts = <UuidValue, int>{
      for (final row in rows)
        UuidValue.fromString(row[0].toString()): row[1] as int,
    };

    final byStreakProfiles = await PlayerProfile.db.find(
      session,
      where: (t) => t.bestStreak > 0,
      orderBy: (t) => t.bestStreak.desc(),
      limit: _limit,
    );
    final byDuelsProfiles = await PlayerProfile.db.find(
      session,
      where: (t) => t.duelsWon > 0,
      orderBy: (t) => t.duelsWon.desc(),
      limit: _limit,
    );
    final ids = {
      ...cardCounts.keys,
      ...byStreakProfiles.map((p) => p.authUserId),
      ...byDuelsProfiles.map((p) => p.authUserId),
    };
    final profiles = ids.isEmpty
        ? <PlayerProfile>[]
        : await PlayerProfile.db.find(
            session,
            where: (t) => t.authUserId.inSet(ids),
          );
    final byId = {for (final p in profiles) p.authUserId: p};

    LeaderboardEntry entry(UuidValue id, int value) => LeaderboardEntry(
      authUserId: id,
      displayName: ProfileService.nameOf(byId[id]),
      value: value,
      isMe: id == me,
      isFriend: friends.contains(id),
    );

    return Leaderboard(
      byCards: [for (final e in cardCounts.entries) entry(e.key, e.value)],
      byStreak: [
        for (final p in byStreakProfiles) entry(p.authUserId, p.bestStreak),
      ],
      byDuelsWon: [
        for (final p in byDuelsProfiles) entry(p.authUserId, p.duelsWon),
      ],
    );
  }
}
