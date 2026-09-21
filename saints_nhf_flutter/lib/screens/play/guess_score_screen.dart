import 'dart:math';

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../state/app_state.dart';
import '../../theme.dart';
import '../../utils/scores.dart';
import '../../widgets/common.dart';
import '../../widgets/saint_card.dart';

/// Solo game: guess the strongest category of one of your cards.
class GuessScoreScreen extends StatefulWidget {
  const GuessScoreScreen({super.key});

  @override
  State<GuessScoreScreen> createState() => _GuessScoreScreenState();
}

class _GuessScoreScreenState extends State<GuessScoreScreen> {
  final _random = Random();
  CollectedCard? _card;
  ScoreCategory? _guess;
  int _correct = 0;
  int _played = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _next());
  }

  void _next() {
    final cards = AppState.of(context).overview?.cards ?? const [];
    if (cards.isEmpty) return;
    CollectedCard pick;
    do {
      pick = cards[_random.nextInt(cards.length)];
    } while (cards.length > 1 && pick.saint.id == _card?.saint.id);
    setState(() {
      _card = pick;
      _guess = null;
    });
  }

  int _best(SaintScores s) =>
      ScoreCategory.values.map((c) => c.of(s)).reduce(max);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final card = _card;
    return Scaffold(
      appBar: AppBar(title: const Text('ADIVINAR EL PUNTAJE')),
      body: card == null
          ? Center(
              child: Text(
                'Necesitás cartas en tu álbum para jugar.',
                style: textTheme.bodyMedium?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Eyebrow('¿Cuál es su categoría más alta?'),
                    Text(
                      '$_correct de $_played',
                      style: textTheme.labelLarge?.copyWith(
                        color: Palette.parchment,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: SaintCard(
                    saint: card.saint,
                    scores: _guess == null ? null : card.scores,
                    width: 220,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    card.saint.name,
                    style: textTheme.titleLarge?.copyWith(color: Palette.gold),
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3.2,
                  children: [
                    // Same layout as the card: left column, then right column.
                    for (final c in const [
                      ScoreCategory.catequesis,
                      ScoreCategory.patronazgos,
                      ScoreCategory.escritos,
                      ScoreCategory.evangelizacion,
                      ScoreCategory.oracion,
                      ScoreCategory.viajes,
                    ])
                      _CategoryButton(
                        category: c,
                        value: _guess == null ? null : c.of(card.scores),
                        isBest:
                            _guess != null &&
                            c.of(card.scores) == _best(card.scores),
                        isGuess: _guess == c,
                        onTap: _guess != null
                            ? null
                            : () => setState(() {
                                _guess = c;
                                _played++;
                                if (c.of(card.scores) == _best(card.scores)) {
                                  _correct++;
                                }
                              }),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_guess != null) ...[
                  Center(
                    child: Text(
                      _guess!.of(card.scores) == _best(card.scores)
                          ? '¡Exacto! Conocés a ${card.saint.name}.'
                          : 'Su fuerte es ${ScoreCategory.values.firstWhere((c) => c.of(card.scores) == _best(card.scores)).label.toLowerCase()}.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _next,
                    icon: const Icon(Icons.skip_next_rounded),
                    label: const Text('OTRA CARTA'),
                  ),
                ],
              ],
            ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.category,
    required this.value,
    required this.isBest,
    required this.isGuess,
    required this.onTap,
  });

  final ScoreCategory category;
  final int? value;
  final bool isBest;
  final bool isGuess;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final border = isBest
        ? Palette.gold
        : isGuess
        ? Palette.crimson
        : Palette.inkLine;
    return Material(
      color: isBest
          ? Palette.goldDark.withValues(alpha: 0.35)
          : Palette.inkRaised,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Palette.parchment,
                  ),
                ),
              ),
              if (value != null)
                Text(
                  '$value',
                  style: textTheme.titleMedium?.copyWith(
                    color: isBest ? Palette.goldLight : Palette.parchmentDim,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
