import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme.dart';
import 'common.dart';
import 'quiz_view.dart';

/// The daily question card shown on the Hoy tab.
class DailyQuizCard extends StatefulWidget {
  const DailyQuizCard({super.key});

  @override
  State<DailyQuizCard> createState() => _DailyQuizCardState();
}

class _DailyQuizCardState extends State<DailyQuizCard> {
  bool _busy = false;

  Future<void> _answer(int index) async {
    final state = AppState.of(context);
    final questionId = state.quiz?.question?.id;
    if (questionId == null) return;
    setState(() => _busy = true);
    try {
      final result = await state.answerQuiz(questionId, index);
      if (!mounted) return;
      showMessage(
        context,
        result.wasCorrect == true
            ? '¡Correcto! Racha de ${result.streak} ${result.streak == 1 ? 'día' : 'días'}.'
            : 'Esta vez no. Mañana hay otra pregunta.',
        error: result.wasCorrect != true,
      );
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final quiz = state.quiz;
    final textTheme = Theme.of(context).textTheme;
    if (quiz == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Eyebrow('Pregunta del día'),
                const Spacer(),
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 16,
                  color: Palette.crimsonLight,
                ),
                const SizedBox(width: 4),
                Text(
                  '${quiz.streak}',
                  style: textTheme.labelLarge?.copyWith(
                    color: Palette.parchment,
                    letterSpacing: 0,
                  ),
                ),
                Text(
                  '  · récord ${quiz.bestStreak}',
                  style: textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (quiz.saint != null)
              Text(
                'Sobre ${quiz.saint!.name}',
                style: textTheme.bodySmall?.copyWith(color: Palette.gold),
              ),
            const SizedBox(height: 10),
            if (quiz.question != null)
              QuizView(
                question: quiz.question!,
                onAnswer: _answer,
                busy: _busy,
              )
            else if (quiz.answeredToday)
              Row(
                children: [
                  Icon(
                    quiz.wasCorrect == true
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: quiz.wasCorrect == true
                        ? Palette.gold
                        : Palette.crimsonLight,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      quiz.wasCorrect == true
                          ? 'Respondiste bien la pregunta de hoy. '
                                'Mañana hay otra.'
                          : 'Hoy no fue. Mañana hay otra pregunta para '
                                'seguir aprendiendo.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              )
            else
              Text(
                quiz.unavailableReason ?? 'Sin pregunta por hoy.',
                style: textTheme.bodyMedium?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
