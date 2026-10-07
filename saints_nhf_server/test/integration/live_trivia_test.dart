import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:saints_nhf_server/src/live/live_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Every question has the same four options with 'A' as the right one, so a
/// test can find the right answer wherever the shuffle put it.
Question _question(int saintId, String prompt) => Question(
  saintId: saintId,
  prompt: prompt,
  options: const ['A', 'B', 'C', 'D'],
  correctIndex: 0,
);

void main() {
  withServerpod('Given a saint with questions and an admin', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late TestSessionBuilder admin;
    late Saint saint;
    late Saint other;
    late List<Question> questions;

    setUp(() async {
      LiveService.forgetSnapshot();
      admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      [saint, other] = await Saint.db.insert(session, [
        for (final slug in ['san-uno', 'san-dos'])
          Saint(
            name: slug,
            slug: slug,
            bio: 'Bio',
            status: SaintStatus.published,
          ),
      ]);
      questions = await Question.db.insert(session, [
        for (var i = 1; i <= 3; i++) _question(saint.id!, 'Pregunta $i'),
      ]);
    });

    Future<int> announce({
      int count = 2,
      int fast = 1,
      int raffle = 0,
    }) async {
      final view = await endpoints.adminLive.announce(
        admin,
        saint.id!,
        [for (final q in questions.take(count)) q.id!],
        60,
        20,
        fast,
        raffle,
      );
      return view.gameId!;
    }

    UuidValue idOf(TestSessionBuilder user) =>
        user.build().authenticated!.authUserId;

    /// The shown position of option [label] in the open question.
    Future<int> shownIndexOf(String label) async {
      final view = await endpoints.live.state(sessionBuilder);
      return view.question!.options.indexOf(label);
    }

    Future<LiveMe> answer(
      TestSessionBuilder user,
      int gameId,
      int index, {
      required bool right,
    }) async {
      final shown = await shownIndexOf(right ? 'A' : 'B');
      return endpoints.live.answer(user, gameId, index, shown);
    }

    /// Moves the current question back in time, keeping its length, so the
    /// next answers arrive [ago] after it opened.
    Future<void> openedAgo(int gameId, Duration ago) async {
      final game = await LiveGame.db.findById(session, gameId);
      final length = game!.closesAt!.difference(game.openedAt!);
      final openedAt = DateTime.now().toUtc().subtract(ago);
      await LiveGame.db.updateRow(
        session,
        game.copyWith(openedAt: openedAt, closesAt: openedAt.add(length)),
      );
    }

    test('when announced then the lobby shows the saint and a countdown '
        'but not the question', () async {
      await announce();
      final view = await endpoints.live.state(sessionBuilder);
      expect(view.phase, LivePhase.countdown);
      expect(view.saint?.id, saint.id);
      expect(view.countdownTo, isNotNull);
      expect(view.questionNumber, 1);
      expect(view.questionCount, 2);
      expect(view.question, isNull);
      expect(view.me, isNull);
    });

    test('when a game is running then another one cannot be announced', () {
      return expectLater(
        () async {
          await announce();
          await announce();
        }(),
        throwsA(isA<LiveException>()),
      );
    });

    test('when the countdown ends then the question opens with its '
        'options shuffled the same for everyone', () async {
      final gameId = await announce();
      await LiveService.openQuestion(session, gameId, 0);
      final anonymous = await endpoints.live.state(sessionBuilder);
      final player = await signedInUser(sessionBuilder);
      final signedIn = await endpoints.live.state(player);
      expect(anonymous.phase, LivePhase.question);
      expect(anonymous.question!.prompt, 'Pregunta 1');
      expect(anonymous.closesAt, isNotNull);
      expect(signedIn.question!.options, anonymous.question!.options);
      expect(signedIn.me, isNotNull);
    });

    test('when answering right at once then it is worth close to the '
        'maximum, and only once', () async {
      final gameId = await announce();
      await LiveService.openQuestion(session, gameId, 0);
      final player = await signedInUser(sessionBuilder);
      final me = await answer(player, gameId, 0, right: true);
      expect(me.answered, isTrue);
      // The points stay hidden until the question closes.
      expect(me.lastPoints, isNull);
      await expectLater(
        answer(player, gameId, 0, right: true),
        throwsA(isA<LiveException>()),
      );
      await LiveService.closeQuestion(session, gameId, 0);
      final view = await endpoints.live.state(player);
      expect(view.me!.correct, isTrue);
      expect(view.me!.lastPoints, greaterThan(LiveService.maxPoints - 20));
      expect(view.me!.rank, 1);
    });

    test('when answering slowly then it is worth less', () async {
      final gameId = await announce();
      await LiveService.openQuestion(session, gameId, 0);
      await openedAgo(gameId, const Duration(seconds: 15));
      final player = await signedInUser(sessionBuilder);
      await answer(player, gameId, 0, right: true);
      await LiveService.closeQuestion(session, gameId, 0);
      final view = await endpoints.live.state(player);
      // 15 of 20 seconds: three quarters of the way down to the minimum.
      expect(view.me!.lastPoints, closeTo(625, 5));
    });

    test('when answering without an account or after the close then it '
        'does not count', () async {
      final gameId = await announce();
      await LiveService.openQuestion(session, gameId, 0);
      await expectLater(
        endpoints.live.answer(sessionBuilder, gameId, 0, 0),
        throwsA(isA<LiveException>()),
      );
      await LiveService.closeQuestion(session, gameId, 0);
      final player = await signedInUser(sessionBuilder);
      await expectLater(
        endpoints.live.answer(player, gameId, 0, 0),
        throwsA(isA<LiveException>()),
      );
    });

    test('when a question closes then the reveal shows the right option, '
        'the tally and the ranking', () async {
      final gameId = await announce();
      await LiveService.openQuestion(session, gameId, 0);
      final right = await signedInUser(sessionBuilder);
      final wrong = await signedInUser(sessionBuilder);
      await answer(right, gameId, 0, right: true);
      await answer(wrong, gameId, 0, right: false);

      final during = await endpoints.live.state(sessionBuilder);
      expect(during.answeredCount, 2);
      expect(during.correctIndex, isNull);
      expect(during.leaderboard, isNull);

      await LiveService.closeQuestion(session, gameId, 0);
      final view = await endpoints.live.state(sessionBuilder);
      expect(view.phase, LivePhase.reveal);
      final options = view.question!.options;
      expect(options[view.correctIndex!], 'A');
      expect(view.tally![options.indexOf('A')], 1);
      expect(view.tally![options.indexOf('B')], 1);
      // Only who scored is in the top; the one who missed still has a rank.
      expect(view.leaderboard, hasLength(1));
      expect(view.leaderboard!.single.points, greaterThan(0));
      final missed = await endpoints.live.state(wrong);
      expect(missed.me!.rank, 2);
    });

    test('when the admin moves on then the next question gets a short '
        'countdown, and after the last one the game ends', () async {
      final gameId = await announce(count: 2);
      await endpoints.adminLive.advance(admin, gameId); // skip the lobby
      await endpoints.adminLive.advance(admin, gameId); // close question 1
      var view = await endpoints.adminLive.advance(admin, gameId);
      expect(view.phase, LivePhase.countdown);
      expect(view.questionNumber, 2);
      await endpoints.adminLive.advance(admin, gameId); // open question 2
      await endpoints.adminLive.advance(admin, gameId); // close question 2
      view = await endpoints.adminLive.advance(admin, gameId);
      expect(view.phase, LivePhase.finished);
    });

    test('when a step runs twice then the second time does nothing', () async {
      final gameId = await announce(count: 1);
      await LiveService.openQuestion(session, gameId, 0);
      final opened = await LiveGame.db.findById(session, gameId);
      await LiveService.openQuestion(session, gameId, 0);
      final again = await LiveGame.db.findById(session, gameId);
      expect(again!.openedAt, opened!.openedAt);

      await LiveService.closeQuestion(session, gameId, 0);
      await LiveService.closeQuestion(session, gameId, 0);
      await LiveService.finish(session, gameId);
      await LiveService.finish(session, gameId);
      final game = await LiveGame.db.findById(session, gameId);
      expect(game!.phase, LivePhase.finished);
    });

    test('when the game ends then the fastest win, the raffle picks among '
        'the rest who scored, and the cards are granted once', () async {
      final gameId = await announce(count: 1, fast: 1, raffle: 1);
      await LiveService.openQuestion(session, gameId, 0);
      final fastest = await signedInUser(sessionBuilder);
      final slow1 = await signedInUser(sessionBuilder);
      final slow2 = await signedInUser(sessionBuilder);
      final wrong = await signedInUser(sessionBuilder);
      await answer(fastest, gameId, 0, right: true);
      await openedAgo(gameId, const Duration(seconds: 10));
      await answer(slow1, gameId, 0, right: true);
      await answer(slow2, gameId, 0, right: true);
      await answer(wrong, gameId, 0, right: false);
      await LiveService.closeQuestion(session, gameId, 0);
      await LiveService.finish(session, gameId);

      final view = await endpoints.live.state(fastest);
      expect(view.phase, LivePhase.finished);
      expect(view.fastWinners, hasLength(1));
      expect(view.fastWinners!.single.isMe, isTrue);
      expect(view.fastWinners!.single.saintName, saint.name);
      expect(view.raffleWinners, hasLength(1));
      expect(view.me!.wonSaintId, saint.id);

      final cards = await UserSaintCard.db.find(
        session,
        where: (t) => t.source.equals(CardSource.live),
      );
      expect(cards, hasLength(2));
      final winners = cards.map((c) => c.authUserId).toSet();
      expect(winners, contains(idOf(fastest)));
      expect(winners.intersection({idOf(slow1), idOf(slow2)}), hasLength(1));
      expect(winners, isNot(contains(idOf(wrong))));
    });

    test('when a winner already has the saint then they get one they are '
        'missing', () async {
      final gameId = await announce(count: 1, fast: 1);
      final player = await signedInUser(sessionBuilder);
      await UserSaintCard.db.insertRow(
        session,
        UserSaintCard(
          authUserId: idOf(player),
          saintId: saint.id!,
          source: CardSource.starter,
        ),
      );
      await LiveService.openQuestion(session, gameId, 0);
      await answer(player, gameId, 0, right: true);
      await LiveService.closeQuestion(session, gameId, 0);
      await LiveService.finish(session, gameId);
      final view = await endpoints.live.state(player);
      expect(view.me!.wonSaintId, other.id);
    });

    test('when the results have been up long enough then everyone sees '
        'nothing, even with the snapshot already built', () async {
      final gameId = await announce(count: 1);
      await LiveService.openQuestion(session, gameId, 0);
      await LiveService.closeQuestion(session, gameId, 0);
      await LiveService.finish(session, gameId);
      final finished = await endpoints.live.state(sessionBuilder);
      expect(finished.phase, LivePhase.finished);
      expect(finished.finishedAt, isNotNull);

      LiveService.clock = () => DateTime.now().add(
        LiveService.resultsShownFor + const Duration(seconds: 1),
      );
      addTearDown(() => LiveService.clock = null);
      final later = await endpoints.live.state(sessionBuilder);
      expect(later.phase, LivePhase.idle);
    });

    test('when cancelled then the game is over and a new one can be '
        'announced', () async {
      final gameId = await announce();
      final view = await endpoints.adminLive.cancel(admin, gameId);
      expect(view.phase, LivePhase.cancelled);
      expect(await announce(), isNot(gameId));
    });

    test('when watching then a view arrives at once and again after each '
        'change', () async {
      final views = <LiveView>[];
      final subscription = endpoints.live
          .watch(sessionBuilder)
          .listen(views.add);
      addTearDown(subscription.cancel);
      await _until(() => views.isNotEmpty);
      expect(views.first.phase, LivePhase.idle);

      final gameId = await announce();
      await _until(() => views.last.phase == LivePhase.countdown);
      await LiveService.openQuestion(session, gameId, 0);
      await _until(() => views.last.phase == LivePhase.question);
      expect(views.last.question, isNotNull);
      expect(views.last.watching, greaterThanOrEqualTo(1));
    });

    test('when a player who is not an admin tries to run a game then it is '
        'refused', () async {
      final player = await signedInUser(sessionBuilder);
      await expectLater(
        endpoints.adminLive.announce(
          player,
          saint.id!,
          [questions.first.id!],
          10,
          20,
          1,
          0,
        ),
        throwsA(isA<ServerpodInsufficientAccessException>()),
      );
    });
  });
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
