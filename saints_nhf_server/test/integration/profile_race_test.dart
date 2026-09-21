import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a brand new user whose profile does not exist yet',
    (sessionBuilder, endpoints) {
      test('when the app calls several endpoints in parallel on sign-in then '
          'none of them fails creating the profile twice', () async {
        final user = await signedInUser(sessionBuilder);

        // Same shape as AppState.loadAll: these run at once and each one
        // needs the player profile.
        final results = await Future.wait<Object?>([
          endpoints.friends.me(user),
          endpoints.collection.overview(user),
          endpoints.quiz.today(user),
        ]);

        expect(results.whereType<MyProfile>().single.friendCode, isNotEmpty);
        expect(
          await PlayerProfile.db.count(sessionBuilder.build()),
          1,
          reason: 'exactly one profile row must exist',
        );
      });
    },
    // The endpoints open their own transactions concurrently.
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
