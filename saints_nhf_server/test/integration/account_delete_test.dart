import 'package:saints_nhf_server/src/account/account_service.dart';
import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

UuidValue _idOf(TestSessionBuilder b) => b.build().authenticated!.authUserId;

void main() {
  withServerpod('Given a player with an album, a friend and a duel', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;
    late List<Saint> saints;
    late int duelId;
    late int gameId;

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
      }
      final bobProfile = await endpoints.friends.me(bob);
      await endpoints.friends.addByCode(alice, bobProfile.friendCode);
      await endpoints.duel.dealHand(alice);
      final duel = await endpoints.duel.challenge(alice, _idOf(bob), [
        for (final s in saints) s.id!,
      ]);
      duelId = duel.duelId;

      final game = await LiveGame.db.insertRow(
        session,
        LiveGame(
          saintId: saints.first.id!,
          questionIds: const [],
          phase: LivePhase.finished,
          fastPrizes: 1,
          rafflePrizes: 0,
          createdBy: _idOf(bob),
          results: LiveResults(
            fast: [
              LiveWinner(
                authUserId: _idOf(alice),
                name: 'Alicia',
                points: 900,
                saintId: saints.first.id,
              ),
            ],
            raffle: const [],
          ),
        ),
      );
      gameId = game.id!;
    });

    test(
      'when the confirmation word is wrong then nothing is deleted',
      () async {
        await expectLater(
          endpoints.account.deleteMyAccount(alice, 'borrar mi cuenta'),
          throwsA(isA<AccountException>()),
        );
        final cards = await UserSaintCard.db.count(
          session,
          where: (t) => t.authUserId.equals(_idOf(alice)),
        );
        expect(cards, saints.length);
      },
    );

    test('when confirmed then everything of the player goes and the friend '
        'keeps their own things', () async {
      final me = _idOf(alice);
      await endpoints.account.deleteMyAccount(alice, ' borrar ');

      expect(await AuthUser.db.findById(session, me), isNull);
      expect(
        await PlayerProfile.db.count(
          session,
          where: (t) => t.authUserId.equals(me),
        ),
        0,
      );
      expect(
        await UserSaintCard.db.count(
          session,
          where: (t) => t.authUserId.equals(me),
        ),
        0,
      );
      expect(await Friendship.db.count(session), 0);
      expect(await Duel.db.findById(session, duelId), isNull);
      expect(await DuelDeck.db.count(session), 0);

      final game = await LiveGame.db.findById(session, gameId);
      expect(game!.results!.fast.single.name, AccountService.deletedName);

      // Bob is untouched, apart from losing the friend and the duel.
      expect(await AuthUser.db.findById(session, _idOf(bob)), isNotNull);
      expect(
        await UserSaintCard.db.count(
          session,
          where: (t) => t.authUserId.equals(_idOf(bob)),
        ),
        saints.length,
      );
      expect(await endpoints.friends.list(bob), isEmpty);
    });
  });
}
