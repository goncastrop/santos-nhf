import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'live_service.dart';

/// The live trivia, for everyone. Watching needs no account, so whoever
/// opens the app because the show told them to sees the game at once;
/// answering does, because the prize goes to an album.
class LiveEndpoint extends Endpoint {
  /// The game as it stands now.
  Future<LiveView> state(Session session) {
    return LiveService.view(session, session.authenticated?.authUserId);
  }

  /// A view now and another one after every change. The app keeps it open
  /// while it is in the foreground, which is how the banner shows up on any
  /// tab when the host announces a game.
  Stream<LiveView> watch(Session session) {
    return LiveService.watch(session, session.authenticated?.authUserId);
  }

  /// Answers question [questionIndex] (0-based) with the option at
  /// [chosenIndex], in the order shown.
  Future<LiveMe> answer(
    Session session,
    int gameId,
    int questionIndex,
    int chosenIndex,
  ) {
    final userId = session.authenticated?.authUserId;
    if (userId == null) {
      throw LiveException(message: 'Ingresá para participar.');
    }
    return LiveService.answer(
      session,
      userId,
      gameId,
      questionIndex,
      chosenIndex,
    );
  }
}
