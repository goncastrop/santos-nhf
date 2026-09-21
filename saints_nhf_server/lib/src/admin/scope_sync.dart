import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Updates a user's scopes and copies them to their active refresh tokens.
///
/// JWT access tokens carry the scopes of the refresh token they were created
/// from, so without this the change would only apply after signing in again.
/// After the update the client refreshes its token and sees the new scopes.
Future<void> setUserScopes(
  Session session,
  UuidValue authUserId,
  Set<Scope> scopes,
) async {
  await AuthServices.instance.authUsers.update(
    session,
    authUserId: authUserId,
    scopes: scopes,
  );
  final tokens = await RefreshToken.db.find(
    session,
    where: (t) => t.authUserId.equals(authUserId),
  );
  final names = scopes.map((s) => s.name).nonNulls.toSet();
  await RefreshToken.db.update(session, [
    for (final token in tokens) token.copyWith(scopeNames: names),
  ]);
}
