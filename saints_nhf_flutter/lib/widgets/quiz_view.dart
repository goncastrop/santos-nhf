import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../utils/years.dart';

/// A multiple-choice question with four options. Shows the result once
/// [chosenIndex] and [correctIndex] are known.
class QuizView extends StatelessWidget {
  const QuizView({
    super.key,
    required this.question,
    required this.onAnswer,
    this.chosenIndex,
    this.correctIndex,
    this.busy = false,
    this.waitingMessage,
  });

  final QuizQuestion question;
  final ValueChanged<int>? onAnswer;
  final int? chosenIndex;
  final int? correctIndex;
  final bool busy;

  /// Shown under the options while the answer is on its way or while the
  /// other player is still moving.
  final String? waitingMessage;

  /// The result is known.
  bool get answered => correctIndex != null;

  /// An option was picked but the result has not arrived yet.
  bool get pending => !answered && chosenIndex != null;

  /// For a question whose options are saints (who was a contemporary of
  /// whom), the catalog by id once the answer is in: the years side by side
  /// are what makes the answer stick. Null for any other question, before
  /// answering, or when the catalog is not loaded.
  Map<int, SaintInfo>? _saintsToDate(BuildContext context) {
    final ids = question.optionSaintIds;
    if (!answered || ids == null || ids.length != question.options.length) {
      return null;
    }
    final catalog = context
        .dependOnInheritedWidgetOfExactType<AppStateScope>()
        ?.notifier
        ?.catalog;
    if (catalog == null) return null;
    return {for (final s in catalog) s.id: s};
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final saints = _saintsToDate(context);
    final subject = saints?[question.saintId];
    final subjectYears = subject == null ? null : lifespanLabel(subject);
    String? yearsOf(int i) {
      if (saints == null) return null;
      final saint = saints[question.optionSaintIds![i]];
      return saint == null ? null : lifespanLabel(saint);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question.prompt,
          style: textTheme.titleMedium?.copyWith(
            color: Palette.parchment,
            height: 1.4,
          ),
        ),
        if (subjectYears != null) ...[
          const SizedBox(height: 4),
          Text(
            '${subject!.name}: $subjectYears',
            style: textTheme.bodySmall?.copyWith(color: Palette.gold),
          ),
        ],
        const SizedBox(height: 14),
        for (var i = 0; i < question.options.length; i++) ...[
          _Option(
            label: String.fromCharCode(65 + i),
            text: question.options[i],
            detail: yearsOf(i),
            state: answered
                ? (i == correctIndex
                      ? _OptionState.correct
                      : i == chosenIndex
                      ? _OptionState.wrong
                      : _OptionState.dimmed)
                : pending
                ? (i == chosenIndex ? _OptionState.chosen : _OptionState.dimmed)
                : _OptionState.idle,
            onTap: answered || pending || busy || onAnswer == null
                ? null
                : () => onAnswer!(i),
          ),
          if (i < question.options.length - 1) const SizedBox(height: 8),
        ],
        if (waitingMessage != null) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Palette.gold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  waitingMessage!,
                  style: textTheme.bodySmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

enum _OptionState { idle, chosen, correct, wrong, dimmed }

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.text,
    required this.state,
    required this.onTap,
    this.detail,
  });

  final String label;
  final String text;
  final _OptionState state;
  final VoidCallback? onTap;

  /// A second line under the option, such as the years of the saint it
  /// names.
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (border, fill, fg) = switch (state) {
      _OptionState.idle => (
        Palette.inkLine,
        Palette.inkRaised,
        Palette.parchment,
      ),
      _OptionState.chosen => (
        Palette.goldLight,
        Palette.goldDark.withValues(alpha: 0.28),
        Palette.parchment,
      ),
      _OptionState.correct => (
        Palette.gold,
        Palette.goldDark.withValues(alpha: 0.35),
        Palette.goldLight,
      ),
      _OptionState.wrong => (
        Palette.crimson,
        Palette.crimson.withValues(alpha: 0.25),
        Palette.parchment,
      ),
      _OptionState.dimmed => (
        Palette.inkLine,
        Palette.ink,
        Palette.parchmentDim,
      ),
    };
    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: border),
                ),
                child: Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: fg,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: textTheme.bodyMedium?.copyWith(color: fg),
                    ),
                    if (detail != null)
                      Text(
                        detail!,
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                  ],
                ),
              ),
              if (state == _OptionState.chosen)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Palette.goldLight,
                  ),
                ),
              if (state == _OptionState.correct)
                const Icon(Icons.check_rounded, color: Palette.gold, size: 18),
              if (state == _OptionState.wrong)
                const Icon(
                  Icons.close_rounded,
                  color: Palette.crimsonLight,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
