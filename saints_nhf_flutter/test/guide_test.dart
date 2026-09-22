import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saints_nhf_flutter/help_content.dart';
import 'package:saints_nhf_flutter/holiness.dart';
import 'package:saints_nhf_flutter/screens/guide_screen.dart';
import 'package:saints_nhf_flutter/screens/welcome_screen.dart';
import 'package:saints_nhf_flutter/theme.dart';
import 'package:saints_nhf_flutter/widgets/holiness_card.dart';

Future<void> _pump(WidgetTester tester, Widget home) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: home));
  await tester.pumpAndSettle();
}

void main() {
  group('contenido de la guía', () {
    test('cada pestaña tiene su capítulo, y hay uno para cada sección', () {
      expect(HelpSection.ofTab(0), HelpSection.today);
      expect(HelpSection.ofTab(1), HelpSection.saints);
      expect(HelpSection.ofTab(2), HelpSection.album);
      expect(HelpSection.ofTab(3), HelpSection.play);
      expect(HelpSection.ofTab(4), HelpSection.friends);
      // Un índice que no existe no puede romper la ayuda.
      expect(HelpSection.ofTab(99), HelpSection.app);

      final covered = {for (final c in helpChapters) c.section};
      expect(covered, {
        HelpSection.app,
        HelpSection.today,
        HelpSection.saints,
        HelpSection.album,
        HelpSection.play,
        HelpSection.friends,
      });
      for (final chapter in helpChapters) {
        expect(chapter.lead, isNotEmpty, reason: chapter.title);
      }
    });

    test('las preguntas frecuentes contestan lo que nos preguntan', () {
      expect(faqs, isNotEmpty);
      for (final faq in faqs) {
        expect(faq.question, endsWith('?'));
        expect(faq.answer, isNotEmpty);
      }
      final questions = faqs.map((f) => f.question.toLowerCase()).join(' ');
      expect(questions, contains('repetir'));
      expect(questions, contains('consiguen'));
    });
  });

  group('santidad', () {
    test('cada tema tiene su cita y su fuente oficial', () {
      expect(holinessTopics.length, greaterThanOrEqualTo(4));
      final ids = <String>{};
      for (final topic in holinessTopics) {
        expect(ids.add(topic.id), isTrue, reason: 'id repetido: ${topic.id}');
        expect(topic.body, isNotEmpty, reason: topic.id);
        expect(topic.quote, isNotEmpty, reason: topic.id);
        expect(topic.source, isNotEmpty, reason: topic.id);
        // La fuente tiene que poder leerse entera, y en el original.
        expect(
          topic.url,
          startsWith('https://www.vatican.va/'),
          reason: topic.id,
        );
        // Las comillas las pone la pantalla.
        expect(topic.quote.startsWith('«'), isFalse, reason: topic.id);
      }
    });

    test('el tema del día no cambia dentro del mismo día, y va rotando', () {
      expect(topicOfTheDay('2026-09-21').id, topicOfTheDay('2026-09-21').id);
      final week = {
        for (var d = 1; d <= 20; d++)
          topicOfTheDay('2026-09-${d.toString().padLeft(2, '0')}').id,
      };
      expect(week.length, greaterThan(1));
    });
  });

  group('GuideScreen', () {
    testWidgets('abre en la sección de la pestaña de donde venís', (
      tester,
    ) async {
      await _pump(tester, const GuideScreen(initial: HelpSection.play));

      // El capítulo de Jugar está desplegado y a la vista, sin buscarlo.
      expect(find.textContaining('Nunca se apuestan cartas'), findsOneWidget);
      expect(find.text('Jugar'), findsOneWidget);

      // Los otros capítulos siguen ahí, más arriba, y plegados.
      await tester.scrollUntilVisible(find.text('Hoy'), -120);
      expect(find.text('Hoy'), findsOneWidget);
      expect(find.textContaining('Una carta por día'), findsNothing);
    });

    testWidgets('se puede abrir y cerrar cada capítulo', (tester) async {
      await _pump(tester, const GuideScreen());

      expect(find.textContaining('Una carta por día'), findsNothing);
      await tester.tap(find.text('Hoy'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Una carta por día'), findsOneWidget);

      await tester.tap(find.text('Hoy'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Una carta por día'), findsNothing);
    });

    testWidgets('contesta si se repiten y si se cambian', (tester) async {
      await _pump(tester, const GuideScreen(initial: HelpSection.faq));

      expect(find.text('¿Se pueden repetir?'), findsOneWidget);
      expect(
        find.textContaining('nunca vas a tener dos veces el mismo santo'),
        findsOneWidget,
      );
      expect(
        find.text('¿Se pueden cambiar o intercambiar con otra persona?'),
        findsOneWidget,
      );
    });

    testWidgets('la sección de santidad cita la fuente', (tester) async {
      await _pump(tester, const GuideScreen(initial: HelpSection.holiness));

      final llamado = holinessTopics.firstWhere(
        (t) => t.id == 'llamado-universal',
      );
      expect(find.text(llamado.title), findsOneWidget);
      expect(find.text('«${llamado.quote}»'), findsOneWidget);
      expect(find.text(llamado.source), findsOneWidget);
    });
  });

  testWidgets('la tarjeta de Hoy muestra el tema del día', (tester) async {
    await _pump(
      tester,
      const Scaffold(body: HolinessCard(day: '2026-09-21')),
    );

    final topic = topicOfTheDay('2026-09-21');
    expect(find.text(topic.title), findsOneWidget);
    expect(find.text('«${topic.quote}»'), findsOneWidget);
  });

  group('WelcomeScreen', () {
    testWidgets('lleva de la primera pantalla al final y se puede saltear', (
      tester,
    ) async {
      await _pump(tester, const WelcomeScreen());

      expect(find.text('El santo del día'), findsOneWidget);
      expect(find.text('SIGUIENTE'), findsOneWidget);
      expect(find.text('SALTEAR'), findsOneWidget);

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('SIGUIENTE'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Por qué los santos'), findsOneWidget);
      expect(find.text('EMPEZAR'), findsOneWidget);
      expect(find.text('CERRAR'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
