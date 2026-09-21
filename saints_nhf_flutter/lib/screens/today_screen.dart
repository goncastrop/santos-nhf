import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../utils/feast.dart';
import '../widgets/card_reveal.dart';
import '../widgets/common.dart';
import '../widgets/daily_quiz_card.dart';
import '../widgets/patch_notes.dart';
import '../widgets/saint_card.dart';
import 'saint_detail_screen.dart';

/// The daily card: claim it, see it, and glance at the collection.
class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  bool _claiming = false;
  bool _revealed = false;
  CollectedCard? _justClaimed;

  bool _starterScheduled = false;
  String? _day;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // After midnight the card claimed yesterday is no longer today's card.
    final day = AppState.of(context).day;
    if (_day != null && _day != day) {
      _justClaimed = null;
      _revealed = false;
    }
    _day = day;
    // Runs whenever AppState notifies; the starter cards arrive with the
    // first successful load, which may happen after this screen is built.
    _maybeShowStarter();
  }

  void _maybeShowStarter() {
    final state = AppState.of(context);
    if (_starterScheduled || state.pendingStarterCards.isEmpty) return;
    _starterScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cards = state.pendingStarterCards;
      state.consumeStarterCards();
      _starterScheduled = false;
      if (cards.isEmpty) return;
      showDialog<void>(
        context: context,
        builder: (_) => _StarterPackDialog(cards: cards),
      );
    });
  }

  Future<void> _claim() async {
    final state = AppState.of(context);
    setState(() => _claiming = true);
    try {
      final result = await state.claimDaily();
      if (!mounted) return;
      setState(() {
        _justClaimed = result.card;
        _revealed = true;
      });
      if (result.isFeastDay) {
        showMessage(
          context,
          '¡Hoy es la fiesta de ${result.card.saint.name}!',
        );
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  Future<void> _redeem() async {
    final state = AppState.of(context);
    final code = await showDialog<String>(
      context: context,
      builder: (_) => const _RedeemDialog(),
    );
    if (code == null || code.trim().isEmpty || !mounted) return;
    try {
      final card = await state.redeem(code);
      if (!mounted) return;
      setState(() {
        _justClaimed = card;
        _revealed = true;
      });
      showMessage(context, '¡Desbloqueaste a ${card.saint.name}!');
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final overview = state.overview;
    final textTheme = Theme.of(context).textTheme;
    if (overview == null) return const LoadingView();

    final todayCard = _justClaimed ?? overview.todayCard;
    final saintsOfToday = state.saintsOfToday(nowInArgentina());
    final cardWidth = (MediaQuery.sizeOf(context).width - 48).clamp(
      200.0,
      260.0,
    );

    return RefreshIndicator(
      color: Palette.gold,
      backgroundColor: Palette.inkRaised,
      onRefresh: state.loadAll,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Center(child: Text(todayLong(), style: textTheme.bodyMedium)),
          const SizedBox(height: 6),
          if (saintsOfToday.isNotEmpty) ...[
            Center(
              child: Text(
                'Hoy la Iglesia celebra a '
                '${saintsOfToday.map((s) => s.name).join(' y ')}',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: Palette.goldLight,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Center(
            child: todayCard != null
                ? _RevealedCard(
                    card: todayCard,
                    width: cardWidth,
                    revealed: _justClaimed == null || _revealed,
                    animate: _justClaimed != null,
                  )
                : overview.canClaimToday
                ? _ClaimCard(
                    width: cardWidth,
                    claiming: _claiming,
                    onClaim: _claim,
                  )
                : _AlbumComplete(width: cardWidth),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: _redeem,
              icon: const Icon(Icons.qr_code_2_rounded, size: 18),
              label: const Text('Tengo un código del programa'),
            ),
          ),
          const SizedBox(height: 20),
          AlbumProgress(
            owned: overview.cards.length,
            total: overview.totalPublished,
          ),
          const SizedBox(height: 24),
          const DailyQuizCard(),
          const SizedBox(height: 24),
          if (overview.cards.isNotEmpty) ...[
            const Eyebrow('Últimas cartas'),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: overview.cards.length.clamp(0, 10),
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final card = overview.cards[i];
                  return GestureDetector(
                    onTap: () => SaintDetailScreen.open(context, card.saint.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SaintCard(
                        saint: card.saint,
                        scores: card.scores,
                        width: 115,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          if (state.patchNotes != null && state.patchNotes!.isNotEmpty) ...[
            const SizedBox(height: 24),
            PatchNotes(entries: state.patchNotes!),
          ],
        ],
      ),
    );
  }
}

class _RedeemDialog extends StatefulWidget {
  const _RedeemDialog();

  @override
  State<_RedeemDialog> createState() => _RedeemDialogState();
}

class _RedeemDialogState extends State<_RedeemDialog> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Código del programa'),
      content: TextField(
        controller: _code,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(hintText: 'Ej.: NHF-2026'),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _code.text),
          child: const Text('CANJEAR'),
        ),
      ],
    );
  }
}

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({
    required this.width,
    required this.claiming,
    required this.onClaim,
  });

  final double width;
  final bool claiming;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Eyebrow('Carta del día'),
        const SizedBox(height: 16),
        _Breathing(child: SaintCardBack(width: width)),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: claiming ? null : onClaim,
          icon: claiming
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_awesome_rounded),
          label: const Text('REVELAR LA CARTA DE HOY'),
        ),
        const SizedBox(height: 8),
        Text(
          'Una carta nueva por día. Si hoy es la fiesta de un santo, es la suya.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Palette.parchmentDim,
          ),
        ),
      ],
    );
  }
}

class _RevealedCard extends StatelessWidget {
  const _RevealedCard({
    required this.card,
    required this.width,
    required this.revealed,
    required this.animate,
  });

  final CollectedCard card;
  final double width;
  final bool revealed;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final front = SaintCard(
      saint: card.saint,
      scores: card.scores,
      width: width,
    );
    return Column(
      children: [
        const Eyebrow('Tu carta de hoy'),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => SaintDetailScreen.open(context, card.saint.id),
          child: animate
              ? CardReveal(card: card, width: width, revealed: revealed)
              : front,
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => SaintDetailScreen.open(context, card.saint.id),
          icon: const Icon(Icons.auto_stories_outlined, size: 18),
          label: const Text('CONOCER SU VIDA'),
        ),
      ],
    );
  }
}

class _AlbumComplete extends StatelessWidget {
  const _AlbumComplete({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const Eyebrow('Álbum completo'),
        const SizedBox(height: 16),
        SaintCardBack(width: width, dimmed: true),
        const SizedBox(height: 16),
        Text(
          'Tenés todas las cartas publicadas. '
          'Cuando el programa presente un santo nuevo, aparecerá acá.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: Palette.parchmentDim),
        ),
      ],
    );
  }
}

/// Slow scale pulse to invite the tap.
class _Breathing extends StatefulWidget {
  const _Breathing({required this.child});

  final Widget child;

  @override
  State<_Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<_Breathing>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Transform.scale(scale: 0.97 + t * 0.03, child: child);
      },
      child: widget.child,
    );
  }
}

class _StarterPackDialog extends StatelessWidget {
  const _StarterPackDialog({required this.cards});

  final List<CollectedCard> cards;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Eyebrow('Bienvenido'),
            const SizedBox(height: 8),
            Text('Tu mazo inicial', style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Estas ${cards.length} cartas ya son tuyas. '
                'Desde mañana, una nueva por día.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 310,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: cards.length,
                separatorBuilder: (_, _) => const SizedBox(width: 0),
                itemBuilder: (context, i) => CardReveal(
                  card: cards[i],
                  width: 150,
                  revealed: true,
                  delay: Duration(milliseconds: 250 * i),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('¡A COLECCIONAR!'),
            ),
          ],
        ),
      ),
    );
  }
}
