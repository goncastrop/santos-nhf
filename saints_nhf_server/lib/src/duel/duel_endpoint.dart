import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'duel_events.dart';
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

  Future<DuelView> createVsMachine(
    Session session,
    List<int> deckSaintIds,
  ) async {
    final view = await DuelService.createVsMachine(
      session,
      _me(session),
      deckSaintIds,
    );
    await DuelEvents.changed(session, view.duelId);
    return view;
  }

  Future<DuelView> challenge(
    Session session,
    UuidValue opponentId,
    List<int> deckSaintIds,
  ) async {
    final view = await DuelService.challenge(
      session,
      _me(session),
      opponentId,
      deckSaintIds,
    );
    await DuelEvents.changed(session, view.duelId);
    return view;
  }

  Future<DuelView> accept(
    Session session,
    int duelId,
    List<int> deckSaintIds,
  ) async {
    final view = await DuelService.accept(
      session,
      _me(session),
      duelId,
      deckSaintIds,
    );
    await DuelEvents.changed(session, duelId);
    return view;
  }

  Future<void> decline(Session session, int duelId) async {
    await DuelService.decline(session, _me(session), duelId);
    await DuelEvents.changed(session, duelId);
  }

  Future<List<DuelSummary>> myDuels(Session session) {
    return DuelService.list(session, _me(session));
  }

  Future<DuelView> view(Session session, int duelId) {
    return DuelService.view(session, _me(session), duelId);
  }

  /// The board now and again after every move, from either player.
  Stream<DuelView> watch(Session session, int duelId) async* {
    final me = _me(session);
    // Subscribed before the first read, so a move landing in between is not
    // lost.
    final signals = session.messages.createStream<DuelSignal>(
      DuelEvents.duelChannel(duelId),
    );
    yield await DuelService.view(session, me, duelId);
    await for (final _ in signals) {
      yield await DuelService.view(session, me, duelId);
    }
  }

  /// The player's duels now and again whenever one of them changes, for the
  /// count of turns waiting.
  Stream<List<DuelSummary>> watchMine(Session session) async* {
    final me = _me(session);
    final signals = session.messages.createStream<DuelSignal>(
      DuelEvents.playerChannel(me),
    );
    yield await DuelService.list(session, me);
    await for (final _ in signals) {
      yield await DuelService.list(session, me);
    }
  }

  Future<DuelView> attack(
    Session session,
    int duelId,
    ScoreCategory category,
    int saintId,
  ) async {
    final view = await DuelService.attack(
      session,
      _me(session),
      duelId,
      category,
      saintId,
    );
    await DuelEvents.changed(session, duelId);
    return view;
  }

  Future<DuelView> defend(Session session, int duelId, int saintId) async {
    final view = await DuelService.defend(
      session,
      _me(session),
      duelId,
      saintId,
    );
    await DuelEvents.changed(session, duelId);
    return view;
  }

  Future<DuelView> answer(Session session, int duelId, int chosenIndex) async {
    final view = await DuelService.answer(
      session,
      _me(session),
      duelId,
      chosenIndex,
    );
    await DuelEvents.changed(session, duelId);
    return view;
  }
}
