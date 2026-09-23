import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

/// The starter pack has to be granted once even when the calls race.
///
/// This is a regression test for a bug that gave brand new players the whole
/// catalog: the app asks for the collection from several endpoints at once on
/// sign-in, and under READ COMMITTED each statement sees a fresh snapshot, so
/// both transactions read `starterGranted == false` and the second one then
/// picks from a list of missing saints that already excludes the first one's
/// cards. The picks do not collide with the unique index, so both grants land.
void main() {
  withServerpod(
    'Given a catalog with more saints than the starter pack',
    (sessionBuilder, endpoints) {
      late List<Saint> saints;

      setUpAll(() async {
        final session = sessionBuilder.build();
        saints = await Saint.db.insert(session, [
          for (var i = 1; i <= 9; i++)
            Saint(
              name: 'Santo $i',
              slug: 'santo-$i',
              title: 'Prueba',
              titles: [],
              feastMonth: 1,
              feastDay: i,
              bio: 'Bio',
              prayer: 'Oración',
              status: SaintStatus.published,
              catequesis: 50,
              escritos: 50,
              oracion: 50,
              patronazgos: 50,
              evangelizacion: 50,
              viajes: 50,
              updatedAt: DateTime.now().toUtc(),
            ),
        ]);
      });

      test('when several endpoints ask for the collection at once then the '
          'starter pack is granted exactly once', () async {
        final user = await signedInUser(sessionBuilder);

        // Same shape as AppState.loadAll, which is what triggered the bug.
        await Future.wait<Object?>([
          endpoints.collection.overview(user),
          endpoints.collection.overview(user),
          endpoints.collection.overview(user),
        ]);

        final session = sessionBuilder.build();
        final cartas = await UserSaintCard.db.find(session);
        expect(
          cartas.length,
          5,
          reason:
              'el mazo inicial son 5 cartas, no una por llamada en paralelo',
        );
        expect(
          cartas.map((c) => c.saintId).toSet().length,
          5,
          reason: 'sin santos repetidos',
        );
        expect(saints.length, 9, reason: 'el catálogo tiene de sobra');
      });
    },
    // Each endpoint opens its own transaction, so the test cannot run inside a
    // rollback transaction of its own.
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
