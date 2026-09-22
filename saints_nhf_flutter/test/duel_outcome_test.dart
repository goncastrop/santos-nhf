import 'package:flutter_test/flutter_test.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:saints_nhf_flutter/utils/duel_outcome.dart';

SaintInfo _saint(String name) => SaintInfo(
  id: 1,
  name: name,
  slug: name,
  birthApprox: false,
  deathApprox: false,
  bio: '',
);

DuelRoundView _round({
  required int mine,
  required int theirs,
  required bool myCorrect,
  required bool theirCorrect,
  bool attackerIsMe = true,
}) {
  // The point goes where DuelService._resolve would send it.
  final bool? pointToMe;
  if (mine > theirs) {
    pointToMe = myCorrect
        ? true
        : theirCorrect
        ? false
        : null;
  } else if (theirs > mine) {
    pointToMe = theirCorrect
        ? false
        : myCorrect
        ? true
        : null;
  } else {
    pointToMe = myCorrect == theirCorrect ? null : myCorrect;
  }
  return DuelRoundView(
    roundNumber: 1,
    category: ScoreCategory.oracion,
    attackerIsMe: attackerIsMe,
    resolved: true,
    mySaint: _saint('Santa Teresa'),
    myScore: mine,
    myCorrect: myCorrect,
    opponentSaint: _saint('San Francisco'),
    opponentScore: theirs,
    opponentCorrect: theirCorrect,
    pointToMe: pointToMe,
  );
}

void main() {
  group('Given a resolved round of a duel', () {
    test('when my card was higher and I answered right then the point is '
        'mine and the reason says both things', () {
      final o = RoundOutcome.of(
        _round(mine: 80, theirs: 60, myCorrect: true, theirCorrect: true),
        'El Sacristán',
      );

      expect(o.result, RoundResult.won);
      expect(o.match, CardMatch.higher);
      expect(o.tone, OutcomeTone.good);
      expect(o.reason, contains('más alta'));
      expect(o.reason, contains('80 a 60'));
      expect(o.reason, contains('respondiste bien'));
    });

    test('when my card was higher but I missed the question then the point '
        'goes to the rival who answered right', () {
      final o = RoundOutcome.of(
        _round(mine: 80, theirs: 60, myCorrect: false, theirCorrect: true),
        'El Sacristán',
      );

      expect(o.result, RoundResult.lost);
      expect(o.match, CardMatch.higher);
      expect(o.reason, contains('erraste tu pregunta'));
      expect(o.reason, contains('El Sacristán acertó'));
    });

    test('when my card was higher and both missed then nobody scores', () {
      final o = RoundOutcome.of(
        _round(mine: 80, theirs: 60, myCorrect: false, theirCorrect: false),
        'El Sacristán',
      );

      expect(o.result, RoundResult.none);
      expect(o.chip, 'Sin punto');
      expect(o.reason, contains('erraron los dos'));
    });

    test('when I answered right but their card was higher then the reason '
        'leads with my answer so the loss is not read as a mistake', () {
      final o = RoundOutcome.of(
        _round(mine: 60, theirs: 80, myCorrect: true, theirCorrect: true),
        'El Sacristán',
      );

      expect(o.result, RoundResult.lost);
      expect(o.match, CardMatch.lower);
      expect(o.reason, startsWith('Respondiste bien, pero'));
      expect(o.reason, contains('80 a 60'));
    });

    test('when their card was higher but they missed then my right answer '
        'takes the point', () {
      final o = RoundOutcome.of(
        _round(mine: 60, theirs: 80, myCorrect: true, theirCorrect: false),
        'El Sacristán',
      );

      expect(o.result, RoundResult.won);
      expect(o.reason, contains('erró la pregunta y vos acertaste'));
    });

    test('when the cards tied then the question is what decided', () {
      final mine = RoundOutcome.of(
        _round(mine: 70, theirs: 70, myCorrect: true, theirCorrect: false),
        'El Sacristán',
      );
      final neither = RoundOutcome.of(
        _round(mine: 70, theirs: 70, myCorrect: false, theirCorrect: false),
        'El Sacristán',
      );

      expect(mine.match, CardMatch.tie);
      expect(mine.result, RoundResult.won);
      expect(mine.reason, contains('desempató la pregunta'));
      expect(neither.result, RoundResult.none);
      expect(neither.reason, contains('erraron los dos'));
    });
  });

  group('Given a round that is still open', () {
    test('when I already answered then the outcome reports my answer and '
        'says what is missing', () {
      final open = DuelRoundView(
        roundNumber: 2,
        category: ScoreCategory.viajes,
        attackerIsMe: true,
        resolved: false,
        mySaint: _saint('Santa Teresa'),
        myScore: 75,
        myCorrect: false,
      );

      final o = RoundOutcome.of(open, 'Ana');

      expect(o.result, RoundResult.pending);
      expect(o.tone, OutcomeTone.bad);
      expect(o.headline, 'Erraste la pregunta');
      expect(o.reason, contains('el punto no es'));
      expect(o.reason, contains('Falta que Ana'));
    });

    test('when nobody played yet then there is nothing to explain', () {
      final o = RoundOutcome.of(
        DuelRoundView(
          roundNumber: 1,
          category: ScoreCategory.viajes,
          attackerIsMe: false,
          resolved: false,
        ),
        'Ana',
      );

      expect(o.result, RoundResult.pending);
      expect(o.tone, OutcomeTone.neutral);
      expect(o.chip, 'En juego');
      expect(o.reason, contains('falta elegir las cartas'));
    });
  });

  group('Given a duel that ended', () {
    test('when the rounds went different ways then the tally reads as a '
        'sentence', () {
      final tally = DuelTally(won: 3, lost: 1, none: 1);

      expect(
        tally.sentence,
        'Ganaste 3 rondas, perdiste 1 ronda y 1 ronda '
        'quedó sin punto.',
      );
    });

    test('when every round was mine then the sentence has no list', () {
      expect(
        DuelTally.of([
          _round(mine: 80, theirs: 60, myCorrect: true, theirCorrect: false),
        ]).sentence,
        'Ganaste 1 ronda.',
      );
    });

    test('when a round is still open then it is not counted', () {
      final open = DuelRoundView(
        roundNumber: 2,
        category: ScoreCategory.viajes,
        attackerIsMe: true,
        resolved: false,
        mySaint: _saint('Santa Teresa'),
        myScore: 75,
      );

      final tally = DuelTally.of([
        _round(mine: 80, theirs: 60, myCorrect: true, theirCorrect: false),
        open,
      ]);

      expect(tally.won, 1);
      expect(tally.lost, 0);
      expect(tally.none, 0);
    });
  });
}
