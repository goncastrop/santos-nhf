import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import 'test_tools/serverpod_test_tools.dart';

var _authServicesReady = false;

/// Initializes the auth services once per test isolate, as `server.dart` does
/// for the real server. Needed by code that reads user profiles or scopes.
void ensureAuthServices() {
  if (_authServicesReady) return;
  AuthServices.set(tokenManagerBuilders: [JwtConfigFromPasswords()]);
  _authServicesReady = true;
}

/// Creates a real auth user and returns a session builder signed in as them.
Future<TestSessionBuilder> signedInUser(
  TestSessionBuilder base, {
  Set<Scope> scopes = const {},
}) async {
  ensureAuthServices();
  final session = base.build();
  final user = await AuthServices.instance.authUsers.create(
    session,
    scopes: scopes,
  );
  return base.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      user.id.toString(),
      scopes,
    ),
  );
}
