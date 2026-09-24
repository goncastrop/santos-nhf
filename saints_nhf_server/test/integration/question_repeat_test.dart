import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:saints_nhf_server/src/questions/question_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

Question _question(int saintId, String prompt) => Question(
  saintId: saintId,
  prompt: prompt,
  options: const ['A', 'B', 'C', 'D'],
  correctIndex: 0,
);

void main() {
  withServerpod('Given a saint with several questions', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late UuidValue me;
    late Saint saint;
    late List<Question> questions;

    setUp(() async {
      me = (await signedInUser(
        sessionBuilder,
      )).build().authenticated!.authUserId;
      saint = await Saint.db.insertRow(
        session,
        Saint(
          name: 'Santo de prueba',
          slug: 'santo-de-prueba',
          bio: 'Bio',
          status: SaintStatus.published,
        ),
      );
      questions = await Question.db.insert(session, [
        for (var i = 1; i <= 5; i++) _question(saint.id!, 'Pregunta $i'),
      ]);
    });

    test('when picking five times then every question comes up once before '
        'any repeats', () async {
      final drawn = <int>[];
      for (var i = 0; i < questions.length; i++) {
        final q = await QuestionService.pickForPlayer(session, me, {saint.id!});
        expect(q, isNotNull);
        await QuestionService.markSeen(session, me, q!.id!);
        drawn.add(q.id!);
      }
      expect(drawn.toSet(), hasLength(questions.length));
      expect(drawn.toSet(), questions.map((q) => q.id).toSet());
    });

    test('when the pool is exhausted then it starts over instead of running '
        'out of questions', () async {
      for (final q in questions) {
        await QuestionService.markSeen(session, me, q.id!);
      }
      final again = await QuestionService.pickForPlayer(session, me, {
        saint.id!,
      });
      expect(again, isNotNull);
    });

    test('when a question is excluded then it is not picked', () async {
      final excluded = questions.map((q) => q.id!).toSet()
        ..remove(questions.last.id!);
      final q = await QuestionService.pickForPlayer(
        session,
        me,
        {saint.id!},
        exclude: excluded,
      );
      expect(q?.id, questions.last.id);
    });

    test("when another player has seen them then my own history is what "
        'counts', () async {
      final other = (await signedInUser(
        sessionBuilder,
      )).build().authenticated!.authUserId;
      for (final q in questions) {
        await QuestionService.markSeen(session, other, q.id!);
      }
      final drawn = <int>[];
      for (var i = 0; i < questions.length; i++) {
        final q = await QuestionService.pickForPlayer(session, me, {saint.id!});
        await QuestionService.markSeen(session, me, q!.id!);
        drawn.add(q.id!);
      }
      expect(drawn.toSet(), hasLength(questions.length));
    });
  });
}
