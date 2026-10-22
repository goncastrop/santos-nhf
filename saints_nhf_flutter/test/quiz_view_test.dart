import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:saints_nhf_flutter/state/app_state.dart';
import 'package:saints_nhf_flutter/theme.dart';
import 'package:saints_nhf_flutter/widgets/quiz_view.dart';

SaintInfo _saint(int id, String name, int birth, int death) => SaintInfo(
  id: id,
  name: name,
  slug: 's$id',
  bio: 'bio',
  birthYear: birth,
  birthApprox: false,
  deathYear: death,
  deathApprox: false,
);

final _catalog = [
  _saint(1, 'San Francisco de Asís', 1181, 1226),
  _saint(2, 'Santo Domingo de Guzmán', 1170, 1221),
  _saint(3, 'San Agustín de Hipona', 354, 430),
  _saint(4, 'Santa Teresa de Jesús', 1515, 1582),
  _saint(5, 'San Juan Bosco', 1815, 1888),
];

final _contemporaries = QuizQuestion(
  id: 10,
  saintId: 1,
  prompt: '¿De quién fue contemporáneo San Francisco de Asís?',
  options: [
    'San Agustín de Hipona',
    'Santo Domingo de Guzmán',
    'San Juan Bosco',
    'Santa Teresa de Jesús',
  ],
  optionSaintIds: [3, 2, 5, 4],
);

Future<void> _pump(WidgetTester tester, QuizQuestion question, {int? correct}) {
  return tester.pumpWidget(
    AppStateScope(
      state: AppState()..catalog = _catalog,
      child: MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
          body: QuizView(
            question: question,
            onAnswer: null,
            chosenIndex: correct == null ? null : 0,
            correctIndex: correct,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('the years stay hidden until the answer is in', (tester) async {
    await _pump(tester, _contemporaries);
    expect(find.text('1170 – 1221'), findsNothing);
    expect(find.text('San Francisco de Asís: 1181 – 1226'), findsNothing);
  });

  testWidgets('once answered, each option shows the years of its saint', (
    tester,
  ) async {
    await _pump(tester, _contemporaries, correct: 1);
    expect(find.text('San Francisco de Asís: 1181 – 1226'), findsOneWidget);
    expect(find.text('354 – 430'), findsOneWidget);
    expect(find.text('1170 – 1221'), findsOneWidget);
    expect(find.text('1815 – 1888'), findsOneWidget);
    expect(find.text('1515 – 1582'), findsOneWidget);
  });

  testWidgets('a typed question shows no years', (tester) async {
    await _pump(
      tester,
      QuizQuestion(
        id: 11,
        saintId: 1,
        prompt: '¿Dónde nació?',
        options: ['Asís', 'Roma', 'Siena', 'Padua'],
      ),
      correct: 0,
    );
    expect(find.textContaining('1181'), findsNothing);
  });
}
