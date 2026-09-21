import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'admin_scope.dart';
import 'scope_sync.dart';

/// Lets a signed-in user check and request admin access.
class AdminAccessEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Whether the caller currently has the admin scope.
  Future<AdminAccess> myAccess(Session session) async {
    final auth = session.authenticated!;
    final profile = await AuthServices.instance.userProfiles
        .maybeFindUserProfileByUserId(session, auth.authUserId);
    return AdminAccess(
      isAdmin: auth.scopes.contains(AppScope.admin),
      email: profile?.email,
    );
  }

  /// Grants the admin scope when the caller's email is listed in the
  /// `adminEmails` password: `config/passwords.yaml` locally, and
  /// `scloud password set adminEmails <emails>` on Serverpod Cloud, which
  /// does not upload that file.
  Future<AdminAccess> requestAccess(Session session) async {
    final auth = session.authenticated!;
    final profile = await AuthServices.instance.userProfiles
        .maybeFindUserProfileByUserId(session, auth.authUserId);
    final email = profile?.email?.toLowerCase();
    final allowed = (session.passwords[AppScope.adminEmailsPasswordKey] ?? '')
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
    if (allowed.isEmpty) {
      // Typical right after a deploy: the password was never set on the
      // server, so nobody could ever become the first admin.
      session.log(
        'requestAccess: the "adminEmails" password is not configured on this '
        'server, so no one can be granted admin access.',
        level: LogLevel.warning,
      );
      throw AdminException(
        message:
            'Este servidor todavía no tiene administradores configurados. '
            'Hay que definir la lista de emails habilitados y volver a '
            'desplegar.',
      );
    }
    if (email == null || !allowed.contains(email)) {
      throw AdminException(
        message:
            'Tu email no está habilitado como administrador. '
            'Pedile acceso a un administrador.',
      );
    }
    await setUserScopes(session, auth.authUserId, {
      ...auth.scopes,
      AppScope.admin,
    });
    return AdminAccess(isAdmin: true, email: email);
  }
}
