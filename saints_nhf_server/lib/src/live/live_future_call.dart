import 'package:serverpod/serverpod.dart';

import 'live_service.dart';

/// The two moments of a live game that nobody triggers by hand: a question
/// opening when its countdown runs out, and closing when its time is up.
///
/// They are future calls and not timers so a restart in the middle of a game
/// does not leave a question open forever. Both are idempotent: they only act
/// when the game is still at the step they were scheduled for.
class LiveFutureCall extends FutureCall {
  Future<void> openQuestion(Session session, int gameId, int index) {
    return LiveService.openQuestion(session, gameId, index);
  }

  Future<void> closeQuestion(Session session, int gameId, int index) {
    return LiveService.closeQuestion(session, gameId, index);
  }
}
