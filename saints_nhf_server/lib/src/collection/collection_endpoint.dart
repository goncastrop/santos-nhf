import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'collection_service.dart';

/// The signed-in user's card collection.
class CollectionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) => session.authenticated!.authUserId;

  /// Collection state. Grants the starter pack on first call.
  Future<CollectionOverview> overview(Session session) {
    return CollectionService.overview(session, _userId(session));
  }

  /// Claims today's card. Throws [CollectionException] when not possible.
  Future<DailyClaimResult> claimDaily(Session session) {
    return CollectionService.claimDaily(session, _userId(session));
  }

  /// Redeems an unlock code. Throws [CollectionException] when invalid.
  Future<CollectedCard> redeem(Session session, String code) {
    return CollectionService.redeem(session, _userId(session), code);
  }
}
