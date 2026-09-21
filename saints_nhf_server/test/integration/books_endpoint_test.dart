import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a published saint with recommended reading', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late TestSessionBuilder admin;
    late Saint saint;

    setUp(() async {
      admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      saint = await Saint.db.insertRow(
        session,
        Saint(
          name: 'Santa Teresa de Jesús',
          slug: 'santa-teresa-de-jesus',
          bio: 'Bio',
          status: SaintStatus.published,
          birthYear: 1515,
          deathYear: 1582,
        ),
      );
    });

    test('when reading the saint page then the books come grouped with the '
        "saint's own writing first", () async {
      // Inserted out of order on purpose.
      await SaintBook.db.insert(session, [
        SaintBook(
          saintId: saint.id!,
          title: 'Teresa de Ávila',
          author: 'Marcelle Auclair',
          kind: BookKind.biografia,
          position: 0,
        ),
        SaintBook(
          saintId: saint.id!,
          title: 'Las moradas',
          kind: BookKind.obra,
          position: 1,
        ),
        SaintBook(
          saintId: saint.id!,
          title: 'Libro de la vida',
          kind: BookKind.autobiografia,
          position: 0,
        ),
      ]);

      final detail = await endpoints.saint.detail(sessionBuilder, saint.id!);
      expect(detail.books.map((b) => b.title), [
        'Libro de la vida',
        'Las moradas',
        'Teresa de Ávila',
      ]);
      // The years travel with the public info, for the timeline.
      expect(detail.saint.birthYear, 1515);
      expect(detail.saint.deathYear, 1582);
      expect(detail.saint.birthApprox, isFalse);
    });

    test('when an admin saves, reorders and deletes books then the saint page '
        'follows', () async {
      final first = await endpoints.adminBook.save(
        admin,
        SaintBook(saintId: saint.id!, title: 'Camino', kind: BookKind.obra),
      );
      final second = await endpoints.adminBook.save(
        admin,
        SaintBook(saintId: saint.id!, title: 'Moradas', kind: BookKind.obra),
      );
      expect(await endpoints.adminBook.counts(admin), {saint.id!: 2});

      final reordered = await endpoints.adminBook.reorder(
        admin,
        saint.id!,
        [second.id!, first.id!],
      );
      expect(reordered.map((b) => b.title), ['Moradas', 'Camino']);

      await endpoints.adminBook.delete(admin, first.id!);
      final detail = await endpoints.saint.detail(sessionBuilder, saint.id!);
      expect(detail.books.map((b) => b.title), ['Moradas']);
    });

    test('when a book has an invalid link then it is rejected', () async {
      await expectLater(
        endpoints.adminBook.save(
          admin,
          SaintBook(
            saintId: saint.id!,
            title: 'Libro',
            kind: BookKind.obra,
            url: 'no-es-un-link',
          ),
        ),
        throwsA(isA<AdminException>()),
      );
      await expectLater(
        endpoints.adminBook.save(
          admin,
          SaintBook(saintId: saint.id!, title: '   ', kind: BookKind.obra),
        ),
        throwsA(isA<AdminException>()),
      );
    });

    test('when deleting the saint then its books go with it', () async {
      await endpoints.adminBook.save(
        admin,
        SaintBook(saintId: saint.id!, title: 'Camino', kind: BookKind.obra),
      );
      await endpoints.adminSaint.delete(admin, saint.id!);
      expect(await SaintBook.db.find(session), isEmpty);
    });

    test('when importing the books CSV then rows are created, matched by '
        'title and reported', () async {
      const csv = '''
id,santo_slug,titulo,autor,tipo,anio,editorial,link,nota
,santa-teresa-de-jesus,Las moradas,,obra,1577,,,La cumbre de su enseñanza
,santa-teresa-de-jesus,Teresa de Ávila,Marcelle Auclair,biografia,1950,,,
''';
      final preview = await endpoints.adminCatalog.importBooksCsv(
        admin,
        csv,
        false,
      );
      expect(preview.errors, isEmpty);
      expect(preview.created, 2);
      expect(preview.applied, isFalse);

      await endpoints.adminCatalog.importBooksCsv(admin, csv, true);
      final detail = await endpoints.saint.detail(sessionBuilder, saint.id!);
      expect(detail.books, hasLength(2));
      expect(detail.books.first.title, 'Las moradas');
      expect(detail.books.first.note, 'La cumbre de su enseñanza');

      // Importing the same file again matches by title and changes nothing.
      final again = await endpoints.adminCatalog.importBooksCsv(
        admin,
        csv,
        true,
      );
      expect(again.created, 0);
      expect(again.unchanged, 2);

      final exported = await endpoints.adminCatalog.exportBooksCsv(admin);
      expect(exported, contains('Las moradas'));
      expect(exported.trim().split('\n'), hasLength(3));
    });

    test(
      'when a CSV row has an unknown book kind then only that line fails',
      () async {
        const csv = '''
id,santo_slug,titulo,autor,tipo,anio,editorial,link,nota
,santa-teresa-de-jesus,Las moradas,,poema,,,,
''';
        final report = await endpoints.adminCatalog.importBooksCsv(
          admin,
          csv,
          true,
        );
        expect(report.applied, isFalse);
        expect(report.errors.single, contains('tipo de libro desconocido'));
        expect(await SaintBook.db.find(session), isEmpty);
      },
    );

    test(
      'when importing the life years then they round-trip through the CSV',
      () async {
        const csv = '''
slug,nombre,nacimiento,nacimiento_aprox,muerte,muerte_aprox,estado,biografia
santa-teresa-de-jesus,Santa Teresa de Jesús,1515,no,1582,si,publicado,Bio
''';
        final report = await endpoints.adminCatalog.importSaintsCsv(
          admin,
          csv,
          true,
        );
        expect(report.errors, isEmpty);
        final stored = await Saint.db.findById(session, saint.id!);
        expect(stored!.birthYear, 1515);
        expect(stored.deathApprox, isTrue);

        final exported = await endpoints.adminCatalog.exportSaintsCsv(admin);
        expect(exported, contains('1515,no,1582,si'));
      },
    );

    test(
      'when the years are the wrong way around then the row is rejected',
      () async {
        const csv = '''
slug,nombre,nacimiento,muerte,estado,biografia
santa-teresa-de-jesus,Santa Teresa de Jesús,1582,1515,publicado,Bio
''';
        final report = await endpoints.adminCatalog.importSaintsCsv(
          admin,
          csv,
          true,
        );
        expect(report.applied, isFalse);
        expect(report.errors.single, contains('posterior al de muerte'));
      },
    );
  });
}
