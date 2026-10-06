import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

UuidValue _idOf(TestSessionBuilder b) => b.build().authenticated!.authUserId;

void main() {
  // The streams read the database as soon as a move posts its signal, while
  // the move's own call is still finishing. The rollback proxy of the tests
  // does not allow two calls at once, so this group runs without it; it gets
  // an empty database of its own anyway.
  withServerpod(
    'Given two friends with cards',
    rollbackDatabase: RollbackDatabase.disabled,
    (
      sessionBuilder,
      endpoints,
    ) {
      final session = sessionBuilder.build();
      late TestSessionBuilder alice;
      late TestSessionBuilder bob;
      late List<Saint> saints;

      setUp(() async {
        alice = await signedInUser(sessionBuilder);
        bob = await signedInUser(sessionBuilder);
        saints = await Saint.db.insert(session, [
          for (var i = 1; i <= 5; i++)
            Saint(
              name: 'santo-$i',
              slug: 'santo-$i',
              bio: 'Bio',
              status: SaintStatus.published,
            ),
        ]);
        await Question.db.insert(session, [
          for (final s in saints)
            Question(
              saintId: s.id!,
              prompt: 'Pregunta',
              options: const ['A', 'B', 'C', 'D'],
              correctIndex: 0,
            ),
        ]);
        for (final user in [alice, bob]) {
          await UserSaintCard.db.insert(session, [
            for (final s in saints)
              UserSaintCard(
                authUserId: _idOf(user),
                saintId: s.id!,
                source: CardSource.starter,
              ),
          ]);
          await PlayerProfile.db.insertRow(
            session,
            PlayerProfile(authUserId: _idOf(user), starterGranted: true),
          );
        }
      });

      test('when a friend moves then the other player\'s board and duel '
          'list update without asking', () async {
        final bobProfile = await endpoints.friends.me(bob);
        await endpoints.friends.addByCode(alice, bobProfile.friendCode);
        final deck = saints.map((s) => s.id!).toList();

        final bobLists = <List<DuelSummary>>[];
        final bobList = endpoints.duel.watchMine(bob).listen(bobLists.add);
        addTearDown(bobList.cancel);
        await _until(() => bobLists.isNotEmpty);
        expect(bobLists.last, isEmpty);

        await endpoints.duel.dealHand(alice);
        final created = await endpoints.duel.challenge(alice, _idOf(bob), deck);
        await _until(() => bobLists.last.isNotEmpty);
        expect(bobLists.last.single.duelId, created.duelId);

        final aliceBoards = <DuelView>[];
        final aliceBoard = endpoints.duel
            .watch(alice, created.duelId)
            .listen(aliceBoards.add);
        addTearDown(aliceBoard.cancel);
        await _until(() => aliceBoards.isNotEmpty);
        expect(aliceBoards.last.phase, DuelPhase.waitingOpponentDeck);

        await endpoints.duel.dealHand(bob);
        await endpoints.duel.accept(bob, created.duelId, deck);
        await _until(() => aliceBoards.last.status == DuelStatus.active);
      });
    },
  );
}

/// Waits for [condition], checking every few milliseconds, for up to two
/// seconds.
Future<void> _until(bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 2));
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('The condition never became true.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}
