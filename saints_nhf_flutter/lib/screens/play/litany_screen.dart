import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/quiz_view.dart';
import '../saint_detail_screen.dart';

/// La Letanía: one question after another about the saints in your album,
/// three lives, and a multiplier that grows with the streak.
class LitanyScreen extends StatefulWidget {
  const LitanyScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LitanyScreen()),
    );
  }

  @override
  State<LitanyScreen> createState() => _LitanyScreenState();
}

class _LitanyScreenState extends State<LitanyScreen> {
  LitanyView? _view;
  Object? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final view = await client.litany.state();
      if (mounted) setState(() => _view = view);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  /// Runs [action] keeping the screen from firing twice, and reports a failure
  /// without losing the board that is already on screen.
  Future<void> _run(Future<LitanyView> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final view = await action();
      if (mounted) setState(() => _view = view);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _giveUp() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cortar la letanía?'),
        content: const Text(
          'Se guarda el puntaje que hiciste hasta acá y la corrida termina.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('SEGUIR'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('CORTAR'),
          ),
        ],
      ),
    );
    if (leave != true) return;
    await _run(client.litany.giveUp);
  }

  @override
  Widget build(BuildContext context) {
    final view = _view;
    return Scaffold(
      appBar: AppBar(
        title: const Text('LA LETANÍA'),
        actions: [
          if (view != null && view.runId != null && !view.finished)
            IconButton(
              tooltip: 'Cortar la letanía',
              onPressed: _busy ? null : _giveUp,
              icon: const Icon(Icons.flag_outlined),
            ),
        ],
      ),
      body: _error != null
          ? ErrorView(error: _error!, onRetry: _load)
          : view == null
          ? const Center(
              child: CircularProgressIndicator(color: Palette.gold),
            )
          : _Board(
              view: view,
              busy: _busy,
              onStart: () => _run(client.litany.start),
              onAnswer: (i) => _run(() => client.litany.answer(i)),
              onNext: () => _run(client.litany.next),
            ),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({
    required this.view,
    required this.busy,
    required this.onStart,
    required this.onAnswer,
    required this.onNext,
  });

  final LitanyView view;
  final bool busy;
  final VoidCallback onStart;
  final ValueChanged<int> onAnswer;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final graded = view.correctIndex != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        _Scoreboard(view: view),
        const SizedBox(height: 18),
        if (view.finished || view.runId != null) ...[
          // The question stays on screen with its result — including the one
          // that ended the run, so the player sees the right answer instead of
          // jumping straight to the score.
          if (view.question != null) ...[
            if (view.saint != null)
              TextButton(
                onPressed: () =>
                    SaintDetailScreen.open(context, view.saint!.id),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: Text(
                  'Sobre ${view.saint!.name}',
                  style: textTheme.bodySmall?.copyWith(color: Palette.gold),
                ),
              ),
            const SizedBox(height: 12),
            QuizView(
              question: view.question!,
              onAnswer: onAnswer,
              chosenIndex: view.chosenIndex,
              correctIndex: view.correctIndex,
              busy: busy,
            ),
          ],
          if (graded && !view.finished) ...[
            const SizedBox(height: 18),
            Text(
              view.lastWasCorrect == true
                  ? _praise(view)
                  : 'Esta vez no. Te queda ${view.lives} '
                        '${view.lives == 1 ? 'vida' : 'vidas'}.',
              style: textTheme.bodyLarge?.copyWith(
                color: view.lastWasCorrect == true
                    ? Palette.goldLight
                    : Palette.crimsonLight,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: busy ? null : onNext,
              icon: const Icon(Icons.skip_next_rounded),
              label: const Text('SIGUIENTE'),
            ),
          ],
          if (view.finished) ...[
            const SizedBox(height: 24),
            _Ending(view: view, busy: busy, onStart: onStart),
          ],
          if (!view.finished && view.question == null)
            Text(
              'Preparando la próxima pregunta…',
              style: textTheme.bodyMedium?.copyWith(
                color: Palette.parchmentDim,
              ),
            ),
        ] else
          _Intro(view: view, busy: busy, onStart: onStart),
      ],
    );
  }

  String _praise(LitanyView view) {
    final base = '¡Bien! +${view.lastGain ?? 0}';
    if (view.streak >= 3) return '$base · racha de ${view.streak}';
    return base;
  }
}

class _Scoreboard extends StatelessWidget {
  const _Scoreboard({required this.view});

  final LitanyView view;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Puntos'),
                const SizedBox(height: 2),
                Text(
                  '${view.score}',
                  style: textTheme.headlineSmall?.copyWith(
                    color: Palette.gold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    for (var i = 0; i < view.maxLives; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Icon(
                          i < view.lives
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: i < view.lives
                              ? Palette.crimsonLight
                              : Palette.parchmentDim,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  view.multiplier > 1
                      ? '×${view.multiplier}  ·  récord ${view.bestScore}'
                      : 'récord ${view.bestScore}',
                  style: textTheme.labelSmall?.copyWith(
                    color: view.multiplier > 1
                        ? Palette.goldLight
                        : Palette.parchmentDim,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Mirrors nothing: the numbers in the copy come from the view.
class _Intro extends StatelessWidget {
  const _Intro({
    required this.view,
    required this.busy,
    required this.onStart,
  });

  final LitanyView view;
  final bool busy;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final blocked = view.unavailableReason;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Ornament(),
        const SizedBox(height: 16),
        Text(
          'Una pregunta tras otra sobre los santos de tu álbum, como las '
          'invocaciones de una letanía. Tenés ${view.maxLives} vidas: cada '
          'respuesta errada te cuesta una. Cada tres aciertos seguidos sube '
          'el multiplicador, hasta ×${view.maxMultiplier}.',
          style: textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 10),
        Text(
          'Nunca se repite una pregunta, así que cuantos más santos tengas, '
          'más larga puede ser la corrida.',
          style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
        ),
        const SizedBox(height: 22),
        if (blocked != null)
          Text(
            blocked,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: Palette.crimsonLight,
            ),
          )
        else
          FilledButton.icon(
            onPressed: busy ? null : onStart,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('EMPEZAR'),
          ),
      ],
    );
  }
}

class _Ending extends StatelessWidget {
  const _Ending({
    required this.view,
    required this.busy,
    required this.onStart,
  });

  final LitanyView view;
  final bool busy;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Ornament(),
        const SizedBox(height: 16),
        Center(
          child: Text(
            view.newRecord ? '¡Récord nuevo!' : 'Terminó la letanía',
            style: textTheme.headlineSmall?.copyWith(color: Palette.gold),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            '${view.score} puntos  ·  ${view.correct} de ${view.answered} '
            'bien',
            style: textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'Récord: ${view.bestScore}',
            style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
          ),
        ),
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: busy ? null : onStart,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('OTRA VEZ'),
        ),
      ],
    );
  }
}
