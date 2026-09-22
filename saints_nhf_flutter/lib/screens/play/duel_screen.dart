import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import '../../utils/duel_outcome.dart';
import '../../utils/scores.dart';
import '../../widgets/common.dart';
import '../../widgets/duel_round_card.dart';
import '../../widgets/quiz_view.dart';
import '../../widgets/waiting_view.dart';
import '../../widgets/saint_card.dart';
import 'deck_picker_screen.dart';

/// The duel board: score, my remaining cards, the rounds and the next move.
class DuelScreen extends StatefulWidget {
  const DuelScreen({
    super.key,
    this.duelId,
    this.initial,
    this.create,
    this.waitingTitle,
    this.waitingSubtitle,
  }) : assert(duelId != null || create != null);

  /// The duel to show. Null when it is created by [create].
  final int? duelId;
  final DuelView? initial;

  /// Creates the duel and then shows it.
  final Future<DuelView> Function()? create;
  final String? waitingTitle;
  final String? waitingSubtitle;

  static Future<void> open(
    BuildContext context,
    int duelId, {
    DuelView? initial,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DuelScreen(duelId: duelId, initial: initial),
      ),
    );
  }

  /// Opens the board for a duel that is still being created, showing the
  /// waiting screen until the server answers.
  static Future<void> openCreating(
    BuildContext context, {
    required Future<DuelView> Function() create,
    required String waitingTitle,
    String? waitingSubtitle,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DuelScreen(
          create: create,
          waitingTitle: waitingTitle,
          waitingSubtitle: waitingSubtitle,
        ),
      ),
    );
  }

  @override
  State<DuelScreen> createState() => _DuelScreenState();
}

class _DuelScreenState extends State<DuelScreen> {
  DuelView? _view;
  Object? _error;
  bool _busy = false;
  ScoreCategory? _pickedCategory;
  int? _pickedSaint;
  int? _lastAnswer;

  /// Result panel the player already closed, so it does not come back on
  /// every poll. Keyed by round and state, so the same round opens it again
  /// when it goes from "answered" to resolved.
  String? _dismissedResult;
  Timer? _poll;

  int? _duelId;

  @override
  void initState() {
    super.initState();
    _view = widget.initial;
    _duelId = widget.duelId;
    if (widget.create != null) {
      _create();
    } else {
      _load();
    }
    // Friend duels are asynchronous: poll while waiting for the other side.
    _poll = Timer.periodic(const Duration(seconds: 8), (_) {
      final v = _view;
      if (v != null &&
          !v.isVsMachine &&
          (v.phase == DuelPhase.waitingOpponent ||
              v.phase == DuelPhase.waitingOpponentDeck)) {
        _load(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _create() async {
    try {
      final v = await widget.create!();
      if (!mounted) return;
      setState(() {
        _duelId = v.duelId;
        _apply(v);
      });
      unawaited(AppState.of(context).refreshDuels());
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _load({bool silent = false}) async {
    final id = _duelId;
    if (id == null) return;
    try {
      final v = await client.duel.view(id);
      if (mounted) setState(() => _apply(v));
    } catch (e) {
      if (mounted && !silent) setState(() => _error = e);
    }
  }

  void _apply(DuelView v) {
    _view = v;
    _error = null;
    _pickedCategory = null;
    _pickedSaint = null;
    if (v.phase != DuelPhase.answer) _lastAnswer = null;
  }

  Future<void> _run(Future<DuelView> Function() action) async {
    setState(() => _busy = true);
    try {
      final v = await action();
      if (!mounted) return;
      setState(() => _apply(v));
      if (v.phase == DuelPhase.finished) {
        unawaited(AppState.of(context).refreshProfile());
      }
      unawaited(AppState.of(context).refreshDuels());
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _chooseDeck() async {
    final deck = await DeckPickerScreen.open(
      context,
      title: 'Tu mazo',
      subtitle: 'Aceptá el desafío eligiendo las cinco cartas que vas a jugar.',
    );
    if (deck == null || !mounted) return;
    await _run(() => client.duel.accept(_duelId!, deck));
  }

  Future<void> _decline() async {
    try {
      await client.duel.decline(_duelId!);
      if (!mounted) return;
      unawaited(AppState.of(context).refreshDuels());
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  /// The round to show face up over the board: the last one that resolved,
  /// or the one in progress once I answered my question, unless the player
  /// already closed it.
  DuelRoundView? _lastResult(DuelView v) {
    final last = v.rounds
        .where((r) => r.resolved || r.myCorrect != null)
        .lastOrNull;
    if (last == null || _keyOf(last) == _dismissedResult) return null;
    return last;
  }

  static String _keyOf(DuelRoundView r) =>
      '${r.roundNumber}:${r.resolved ? 'fin' : 'abierta'}';

  @override
  Widget build(BuildContext context) {
    final v = _view;
    return Scaffold(
      appBar: AppBar(
        title: Text(v == null ? 'DUELO' : 'VS ${v.opponentName.toUpperCase()}'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _busy ? null : _load,
          ),
        ],
      ),
      body: _error != null && v == null
          ? ErrorView(
              error: _error!,
              onRetry: widget.create != null && _duelId == null
                  ? _create
                  : _load,
            )
          : v == null
          ? WaitingView(
              title: widget.waitingTitle ?? 'Cargando el duelo',
              subtitle: widget.waitingSubtitle,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              children: [
                _ScoreBoard(view: v),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  child: switch (_lastResult(v)) {
                    final r? => Padding(
                      key: ValueKey(_keyOf(r)),
                      padding: const EdgeInsets.only(top: 20),
                      child: RoundResultPanel(
                        round: r,
                        opponentName: v.opponentName,
                        onDismiss: () =>
                            setState(() => _dismissedResult = _keyOf(r)),
                      ),
                    ),
                    null => const SizedBox.shrink(),
                  },
                ),
                const SizedBox(height: 20),
                _phaseSection(v),
                const SizedBox(height: 28),
                if (v.rounds.isNotEmpty) ...[
                  const Eyebrow('Rondas'),
                  const SizedBox(height: 10),
                  for (final r in v.rounds.reversed)
                    RoundTile(round: r, opponentName: v.opponentName),
                ],
                if (v.phase != DuelPhase.finished &&
                    v.phase != DuelPhase.declined &&
                    v.myDeck.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Eyebrow('Tu mazo'),
                  const SizedBox(height: 10),
                  _DeckRow(
                    cards: v.myDeck,
                    selected: _pickedSaint,
                    onTap: null,
                  ),
                ],
              ],
            ),
    );
  }

  Widget _phaseSection(DuelView v) {
    final textTheme = Theme.of(context).textTheme;
    switch (v.phase) {
      case DuelPhase.chooseDeck:
        return _Panel(
          title: 'Te desafiaron',
          body:
              '${v.opponentName} quiere un duelo. Elegí tus cinco cartas '
              'para aceptar.',
          actions: [
            FilledButton.icon(
              onPressed: _busy ? null : _chooseDeck,
              icon: const Icon(Icons.style_rounded),
              label: const Text('ELEGIR MAZO'),
            ),
            TextButton(onPressed: _decline, child: const Text('Rechazar')),
          ],
        );
      case DuelPhase.waitingOpponentDeck:
        return _Panel(
          title: 'Esperando',
          body:
              '${v.opponentName} todavía no aceptó el desafío. '
              'Te avisamos en la pestaña Jugar cuando sea tu turno.',
          actions: [
            TextButton(
              onPressed: _decline,
              child: const Text('Cancelar desafío'),
            ),
          ],
        );
      case DuelPhase.waitingOpponent:
        return _Panel(
          title: 'Turno de ${v.opponentName}',
          body: v.attackerIsMe
              ? 'Jugaste tu carta. Ahora ${v.opponentName} elige la suya y '
                    'responde su pregunta.'
              : '${v.opponentName} está eligiendo categoría y carta.',
        );
      case DuelPhase.attack:
        final available = ScoreCategory.values
            .where((c) => !v.usedCategories.contains(c))
            .toList();
        return _Panel(
          title: 'Atacás vos',
          body:
              'Elegí una categoría y la carta con la que vas a jugar. '
              'Después respondés una pregunta sobre ese santo.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in available)
                    ChoiceChip(
                      label: Text(c.label.toUpperCase()),
                      selected: _pickedCategory == c,
                      selectedColor: Palette.goldDark,
                      onSelected: (_) => setState(() => _pickedCategory = c),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _pickedCategory == null
                    ? 'Tus cartas'
                    : 'Tus cartas en ${_pickedCategory!.label}',
                style: textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              _DeckRow(
                cards: v.myDeck,
                selected: _pickedSaint,
                highlight: _pickedCategory,
                onTap: (id) => setState(() => _pickedSaint = id),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed:
                    _busy || _pickedCategory == null || _pickedSaint == null
                    ? null
                    : () => _run(
                        () => client.duel.attack(
                          v.duelId,
                          _pickedCategory!,
                          _pickedSaint!,
                        ),
                      ),
                icon: _busy
                    ? const _ButtonSpinner()
                    : const Icon(Icons.bolt_rounded),
                label: Text(_busy ? 'JUGANDO…' : 'JUGAR CARTA'),
              ),
            ],
          ),
        );
      case DuelPhase.defend:
        return _Panel(
          title: 'Defendés en ${v.currentCategory?.label ?? ''}',
          body:
              '${v.opponentName} eligió ${v.currentCategory?.label}. '
              'Elegí la carta que creés que gana. No ves la suya hasta el final '
              'de la ronda.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DeckRow(
                cards: v.myDeck,
                selected: _pickedSaint,
                highlight: v.currentCategory,
                onTap: (id) => setState(() => _pickedSaint = id),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _busy || _pickedSaint == null
                    ? null
                    : () => _run(
                        () => client.duel.defend(v.duelId, _pickedSaint!),
                      ),
                icon: _busy
                    ? const _ButtonSpinner()
                    : const Icon(Icons.shield_rounded),
                label: Text(_busy ? 'JUGANDO…' : 'JUGAR CARTA'),
              ),
            ],
          ),
        );
      case DuelPhase.answer:
        final q = v.pendingQuestion;
        return _Panel(
          title: 'Tu pregunta',
          body: v.pendingSaint == null
              ? 'Respondé sobre tu santo.'
              : 'Sobre ${v.pendingSaint!.name}. Si tu carta gana la '
                    'comparación, el punto es tuyo solo si respondés bien.',
          child: q == null
              ? Text(
                  'Este santo no tiene preguntas. Tocá "Actualizar".',
                  style: textTheme.bodyMedium,
                )
              : QuizView(
                  question: q,
                  busy: _busy,
                  chosenIndex: _lastAnswer,
                  waitingMessage: _lastAnswer == null
                      ? null
                      : v.attackerIsMe
                      ? 'Guardando tu respuesta. Después juega '
                            '${v.opponentName}.'
                      : 'Guardando tu respuesta y resolviendo la ronda.',
                  onAnswer: (i) {
                    setState(() => _lastAnswer = i);
                    _run(() => client.duel.answer(v.duelId, i));
                  },
                ),
        );
      case DuelPhase.finished:
        final draw = v.winnerIsMe == null;
        final tally = DuelTally.of(v.rounds);
        return _Panel(
          title: draw
              ? 'Empate'
              : v.winnerIsMe!
              ? '¡Ganaste!'
              : 'Ganó ${v.opponentName}',
          body: draw
              ? 'Terminaron ${v.myScore} a ${v.opponentScore}. '
                    '${tally.sentence} La próxima se define.'
              : v.winnerIsMe!
              ? 'Te llevaste el duelo ${v.myScore} a ${v.opponentScore}. '
                    '${tally.sentence}'
              : 'Perdiste ${v.myScore} a ${v.opponentScore}. '
                    '${tally.sentence} Repasá las vidas de tus santos y '
                    'pedí revancha.',
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('VOLVER'),
            ),
          ],
          child: tally.none > 0
              ? Text(
                  'Una ronda queda sin punto cuando erraron los dos, o '
                  'cuando las cartas empataron y los dos respondieron igual.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                )
              : null,
        );
      case DuelPhase.declined:
        return _Panel(
          title: 'Duelo cancelado',
          body: 'Este desafío no se jugó.',
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('VOLVER'),
            ),
          ],
        );
    }
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 16,
    height: 16,
    child: CircularProgressIndicator(strokeWidth: 2, color: Palette.ink),
  );
}

class _ScoreBoard extends StatelessWidget {
  const _ScoreBoard({required this.view});

  final DuelView view;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget side(String name, int score, int cardsLeft, {required bool me}) =>
        Expanded(
          child: Column(
            crossAxisAlignment: me
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: me ? Palette.gold : Palette.parchmentDim,
                ),
              ),
              Text(
                '$score',
                style: textTheme.displayMedium?.copyWith(
                  fontSize: 44,
                  color: me ? Palette.goldLight : Palette.parchment,
                ),
              ),
              Text(
                '$cardsLeft ${cardsLeft == 1 ? 'carta' : 'cartas'}',
                style: textTheme.bodySmall?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
            ],
          ),
        );
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        child: Row(
          children: [
            side('Vos', view.myScore, view.myDeck.length, me: true),
            Column(
              children: [
                Text(
                  'RONDA ${view.roundNumber}',
                  style: textTheme.labelSmall?.copyWith(color: Palette.gold),
                ),
                const SizedBox(height: 4),
                Text(
                  'a ${view.pointsToWin}',
                  style: textTheme.bodySmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                ),
              ],
            ),
            side(
              view.opponentName,
              view.opponentScore,
              view.opponentCardsLeft,
              me: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.body,
    this.child,
    this.actions = const [],
  });

  final String title;
  final String body;
  final Widget? child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Palette.goldDark),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF221C3A), Palette.inkRaised],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            body,
            style: textTheme.bodyMedium?.copyWith(color: Palette.parchmentDim),
          ),
          if (child != null) ...[const SizedBox(height: 16), child!],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 8, children: actions),
          ],
        ],
      ),
    );
  }
}

class _DeckRow extends StatelessWidget {
  const _DeckRow({
    required this.cards,
    required this.selected,
    required this.onTap,
    this.highlight,
  });

  final List<CollectedCard> cards;
  final int? selected;
  final ValueChanged<int>? onTap;
  final ScoreCategory? highlight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 214,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final card = cards[i];
          final isSelected = selected == card.saint.id;
          return GestureDetector(
            onTap: onTap == null ? null : () => onTap!(card.saint.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.only(bottom: 10),
              transform: Matrix4.translationValues(0, isSelected ? -8 : 0, 0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SaintCard(
                        saint: card.saint,
                        scores: card.scores,
                        width: 120,
                      ),
                      if (isSelected)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                  color: Palette.goldLight,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (highlight != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '${highlight!.abbreviation} ${highlight!.of(card.scores)}',
                        style: textTheme.labelSmall?.copyWith(
                          color: Palette.gold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
