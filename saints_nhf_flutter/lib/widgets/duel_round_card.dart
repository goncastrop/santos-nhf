import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../theme.dart';
import '../utils/duel_outcome.dart';
import '../utils/scores.dart';
import 'saint_illustration.dart';

Color _colorOf(OutcomeTone tone) => switch (tone) {
  OutcomeTone.good => Palette.gold,
  OutcomeTone.bad => Palette.crimsonLight,
  OutcomeTone.neutral => Palette.parchmentDim,
};

/// The round that just closed, face up: both cards, both answers and the
/// sentence that explains where the point went.
///
/// The opponent's card is hidden until the round resolves, so this is the
/// first time the player sees what they were up against. Against the machine
/// the whole round resolves inside one tap, which makes it the only chance to
/// read what happened.
class RoundResultPanel extends StatelessWidget {
  const RoundResultPanel({
    super.key,
    required this.round,
    required this.opponentName,
    required this.onDismiss,
  });

  final DuelRoundView round;
  final String opponentName;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outcome = RoundOutcome.of(round, opponentName);
    final color = _colorOf(outcome.tone);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.7)),
        color: Palette.inkRaised,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'RONDA ${round.roundNumber} · '
                  '${round.category.label.toUpperCase()}',
                  style: textTheme.labelSmall?.copyWith(color: Palette.gold),
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                iconSize: 18,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Cerrar',
                icon: const Icon(
                  Icons.close_rounded,
                  color: Palette.parchmentDim,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            outcome.headline,
            style: textTheme.headlineSmall?.copyWith(color: color),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Side(
                  who: 'Vos',
                  saint: round.mySaint,
                  score: round.myScore,
                  correct: round.myCorrect,
                  placeholder: 'Sin carta',
                  wins: outcome.match == CardMatch.higher,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Text(
                  'VS',
                  style: textTheme.labelSmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                ),
              ),
              Expanded(
                child: _Side(
                  who: opponentName,
                  saint: round.opponentSaint,
                  score: round.opponentScore,
                  correct: round.opponentCorrect,
                  placeholder: 'Carta oculta',
                  wins: outcome.match == CardMatch.lower,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            outcome.reason,
            style: textTheme.bodyMedium?.copyWith(
              color: Palette.parchment,
              height: 1.4,
            ),
          ),
          if (round.myQuestionPrompt != null) ...[
            const SizedBox(height: 14),
            const Divider(color: Palette.inkLine, height: 1),
            const SizedBox(height: 12),
            _QuestionRecap(round: round),
          ],
        ],
      ),
    );
  }
}

/// One player's half of the comparison.
class _Side extends StatelessWidget {
  const _Side({
    required this.who,
    required this.saint,
    required this.score,
    required this.correct,
    required this.placeholder,
    required this.wins,
  });

  final String who;
  final SaintInfo? saint;
  final int? score;

  /// Null until that player answered their question.
  final bool? correct;

  /// Shown instead of the name while there is no card to show.
  final String placeholder;

  /// This card was the higher one in the category.
  final bool wins;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          who.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(color: Palette.parchmentDim),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 62,
          height: 76,
          child: ClipPath(
            clipper: const ArchClipper(archRatio: 0.55),
            child: saint == null
                ? const ColoredBox(
                    color: Palette.ink,
                    child: Center(
                      child: Icon(
                        Icons.question_mark_rounded,
                        size: 20,
                        color: Palette.parchmentDim,
                      ),
                    ),
                  )
                : SaintIllustration(
                    url: saint!.illustrationUrl,
                    name: saint!.name,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          saint?.name ?? placeholder,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(color: Palette.parchment),
        ),
        const SizedBox(height: 4),
        Text(
          score?.toString() ?? '—',
          style: textTheme.displayMedium?.copyWith(
            fontSize: 30,
            height: 1,
            color: wins ? Palette.goldLight : Palette.parchmentDim,
          ),
        ),
        if (correct != null) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                correct == true
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 13,
                color: correct == true ? Palette.gold : Palette.crimsonLight,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  // Whose answer it is, is already above the portrait.
                  correct == true ? 'Respondió bien' : 'Erró',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: correct == true
                        ? Palette.gold
                        : Palette.crimsonLight,
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

/// What my question was and what the right answer turned out to be.
class _QuestionRecap extends StatelessWidget {
  const _QuestionRecap({required this.round});

  final DuelRoundView round;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final right = round.myCorrect == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          round.myQuestionPrompt!,
          style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
        ),
        const SizedBox(height: 8),
        if (round.myAnswer != null)
          _AnswerLine(
            label: 'Respondiste',
            text: round.myAnswer!,
            color: right ? Palette.gold : Palette.crimsonLight,
            icon: right ? Icons.check_rounded : Icons.close_rounded,
          ),
        if (!right && round.myRightAnswer != null) ...[
          const SizedBox(height: 4),
          _AnswerLine(
            label: 'Era',
            text: round.myRightAnswer!,
            color: Palette.gold,
            icon: Icons.check_rounded,
          ),
        ],
      ],
    );
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.label,
    required this.text,
    required this.color,
    required this.icon,
  });

  final String label;
  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: textTheme.bodySmall?.copyWith(color: Palette.parchment),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(color: color),
                ),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// One round in the history at the bottom of the board, with the reason it
/// went the way it did.
class RoundTile extends StatelessWidget {
  const RoundTile({
    super.key,
    required this.round,
    required this.opponentName,
  });

  final DuelRoundView round;
  final String opponentName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outcome = RoundOutcome.of(round, opponentName);
    final color = _colorOf(switch (outcome.result) {
      RoundResult.won => OutcomeTone.good,
      RoundResult.lost => OutcomeTone.bad,
      _ => OutcomeTone.neutral,
    });
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'R${round.roundNumber}',
                  style: textTheme.labelSmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    round.category.label.toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(color: Palette.gold),
                  ),
                ),
                Text(
                  outcome.chip.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _PlayerLine(
              who: 'Vos',
              saint: round.mySaint,
              score: round.myScore,
              correct: round.myCorrect,
              pending: 'por jugar',
              wins: outcome.match == CardMatch.higher,
            ),
            const SizedBox(height: 2),
            _PlayerLine(
              who: opponentName,
              saint: round.opponentSaint,
              score: round.opponentScore,
              correct: round.opponentCorrect,
              pending: round.resolved ? '—' : 'oculta',
              wins: outcome.match == CardMatch.lower,
            ),
            const SizedBox(height: 8),
            Text(
              outcome.reason,
              style: textTheme.bodySmall?.copyWith(
                color: Palette.parchmentDim,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerLine extends StatelessWidget {
  const _PlayerLine({
    required this.who,
    required this.saint,
    required this.score,
    required this.correct,
    required this.pending,
    required this.wins,
  });

  final String who;
  final SaintInfo? saint;
  final int? score;
  final bool? correct;

  /// Shown instead of the saint while there is none to show.
  final String pending;
  final bool wins;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            '$who: ${saint?.name ?? pending}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: Palette.parchment),
          ),
        ),
        if (correct != null) ...[
          const SizedBox(width: 6),
          Icon(
            correct! ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 14,
            color: correct! ? Palette.gold : Palette.crimsonLight,
          ),
        ],
        if (score != null) ...[
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '$score',
              textAlign: TextAlign.right,
              style: textTheme.labelLarge?.copyWith(
                color: wins ? Palette.goldLight : Palette.parchmentDim,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
