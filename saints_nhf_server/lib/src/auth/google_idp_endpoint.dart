import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

/// Sign-in with Google. Its existence is what makes the sign-in widget show
/// the Google button; the provider itself only runs when `server.dart` finds
/// `googleClientSecret` in the passwords.
///
/// Serverpod keys a Google account by Google's own user id and, the first
/// time it sees one, creates a brand new user for it, even when someone
/// already plays with that same address by email and password. Here that
/// person would land in an empty album, so before Serverpod looks, the Google
/// account is linked to the existing user. See [GoogleAccountLinking].
class GoogleIdpEndpoint extends GoogleIdpBaseEndpoint {
  @override
  Future<AuthSuccess> login(
    Session session, {
    required String idToken,
    required String? accessToken,
  }) async {
    final details = await googleIdp.utils.fetchAccountDetails(
      session,
      idToken: idToken,
      accessToken: accessToken,
    );
    await GoogleAccountLinking.linkToEmailAccount(session, details);
    return super.login(session, idToken: idToken, accessToken: accessToken);
  }

  /// The web flow. The code can be exchanged only once, so it is exchanged
  /// here and the tokens go through [login], which does the linking.
  @override
  Future<AuthSuccess> loginWithCode(
    Session session, {
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) async {
    final tokens = await googleIdp.utils.exchangeCodeForToken(
      session,
      code: code,
      codeVerifier: codeVerifier,
      redirectUri: redirectUri,
    );
    return login(
      session,
      idToken: tokens.idToken,
      accessToken: tokens.accessToken,
    );
  }
}

/// Links a Google account to the player who already has an account with the
/// same email, so signing in with Google finds their album.
///
/// It only links when both sides vouch for the address: Google says the
/// email is verified, and our email accounts only exist after the code sent
/// to that address was typed in. Otherwise Serverpod goes on as usual and
/// creates a new user.
class GoogleAccountLinking {
  /// Returns the user the Google account was linked to, or null when there
  /// was nothing to link.
  static Future<UuidValue?> linkToEmailAccount(
    Session session,
    GoogleAccountDetails details,
  ) async {
    final known = await GoogleAccount.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals(details.userIdentifier),
    );
    if (known != null) return null;
    if (details.verifiedEmail != true) return null;

    final email = details.email.trim().toLowerCase();
    final emailAccount = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );
    if (emailAccount == null) return null;

    await GoogleAccount.db.insertRow(
      session,
      GoogleAccount(
        userIdentifier: details.userIdentifier,
        email: email,
        authUserId: emailAccount.authUserId,
      ),
    );
    session.log('Google account linked to an existing email account.');
    return emailAccount.authUserId;
  }
}
