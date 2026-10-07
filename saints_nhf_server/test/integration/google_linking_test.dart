import 'package:saints_nhf_server/src/auth/google_idp_endpoint.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

GoogleAccountDetails _google({
  required String email,
  bool? verified = true,
  String id = 'google-123',
}) => (
  userIdentifier: id,
  email: email,
  name: 'Ana',
  fullName: 'Ana Pérez',
  image: null,
  verifiedEmail: verified,
);

void main() {
  withServerpod('Given a player who signed up with email and password', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late UuidValue player;

    setUp(() async {
      final user = await signedInUser(sessionBuilder);
      player = user.build().authenticated!.authUserId;
      await EmailAccount.db.insertRow(
        session,
        EmailAccount(
          authUserId: player,
          email: 'ana@gmail.com',
          passwordHash: 'hash',
        ),
      );
    });

    test('when signing in with Google with the same verified email then '
        'the Google account is linked to that player', () async {
      final linked = await GoogleAccountLinking.linkToEmailAccount(
        session,
        _google(email: 'Ana@Gmail.com'),
      );
      expect(linked, player);
      final account = await GoogleAccount.db.findFirstRow(
        session,
        where: (t) => t.userIdentifier.equals('google-123'),
      );
      expect(account?.authUserId, player);
    });

    test(
      'when Google does not vouch for the email then nothing is linked',
      () async {
        final linked = await GoogleAccountLinking.linkToEmailAccount(
          session,
          _google(email: 'ana@gmail.com', verified: false),
        );
        expect(linked, isNull);
        expect(await GoogleAccount.db.count(session), 0);
      },
    );

    test('when nobody has that email then nothing is linked', () async {
      final linked = await GoogleAccountLinking.linkToEmailAccount(
        session,
        _google(email: 'otra@gmail.com'),
      );
      expect(linked, isNull);
      expect(await GoogleAccount.db.count(session), 0);
    });

    test(
      'when the Google account is already known then it is left as is',
      () async {
        await GoogleAccountLinking.linkToEmailAccount(
          session,
          _google(email: 'ana@gmail.com'),
        );
        final again = await GoogleAccountLinking.linkToEmailAccount(
          session,
          _google(email: 'ana@gmail.com'),
        );
        expect(again, isNull);
        expect(await GoogleAccount.db.count(session), 1);
      },
    );
  });
}
