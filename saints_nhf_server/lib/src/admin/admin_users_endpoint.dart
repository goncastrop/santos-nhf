import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'admin_scope.dart';
import 'scope_sync.dart';

/// Admin management of other admins.
class AdminUsersEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AppScope.admin};

  /// Users that currently hold the admin scope.
  Future<List<AdminUser>> listAdmins(Session session) async {
    final users = await AuthServices.instance.authUsers.list(session);
    final admins = users.where((u) => u.scopes.contains(AppScope.admin));
    final result = <AdminUser>[];
    for (final user in admins) {
      final profile = await AuthServices.instance.userProfiles
          .maybeFindUserProfileByUserId(session, user.id);
      result.add(AdminUser(authUserId: user.id, email: profile?.email));
    }
    return result;
  }

  /// Grants the admin scope to the user registered with [email].
  Future<AdminUser> grantAdmin(Session session, String email) async {
    final user = await _userByEmail(session, email);
    await setUserScopes(session, user.authUserId, {
      ...user.scopes,
      AppScope.admin,
    });
    return AdminUser(authUserId: user.authUserId, email: email.toLowerCase());
  }

  /// Removes the admin scope from the user registered with [email].
  Future<void> revokeAdmin(Session session, String email) async {
    final user = await _userByEmail(session, email);
    if (user.authUserId == session.authenticated!.authUserId) {
      throw AdminException(message: 'No podés quitarte el acceso a vos mismo.');
    }
    await setUserScopes(
      session,
      user.authUserId,
      user.scopes.where((s) => s != AppScope.admin).toSet(),
    );
  }

  Future<({UuidValue authUserId, Set<Scope> scopes})> _userByEmail(
    Session session,
    String email,
  ) async {
    final profiles = await AuthServices.instance.userProfiles.admin
        .listUserProfiles(session, email: email.trim().toLowerCase(), limit: 1);
    final profile = profiles.firstOrNull;
    if (profile == null) {
      throw AdminException(
        message: 'No hay ningún usuario registrado con el email $email.',
      );
    }
    final authUser = await AuthServices.instance.authUsers.get(
      session,
      authUserId: profile.authUserId,
    );
    return (authUserId: profile.authUserId, scopes: authUser.scopes);
  }
}
