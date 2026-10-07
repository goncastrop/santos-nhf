import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../live/live_service.dart';

/// Deleting a player's account and everything that hangs off it.
class AccountService {
  /// The word the player has to type, in the app and checked here too, so a
  /// stray call cannot wipe an account.
  static const confirmationWord = 'BORRAR';

  /// Shown in past trivia results instead of the name of a deleted player.
  static const deletedName = 'Cuenta borrada';

  /// Deletes [authUserId] for good: the album, the games, the friends and
  /// the duels, and then the auth user, which takes the sign-in methods,
  /// the sessions and the player profile with it by cascade.
  ///
  /// The tables of the game only hold the user id, without a foreign key,
  /// so they are cleared here one by one. Duels go whole, also for the other
  /// player: half a duel cannot be shown. Revisions by an admin keep the
  /// change and lose the author.
  static Future<void> delete(
    Session session,
    UuidValue authUserId, {
    required String confirmation,
  }) async {
    if (confirmation.trim().toUpperCase() != confirmationWord) {
      throw AccountException(
        message: 'Escribí $confirmationWord para confirmar.',
      );
    }
    await session.db.transaction((tx) async {
      await UserSaintCard.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: tx,
      );
      await QuestionSeen.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: tx,
      );
      await LitanyRun.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: tx,
      );
      await UnlockRedemption.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: tx,
      );
      await LiveAnswer.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: tx,
      );
      await Friendship.db.deleteWhere(
        session,
        where: (t) =>
            t.playerA.equals(authUserId) | t.playerB.equals(authUserId),
        transaction: tx,
      );
      // Decks and rounds go with their duel by cascade.
      await Duel.db.deleteWhere(
        session,
        where: (t) =>
            t.challengerId.equals(authUserId) | t.opponentId.equals(authUserId),
        transaction: tx,
      );
      final revisions = await SaintRevision.db.find(
        session,
        where: (t) => t.changedByAuthUserId.equals(authUserId),
        transaction: tx,
      );
      if (revisions.isNotEmpty) {
        await SaintRevision.db.update(
          session,
          [for (final r in revisions) r.copyWith(changedByAuthUserId: null)],
          columns: (t) => [t.changedByAuthUserId],
          transaction: tx,
        );
      }
      await _scrubLiveResults(session, authUserId, tx);
      await PlayerProfile.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: tx,
      );
      await AuthServices.instance.authUsers.delete(
        session,
        authUserId: authUserId,
        transaction: tx,
      );
    });
    // The access token the app holds is still valid until it expires: this
    // closes the open streams and refuses it from now on.
    await session.messages.authenticationRevoked(
      authUserId.toString(),
      RevokedAuthenticationUser(),
    );
    LiveService.forgetSnapshot();
  }

  /// Past trivia results keep who won, by name: the name of a deleted player
  /// is replaced, and the card stays listed as given.
  static Future<void> _scrubLiveResults(
    Session session,
    UuidValue authUserId,
    Transaction tx,
  ) async {
    // Finished games only: the others have no results yet.
    final games = await LiveGame.db.find(
      session,
      where: (t) => t.phase.equals(LivePhase.finished),
      transaction: tx,
    );
    for (final game in games) {
      final results = game.results;
      if (results == null) continue;
      bool mine(LiveWinner w) => w.authUserId == authUserId;
      if (!results.fast.any(mine) && !results.raffle.any(mine)) continue;
      LiveWinner scrub(LiveWinner w) =>
          mine(w) ? w.copyWith(name: deletedName) : w;
      await LiveGame.db.updateRow(
        session,
        game.copyWith(
          results: results.copyWith(
            fast: results.fast.map(scrub).toList(),
            raffle: results.raffle.map(scrub).toList(),
          ),
        ),
        columns: (t) => [t.results],
        transaction: tx,
      );
    }
  }
}
