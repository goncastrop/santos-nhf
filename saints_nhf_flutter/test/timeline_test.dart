import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:saints_nhf_flutter/church_events.dart';
import 'package:saints_nhf_flutter/screens/timeline_screen.dart';
import 'package:saints_nhf_flutter/state/app_state.dart';
import 'package:saints_nhf_flutter/theme.dart';
import 'package:saints_nhf_flutter/utils/years.dart';

SaintInfo _saint(
  int id,
  String name, {
  int? birth,
  int? death,
  bool birthApprox = false,
  bool deathApprox = false,
}) => SaintInfo(
  id: id,
  name: name,
  slug: 's$id',
  bio: 'bio',
  birthYear: birth,
  birthApprox: birthApprox,
  deathYear: death,
  deathApprox: deathApprox,
);

Future<void> _pump(WidgetTester tester, List<SaintInfo> catalog) async {
  final state = AppState()..catalog = catalog;
  await tester.pumpWidget(
    AppStateScope(
      state: state,
      child: MaterialApp(
        theme: buildTheme(),
        home: const Scaffold(body: TimelineScreen()),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('lifespan labels', () {
    test('reads both ends, with "c." for the approximate ones', () {
      expect(
        lifespanLabel(
          _saint(1, 'a', birth: 1181, birthApprox: true, death: 1226),
        ),
        'c. 1181 – 1226',
      );
      expect(
        lifespanLabel(_saint(1, 'a', birth: 1515, death: 1582)),
        '1515 – 1582',
      );
    });

    test('handles one known end and years before Christ', () {
      expect(lifespanLabel(_saint(1, 'a', birth: 1900)), 'n. 1900');
      expect(
        lifespanLabel(_saint(1, 'a', death: 67, deathApprox: true)),
        '† c. 67',
      );
      expect(
        lifespanLabel(_saint(1, 'a', birth: -4, death: 30)),
        '4 a.C. – 30',
      );
      expect(lifespanLabel(_saint(1, 'a')), isNull);
    });

    test('centuries count from 1, including before Christ', () {
      expect(centuryOf(1), 1);
      expect(centuryOf(100), 1);
      expect(centuryOf(101), 2);
      expect(centuryOf(1226), 13);
      expect(centuryOf(-1), -1);
      expect(centuryOf(-100), -1);
      expect(centuryOf(-101), -2);
      expect(centuryLabel(13), 's. XIII');
      expect(centuryLabel(-1), 's. I a.C.');
    });

    test('a missing end still gives the bar a length', () {
      expect(lifeSpan(_saint(1, 'a', birth: 1900))!.to, 1960);
      expect(lifeSpan(_saint(1, 'a', death: 1900))!.from, 1840);
      expect(lifeSpan(_saint(1, 'a')), isNull);
      expect(hasBothYears(_saint(1, 'a', birth: 1, death: 2)), isTrue);
      expect(hasBothYears(_saint(1, 'a', birth: 1)), isFalse);
    });
  });

  group('church events', () {
    test('only the ones inside the years the saints cover', () {
      final names = [
        for (final e in churchEventsBetween(1490, 1590)) e.name,
      ];
      expect(names, contains('Concilio de Trento'));
      expect(names, contains('Reforma protestante'));
      // Antes y después del catálogo: el eje es de los santos.
      expect(names, isNot(contains('Pentecostés')));
      expect(names, isNot(contains('Concilio Vaticano II')));
    });

    test('an event that started before the window still counts', () {
      // Trento va de 1545 a 1563: un catálogo que arranca en 1550 lo está
      // viviendo igual.
      final names = [for (final e in churchEventsBetween(1550, 1560)) e.name];
      expect(names, contains('Concilio de Trento'));
    });

    test('the list runs forward and every event with it', () {
      var previous = -10000;
      for (final event in churchEvents) {
        expect(
          event.year,
          greaterThanOrEqualTo(previous),
          reason: '${event.name} está fuera de orden',
        );
        expect(
          event.lastYear,
          greaterThanOrEqualTo(event.year),
          reason: '${event.name} termina antes de empezar',
        );
        expect(event.note, isNotEmpty, reason: '${event.name} sin nota');
        previous = event.year;
      }
    });
  });

  group('TimelineScreen', () {
    testWidgets('lays out saints spread over twenty centuries', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await _pump(tester, [
        _saint(1, 'San Pablo', birth: 5, death: 67, birthApprox: true),
        _saint(2, 'San Agustín de Hipona', birth: 354, death: 430),
        _saint(3, 'San Francisco de Asís', birth: 1181, death: 1226),
        _saint(4, 'Santa Catalina de Siena', birth: 1347, death: 1380),
        _saint(5, 'Santa Teresa de Jesús', birth: 1515, death: 1582),
        _saint(6, 'San Ignacio de Loyola', birth: 1491, death: 1556),
        _saint(7, 'San Francisco Javier', birth: 1506, death: 1552),
        _saint(8, 'Santa Teresa de Lisieux', birth: 1873, death: 1897),
        _saint(9, 'San Juan Pablo II', birth: 1920, death: 2005),
        _saint(10, 'Sin fechas'),
      ]);

      expect(tester.takeException(), isNull);
      expect(find.text('9 ubicados · 1 sin fechas'), findsOneWidget);
      // A long life reads by name at the default zoom; a shorter one needs
      // to be zoomed into.
      expect(find.text('Ignacio de Loyola'), findsOneWidget);
      expect(find.text('Francisco Javier'), findsNothing);

      await tester.tap(find.text('AÑOS'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Francisco Javier'), findsOneWidget);
      expect(find.text('Teresa de Jesús'), findsOneWidget);
      // With that much room the years are written on the bar too.
      expect(find.text('1491 – 1556'), findsOneWidget);
    });

    testWidgets('zooming in keeps every saint on screen', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await _pump(tester, [
        for (var i = 0; i < 12; i++)
          _saint(i, 'Santo $i', birth: 1500 + i, death: 1560 + i),
      ]);
      for (final zoom in ['DÉCADAS', 'AÑOS', 'SIGLOS']) {
        await tester.tap(find.text(zoom));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'zoom $zoom');
      }
    });

    testWidgets('a crowded era stacks contemporaries down the screen '
        'instead of shrinking them to initials', (tester) async {
      Future<({int lanes, double bottom, int names, int faces})> measure(
        List<SaintInfo> catalog,
      ) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await _pump(tester, catalog);
        await tester.pumpAndSettle();
        final tops = <double>{};
        var bottom = 0.0;
        for (final element in find.byType(Tooltip).evaluate()) {
          final box = element.renderObject as RenderBox?;
          if (box == null || !box.hasSize) continue;
          final at = box.localToGlobal(Offset.zero);
          if (at.dy <= 120) continue; // The century strip, not a life bar.
          tops.add(at.dy);
          bottom = math.max(bottom, at.dy + box.size.height);
        }
        expect(tester.takeException(), isNull);
        return (
          lanes: tops.length,
          bottom: bottom,
          names: find.textContaining('Contemporáneo').evaluate().length,
          faces: find.byType(ClipOval).evaluate().length,
        );
      }

      List<SaintInfo> contemporaries(int n) => [
        for (var i = 0; i < n; i++)
          _saint(i, 'San Contemporáneo $i', birth: 1500 + i, death: 1560 + i),
      ];

      // Ten lives at once stack as ten rows, each with its face and its name,
      // and the stack still fits on a phone.
      final ten = await measure(contemporaries(10));
      expect(ten.lanes, 10);
      expect(ten.faces, 10);
      expect(ten.names, 10);
      expect(
        ten.bottom,
        lessThanOrEqualTo(812),
        reason: 'las diez filas tienen que entrar a lo alto',
      );
    });

    testWidgets('a bar says as much as its length allows', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // At the default zoom a long life has room for the name, a very short
      // one does not, and both are on screen.
      await _pump(tester, [
        _saint(1, 'San Vividor', birth: 1500, death: 1590),
        _saint(2, 'San Fugaz', birth: 1500, death: 1508),
      ]);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Vividor'), findsOneWidget);
      expect(find.text('Fugaz'), findsNothing);
    });

    testWidgets('no lifespan overflows its bar at any zoom', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // One saint per length of life, so every bar width the layout can
      // produce gets drawn: the short ones are where the face stops fitting.
      await _pump(tester, [
        for (var years = 1; years <= 110; years++)
          _saint(years, 'San Vida de $years', birth: 1000, death: 1000 + years),
      ]);
      for (final zoom in ['SIGLOS', 'DÉCADAS', 'AÑOS']) {
        await tester.tap(find.text(zoom));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'zoom $zoom');
      }
    });

    testWidgets('the map above jumps the chart to the century you touch', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await _pump(tester, [
        for (var century = 1; century <= 20; century++)
          _saint(
            century,
            'San Siglo $century',
            birth: century * 100 - 90,
            death: century * 100 - 30,
          ),
      ]);
      await tester.pumpAndSettle();

      double timeOffset() => tester
          .state<ScrollableState>(
            find.byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.right,
            ),
          )
          .position
          .pixels;

      expect(timeOffset(), 0);
      // The map spans the whole timeline, so its right end is the last
      // century: touching there has to move the chart a long way.
      await tester.tapAt(const Offset(330, 28));
      await tester.pumpAndSettle();
      expect(timeOffset(), greaterThan(1000));
      expect(tester.takeException(), isNull);

      // And back to the start.
      await tester.tapAt(const Offset(28, 28));
      await tester.pumpAndSettle();
      expect(timeOffset(), 0);
    });

    testWidgets('a bar wider than the screen keeps its face and name in '
        'view while you scroll along it', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // Noventa años al zoom más cercano son mucho más anchos que la
      // pantalla: al entrar al medio de la barra, el nombre quedaba atrás.
      await _pump(tester, [
        _saint(1, 'San Larguísimo', birth: 1500, death: 1590),
      ]);
      await tester.tap(find.text('AÑOS'));
      await tester.pumpAndSettle();

      final scroll = tester.state<ScrollableState>(
        find.byWidgetPredicate(
          (w) => w is Scrollable && w.axisDirection == AxisDirection.right,
        ),
      );
      final nombre = find.text('Larguísimo');
      // El botón de los hechos de la Iglesia también tiene tooltip: la barra
      // es la que envuelve a la cara.
      final barra = find.ancestor(
        of: find.byType(ClipOval),
        matching: find.byType(Tooltip),
      );
      expect(nombre, findsOneWidget);

      scroll.position.jumpTo(scroll.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // La barra se fue para la izquierda, fuera de la pantalla...
      expect(tester.getTopLeft(barra).dx, lessThan(-100));
      // ...pero el nombre y la cara se quedaron a la vista.
      expect(nombre, findsOneWidget);
      expect(tester.getTopLeft(nombre).dx, inInclusiveRange(0, 375));
      expect(find.byType(ClipOval), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(ClipOval)).dx,
        inInclusiveRange(0, 375),
      );
    });

    testWidgets('a bar fully in view keeps its name at its own start', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await _pump(tester, [
        _saint(1, 'San Corto', birth: 1500, death: 1560),
        _saint(2, 'San Lejano', birth: 1900, death: 1960),
      ]);

      // Sin scroll, la etiqueta arranca donde arranca la barra: no se pega
      // al borde cuando no hace falta.
      final barra = tester
          .getTopLeft(
            find
                .ancestor(
                  of: find.byType(ClipOval),
                  matching: find.byType(Tooltip),
                )
                .first,
          )
          .dx;
      final cara = tester.getTopLeft(find.byType(ClipOval).first).dx;
      expect(cara - barra, lessThan(6), reason: 'la cara no se corrió');
      expect(tester.takeException(), isNull);
    });

    testWidgets('the rail tells what the Church was living', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // Todos en el siglo XVI: el eje va de 1400 a 1600 y Trento cae a la
      // vista, sin scrollear.
      await _pump(tester, [
        for (var i = 0; i < 4; i++)
          _saint(i, 'Santo $i', birth: 1490 + i, death: 1580 + i),
      ]);
      await tester.pumpAndSettle();

      final rail = find.byWidgetPredicate(
        (w) =>
            w is CustomPaint &&
            w.painter.runtimeType.toString() == '_EventRailPainter',
      );
      expect(rail, findsOneWidget);

      // x del año en la regla: (año - 1400) * 1.8 + 16 de margen.
      const trentoX = (1545 - 1400) * 1.8 + 16;
      await tester.tapAt(Offset(trentoX, tester.getTopLeft(rail).dy + 7));
      await tester.pumpAndSettle();

      expect(find.text('Concilio de Trento'), findsOneWidget);
      expect(find.text('1545 – 1563'), findsOneWidget);
      expect(find.text('CONCILIO ECUMÉNICO'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the rail can be turned off to keep only the lives', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await _pump(tester, [
        for (var i = 0; i < 4; i++)
          _saint(i, 'Santo $i', birth: 1490 + i, death: 1580 + i),
      ]);
      await tester.pumpAndSettle();

      final rail = find.byWidgetPredicate(
        (w) =>
            w is CustomPaint &&
            w.painter.runtimeType.toString() == '_EventRailPainter',
      );
      final toggle = find.byTooltip('Ocultar los hechos de la Iglesia');
      expect(rail, findsOneWidget);
      expect(toggle, findsOneWidget);

      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(rail, findsNothing);
      expect(
        find.byTooltip('Mostrar los hechos de la Iglesia'),
        findsOneWidget,
      );

      await tester.tap(find.byTooltip('Mostrar los hechos de la Iglesia'));
      await tester.pumpAndSettle();
      expect(rail, findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('says so when no saint has years yet', (tester) async {
      await _pump(tester, [_saint(1, 'Sin fechas'), _saint(2, 'Tampoco')]);
      expect(find.textContaining('ninguno de los 2 santos'), findsOneWidget);
    });
  });
}
