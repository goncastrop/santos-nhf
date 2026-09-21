import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an admin and one published saint', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late TestSessionBuilder admin;
    late Saint existing;

    setUp(() async {
      admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      existing = await Saint.db.insertRow(
        session,
        Saint(
          name: 'San Existente',
          slug: 'san-existente',
          bio: 'Bio original',
          status: SaintStatus.published,
          viajes: 40,
        ),
      );
    });

    test(
      'when exporting saints then the CSV has a header and one row',
      () async {
        final csv = await endpoints.adminCatalog.exportSaintsCsv(admin);
        final lines = csv.trim().split('\n');
        expect(lines, hasLength(2));
        expect(lines.first, startsWith('slug,nombre,titulo'));
        expect(lines[1], contains('san-existente'));
        expect(lines[1], contains('publicado'));
      },
    );

    test('when importing a CSV with one changed and one new saint then the '
        'preview reports it and applying writes it with a revision', () async {
      const csv = '''
slug,nombre,titulo,fiesta_mes,fiesta_dia,estado,viajes,biografia,oracion_texto
san-existente,San Existente,Obispo,3,12,publicado,90,Bio original,Oración nueva
,San Nuevo Ñandú,,,,borrador,15,Bio nueva,
''';
      final preview = await endpoints.adminCatalog.importSaintsCsv(
        admin,
        csv,
        false,
      );
      expect(preview.applied, isFalse);
      expect(preview.errors, isEmpty);
      expect(preview.created, 1);
      expect(preview.updated, 1);
      expect(preview.changes.first, contains('viajes'));

      // Nothing was written by the preview.
      expect((await Saint.db.findById(session, existing.id!))!.viajes, 40);

      final applied = await endpoints.adminCatalog.importSaintsCsv(
        admin,
        csv,
        true,
      );
      expect(applied.applied, isTrue);
      final updated = (await Saint.db.findById(session, existing.id!))!;
      expect(updated.viajes, 90);
      expect(updated.title, 'Obispo');
      expect(updated.feastMonth, 3);
      expect(updated.prayer, 'Oración nueva');
      final created = await Saint.db.findFirstRow(
        session,
        where: (t) => t.slug.equals('san-nuevo-nandu'),
      );
      expect(created, isNotNull);
      expect(created!.status, SaintStatus.draft);
      final revisions = await endpoints.adminSaint.revisions(
        admin,
        existing.id!,
      );
      expect(revisions.single.note, 'Importación CSV');
    });

    test('when the liturgical titles column is imported then it is parsed, '
        'exported back and unknown values are reported', () async {
      const csv = '''
slug,nombre,titulos_liturgicos,estado,biografia
san-existente,San Existente,doctor; obispo,publicado,Bio original
''';
      final report = await endpoints.adminCatalog.importSaintsCsv(
        admin,
        csv,
        true,
      );
      expect(report.applied, isTrue);
      final updated = (await Saint.db.findById(session, existing.id!))!;
      expect(updated.titles, [SaintTitle.doctor, SaintTitle.obispo]);

      final exported = await endpoints.adminCatalog.exportSaintsCsv(admin);
      expect(exported, contains('doctor; obispo'));

      const bad = '''
slug,nombre,titulos_liturgicos,estado,biografia
san-existente,San Existente,arzobispo,publicado,Bio original
''';
      final failed = await endpoints.adminCatalog.importSaintsCsv(
        admin,
        bad,
        true,
      );
      expect(failed.applied, isFalse);
      expect(failed.errors.single, contains('arzobispo'));
    });

    test('when a row is invalid then nothing is imported and the error names '
        'the line', () async {
      const csv = '''
slug,nombre,estado,viajes,biografia
san-existente,San Existente,publicado,150,Bio original
''';
      final report = await endpoints.adminCatalog.importSaintsCsv(
        admin,
        csv,
        true,
      );
      expect(report.applied, isFalse);
      expect(report.errors.single, contains('Línea 2'));
      expect(report.errors.single, contains('viajes'));
      expect((await Saint.db.findById(session, existing.id!))!.viajes, 40);
    });

    test('when importing questions then they are created, matched by prompt '
        'on re-import and exported with letters', () async {
      const csv = '''
id,santo_slug,pregunta,opcion_a,opcion_b,opcion_c,opcion_d,correcta
,san-existente,¿Dónde nació?,Roma,Asís,Siena,Lima,c
''';
      final first = await endpoints.adminCatalog.importQuestionsCsv(
        admin,
        csv,
        true,
      );
      expect(first.created, 1);
      final questions = await Question.db.find(session);
      expect(questions.single.correctIndex, 2);

      // Same prompt again, different answer: an update, not a duplicate.
      const again = '''
id,santo_slug,pregunta,opcion_a,opcion_b,opcion_c,opcion_d,correcta
,san-existente,¿Dónde nació?,Roma,Asís,Siena,Lima,B
''';
      final second = await endpoints.adminCatalog.importQuestionsCsv(
        admin,
        again,
        true,
      );
      expect(second.created, 0);
      expect(second.updated, 1);
      expect((await Question.db.find(session)).single.correctIndex, 1);

      final exported = await endpoints.adminCatalog.exportQuestionsCsv(admin);
      expect(exported.trim().split('\n').last, endsWith(',B'));

      const bad = '''
id,santo_slug,pregunta,opcion_a,opcion_b,opcion_c,opcion_d,correcta
,no-existe,¿Qué?,a,b,c,d,A
''';
      final report = await endpoints.adminCatalog.importQuestionsCsv(
        admin,
        bad,
        true,
      );
      expect(report.errors.single, contains('no-existe'));
    });
  });
}
