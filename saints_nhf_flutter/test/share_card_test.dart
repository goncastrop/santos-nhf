import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:saints_nhf_flutter/credits.dart';
import 'package:saints_nhf_flutter/theme.dart';
import 'package:saints_nhf_flutter/widgets/share_card.dart';

SaintInfo _saint({int? feastMonth, int? feastDay}) => SaintInfo(
  id: 1,
  name: 'San Francisco de Asís',
  slug: 'san-francisco-de-asis',
  bio: 'bio',
  title: 'El pobre de Asís',
  feastMonth: feastMonth,
  feastDay: feastDay,
  birthYear: 1181,
  birthApprox: true,
  deathYear: 1226,
  deathApprox: false,
);

final _scores = SaintScores(
  catequesis: 8,
  escritos: 6,
  oracion: 9,
  patronazgos: 7,
  evangelizacion: 9,
  viajes: 5,
);

Future<void> _pump(WidgetTester tester, Widget child) async {
  // El lienzo es de tamaño fijo: la pantalla de prueba tiene que darle lugar
  // para que un desborde se vea como desborde y no como recorte.
  tester.view.physicalSize = shareImageSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: child),
    ),
  );
  await tester.pump();
}

void main() {
  group('ShareCardImage', () {
    testWidgets('arma el lienzo con la tarjeta, la fiesta y el programa', (
      tester,
    ) async {
      await _pump(
        tester,
        ShareCardImage(
          saint: _saint(feastMonth: 10, feastDay: 4),
          scores: _scores,
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('EL SANTO DEL DÍA'), findsOneWidget);
      expect(find.text('4 DE OCTUBRE'), findsOneWidget);
      expect(find.text(programName), findsOneWidget);

      final size = tester.getSize(find.byType(ShareCardImage));
      expect(size, shareImageSize);
    });

    testWidgets('sin fecha de fiesta no deja el renglón vacío ni desborda', (
      tester,
    ) async {
      await _pump(tester, ShareCardImage(saint: _saint(), scores: _scores));

      expect(tester.takeException(), isNull);
      expect(find.textContaining('DE OCTUBRE'), findsNothing);
      expect(find.text(programName), findsOneWidget);
    });
  });
}
