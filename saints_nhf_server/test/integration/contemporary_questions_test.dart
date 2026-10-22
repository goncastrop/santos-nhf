import 'package:saints_nhf_server/src/admin/csv_catalog.dart';
import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:saints_nhf_server/src/questions/contemporary_questions.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

// The slug goes through the same slugify as the CSV: the names carry accents
// ("Guzmán"), and `adminSaint.save` refuses a slug that is not plain ASCII.
Saint _saint(String name, int birth, int death) => Saint(
  name: name,
  slug: CsvCatalog.slugify(name),
  bio: 'Bio',
  status: SaintStatus.published,
  birthYear: birth,
  deathYear: death,
);

void main() {
  withServerpod('Given a catalog with two contemporaries and saints far away', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late TestSessionBuilder admin;
    late Saint francis;
    late Saint dominic;
    late Saint augustine;

    Future<List<Question>> generated() => Question.db.find(
      session,
      where: (t) => t.kind.equals(QuestionKind.contemporary),
      orderBy: (t) => t.saintId,
    );

    setUp(() async {
      admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      francis = await Saint.db.insertRow(
        session,
        _saint('San Francisco de Asís', 1181, 1226),
      );
      dominic = await Saint.db.insertRow(
        session,
        _saint('Santo Domingo de Guzmán', 1170, 1221),
      );
      augustine = await Saint.db.insertRow(
        session,
        _saint('San Agustín de Hipona', 354, 430),
      );
      await Saint.db.insert(session, [
        _saint('Santa Teresa de Jesús', 1515, 1582),
        _saint('San Juan Bosco', 1815, 1888),
      ]);
    });

    test('when syncing then each saint with a contemporary gets one question '
        'and the others none', () async {
      final result = await ContemporaryQuestions.sync(session);
      expect(result.created, 2);
      final questions = await generated();
      expect(questions.map((q) => q.saintId), [francis.id, dominic.id]);
      final aboutFrancis = questions.first;
      expect(
        aboutFrancis.prompt,
        '¿De quién fue contemporáneo San Francisco de Asís?',
      );
      expect(
        aboutFrancis.optionSaintIds![aboutFrancis.correctIndex],
        dominic.id,
      );
    });

    test(
      'when syncing twice then the second one keeps them as they are',
      () async {
        await ContemporaryQuestions.sync(session);
        final before = await generated();
        final again = await ContemporaryQuestions.sync(session);
        expect(again.changed, isFalse);
        expect(again.kept, 2);
        final after = await generated();
        expect(after.map((q) => q.id), before.map((q) => q.id));
      },
    );

    test('when an option is renamed through the admin then its questions are '
        'rewritten in place', () async {
      await ContemporaryQuestions.sync(session);
      final before = (await generated()).first;
      await endpoints.adminSaint.save(
        admin,
        dominic.copyWith(name: 'Santo Domingo'),
        'Nombre corto',
      );
      final after = (await generated()).first;
      expect(after.id, before.id);
      expect(after.options, contains('Santo Domingo'));
      expect(
        (await generated()).last.prompt,
        '¿De quién fue contemporáneo Santo Domingo?',
      );
    });

    test('when the only contemporary moves to draft then the question goes '
        'away', () async {
      await ContemporaryQuestions.sync(session);
      await endpoints.adminSaint.save(
        admin,
        dominic.copyWith(status: SaintStatus.draft),
        null,
      );
      expect(await generated(), isEmpty);
    });

    test(
      'when a saint gains a contemporary then it gets its question',
      () async {
        await ContemporaryQuestions.sync(session);
        await endpoints.adminSaint.save(
          admin,
          Saint(
            name: 'San Jerónimo',
            slug: 'san-jeronimo',
            bio: 'Bio',
            status: SaintStatus.published,
            birthYear: 347,
            deathYear: 420,
          ),
          null,
        );
        final saintIds = (await generated()).map((q) => q.saintId).toSet();
        expect(saintIds, contains(augustine.id));
      },
    );

    test('when the admin tries to edit or delete one then it is refused, and '
        'the CSV leaves them out', () async {
      await ContemporaryQuestions.sync(session);
      final q = (await generated()).first;
      await expectLater(
        endpoints.adminQuestion.save(admin, q.copyWith(prompt: 'Otra cosa')),
        throwsA(isA<AdminException>()),
      );
      await expectLater(
        endpoints.adminQuestion.delete(admin, q.id!),
        throwsA(isA<AdminException>()),
      );
      final csv = await endpoints.adminCatalog.exportQuestionsCsv(admin);
      expect(csv, isNot(contains('contemporáneo')));
    });

    test('when the admin types a question then it is stored as typed even if '
        'the client claims otherwise', () async {
      final saved = await endpoints.adminQuestion.save(
        admin,
        Question(
          saintId: francis.id!,
          prompt: '¿Dónde nació?',
          options: const ['Asís', 'Roma', 'Siena', 'Padua'],
          correctIndex: 0,
          kind: QuestionKind.contemporary,
          optionSaintIds: const [1, 2, 3, 4],
        ),
      );
      expect(saved.kind, QuestionKind.manual);
      expect(saved.optionSaintIds, isNull);
    });

    test('when a player is asked one then the ids of the options travel in '
        'the order they see them', () async {
      await ContemporaryQuestions.sync(session);
      final q = (await generated()).first;
      final player = await signedInUser(sessionBuilder);
      final me = player.build().authenticated!.authUserId;
      await UserSaintCard.db.insertRow(
        session,
        UserSaintCard(
          authUserId: me,
          saintId: francis.id!,
          source: CardSource.daily,
        ),
      );
      final quiz = await endpoints.quiz.today(player);
      final shown = quiz.question!;
      expect(shown.id, q.id);
      final names = {
        for (final s in await Saint.db.find(session)) s.id!: s.name,
      };
      for (var i = 0; i < 4; i++) {
        expect(shown.options[i], names[shown.optionSaintIds![i]]);
      }
    });
  });
}
