import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
        const SizedBox(height: 14),
        for (var i = 0; i < question.options.length; i++) ...[
          _Option(
            label: String.fromCharCode(65 + i),
            text: question.options[i],
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
  });

  final String label;
  final String text;
  final _OptionState state;
  final VoidCallback? onTap;

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
                child: Text(
                  text,
                  style: textTheme.bodyMedium?.copyWith(color: fg),
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
