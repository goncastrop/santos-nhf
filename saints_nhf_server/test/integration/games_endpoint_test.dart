import 'dart:math';

import 'package:saints_nhf_server/src/duel/duel_service.dart';
import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

Saint _saint(String slug, {int viajes = 50, int oracion = 50}) => Saint(
  name: slug,
  slug: slug,
  bio: 'Bio de $slug',
  status: SaintStatus.published,
  viajes: viajes,
  oracion: oracion,
);

Question _question(int saintId, {int correct = 0}) => Question(
  saintId: saintId,
  prompt: 'Pregunta sobre $saintId',
  options: const ['A', 'B', 'C', 'D'],
  correctIndex: correct,
);

/// Seeds [count] published saints, each with one question (correct index 0),
/// and returns them.
Future<List<Saint>> _seedSaints(
  Session session,
  int count, {
  String prefix = 'santo',
}) async {
  final saints = await Saint.db.insert(session, [
    for (var i = 1; i <= count; i++)
      _saint('$prefix-$i', viajes: 10 * i, oracion: 100 - 10 * i),
  ]);
  await Question.db.insert(session, [
    for (final s in saints) _question(s.id!),
  ]);
  return saints;
}

Future<void> _giveAll(
  Session session,
  UuidValue user,
  List<Saint> saints,
) async {
  await UserSaintCard.db.insert(session, [
    for (final s in saints)
      UserSaintCard(
        authUserId: user,
        saintId: s.id!,
        source: CardSource.starter,
      ),
  ]);
  await PlayerProfile.db.insertRow(
    session,
    PlayerProfile(authUserId: user, starterGranted: true),
  );
}

UuidValue _idOf(TestSessionBuilder b) => b.build().authenticated!.authUserId;

void main() {
  withServerpod('Given a player with cards that have questions', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late TestSessionBuilder user;
    late List<Saint> saints;

    setUp(() async {
      user = await signedInUser(sessionBuilder);
      saints = await _seedSaints(session, 6);
      await _giveAll(session, _idOf(user), saints);
    });

    test('when asking for the daily quiz then a question about an owned '
        'saint is returned and answering right starts a streak', () async {
      final quiz = await endpoints.quiz.today(user);
      expect(quiz.question, isNotNull);
      expect(quiz.answeredToday, isFalse);
      expect(saints.map((s) => s.id), contains(quiz.question!.saintId));

      // The options come shuffled, so find where the right one ("A") landed.
      final right = quiz.question!.options.indexOf('A');
      final result = await endpoints.quiz.answer(
        user,
        quiz.question!.id,
        right,
      );
      expect(result.wasCorrect, isTrue);
      expect(result.streak, 1);
      expect(result.totalCorrect, 1);
      expect(result.question, isNull);

      // Asking again the same day keeps the answered state.
      final again = await endpoints.quiz.today(user);
      expect(again.answeredToday, isTrue);
      expect(again.correctIndex, right);

      await expectLater(
        endpoints.quiz.answer(user, quiz.question!.id, right),
        throwsA(isA<QuizException>()),
      );
    });

    test('when playing a full duel against the machine then it finishes '
        'with a winner or a draw and stats are recorded', () async {
      // Deterministic machine: always answers right, coin flips fixed.
      DuelService.random = Random(7);
      DuelService.machineAccuracy = 1;
      addTearDown(() {
        DuelService.random = Random();
        DuelService.machineAccuracy = 0.6;
      });

      final eligible = await endpoints.duel.eligibleSaintIds(user);
      expect(eligible, hasLength(6));
      final hand = await endpoints.duel.dealHand(user);
      expect(hand, hasLength(6)); // Fewer than 8 eligible: all are dealt.

      var view = await endpoints.duel.createVsMachine(
        user,
        hand.take(5).toList(),
      );
      expect(view.status, DuelStatus.active);
      expect(view.myDeck, hasLength(5));

      var safety = 0;
      while (view.phase != DuelPhase.finished && safety++ < 30) {
        switch (view.phase) {
          case DuelPhase.attack:
            final category = ScoreCategory.values.firstWhere(
              (c) => !view.usedCategories.contains(c),
            );
            view = await endpoints.duel.attack(
              user,
              view.duelId,
              category,
              view.myDeck.first.saint.id,
            );
            expect(view.phase, DuelPhase.answer);
          case DuelPhase.defend:
            expect(view.currentCategory, isNotNull);
            view = await endpoints.duel.defend(
              user,
              view.duelId,
              view.myDeck.first.saint.id,
            );
            expect(view.phase, DuelPhase.answer);
          case DuelPhase.answer:
            expect(view.pendingQuestion, isNotNull);
            // Always right: wherever the shuffle put "A".
            view = await endpoints.duel.answer(
              user,
              view.duelId,
              view.pendingQuestion!.options.indexOf('A'),
            );
          default:
            fail('Unexpected phase ${view.phase} against the machine');
        }
      }
      expect(view.phase, DuelPhase.finished);
      expect(view.rounds, isNotEmpty);
      expect(view.rounds.every((r) => r.resolved), isTrue);
      // Every resolved round reveals both cards.
      expect(view.rounds.every((r) => r.opponentSaint != null), isTrue);
      expect(
        view.myScore >= DuelService.pointsToWin ||
            view.opponentScore >= DuelService.pointsToWin ||
            view.rounds.length == DuelService.deckSize,
        isTrue,
      );

      final duels = await endpoints.duel.myDuels(user);
      expect(duels.single.status, DuelStatus.finished);
      final me = await endpoints.friends.me(user);
      expect(me.duelsPlayed, 1);
    });

    test('when a round closes then it recaps my question and reveals the '
        'rival card, so the player can see why the point moved', () async {
      DuelService.random = Random(7);
      // The machine always answers right, so a miss of mine decides the
      // round on its own.
      DuelService.machineAccuracy = 1;
      addTearDown(() {
        DuelService.random = Random();
        DuelService.machineAccuracy = 0.6;
      });

      final hand = await endpoints.duel.dealHand(user);
      var view = await endpoints.duel.createVsMachine(
        user,
        hand.take(5).toList(),
      );

      var safety = 0;
      while (!view.rounds.any((r) => r.resolved) && safety++ < 10) {
        switch (view.phase) {
          case DuelPhase.attack:
            view = await endpoints.duel.attack(
              user,
              view.duelId,
              ScoreCategory.values.firstWhere(
                (c) => !view.usedCategories.contains(c),
              ),
              view.myDeck.first.saint.id,
            );
          case DuelPhase.defend:
            view = await endpoints.duel.defend(
              user,
              view.duelId,
              view.myDeck.first.saint.id,
            );
          case DuelPhase.answer:
            // The question is still in front of me: nothing to recap yet.
            final open = view.rounds.singleWhere(
              (r) => r.roundNumber == view.roundNumber,
            );
            expect(open.myQuestionPrompt, isNull);
            expect(open.myAnswer, isNull);
            expect(open.myRightAnswer, isNull);
            expect(open.opponentSaint, isNull, reason: 'still face down');
            // Answer wrong on purpose: anything that is not "A".
            view = await endpoints.duel.answer(
              user,
              view.duelId,
              view.pendingQuestion!.options.indexWhere((o) => o != 'A'),
            );
          default:
            fail('Unexpected phase ${view.phase} against the machine');
        }
      }

      final round = view.rounds.first;
      expect(round.resolved, isTrue);
      expect(round.myQuestionPrompt, isNotNull);
      expect(round.myAnswer, isNotNull);
      expect(round.myAnswer, isNot('A'));
      expect(round.myRightAnswer, 'A');
      expect(round.myCorrect, isFalse);
      expect(round.opponentCorrect, isTrue);
      expect(round.opponentSaint, isNotNull);
      expect(round.opponentScore, isNotNull);
      // I missed and the machine did not: the point is never mine, whatever
      // the cards said.
      expect(round.pointToMe, isFalse);
    });

    test('when the deck is invalid then the duel is rejected', () async {
      await endpoints.duel.dealHand(user);
      await expectLater(
        endpoints.duel.createVsMachine(user, [saints.first.id!]),
        throwsA(isA<DuelException>()),
      );
      final stranger = await Saint.db.insertRow(session, _saint('ajeno'));
      await expectLater(
        endpoints.duel.createVsMachine(user, [
          ...saints.take(4).map((s) => s.id!),
          stranger.id!,
        ]),
        throwsA(isA<DuelException>()),
      );
    });

    test('when the deck is not taken from the dealt hand then it is rejected '
        'and the hand is consumed after a duel starts', () async {
      // Ten eligible cards so the hand of 8 leaves two out.
      final extra = await _seedSaints(session, 4, prefix: 'extra');
      await UserSaintCard.db.insert(session, [
        for (final s in extra)
          UserSaintCard(
            authUserId: _idOf(user),
            saintId: s.id!,
            source: CardSource.daily,
          ),
      ]);
      final hand = await endpoints.duel.dealHand(user);
      expect(hand, hasLength(8));
      final all = [...saints, ...extra].map((s) => s.id!).toSet();
      final outside = all.difference(hand.toSet()).toList();
      expect(outside, hasLength(2));

      await expectLater(
        endpoints.duel.createVsMachine(user, [
          ...hand.take(4),
          outside.first,
        ]),
        throwsA(isA<DuelException>()),
      );
      await endpoints.duel.createVsMachine(user, hand.take(5).toList());
      // The hand is spent: the same deck cannot start another duel.
      await expectLater(
        endpoints.duel.createVsMachine(user, hand.take(5).toList()),
        throwsA(isA<DuelException>()),
      );
    });
  });

  withServerpod('Given two players who are friends', (
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
      saints = await _seedSaints(session, 5);
      await _giveAll(session, _idOf(alice), saints);
      await _giveAll(session, _idOf(bob), saints);
    });

    test('when adding by friend code then both see each other and the '
        'friend collection is visible without scores', () async {
      final bobProfile = await endpoints.friends.me(bob);
      final added = await endpoints.friends.addByCode(
        alice,
        bobProfile.friendCode,
      );
      expect(added.authUserId, _idOf(bob));
      expect(added.cards, 5);

      final aliceFriends = await endpoints.friends.list(alice);
      final bobFriends = await endpoints.friends.list(bob);
      expect(aliceFriends.single.authUserId, _idOf(bob));
      expect(bobFriends.single.authUserId, _idOf(alice));

      final collection = await endpoints.friends.collectionOf(
        alice,
        _idOf(bob),
      );
      expect(collection.saints, hasLength(5));

      await expectLater(
        endpoints.friends.addByCode(alice, 'NOPE00'),
        throwsA(isA<SocialException>()),
      );
    });

    test('when challenging a friend then rounds alternate and the duel '
        'resolves according to the rules', () async {
      DuelService.random = Random(1);
      addTearDown(() => DuelService.random = Random());
      final bobProfile = await endpoints.friends.me(bob);
      await endpoints.friends.addByCode(alice, bobProfile.friendCode);
      final deck = saints.map((s) => s.id!).toList();
      await endpoints.duel.dealHand(alice);

      var aliceView = await endpoints.duel.challenge(alice, _idOf(bob), deck);
      expect(aliceView.phase, DuelPhase.waitingOpponentDeck);
      var bobView = await endpoints.duel.view(bob, aliceView.duelId);
      expect(bobView.phase, DuelPhase.chooseDeck);

      await endpoints.duel.dealHand(bob);
      bobView = await endpoints.duel.accept(bob, aliceView.duelId, deck);
      expect(bobView.status, DuelStatus.active);
      aliceView = await endpoints.duel.view(alice, aliceView.duelId);
      expect(aliceView.attackerIsMe, isNot(bobView.attackerIsMe));

      // Play one full round with both answering right.
      final (attacker, defender) = aliceView.attackerIsMe
          ? (alice, bob)
          : (bob, alice);
      var v = await endpoints.duel.view(attacker, aliceView.duelId);
      expect(v.phase, DuelPhase.attack);
      // Attacker plays the strongest card in viajes: santo-5 (50).
      v = await endpoints.duel.attack(
        attacker,
        v.duelId,
        ScoreCategory.viajes,
        saints.last.id!,
      );
      v = await endpoints.duel.answer(
        attacker,
        v.duelId,
        v.pendingQuestion!.options.indexOf('A'),
      );
      expect(v.phase, DuelPhase.waitingOpponent);

      var d = await endpoints.duel.view(defender, v.duelId);
      expect(d.phase, DuelPhase.defend);
      expect(d.currentCategory, ScoreCategory.viajes);
      // Defender plays the weakest card in viajes: santo-1 (10).
      d = await endpoints.duel.defend(defender, d.duelId, saints.first.id!);
      d = await endpoints.duel.answer(
        defender,
        d.duelId,
        d.pendingQuestion!.options.indexOf('A'),
      );

      // Attacker had the higher card and answered right: attacker scores.
      expect(d.rounds.single.resolved, isTrue);
      expect(d.rounds.single.pointToMe, isFalse);
      expect(d.myScore, 0);
      expect(d.opponentScore, 1);
      // Now the defender attacks.
      expect(d.phase, DuelPhase.attack);
      expect(d.usedCategories, [ScoreCategory.viajes]);

      await expectLater(
        endpoints.duel.attack(
          d.duelId == 0 ? attacker : defender,
          d.duelId,
          ScoreCategory.viajes,
          saints[1].id!,
        ),
        throwsA(isA<DuelException>()),
      );
    });

    test(
      'when challenging someone who is not a friend then it fails',
      () async {
        final deck = saints.map((s) => s.id!).toList();
        await endpoints.duel.dealHand(alice);
        await expectLater(
          endpoints.duel.challenge(alice, _idOf(bob), deck),
          throwsA(isA<DuelException>()),
        );
      },
    );
  });

  withServerpod('Given an unlock code for a specific saint', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();

    test('when redeemed then the card is granted once per player', () async {
      final user = await signedInUser(sessionBuilder);
      final admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      final saints = await _seedSaints(session, 2);
      await PlayerProfile.db.insertRow(
        session,
        PlayerProfile(authUserId: _idOf(user), starterGranted: true),
      );
      final code = await endpoints.adminCodes.create(
        admin,
        'NHF-2026',
        saints.first.id,
        1,
        null,
        'Prueba',
      );
      expect(code.code, 'NHF-2026');

      final card = await endpoints.collection.redeem(user, 'nhf-2026');
      expect(card.saint.id, saints.first.id);
      expect(card.source, CardSource.code);

      await expectLater(
        endpoints.collection.redeem(user, 'NHF-2026'),
        throwsA(
          isA<CollectionException>().having(
            (e) => e.code,
            'code',
            CollectionErrorCode.codeAlreadyUsed,
          ),
        ),
      );
      final other = await signedInUser(sessionBuilder);
      await expectLater(
        endpoints.collection.redeem(other, 'NHF-2026'),
        throwsA(
          isA<CollectionException>().having(
            (e) => e.code,
            'code',
            CollectionErrorCode.codeExhausted,
          ),
        ),
      );
    });
  });

  withServerpod('Given a published saint whose scores were changed', (
    sessionBuilder,
    endpoints,
  ) {
    test('when reading recent changes then owners see values and others only '
        'the direction', () async {
      final admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      final owner = await signedInUser(sessionBuilder);
      final other = await signedInUser(sessionBuilder);
      final created = await endpoints.adminSaint.save(
        admin,
        _saint('cambiado', viajes: 20),
        null,
      );
      await UserSaintCard.db.insertRow(
        sessionBuilder.build(),
        UserSaintCard(
          authUserId: _idOf(owner),
          saintId: created.id!,
          source: CardSource.daily,
        ),
      );
      await endpoints.adminSaint.save(
        admin,
        created.copyWith(viajes: 80),
        'Buff de viajes',
      );

      final forOwner = await endpoints.saint.recentChanges(owner);
      expect(forOwner.single.changes.single.category, ScoreCategory.viajes);
      expect(forOwner.single.changes.single.increased, isTrue);
      expect(forOwner.single.changes.single.from, 20);
      expect(forOwner.single.changes.single.to, 80);
      expect(forOwner.single.note, 'Buff de viajes');

      final forOther = await endpoints.saint.recentChanges(other);
      expect(forOther.single.changes.single.from, isNull);
      expect(forOther.single.changes.single.increased, isTrue);
    });
  });
}
