import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:saints_nhf_server/src/litany/litany_service.dart';
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
  withServerpod('Given a player with cards and plenty of questions', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late TestSessionBuilder user;

    /// Answers the question on the table, right or wrong, and returns the
    /// graded view.
    Future<LitanyView> answer(LitanyView view, {required bool right}) {
      final options = view.question!.options;
      final index = right
          ? options.indexOf('A')
          : options.indexWhere((o) => o != 'A');
      return endpoints.litany.answer(user, index);
    }

    setUp(() async {
      user = await signedInUser(sessionBuilder);
      final me = user.build().authenticated!.authUserId;
      final saints = await Saint.db.insert(session, [
        for (var i = 1; i <= 4; i++)
          Saint(
            name: 'Santo $i',
            slug: 'santo-$i',
            bio: 'Bio $i',
            status: SaintStatus.published,
          ),
      ]);
      await Question.db.insert(session, [
        for (final s in saints)
          for (var i = 1; i <= 5; i++)
            _question(s.id!, '${s.slug} pregunta $i'),
      ]);
      await UserSaintCard.db.insert(session, [
        for (final s in saints)
          UserSaintCard(
            authUserId: me,
            saintId: s.id!,
            source: CardSource.starter,
          ),
      ]);
      await PlayerProfile.db.insertRow(
        session,
        PlayerProfile(authUserId: me, starterGranted: true),
      );
    });

    test('when starting then there is a question, three lives and no '
        'score', () async {
      final view = await endpoints.litany.start(user);
      expect(view.runId, isNotNull);
      expect(view.lives, LitanyService.lives);
      expect(view.score, 0);
      expect(view.question, isNotNull);
      expect(view.saint, isNotNull);
      expect(view.finished, isFalse);
    });

    test(
      'when answering right then the score goes up and the lives stay',
      () async {
        final started = await endpoints.litany.start(user);
        final graded = await answer(started, right: true);
        expect(graded.lastWasCorrect, isTrue);
        expect(graded.lastGain, LitanyService.basePoints);
        expect(graded.score, LitanyService.basePoints);
        expect(graded.lives, LitanyService.lives);
        expect(graded.correctIndex, isNotNull);
      },
    );

    test(
      'when answering wrong then it costs a life and resets the streak',
      () async {
        var view = await endpoints.litany.start(user);
        view = await answer(view, right: true);
        view = await endpoints.litany.next(user);
        view = await answer(view, right: false);
        expect(view.lastWasCorrect, isFalse);
        expect(view.lastGain, 0);
        expect(view.lives, LitanyService.lives - 1);
        expect(view.streak, 0);
        expect(view.score, LitanyService.basePoints);
      },
    );

    test('when the streak reaches the step then the multiplier raises what '
        'the next answer pays', () async {
      var view = await endpoints.litany.start(user);
      for (var i = 0; i < LitanyService.streakPerStep; i++) {
        view = await answer(view, right: true);
        view = await endpoints.litany.next(user);
      }
      expect(view.streak, LitanyService.streakPerStep);
      expect(view.multiplier, 2);
      expect(view.nextPoints, LitanyService.basePoints * 2);

      view = await answer(view, right: true);
      expect(view.lastGain, LitanyService.basePoints * 2);
    });

    test('when the lives run out then the run ends and the score becomes the '
        'record', () async {
      var view = await endpoints.litany.start(user);
      view = await answer(view, right: true);
      for (var i = 0; i < LitanyService.lives; i++) {
        view = await endpoints.litany.next(user);
        view = await answer(view, right: false);
      }
      expect(view.finished, isTrue);
      expect(view.lives, 0);
      expect(view.runId, isNull);
      expect(view.score, LitanyService.basePoints);
      expect(view.bestScore, LitanyService.basePoints);
      expect(view.newRecord, isTrue);
    });

    test('when a second run does worse then the record is kept', () async {
      var view = await endpoints.litany.start(user);
      view = await answer(view, right: true);
      for (var i = 0; i < LitanyService.lives; i++) {
        view = await endpoints.litany.next(user);
        view = await answer(view, right: false);
      }
      final record = view.bestScore;

      view = await endpoints.litany.start(user);
      for (var i = 0; i < LitanyService.lives; i++) {
        if (i > 0) view = await endpoints.litany.next(user);
        view = await answer(view, right: false);
      }
      expect(view.finished, isTrue);
      expect(view.score, 0);
      expect(view.bestScore, record);
      expect(view.newRecord, isFalse);
    });

    test('when starting again with a run in progress then the same run comes '
        'back instead of a fresh one', () async {
      final started = await endpoints.litany.start(user);
      final graded = await answer(started, right: true);
      final again = await endpoints.litany.start(user);
      expect(again.runId, started.runId);
      expect(again.score, graded.score);
    });

    test(
      'when playing on then no question comes back twice in the same run',
      () async {
        var view = await endpoints.litany.start(user);
        final ids = <int>[view.question!.id];
        for (var i = 0; i < 8; i++) {
          view = await answer(view, right: true);
          view = await endpoints.litany.next(user);
          ids.add(view.question!.id);
        }
        expect(ids.toSet(), hasLength(ids.length));
      },
    );

    test('when giving up then the run ends keeping the score', () async {
      var view = await endpoints.litany.start(user);
      view = await answer(view, right: true);
      view = await endpoints.litany.giveUp(user);
      expect(view.finished, isTrue);
      expect(view.score, LitanyService.basePoints);
      expect(view.bestScore, LitanyService.basePoints);
    });

    test(
      'when there is no run then the view says so without a question',
      () async {
        final view = await endpoints.litany.state(user);
        expect(view.runId, isNull);
        expect(view.question, isNull);
        expect(view.unavailableReason, isNull);
      },
    );
  });

  withServerpod('Given a player with no cards', (sessionBuilder, endpoints) {
    test('when starting then it is refused with a reason', () async {
      final user = await signedInUser(sessionBuilder);
      final view = await endpoints.litany.state(user);
      expect(view.runId, isNull);
      expect(view.unavailableReason, isNotNull);
      await expectLater(
        endpoints.litany.start(user),
        throwsA(isA<LitanyException>()),
      );
    });
  });
}
