import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../state/app_state.dart';
import '../../state/live_state.dart';
import '../../theme.dart';
import '../../widgets/card_reveal.dart';
import '../../widgets/common.dart';
import '../../widgets/quiz_view.dart';
import '../../widgets/saint_card.dart';
import '../sign_in_screen.dart';
import 'live_widgets.dart';

/// The live trivia, from the lobby to the podium. It follows the stream on
/// its own: the host moves the game and this screen goes along.
class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LiveScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final live = LiveState.of(context);
    final view = live.view;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRIVIA EN VIVO'),
        actions: [
          if (live.isPlaying)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: LiveDot()),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey('${view?.phase}-${view?.questionNumber}'),
          child: switch (view?.phase) {
            null => const LoadingView(),
            LivePhase.countdown when view!.questionNumber == 1 => _Lobby(
              view: view,
            ),
            LivePhase.countdown => _GetReady(view: view!),
            LivePhase.question => _Question(view: view!),
            LivePhase.reveal => _Reveal(view: view!),
            LivePhase.finished => _Podium(view: view!),
            LivePhase.cancelled => const _Nothing(
              message: 'La trivia se canceló.',
            ),
            LivePhase.idle => const _Nothing(
              message:
                  'No hay ninguna trivia en este momento. Se juega en vivo '
                  'durante el programa: cuando empiece, te aparece un aviso '
                  'arriba en la app.',
            ),
          },
        ),
      ),
    );
  }
}

/// Before the first question: the card at stake, the countdown and the rules.
class _Lobby extends StatelessWidget {
  const _Lobby({required this.view});

  final LiveView view;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final live = LiveState.of(context);
    final signedIn = AppState.of(context).signedIn;
    final saint = view.saint;
    final fast = view.fastPrizes ?? 0;
    final raffle = view.rafflePrizes ?? 0;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      children: [
        const Center(child: Eyebrow('Empieza en')),
        const SizedBox(height: 6),
        Center(
          child: Ticking(
            builder: (_) => Text(
              clockText(view.countdownTo, live.serverNow),
              style: textTheme.displayMedium?.copyWith(color: Palette.gold),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            '${view.watching} '
            '${view.watching == 1 ? 'persona esperando' : 'personas esperando'}',
            style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
          ),
        ),
        const SizedBox(height: 24),
        if (saint != null) ...[
          Center(
            child: Transform.rotate(
              angle: -0.04,
              child: SaintCard(saint: saint, scores: null, width: 160),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'En juego: la carta de ${saint.name}',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(color: Palette.parchment),
            ),
          ),
        ],
        const SizedBox(height: 20),
        const Center(child: Ornament()),
        const SizedBox(height: 16),
        Text(
          '${view.questionCount} '
          '${view.questionCount == 1 ? 'pregunta' : 'preguntas'} de '
          '${view.questionSeconds} segundos. Acertar vale entre 500 y 1000 '
          'puntos: cuanto más rápido, más.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 8),
        Text(
          _prizesText(fast, raffle),
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
        ),
        if (!signedIn) ...[
          const SizedBox(height: 24),
          const SignInToPlay(),
        ],
      ],
    );
  }

  static String _prizesText(int fast, int raffle) {
    final parts = [
      if (fast > 0)
        fast == 1 ? 'el mejor puntaje' : 'los $fast mejores puntajes',
      if (raffle > 0)
        raffle == 1
            ? 'uno más por sorteo entre los que sumaron'
            : '$raffle más por sorteo entre los que sumaron',
    ];
    if (parts.isEmpty) return 'Esta vez se juega solo por el honor.';
    return 'Se llevan la carta ${parts.join(' y ')}. Si ya la tenés, te toca '
        'una que te falte.';
  }
}

/// The few seconds before each question after the first.
class _GetReady extends StatelessWidget {
  const _GetReady({required this.view});

  final LiveView view;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final live = LiveState.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Eyebrow('Pregunta ${view.questionNumber} de ${view.questionCount}'),
          const SizedBox(height: 12),
          Ticking(
            builder: (_) {
              final left = secondsLeft(view.countdownTo, live.serverNow);
              return Text(
                left > 0 ? '$left' : '¡Ya!',
                style: textTheme.displayLarge?.copyWith(color: Palette.gold),
              );
            },
          ),
          const SizedBox(height: 12),
          _StandingLine(me: view.me),
        ],
      ),
    );
  }
}

/// An open question with its clock.
class _Question extends StatelessWidget {
  const _Question({required this.view});

  final LiveView view;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final live = LiveState.of(context);
    final signedIn = AppState.of(context).signedIn;
    final choice = live.myChoice;
    final total = Duration(seconds: view.questionSeconds ?? 20);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        Ticking(
          builder: (_) {
            final left = view.closesAt == null
                ? Duration.zero
                : view.closesAt!.difference(live.serverNow);
            final fraction = (left.inMilliseconds / total.inMilliseconds).clamp(
              0.0,
              1.0,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Eyebrow(
                      'Pregunta ${view.questionNumber} de '
                      '${view.questionCount}',
                    ),
                    const Spacer(),
                    Text(
                      // The server closes it within a second; until then
                      // a frozen 0 would look broken.
                      secondsLeft(view.closesAt, live.serverNow) > 0
                          ? '${secondsLeft(view.closesAt, live.serverNow)}'
                          : '¡Tiempo!',
                      style: textTheme.titleLarge?.copyWith(
                        color: fraction < 0.25
                            ? Palette.crimsonLight
                            : Palette.gold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 6,
                    backgroundColor: Palette.inkLine,
                    color: fraction < 0.25
                        ? Palette.crimsonLight
                        : Palette.gold,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Ticking(
          builder: (_) {
            final timeUp =
                view.closesAt != null &&
                !live.serverNow.isBefore(view.closesAt!);
            return QuizView(
              question: view.question!,
              chosenIndex: choice,
              onAnswer: signedIn && choice == null && !timeUp
                  ? (i) => _answer(context, live, i)
                  : null,
              waitingMessage: choice != null
                  ? 'Listo. Esperá a que cierre la pregunta.'
                  : timeUp && signedIn
                  ? 'Se terminó el tiempo.'
                  : null,
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          '${view.answeredCount ?? 0} '
          '${view.answeredCount == 1 ? 'respondió' : 'respondieron'}',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
        ),
        if (!signedIn) ...[
          const SizedBox(height: 20),
          const SignInToPlay(),
        ],
      ],
    );
  }

  Future<void> _answer(BuildContext context, LiveState live, int index) async {
    try {
      await live.answer(index);
    } catch (e) {
      if (context.mounted) showMessage(context, friendlyError(e), error: true);
    }
  }
}

/// A closed question: the right answer, how everyone voted, and where the
/// player stands.
class _Reveal extends StatelessWidget {
  const _Reveal({required this.view});

  final LiveView view;

  @override
  Widget build(BuildContext context) {
    final live = LiveState.of(context);
    final last = view.questionNumber == view.questionCount;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        Eyebrow('Pregunta ${view.questionNumber} de ${view.questionCount}'),
        const SizedBox(height: 14),
        QuizView(
          question: view.question!,
          onAnswer: null,
          chosenIndex: live.myChoice,
          correctIndex: view.correctIndex,
        ),
        const SizedBox(height: 18),
        _Result(me: view.me),
        if (view.tally != null) ...[
          const SizedBox(height: 22),
          const Eyebrow('Cómo respondieron'),
          const SizedBox(height: 10),
          TallyBars(tally: view.tally!, correctIndex: view.correctIndex),
        ],
        if (view.leaderboard?.isNotEmpty ?? false) ...[
          const SizedBox(height: 22),
          const Eyebrow('Van ganando'),
          const SizedBox(height: 10),
          LiveLeaderboard(entries: view.leaderboard!, me: view.me),
        ],
        const SizedBox(height: 22),
        Text(
          last
              ? 'Esa fue la última. En un momento, el podio.'
              : 'En un momento, la próxima pregunta.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Palette.parchmentDim,
          ),
        ),
      ],
    );
  }
}

/// The end: the player's prize if they won, the podium and the winners.
class _Podium extends StatelessWidget {
  const _Podium({required this.view});

  final LiveView view;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final me = view.me;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        Center(
          child: Text(
            '¡Terminó la trivia!',
            style: textTheme.headlineSmall?.copyWith(color: Palette.gold),
          ),
        ),
        const SizedBox(height: 8),
        if (me?.wonSaintId != null) ...[
          Center(
            child: Text(
              '¡Ganaste una carta!',
              style: textTheme.titleMedium?.copyWith(
                color: Palette.goldLight,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Prize(saintId: me!.wonSaintId!),
        ] else if (me?.rank != null)
          Center(
            child: Text(
              'Hiciste ${me!.totalPoints} puntos y quedaste '
              '${me.rank}.º de ${me.players}.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge,
            ),
          ),
        const SizedBox(height: 20),
        const Center(child: Ornament()),
        if (view.fastWinners?.isNotEmpty ?? false) ...[
          const SizedBox(height: 20),
          const Eyebrow('Los más rápidos'),
          const SizedBox(height: 10),
          WinnerList(winners: view.fastWinners!),
        ],
        if (view.raffleWinners?.isNotEmpty ?? false) ...[
          const SizedBox(height: 20),
          const Eyebrow('Sorteo'),
          const SizedBox(height: 10),
          WinnerList(winners: view.raffleWinners!),
        ],
        if ((view.fastWinners?.isEmpty ?? true) &&
            (view.raffleWinners?.isEmpty ?? true)) ...[
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Esta vez nadie sumó puntos.',
              style: textTheme.bodyMedium?.copyWith(
                color: Palette.parchmentDim,
              ),
            ),
          ),
        ],
        if (view.leaderboard?.isNotEmpty ?? false) ...[
          const SizedBox(height: 20),
          const Eyebrow('Tabla final'),
          const SizedBox(height: 10),
          LiveLeaderboard(entries: view.leaderboard!, me: me),
        ],
      ],
    );
  }
}

/// The card the player won, with the new-card animation. The collection is
/// refreshed first: the card was granted on the server when the game ended.
class _Prize extends StatefulWidget {
  const _Prize({required this.saintId});

  final int saintId;

  @override
  State<_Prize> createState() => _PrizeState();
}

class _PrizeState extends State<_Prize> {
  CollectedCard? _card;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final state = AppState.of(context);
    try {
      await state.refreshCollection();
    } catch (_) {
      // Without network the card shows up on the next load anyway.
    }
    if (mounted) setState(() => _card = state.cardFor(widget.saintId));
  }

  @override
  Widget build(BuildContext context) {
    final card = _card;
    if (card == null) {
      return const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator(color: Palette.gold)),
      );
    }
    final width = min(200.0, MediaQuery.sizeOf(context).width * 0.5);
    return Center(
      child: CardReveal(card: card, width: width, revealed: true),
    );
  }
}

/// The player's result in the question that just closed.
class _Result extends StatelessWidget {
  const _Result({required this.me});

  final LiveMe? me;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final me = this.me;
    if (me == null) return const SizedBox.shrink();
    final (text, color) = switch (me.correct) {
      true => ('¡Bien! +${me.lastPoints ?? 0}', Palette.goldLight),
      false => ('Esta vez no.', Palette.crimsonLight),
      null => ('No llegaste a responder.', Palette.parchmentDim),
    };
    return Column(
      children: [
        Text(text, style: textTheme.titleLarge?.copyWith(color: color)),
        const SizedBox(height: 4),
        _StandingLine(me: me),
      ],
    );
  }
}

/// "Vas 12.º de 128 · 1650 puntos", or nothing before the first answer.
class _StandingLine extends StatelessWidget {
  const _StandingLine({required this.me});

  final LiveMe? me;

  @override
  Widget build(BuildContext context) {
    final me = this.me;
    if (me == null || me.rank == null) return const SizedBox.shrink();
    return Text(
      'Vas ${me.rank}.º de ${me.players} · ${me.totalPoints} puntos',
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: Palette.parchmentDim),
    );
  }
}

class _Nothing extends StatelessWidget {
  const _Nothing({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.podcasts_rounded,
              size: 40,
              color: Palette.parchmentDim,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Palette.parchmentDim,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The invitation in place of the options for viewers without an account.
class SignInToPlay extends StatelessWidget {
  const SignInToPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Para responder y ganar la carta necesitás una cuenta.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => SignInScreen.open(context),
              child: const Text('INGRESÁ PARA PARTICIPAR'),
            ),
          ],
        ),
      ),
    );
  }
}
