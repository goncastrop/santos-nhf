import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../state/live_state.dart';
import '../../theme.dart';
import '../../utils/feast.dart';
import '../../widgets/common.dart';
import '../live/live_widgets.dart';

/// Runs the live trivia during the show: set it up and announce it, then
/// move it along with one button.
class AdminLiveScreen extends StatelessWidget {
  const AdminLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final live = LiveState.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('TRIVIA EN VIVO')),
      body: live.isPlaying && live.view?.gameId != null
          ? _Control(view: live.view!)
          : const _Setup(),
    );
  }
}

/// The game in progress and the button that moves it.
class _Control extends StatefulWidget {
  const _Control({required this.view});

  final LiveView view;

  @override
  State<_Control> createState() => _ControlState();
}

class _ControlState extends State<_Control> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancel() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cancelar la trivia?'),
        content: const Text(
          'Se corta para todos y nadie gana cartas. No se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('SEGUIR'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('CANCELAR TRIVIA'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _run(() => client.adminLive.cancel(widget.view.gameId!));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final live = LiveState.of(context);
    final view = widget.view;
    final last = view.questionNumber == view.questionCount;
    final (status, button) = switch (view.phase) {
      LivePhase.countdown when view.questionNumber == 1 => (
        'En la sala de espera',
        'EMPEZAR YA',
      ),
      LivePhase.countdown => (
        'Por abrir la pregunta ${view.questionNumber}',
        'ABRIR YA',
      ),
      LivePhase.question => (
        'Pregunta ${view.questionNumber} abierta',
        'CERRAR PREGUNTA',
      ),
      LivePhase.reveal => (
        'Mostrando la respuesta ${view.questionNumber}',
        last ? 'TERMINAR Y VER EL PODIO' : 'SIGUIENTE PREGUNTA',
      ),
      _ => ('', ''),
    };
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        Row(
          children: [
            const LiveDot(),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                view.saint?.name ?? '',
                style: textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Ticking(
              builder: (_) {
                final clock = switch (view.phase) {
                  LivePhase.countdown => clockText(
                    view.countdownTo,
                    live.serverNow,
                  ),
                  LivePhase.question => clockText(
                    view.closesAt,
                    live.serverNow,
                  ),
                  _ => null,
                };
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(
                      'Pregunta ${view.questionNumber} de '
                      '${view.questionCount}',
                    ),
                    const SizedBox(height: 6),
                    Text(status, style: textTheme.titleLarge),
                    if (clock != null)
                      Text(
                        clock,
                        style: textTheme.displaySmall?.copyWith(
                          color: Palette.gold,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      '${view.watching} mirando'
                      '${view.answeredCount == null ? '' : ' · ${view.answeredCount} respondieron'}',
                      style: textTheme.bodySmall?.copyWith(
                        color: Palette.parchmentDim,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        if (view.question != null) ...[
          const SizedBox(height: 16),
          Text(
            view.question!.prompt,
            style: textTheme.titleMedium?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < view.question!.options.length; i++)
            Text(
              '${String.fromCharCode(65 + i)}. ${view.question!.options[i]}'
              '${i == view.correctIndex ? '  ✓' : ''}',
              style: textTheme.bodyMedium?.copyWith(
                color: i == view.correctIndex ? Palette.gold : null,
              ),
            ),
        ],
        if (view.tally != null) ...[
          const SizedBox(height: 16),
          TallyBars(tally: view.tally!, correctIndex: view.correctIndex),
        ],
        if (view.leaderboard?.isNotEmpty ?? false) ...[
          const SizedBox(height: 16),
          LiveLeaderboard(entries: view.leaderboard!),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _busy
              ? null
              : () => _run(() => client.adminLive.advance(view.gameId!)),
          child: Text(button),
        ),
        const SizedBox(height: 10),
        Text(
          view.phase == LivePhase.question
              ? 'La pregunta se cierra sola al terminar el tiempo.'
              : view.phase == LivePhase.countdown
              ? 'Se abre sola al terminar la cuenta regresiva.'
              : 'Pasá cuando termines de comentar la respuesta.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: _busy ? null : _cancel,
          child: const Text('CANCELAR TRIVIA'),
        ),
      ],
    );
  }
}

/// Picking the saint, the questions and the prizes.
class _Setup extends StatefulWidget {
  const _Setup();

  @override
  State<_Setup> createState() => _SetupState();
}

class _SetupState extends State<_Setup> {
  static const _maxPicked = 5;

  SaintInfo? _saint;
  List<Question>? _questions;
  final _picked = <int>[];
  int _countdown = 60;
  int _seconds = 20;
  int _fast = 3;
  int _raffle = 2;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final today = AppState.of(context).saintsOfToday(nowInArgentina());
      if (today.isNotEmpty) _pickSaint(today.first);
    });
  }

  Future<void> _pickSaint(SaintInfo saint) async {
    setState(() {
      _saint = saint;
      _questions = null;
      _picked.clear();
    });
    try {
      final questions = await client.adminQuestion.listFor(saint.id);
      if (!mounted || _saint?.id != saint.id) return;
      setState(() {
        _questions = questions;
        _picked.addAll(questions.take(_maxPicked).map((q) => q.id!));
      });
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  void _toggle(int id) {
    setState(() {
      if (!_picked.remove(id) && _picked.length < _maxPicked) _picked.add(id);
    });
  }

  Future<void> _announce() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Anunciar la trivia?'),
        content: Text(
          'A todos los que tengan la app abierta les aparece el aviso ya. '
          'La primera pregunta se abre en $_countdown segundos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('TODAVÍA NO'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ANUNCIAR'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await client.adminLive.announce(
        _saint!.id,
        List.of(_picked),
        _countdown,
        _seconds,
        _fast,
        _raffle,
      );
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final catalog = [...?AppState.of(context).catalog]
      ..sort((a, b) => a.name.compareTo(b.name));
    final questions = _questions;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        const Eyebrow('Santo'),
        const SizedBox(height: 8),
        DropdownMenu<SaintInfo>(
          key: ValueKey(_saint?.id),
          initialSelection: _saint,
          expandedInsets: EdgeInsets.zero,
          enableFilter: true,
          requestFocusOnTap: true,
          hintText: 'Elegí el santo del programa',
          dropdownMenuEntries: [
            for (final s in catalog) DropdownMenuEntry(value: s, label: s.name),
          ],
          onSelected: (s) {
            if (s != null) _pickSaint(s);
          },
        ),
        if (_saint != null) ...[
          const SizedBox(height: 20),
          Eyebrow(
            'Preguntas (hasta $_maxPicked, en el orden en que las tocás)',
          ),
          const SizedBox(height: 8),
          if (questions == null)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: Palette.gold),
              ),
            )
          else if (questions.isEmpty)
            Text(
              'Este santo no tiene preguntas. Cargalas desde su ficha.',
              style: textTheme.bodyMedium?.copyWith(
                color: Palette.crimsonLight,
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (final q in questions)
                    ListTile(
                      onTap: () => _toggle(q.id!),
                      leading: CircleAvatar(
                        radius: 13,
                        backgroundColor: _picked.contains(q.id)
                            ? Palette.gold
                            : Palette.inkLine,
                        child: Text(
                          _picked.contains(q.id)
                              ? '${_picked.indexOf(q.id!) + 1}'
                              : '',
                          style: textTheme.labelSmall?.copyWith(
                            color: Palette.ink,
                          ),
                        ),
                      ),
                      title: Text(q.prompt, style: textTheme.bodyMedium),
                      subtitle: Text(
                        q.options[q.correctIndex],
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 20),
        const Eyebrow('Cuenta regresiva antes de la primera'),
        const SizedBox(height: 8),
        _Choice(
          values: const [30, 60, 90, 120],
          selected: _countdown,
          label: (v) => '$v s',
          onChanged: (v) => setState(() => _countdown = v),
        ),
        const SizedBox(height: 16),
        const Eyebrow('Tiempo por pregunta'),
        const SizedBox(height: 8),
        _Choice(
          values: const [15, 20, 30],
          selected: _seconds,
          label: (v) => '$v s',
          onChanged: (v) => setState(() => _seconds = v),
        ),
        const SizedBox(height: 16),
        _Counter(
          label: 'Premios a los mejores puntajes',
          value: _fast,
          onChanged: (v) => setState(() => _fast = v),
        ),
        _Counter(
          label: 'Premios por sorteo',
          value: _raffle,
          onChanged: (v) => setState(() => _raffle = v),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _busy || _saint == null || _picked.isEmpty
              ? null
              : _announce,
          icon: const Icon(Icons.podcasts_rounded),
          label: const Text('ANUNCIAR'),
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.values,
    required this.selected,
    required this.label,
    required this.onChanged,
  });

  final List<int> values;
  final int selected;
  final String Function(int) label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      showSelectedIcon: false,
      segments: [
        for (final v in values) ButtonSegment(value: v, label: Text(label(v))),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        IconButton(
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline_rounded),
        ),
        SizedBox(
          width: 28,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          onPressed: value < 20 ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_circle_outline_rounded),
        ),
      ],
    );
  }
}
