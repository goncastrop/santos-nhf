import 'package:saints_nhf_client/saints_nhf_client.dart';

import 'scores.dart';

/// Who took the point in a round.
enum RoundResult {
  /// The round is still open: the cards are not both on the table.
  pending,
  won,
  lost,

  /// Nobody scored.
  none,
}

/// How my card compared with the opponent's in the round's category.
enum CardMatch { higher, lower, tie }

/// How the round reads for me, for the colour of the panel.
enum OutcomeTone { good, bad, neutral }

/// Why a round ended the way it did, in words.
///
/// The rule lives on the server (`DuelService._resolve`): the higher card wins
/// the comparison and its owner scores, but only if they answered their
/// question right; otherwise the point goes to the other player if *they*
/// answered right, and to nobody if both missed. When the cards tie, the
/// question decides, and a tie there too leaves the round without a point.
/// This reads a resolved round back into that story.
class RoundOutcome {
  const RoundOutcome({
    required this.result,
    required this.tone,
    required this.match,
    required this.headline,
    required this.reason,
  });

  final RoundResult result;
  final OutcomeTone tone;

  /// Null while the round is still open.
  final CardMatch? match;

  /// Short verdict: '¡Ganaste la ronda!'.
  final String headline;

  /// The full sentence: card comparison and answers, in order.
  final String reason;

  factory RoundOutcome.of(DuelRoundView round, String opponentName) {
    final category = round.category.label.toLowerCase();
    final mine = round.myScore;
    final theirs = round.opponentScore;
    final myCorrect = round.myCorrect;
    final theirCorrect = round.opponentCorrect;

    if (!round.resolved || mine == null || theirs == null) {
      // The comparison is still to come, but my own answer is already
      // decided: it is the half of the round I can learn from now.
      final waiting = round.attackerIsMe
          ? 'Falta que $opponentName juegue su carta y responda.'
          : 'Falta resolver la ronda.';
      return RoundOutcome(
        result: RoundResult.pending,
        tone: switch (myCorrect) {
          true => OutcomeTone.good,
          false => OutcomeTone.bad,
          null => OutcomeTone.neutral,
        },
        match: null,
        headline: switch (myCorrect) {
          true => 'Respondiste bien',
          false => 'Erraste la pregunta',
          null => 'Ronda en juego',
        },
        reason: round.mySaint == null
            ? 'Todavía falta elegir las cartas de esta ronda.'
            : myCorrect == null
            ? 'Jugaste tu carta en $category. $waiting'
            : myCorrect
            ? 'Tu carta juega con ${mine ?? '—'} en $category. $waiting '
                  'Si la tuya es la más alta, el punto es tuyo.'
            : 'Tu carta juega con ${mine ?? '—'} en $category, pero erraste '
                  'la pregunta: aunque gane la comparación, el punto no es '
                  'tuyo. $waiting',
      );
    }

    final match = mine > theirs
        ? CardMatch.higher
        : mine < theirs
        ? CardMatch.lower
        : CardMatch.tie;
    final result = switch (round.pointToMe) {
      true => RoundResult.won,
      false => RoundResult.lost,
      null => RoundResult.none,
    };
    final headline = switch (result) {
      RoundResult.won => '¡Ganaste la ronda!',
      RoundResult.lost => 'La ronda fue para $opponentName',
      _ => 'Ronda sin punto',
    };

    final me = myCorrect ?? false;
    final them = theirCorrect ?? false;
    final reason = switch (match) {
      CardMatch.higher =>
        me
            ? 'Tu carta era la más alta en $category, $mine a $theirs, y '
                  'respondiste bien: el punto es tuyo.'
            : them
            ? 'Tu carta era la más alta en $category, $mine a $theirs, pero '
                  'erraste tu pregunta y $opponentName acertó la suya: el '
                  'punto se lo lleva.'
            : 'Tu carta era la más alta en $category, $mine a $theirs, pero '
                  'erraron los dos: la ronda queda sin punto.',
      CardMatch.lower =>
        them
            ? me
                  ? 'Respondiste bien, pero la carta de $opponentName era más '
                        'alta en $category, $theirs a $mine, y también '
                        'acertó: el punto es suyo.'
                  : 'La carta de $opponentName era más alta en $category, '
                        '$theirs a $mine, y respondió bien: el punto es suyo.'
            : me
            ? 'La carta de $opponentName era más alta en $category, $theirs a '
                  '$mine, pero erró la pregunta y vos acertaste: el punto es '
                  'tuyo.'
            : 'La carta de $opponentName era más alta en $category, $theirs a '
                  '$mine, pero erraron los dos: la ronda queda sin punto.',
      CardMatch.tie =>
        me == them
            ? me
                  ? 'Las dos cartas tenían $mine en $category y los dos '
                        'respondieron bien: la ronda queda sin punto.'
                  : 'Las dos cartas tenían $mine en $category y erraron los '
                        'dos: la ronda queda sin punto.'
            : me
            ? 'Las dos cartas tenían $mine en $category: desempató la '
                  'pregunta, y la acertaste vos.'
            : 'Las dos cartas tenían $mine en $category: desempató la '
                  'pregunta, y la acertó $opponentName.',
    };

    return RoundOutcome(
      result: result,
      tone: switch (result) {
        RoundResult.won => OutcomeTone.good,
        RoundResult.lost => OutcomeTone.bad,
        _ => OutcomeTone.neutral,
      },
      match: match,
      headline: headline,
      reason: reason,
    );
  }

  /// Chip on the round of the history list.
  String get chip => switch (result) {
    RoundResult.won => 'Punto tuyo',
    RoundResult.lost => 'Punto rival',
    RoundResult.none => 'Sin punto',
    RoundResult.pending => 'En juego',
  };
}

/// How the rounds of a finished duel went, to close it with a sentence.
class DuelTally {
  const DuelTally({required this.won, required this.lost, required this.none});

  final int won;
  final int lost;
  final int none;

  factory DuelTally.of(List<DuelRoundView> rounds) {
    var won = 0, lost = 0, none = 0;
    for (final r in rounds) {
      if (!r.resolved) continue;
      switch (r.pointToMe) {
        case true:
          won++;
        case false:
          lost++;
        case null:
          none++;
      }
    }
    return DuelTally(won: won, lost: lost, none: none);
  }

  /// 'Ganaste 3 rondas, perdiste 1 y 1 quedó sin punto.'
  String get sentence {
    final parts = <String>[
      if (won > 0) 'ganaste ${_rounds(won)}',
      if (lost > 0) 'perdiste ${_rounds(lost)}',
      if (none > 0)
        '${_rounds(none)} ${none == 1 ? 'quedó' : 'quedaron'} '
            'sin punto',
    ];
    if (parts.isEmpty) return 'No se resolvió ninguna ronda.';
    final head = parts.first;
    final text = parts.length == 1
        ? head
        : '${parts.sublist(0, parts.length - 1).join(', ')} y ${parts.last}';
    return '${text[0].toUpperCase()}${text.substring(1)}.';
  }

  static String _rounds(int n) => n == 1 ? '1 ronda' : '$n rondas';
}
