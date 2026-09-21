import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/saint_card.dart';

/// Pick the five cards of a duel deck. Returns the chosen saint ids.
class DeckPickerScreen extends StatefulWidget {
  const DeckPickerScreen({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  static Future<List<int>?> open(
    BuildContext context, {
    required String title,
    String? subtitle,
  }) {
    return Navigator.of(context).push<List<int>>(
      MaterialPageRoute(
        builder: (_) => DeckPickerScreen(title: title, subtitle: subtitle),
      ),
    );
  }

  @override
  State<DeckPickerScreen> createState() => _DeckPickerScreenState();
}

class _DeckPickerScreenState extends State<DeckPickerScreen> {
  static const size = 5;
  List<int>? _hand;
  Object? _error;
  final _chosen = <int>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final hand = await client.duel.dealHand();
      if (mounted) setState(() => _hand = hand);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final textTheme = Theme.of(context).textTheme;
    final all = state.overview?.cards ?? const <CollectedCard>[];
    final hand = _hand ?? const <int>[];
    // Only the dealt cards, in the order they were dealt.
    final cards = [
      for (final id in hand) ...all.where((c) => c.saint.id == id),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(widget.title.toUpperCase())),
      body: _error != null
          ? ErrorView(error: _error!, onRetry: _load)
          : _hand == null
          ? const LoadingView()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: Column(
                    children: [
                      if (widget.subtitle != null)
                        Text(
                          widget.subtitle!,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Palette.parchmentDim,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'La app repartió ${cards.length} cartas de tu álbum. '
                        'Elegí $size · ${_chosen.length} de $size',
                        textAlign: TextAlign.center,
                        style: textTheme.labelLarge?.copyWith(
                          color: Palette.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = (constraints.maxWidth / 150)
                          .floor()
                          .clamp(2, 6);
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 12,
                          childAspectRatio: cardAspectRatio,
                        ),
                        itemCount: cards.length,
                        itemBuilder: (context, i) {
                          final card = cards[i];
                          final id = card.saint.id;
                          final index = _chosen.indexOf(id);
                          return GestureDetector(
                            onTap: () => setState(() {
                              if (index >= 0) {
                                _chosen.remove(id);
                              } else if (_chosen.length < size) {
                                _chosen.add(id);
                              }
                            }),
                            child: LayoutBuilder(
                              builder: (context, c) => Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: SaintCard(
                                      saint: card.saint,
                                      scores: card.scores,
                                      width: c.maxWidth - 6,
                                    ),
                                  ),
                                  if (index >= 0)
                                    Positioned(
                                      top: -4,
                                      right: 0,
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Palette.gold,
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: textTheme.labelLarge?.copyWith(
                                            color: Palette.ink,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: _chosen.length == size
          ? FloatingActionButton.extended(
              backgroundColor: Palette.gold,
              foregroundColor: Palette.ink,
              onPressed: () => Navigator.of(context).pop(List.of(_chosen)),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('LISTO'),
            )
          : null,
    );
  }
}
