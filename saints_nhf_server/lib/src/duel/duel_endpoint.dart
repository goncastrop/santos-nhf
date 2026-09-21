import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'duel_service.dart';

/// Card duels against the machine or against friends.
class DuelEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _me(Session session) => session.authenticated!.authUserId;

  /// Owned saints that can be put in a deck (they have questions).
  Future<List<int>> eligibleSaintIds(Session session) {
    return DuelService.eligibleSaintIds(session, _me(session));
  }

  /// Deals the hand the next deck must be chosen from.
  Future<List<int>> dealHand(Session session) {
    return DuelService.dealHand(session, _me(session));
  }

  Future<DuelView> createVsMachine(Session session, List<int> deckSaintIds) {
    return DuelService.createVsMachine(session, _me(session), deckSaintIds);
  }

  Future<DuelView> challenge(
    Session session,
    UuidValue opponentId,
    List<int> deckSaintIds,
  ) {
    return DuelService.challenge(
      session,
      _me(session),
      opponentId,
      deckSaintIds,
    );
  }

  Future<DuelView> accept(Session session, int duelId, List<int> deckSaintIds) {
    return DuelService.accept(session, _me(session), duelId, deckSaintIds);
  }

  Future<void> decline(Session session, int duelId) {
    return DuelService.decline(session, _me(session), duelId);
  }

  Future<List<DuelSummary>> myDuels(Session session) {
    return DuelService.list(session, _me(session));
  }

  Future<DuelView> view(Session session, int duelId) {
    return DuelService.view(session, _me(session), duelId);
  }

  Future<DuelView> attack(
    Session session,
    int duelId,
    ScoreCategory category,
    int saintId,
  ) {
    return DuelService.attack(session, _me(session), duelId, category, saintId);
  }

  Future<DuelView> defend(Session session, int duelId, int saintId) {
    return DuelService.defend(session, _me(session), duelId, saintId);
  }

  Future<DuelView> answer(Session session, int duelId, int chosenIndex) {
    return DuelService.answer(session, _me(session), duelId, chosenIndex);
  }
}
