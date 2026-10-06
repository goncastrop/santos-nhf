import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../admin/admin_scope.dart';
import '../generated/protocol.dart';
import 'live_service.dart';

/// Runs the live trivia from the admin panel.
class AdminLiveEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AppScope.admin};

  /// Opens the lobby now; the first question opens after [countdownSeconds].
  Future<LiveView> announce(
    Session session,
    int saintId,
    List<int> questionIds,
    int countdownSeconds,
    int questionSeconds,
    int fastPrizes,
    int rafflePrizes,
  ) async {
    final adminId = session.authenticated!.authUserId;
    await LiveService.announce(
      session,
      adminId,
      saintId: saintId,
      questionIds: questionIds,
      countdownSeconds: countdownSeconds,
      questionSeconds: questionSeconds,
      fastPrizes: fastPrizes,
      rafflePrizes: rafflePrizes,
    );
    return LiveService.view(session, adminId);
  }

  /// Skips the countdown, closes the open question, goes to the next one or
  /// ends the game, depending on where it is.
  Future<LiveView> advance(Session session, int gameId) async {
    await LiveService.advance(session, gameId);
    return LiveService.view(session, session.authenticated!.authUserId);
  }

  Future<LiveView> cancel(Session session, int gameId) async {
    await LiveService.cancel(session, gameId);
    return LiveService.view(session, session.authenticated!.authUserId);
  }
}
