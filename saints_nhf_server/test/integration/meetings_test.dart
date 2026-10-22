import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given saints who met in life', (sessionBuilder, endpoints) {
    final session = sessionBuilder.build();
    late TestSessionBuilder admin;
    late Saint juanPablo;
    late Saint teresa;
    late Saint romero;
    late Saint francisco;
    late Saint borrador;

    Future<Saint> insert(
      String name,
      String slug,
      int birth,
      int death, {
      SaintStatus status = SaintStatus.published,
    }) => Saint.db.insertRow(
      session,
      Saint(
        name: name,
        slug: slug,
        bio: 'Bio',
        birthYear: birth,
        deathYear: death,
        status: status,
      ),
    );

    setUp(() async {
      admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      juanPablo = await insert(
        'San Juan Pablo II',
        'san-juan-pablo-ii',
        1920,
        2005,
      );
      teresa = await insert(
        'Santa Teresa de Calcuta',
        'santa-teresa-de-calcuta',
        1910,
        1997,
      );
      romero = await insert('San Óscar Romero', 'san-oscar-romero', 1917, 1980);
      francisco = await insert(
        'San Francisco de Asís',
        'san-francisco-de-asis',
        1181,
        1226,
      );
      borrador = await insert(
        'Santa Borrador',
        'santa-borrador',
        1915,
        1990,
        status: SaintStatus.draft,
      );
    });

    test('when nobody was added then the detail has no met saints', () async {
      final detail = await endpoints.saint.detail(sessionBuilder, teresa.id!);
      expect(detail.metSaints, isEmpty);
    });

    test('when the admin adds a pair then both fichas show the other, '
        'oldest first', () async {
      await endpoints.adminMeeting.add(admin, juanPablo.id!, teresa.id!);
      await endpoints.adminMeeting.add(admin, juanPablo.id!, romero.id!);

      final ofJuanPablo = await endpoints.saint.detail(
        sessionBuilder,
        juanPablo.id!,
      );
      expect(ofJuanPablo.metSaints.map((s) => s.slug), [
        'santa-teresa-de-calcuta',
        'san-oscar-romero',
      ]);
      final ofTeresa = await endpoints.saint.detail(sessionBuilder, teresa.id!);
      expect(ofTeresa.metSaints.map((s) => s.slug), ['san-juan-pablo-ii']);
    });

    test('when the same pair is added twice, in either order, then it is '
        'stored once', () async {
      await endpoints.adminMeeting.add(admin, juanPablo.id!, teresa.id!);
      final met = await endpoints.adminMeeting.add(
        admin,
        teresa.id!,
        juanPablo.id!,
      );
      expect(met.map((s) => s.id), [juanPablo.id]);
      expect(await SaintMeeting.db.count(session), 1);
    });

    test('when the other saint is a draft then the admin sees it and the '
        'public ficha does not', () async {
      await endpoints.adminMeeting.add(admin, teresa.id!, borrador.id!);
      final forAdmin = await endpoints.adminMeeting.listFor(admin, teresa.id!);
      expect(forAdmin.map((s) => s.id), [borrador.id]);
      final detail = await endpoints.saint.detail(sessionBuilder, teresa.id!);
      expect(detail.metSaints, isEmpty);
    });

    test('when the two never lived at the same time then adding fails', () {
      expect(
        endpoints.adminMeeting.add(admin, juanPablo.id!, francisco.id!),
        throwsA(isA<AdminException>()),
      );
    });

    test(
      'when removing a pair from either side then both fichas lose it',
      () async {
        await endpoints.adminMeeting.add(admin, juanPablo.id!, teresa.id!);
        final met = await endpoints.adminMeeting.remove(
          admin,
          teresa.id!,
          juanPablo.id!,
        );
        expect(met, isEmpty);
        final detail = await endpoints.saint.detail(
          sessionBuilder,
          juanPablo.id!,
        );
        expect(detail.metSaints, isEmpty);
      },
    );

    test('when a saint is deleted then its meetings go with it', () async {
      await endpoints.adminMeeting.add(admin, juanPablo.id!, teresa.id!);
      await endpoints.adminSaint.delete(admin, teresa.id!);
      expect(await SaintMeeting.db.count(session), 0);
    });

    test(
      'when a player who is not admin adds a pair then it is refused',
      () async {
        final player = await signedInUser(sessionBuilder);
        expect(
          endpoints.adminMeeting.add(player, juanPablo.id!, teresa.id!),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );
      },
    );

    test(
      'when importing the meetings CSV then the preview lists the new '
      'pairs, applying writes them and a second import changes nothing',
      () async {
        await endpoints.adminMeeting.add(admin, juanPablo.id!, teresa.id!);
        const csv = '''
santo_slug,otro_santo_slug
santa-teresa-de-calcuta,san-juan-pablo-ii
san-juan-pablo-ii,san-oscar-romero
''';
        final preview = await endpoints.adminCatalog.importMeetingsCsv(
          admin,
          csv,
          false,
        );
        expect(preview.errors, isEmpty);
        expect(preview.created, 1);
        expect(preview.unchanged, 1);
        expect(await SaintMeeting.db.count(session), 1);

        final applied = await endpoints.adminCatalog.importMeetingsCsv(
          admin,
          csv,
          true,
        );
        expect(applied.applied, isTrue);
        expect(await SaintMeeting.db.count(session), 2);

        final again = await endpoints.adminCatalog.importMeetingsCsv(
          admin,
          csv,
          true,
        );
        expect(again.created, 0);
        expect(again.unchanged, 2);
      },
    );

    test(
      'when the meetings CSV has a bad line then nothing is imported',
      () async {
        const csv = '''
santo_slug,otro_santo_slug
san-juan-pablo-ii,santa-teresa-de-calcuta
san-juan-pablo-ii,san-francisco-de-asis
san-juan-pablo-ii,san-inexistente
santa-teresa-de-calcuta,san-juan-pablo-ii
''';
        final report = await endpoints.adminCatalog.importMeetingsCsv(
          admin,
          csv,
          true,
        );
        expect(report.applied, isFalse);
        expect(report.errors, hasLength(3));
        expect(report.errors[0], contains('no vivieron en la misma época'));
        expect(report.errors[1], contains('san-inexistente'));
        expect(report.errors[2], contains('ya están en otra línea'));
        expect(await SaintMeeting.db.count(session), 0);
      },
    );

    test(
      'when exporting then each pair is one row with the oldest first',
      () async {
        await endpoints.adminMeeting.add(admin, juanPablo.id!, teresa.id!);
        await endpoints.adminMeeting.add(admin, romero.id!, juanPablo.id!);
        final csv = await endpoints.adminCatalog.exportMeetingsCsv(admin);
        expect(csv.trim().split('\n'), [
          'santo_slug,otro_santo_slug',
          'santa-teresa-de-calcuta,san-juan-pablo-ii',
          'san-oscar-romero,san-juan-pablo-ii',
        ]);
      },
    );
  });
}
