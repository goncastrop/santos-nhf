import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'litany_service.dart';

/// La Letanía: the solo run of questions.
class LitanyEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The run in progress, if any.
  Future<LitanyView> state(Session session) {
    return LitanyService.state(session, session.authenticated!.authUserId);
  }

  /// Starts a run, or picks up the one already going on.
  Future<LitanyView> start(Session session) {
    return LitanyService.start(session, session.authenticated!.authUserId);
  }

  Future<LitanyView> answer(Session session, int chosenIndex) {
    return LitanyService.answer(
      session,
      session.authenticated!.authUserId,
      chosenIndex,
    );
  }

  Future<LitanyView> next(Session session) {
    return LitanyService.next(session, session.authenticated!.authUserId);
  }

  Future<LitanyView> giveUp(Session session) {
    return LitanyService.giveUp(session, session.authenticated!.authUserId);
  }
}
