import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:saints_nhf_flutter/screens/map_screen.dart';
import 'package:saints_nhf_flutter/state/app_state.dart';
import 'package:saints_nhf_flutter/theme.dart';
import 'package:saints_nhf_flutter/utils/world.dart';

SaintInfo _saint(
  int id,
  String name, {
  String? birthPlace,
  double? birthLat,
  double? birthLng,
  String? deathPlace,
  double? deathLat,
  double? deathLng,
}) => SaintInfo(
  id: id,
  name: name,
  slug: 's$id',
  bio: 'bio',
  birthApprox: false,
  deathApprox: false,
  birthPlace: birthPlace,
  birthLat: birthLat,
  birthLng: birthLng,
  deathPlace: deathPlace,
  deathLat: deathLat,
  deathLng: deathLng,
);

Future<void> _pump(WidgetTester tester, List<SaintInfo> catalog) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final state = AppState()..catalog = catalog;
  await tester.pumpWidget(
    AppStateScope(
      state: state,
      child: MaterialApp(
        theme: buildTheme(),
        home: const Scaffold(body: MapScreen()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

/// Cualquier marcador agrupado.
final _anyCluster = find.byWidgetPredicate(
  (w) => w is Tooltip && (w.message ?? '').contains('santos acá'),
);

/// El marcador de un santo, sin confundirlo con los tooltips de los botones.
Finder _marker(String name) => find.byWidgetPredicate(
  (w) => w is Tooltip && (w.message ?? '').startsWith(name),
);

void main() {
  // El asset se lee una sola vez y acá afuera: adentro de `testWidgets` el
  // tiempo es falso y un `await` sobre entrada/salida real no vuelve nunca.
  // Además, con el indicador de carga girando `pumpAndSettle` no asienta.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await WorldOutlines.load();
  });

  group('Mercator', () {
    test('wraps longitude across the full width', () {
      expect(Mercator.x(-180), 0);
      expect(Mercator.x(0), 0.5);
      expect(Mercator.x(180), 1);
    });

    test('puts the equator halfway down and clamps the poles', () {
      expect(Mercator.y(0), closeTo(0.5, 0.0001));
      expect(Mercator.yInCrop(Mercator.maxLatitude), closeTo(0, 0.0001));
      expect(Mercator.yInCrop(-Mercator.maxLatitude), closeTo(1, 0.0001));
      // Anything beyond the crop is pinned to its edge, never off the map.
      expect(Mercator.yInCrop(89), closeTo(0, 0.0001));
      expect(Mercator.yInCrop(-89), closeTo(1, 0.0001));
    });

    test('the north is above the equator and the south below', () {
      expect(Mercator.yInCrop(45), lessThan(Mercator.yInCrop(0)));
      expect(Mercator.yInCrop(-45), greaterThan(Mercator.yInCrop(0)));
    });
  });

  group('the world asset', () {
    test('ships with the app and parses into closed outlines', () async {
      final world = await WorldOutlines.load();
      expect(world.rings, isNotEmpty);
      for (final ring in world.rings) {
        expect(ring.length.isEven, isTrue, reason: 'lng/lat pairs');
        expect(ring.length, greaterThanOrEqualTo(8));
        for (var i = 0; i < ring.length; i += 2) {
          expect(ring[i], inInclusiveRange(-180, 180));
          expect(ring[i + 1], inInclusiveRange(-90, 90));
        }
      }
      // Loading it twice must not re-parse the asset.
      expect(identical(await WorldOutlines.load(), world), isTrue);
    });
  });

  group('MapScreen', () {
    testWidgets('counts the saints it could place', (tester) async {
      await _pump(tester, [
        _saint(1, 'San Ubicado', birthLat: 41.9, birthLng: 12.5),
        _saint(2, 'San Perdido'),
      ]);
      expect(find.text('1 ubicados · 1 sin lugar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('switching to where they died moves the markers', (
      tester,
    ) async {
      // Born in Rome, died in Lima: the two ends are worlds apart.
      await _pump(tester, [
        _saint(
          1,
          'San Viajero',
          birthPlace: 'Roma',
          birthLat: 41.9,
          birthLng: 12.5,
          deathPlace: 'Lima',
          deathLat: -12.0,
          deathLng: -77.0,
        ),
      ]);

      Offset markerAt() => tester.getCenter(_marker('San Viajero'));

      final born = markerAt();
      expect(_marker('San Viajero'), findsOneWidget);

      await tester.tap(find.text('MURIÓ'));
      await tester.pump();
      final died = markerAt();

      expect(tester.takeException(), isNull);
      // Lima is west of Rome and south of the equator.
      expect(died.dx, lessThan(born.dx));
      expect(died.dy, greaterThan(born.dy));
    });

    testWidgets('saints in neighbouring cities become one marker, and the '
        'zoom takes them apart', (tester) async {
      // Tres a unos grados de distancia y uno del otro lado del mundo.
      await _pump(tester, [
        _saint(1, 'San Uno', birthLat: 41.9, birthLng: 12.5),
        _saint(2, 'San Dos', birthLat: 45.1, birthLng: 7.7),
        _saint(3, 'San Tres', birthLat: 43.8, birthLng: 11.3),
        _saint(4, 'San Lejos', birthLat: -34.6, birthLng: -58.4),
      ]);

      expect(find.text('3'), findsOneWidget, reason: 'el grupo de Italia');
      expect(_marker('San Lejos'), findsOneWidget);
      expect(_marker('San Uno'), findsNothing);

      // Acercando se van abriendo hasta que no queda ningún grupo.
      for (var i = 0; i < 10 && _anyCluster.evaluate().isNotEmpty; i++) {
        await tester.tap(find.byTooltip('Acercar'));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      expect(_anyCluster, findsNothing);
      expect(_marker('San Uno'), findsOneWidget);
      expect(_marker('San Dos'), findsOneWidget);
      expect(_marker('San Tres'), findsOneWidget);
    });

    testWidgets('saints of the same city are listed instead, because no zoom '
        'will ever separate them', (tester) async {
      await _pump(tester, [
        _saint(
          1,
          'San Romano',
          birthPlace: 'Roma',
          birthLat: 41.9028,
          birthLng: 12.4964,
        ),
        _saint(
          2,
          'Santa Romana',
          birthPlace: 'Roma',
          birthLat: 41.9028,
          birthLng: 12.4964,
        ),
      ]);
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // La hoja lista a los dos, con el lugar como encabezado.
      expect(find.text('San Romano'), findsOneWidget);
      expect(find.text('Santa Romana'), findsOneWidget);
    });

    testWidgets('the zoom buttons move the map in and out', (tester) async {
      await _pump(tester, [
        _saint(1, 'San Ubicado', birthLat: 41.9, birthLng: 12.5),
      ]);

      double scale() => tester
          .widget<InteractiveViewer>(find.byType(InteractiveViewer))
          .transformationController!
          .value
          .getMaxScaleOnAxis();

      expect(scale(), 1);
      // Alejar no hace nada cuando ya se ve todo el mundo.
      expect(find.byTooltip('Ver todo el mundo'), findsNothing);

      await tester.tap(find.byTooltip('Acercar'));
      await tester.pumpAndSettle();
      final acercado = scale();
      expect(acercado, greaterThan(1));
      expect(find.byTooltip('Ver todo el mundo'), findsOneWidget);

      await tester.tap(find.byTooltip('Alejar'));
      await tester.pumpAndSettle();
      expect(scale(), lessThan(acercado));

      await tester.tap(find.byTooltip('Acercar'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Ver todo el mundo'));
      await tester.pumpAndSettle();
      expect(scale(), 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a saint with only one end of the journey still shows up on '
        'the side that has it', (tester) async {
      await _pump(tester, [
        _saint(1, 'San Solo Nace', birthLat: 41.9, birthLng: 12.5),
      ]);
      expect(find.text('1 santos'), findsOneWidget);

      await tester.tap(find.text('MURIÓ'));
      await tester.pump();
      expect(find.text('0 ubicados · 1 sin lugar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
