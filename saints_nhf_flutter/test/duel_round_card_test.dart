import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:saints_nhf_flutter/theme.dart';
import 'package:saints_nhf_flutter/widgets/duel_round_card.dart';

SaintInfo _saint(String name) => SaintInfo(
  id: name.length,
  name: name,
  slug: name,
  birthApprox: false,
  deathApprox: false,
  bio: '',
);

DuelRoundView _resolved({bool myCorrect = false}) => DuelRoundView(
  roundNumber: 2,
  category: ScoreCategory.evangelizacion,
  attackerIsMe: true,
  resolved: true,
  mySaint: _saint('Santa Teresa de Ávila'),
  myScore: 88,
  myCorrect: myCorrect,
  opponentSaint: _saint('San Francisco Javier'),
  opponentScore: 74,
  opponentCorrect: true,
  pointToMe: myCorrect,
  myQuestionPrompt: '¿Qué orden reformó Santa Teresa?',
  myAnswer: myCorrect ? 'El Carmelo' : 'Los dominicos',
  myRightAnswer: 'El Carmelo',
);

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(360, 780);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: buildTheme(),
      home: Scaffold(
        body: ListView(padding: const EdgeInsets.all(20), children: [child]),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('RoundResultPanel', () {
    testWidgets('reveals both cards and says where the point went', (
      tester,
    ) async {
      await _pump(
        tester,
        RoundResultPanel(
          round: _resolved(),
          opponentName: 'El Sacristán',
          onDismiss: () {},
        ),
      );

      expect(find.text('La ronda fue para El Sacristán'), findsOneWidget);
      expect(find.text('Santa Teresa de Ávila'), findsOneWidget);
      expect(find.text('San Francisco Javier'), findsOneWidget);
      expect(find.text('88'), findsOneWidget);
      expect(find.text('74'), findsOneWidget);
      expect(
        find.textContaining('erraste tu pregunta'),
        findsOneWidget,
        reason: 'the reason is what the panel is for',
      );
    });

    testWidgets('a wrong answer is shown next to the right one', (
      tester,
    ) async {
      await _pump(
        tester,
        RoundResultPanel(
          round: _resolved(),
          opponentName: 'El Sacristán',
          onDismiss: () {},
        ),
      );

      expect(find.textContaining('¿Qué orden reformó'), findsOneWidget);
      expect(
        find.textContaining('Los dominicos', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('El Carmelo', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('a right answer does not repeat itself', (tester) async {
      await _pump(
        tester,
        RoundResultPanel(
          round: _resolved(myCorrect: true),
          opponentName: 'El Sacristán',
          onDismiss: () {},
        ),
      );

      expect(find.text('¡Ganaste la ronda!'), findsOneWidget);
      expect(
        find.textContaining('El Carmelo', findRichText: true),
        findsOneWidget,
      );
      expect(find.textContaining('Era:', findRichText: true), findsNothing);
    });

    testWidgets('the rival card stays face down while the round is open', (
      tester,
    ) async {
      await _pump(
        tester,
        RoundResultPanel(
          round: DuelRoundView(
            roundNumber: 1,
            category: ScoreCategory.oracion,
            attackerIsMe: true,
            resolved: false,
            mySaint: _saint('Santa Teresa de Ávila'),
            myScore: 88,
            myCorrect: true,
          ),
          opponentName: 'Ana',
          onDismiss: () {},
        ),
      );

      expect(find.text('Respondiste bien'), findsOneWidget);
      expect(find.text('Carta oculta'), findsOneWidget);
    });

    testWidgets('closing it calls back', (tester) async {
      var closed = false;
      await _pump(
        tester,
        RoundResultPanel(
          round: _resolved(),
          opponentName: 'El Sacristán',
          onDismiss: () => closed = true,
        ),
      );

      await tester.tap(find.byTooltip('Cerrar'));
      expect(closed, isTrue);
    });
  });

  group('RoundTile', () {
    testWidgets('carries the reason into the history, at phone width', (
      tester,
    ) async {
      await _pump(
        tester,
        RoundTile(round: _resolved(), opponentName: 'El Sacristán'),
      );

      expect(find.text('PUNTO RIVAL'), findsOneWidget);
      expect(find.text('Vos: Santa Teresa de Ávila'), findsOneWidget);
      expect(find.text('El Sacristán: San Francisco Javier'), findsOneWidget);
      expect(find.textContaining('88 a 74'), findsOneWidget);
    });
  });
}
