import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import 'account_service.dart';

/// The signed-in player's own account.
class AccountEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Deletes the account for good. [confirmation] has to be
  /// [AccountService.confirmationWord], typed by the player.
  Future<void> deleteMyAccount(Session session, String confirmation) {
    return AccountService.delete(
      session,
      session.authenticated!.authUserId,
      confirmation: confirmation,
    );
  }
}
