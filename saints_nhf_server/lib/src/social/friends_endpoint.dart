import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../duel/duel_service.dart';
import '../generated/protocol.dart';
import '../saints/saint_mapper.dart';
import 'profile_service.dart';

/// Player identity, friend codes and friends' collections.
class FriendsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _me(Session session) => session.authenticated!.authUserId;

  Future<MyProfile> me(Session session) async {
    final profile = await ProfileService.ensure(session, _me(session));
    return _myProfile(session, profile);
  }

  Future<MyProfile> setDisplayName(Session session, String name) async {
    final trimmed = name.trim();
    if (trimmed.length < 2 || trimmed.length > 24) {
      throw SocialException(
        message: 'El nombre tiene que tener entre 2 y 24 caracteres.',
      );
    }
    var profile = await ProfileService.ensure(session, _me(session));
    profile = await PlayerProfile.db.updateRow(
      session,
      profile.copyWith(displayName: trimmed),
      columns: (t) => [t.displayName],
    );
    return _myProfile(session, profile);
  }

  /// Adds the player whose friend code is [code]. Friendship is immediate:
  /// the code is the invitation.
  Future<FriendSummary> addByCode(Session session, String code) async {
    final me = _me(session);
    final normalized = code.trim().toUpperCase();
    final other = await PlayerProfile.db.findFirstRow(
      session,
      where: (t) => t.friendCode.equals(normalized),
    );
    if (other == null) {
      throw SocialException(message: 'No encontramos a nadie con ese código.');
    }
    if (other.authUserId == me) {
      throw SocialException(message: 'Ese es tu propio código.');
    }
    final (lo, hi) = DuelService.sortedPair(me, other.authUserId);
    final existing = await Friendship.db.findFirstRow(
      session,
      where: (t) => t.playerA.equals(lo) & t.playerB.equals(hi),
    );
    final friendship =
        existing ??
        await Friendship.db.insertRow(
          session,
          Friendship(playerA: lo, playerB: hi),
        );
    return _summary(session, other, friendship.createdAt);
  }

  Future<List<FriendSummary>> list(Session session) async {
    final me = _me(session);
    final friendships = await Friendship.db.find(
      session,
      where: (t) => t.playerA.equals(me) | t.playerB.equals(me),
      orderBy: (t) => t.createdAt.desc(),
    );
    if (friendships.isEmpty) return const [];
    final ids = friendships
        .map((f) => f.playerA == me ? f.playerB : f.playerA)
        .toSet();
    final profiles = await PlayerProfile.db.find(
      session,
      where: (t) => t.authUserId.inSet(ids),
    );
    final byId = {for (final p in profiles) p.authUserId: p};
    final result = <FriendSummary>[];
    for (final f in friendships) {
      final otherId = f.playerA == me ? f.playerB : f.playerA;
      final profile = byId[otherId];
      if (profile == null) continue;
      result.add(await _summary(session, profile, f.createdAt));
    }
    return result;
  }

  Future<void> remove(Session session, UuidValue friendId) async {
    final (lo, hi) = DuelService.sortedPair(_me(session), friendId);
    await Friendship.db.deleteWhere(
      session,
      where: (t) => t.playerA.equals(lo) & t.playerB.equals(hi),
    );
  }

  /// The saints a friend has collected. Scores are not included.
  Future<FriendCollection> collectionOf(
    Session session,
    UuidValue friendId,
  ) async {
    final me = _me(session);
    final (lo, hi) = DuelService.sortedPair(me, friendId);
    final friendship = await Friendship.db.findFirstRow(
      session,
      where: (t) => t.playerA.equals(lo) & t.playerB.equals(hi),
    );
    if (friendship == null) {
      throw SocialException(message: 'Solo podés ver el álbum de tus amigos.');
    }
    final profile = await ProfileService.byUserId(session, friendId);
    if (profile == null) {
      throw SocialException(message: 'Jugador no encontrado.');
    }
    final cards = await UserSaintCard.db.find(
      session,
      where: (t) =>
          t.authUserId.equals(friendId) &
          t.saint.status.equals(SaintStatus.published),
      orderBy: (t) => t.obtainedAt.desc(),
      include: UserSaintCard.include(saint: Saint.include()),
    );
    final saints = await SaintMapper.toInfos(
      session,
      cards.map((c) => c.saint!).toList(),
    );
    return FriendCollection(
      friend: await _summary(session, profile, friendship.createdAt),
      saints: saints,
    );
  }

  Future<MyProfile> _myProfile(Session session, PlayerProfile profile) async {
    return MyProfile(
      authUserId: profile.authUserId,
      displayName: ProfileService.nameOf(profile),
      friendCode: profile.friendCode!,
      cards: await ProfileService.cardCount(session, profile.authUserId),
      streak: profile.streak,
      bestStreak: profile.bestStreak,
      duelsWon: profile.duelsWon,
      duelsPlayed: profile.duelsPlayed,
    );
  }

  Future<FriendSummary> _summary(
    Session session,
    PlayerProfile profile,
    DateTime since,
  ) async {
    return FriendSummary(
      authUserId: profile.authUserId,
      displayName: ProfileService.nameOf(profile),
      cards: await ProfileService.cardCount(session, profile.authUserId),
      streak: profile.streak,
      bestStreak: profile.bestStreak,
      duelsWon: profile.duelsWon,
      since: since,
    );
  }
}
