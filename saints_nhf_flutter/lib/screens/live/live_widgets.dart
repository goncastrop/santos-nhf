import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../state/live_state.dart';
import '../../theme.dart';
import 'live_screen.dart';

/// Whole seconds from [now] until [to], rounded up so the clock shows 1
/// until the very end; 0 once it passed.
int secondsLeft(DateTime? to, DateTime now) {
  if (to == null) return 0;
  final ms = to.difference(now).inMilliseconds;
  return ms <= 0 ? 0 : (ms / 1000).ceil();
}

/// "1:05" or "0:42".
String clockText(DateTime? to, DateTime now) {
  final s = secondsLeft(to, now);
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}

/// Rebuilds [builder] a few times a second, for countdowns.
class Ticking extends StatefulWidget {
  const Ticking({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  State<Ticking> createState() => _TickingState();
}

class _TickingState extends State<Ticking> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}

/// The red "● EN VIVO" mark.
class LiveDot extends StatelessWidget {
  const LiveDot({super.key, this.label = 'EN VIVO'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Pulse(),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Palette.crimsonLight,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _Pulse extends StatefulWidget {
  const _Pulse();

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.35, end: 1.0).animate(_controller),
      child: Container(
        width: 9,
        height: 9,
        decoration: const BoxDecoration(
          color: Palette.crimsonLight,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// How many picked each option, with the right one in gold.
class TallyBars extends StatelessWidget {
  const TallyBars({super.key, required this.tally, this.correctIndex});

  final List<int> tally;
  final int? correctIndex;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final top = tally.fold<int>(0, (a, b) => a > b ? a : b);
    return Column(
      children: [
        for (var i = 0; i < tally.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: Text(
                    String.fromCharCode(65 + i),
                    style: textTheme.labelLarge?.copyWith(
                      color: i == correctIndex
                          ? Palette.gold
                          : Palette.parchmentDim,
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final fraction = top == 0 ? 0.0 : tally[i] / top;
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                          height: 18,
                          width: (constraints.maxWidth * fraction).clamp(
                            4.0,
                            constraints.maxWidth,
                          ),
                          decoration: BoxDecoration(
                            color: i == correctIndex
                                ? Palette.gold
                                : Palette.inkLine,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 44,
                  child: Text(
                    '${tally[i]}',
                    textAlign: TextAlign.right,
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The top of the ranking, with the player's own row marked, and their
/// position below when they are not in it.
class LiveLeaderboard extends StatelessWidget {
  const LiveLeaderboard({super.key, required this.entries, this.me});

  final List<LiveRankEntry> entries;
  final LiveMe? me;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final meInList = entries.any((e) => e.isMe);
    Widget row(int rank, String name, int points, bool isMe) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? Palette.goldDark.withValues(alpha: 0.3) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$rank.º',
              style: textTheme.labelLarge?.copyWith(color: Palette.gold),
            ),
          ),
          Expanded(
            child: Text(
              isMe ? '$name (vos)' : name,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium,
            ),
          ),
          Text('$points', style: textTheme.labelLarge),
        ],
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            for (final e in entries) row(e.rank, e.name, e.points, e.isMe),
            if (!meInList && me?.rank != null) ...[
              const Divider(height: 8),
              row(me!.rank!, 'Vos', me!.totalPoints, true),
            ],
          ],
        ),
      ),
    );
  }
}

/// Prize winners and the card each one got.
class WinnerList extends StatelessWidget {
  const WinnerList({super.key, required this.winners});

  final List<LiveWinnerView> winners;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Column(
        children: [
          for (final w in winners)
            ListTile(
              dense: true,
              leading: Icon(
                Icons.emoji_events_rounded,
                color: w.isMe ? Palette.goldLight : Palette.gold,
              ),
              title: Text(
                w.isMe ? '${w.name} (vos)' : w.name,
                style: textTheme.bodyMedium?.copyWith(
                  color: w.isMe ? Palette.goldLight : null,
                ),
              ),
              subtitle: Text(
                w.saintName == null
                    ? '${w.points} puntos · ya tenía todo el álbum'
                    : '${w.points} puntos · ${w.saintName}',
                style: textTheme.bodySmall?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The strip on top of every tab while a game is on. It opens the game; the
/// cross hides it for this game and leaves the dot in the app bar.
class LiveBanner extends StatelessWidget {
  const LiveBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final live = LiveState.of(context);
    final view = live.view;
    if (view == null || !live.isOn || live.bannerDismissed) {
      return const SizedBox.shrink();
    }
    final textTheme = Theme.of(context).textTheme;
    final saint = view.saint?.name;
    return Material(
      color: const Color(0xFF3A1518),
      child: InkWell(
        onTap: () => LiveScreen.open(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 4, 6),
          child: Row(
            children: [
              const LiveDot(),
              const SizedBox(width: 12),
              Expanded(
                child: Ticking(
                  builder: (_) => Text(
                    _message(view, live, saint),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: Palette.parchment,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => LiveScreen.open(context),
                child: Text(_action(view, live)),
              ),
              IconButton(
                tooltip: 'Ocultar',
                visualDensity: VisualDensity.compact,
                onPressed: live.dismissBanner,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: Palette.parchmentDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _message(LiveView view, LiveState live, String? saint) {
    final now = live.serverNow;
    return switch (view.phase) {
      LivePhase.countdown when view.questionNumber == 1 =>
        'Trivia${saint == null ? '' : ' de $saint'} · empieza en '
            '${clockText(view.countdownTo, now)}',
      LivePhase.countdown =>
        'Pregunta ${view.questionNumber} de ${view.questionCount} en '
            '${secondsLeft(view.countdownTo, now)}…',
      LivePhase.question when live.myChoice != null =>
        'Respondiste · cierra en ${secondsLeft(view.closesAt, now)}',
      LivePhase.question =>
        '¡Respondé ya! Pregunta ${view.questionNumber} · '
            '${secondsLeft(view.closesAt, now)} s',
      LivePhase.reveal =>
        'Pregunta ${view.questionNumber} de ${view.questionCount} · '
            'mirá cómo te fue',
      LivePhase.finished => 'Terminó la trivia · mirá quién ganó',
      _ => '',
    };
  }

  static String _action(LiveView view, LiveState live) => switch (view.phase) {
    LivePhase.countdown when view.questionNumber == 1 => 'SUMARME',
    LivePhase.question when live.myChoice == null => 'JUGAR',
    _ => 'VER',
  };
}

/// The app-bar mark that brings the banner back after it was closed.
class LiveAppBarButton extends StatelessWidget {
  const LiveAppBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    final live = LiveState.of(context);
    if (!live.isOn || !live.bannerDismissed) return const SizedBox.shrink();
    return Tooltip(
      message: 'Trivia en vivo',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          live.showBanner();
          LiveScreen.open(context);
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: LiveDot(),
        ),
      ),
    );
  }
}
