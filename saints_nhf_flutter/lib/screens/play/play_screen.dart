import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import '../../utils/feast.dart';
import '../../widgets/common.dart';
import 'deck_picker_screen.dart';
import 'duel_screen.dart';
import 'guess_score_screen.dart';

/// Hub of the games: duels, solo games and the list of ongoing duels.
class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool _creating = false;

  Future<void> _duelMachine() async {
    final deck = await DeckPickerScreen.open(
      context,
      title: 'Tu mazo',
      subtitle:
          'La app te reparte ocho cartas de tu álbum y elegís cinco. '
          'Los puntajes del Sacristán están ocultos hasta el final de cada ronda.',
    );
    if (deck == null || !mounted) return;
    setState(() => _creating = true);
    // The board is opened right away with a waiting screen, so a slow server
    // never leaves the player looking at the tab wondering what happened.
    await DuelScreen.openCreating(
      context,
      create: () => client.duel.createVsMachine(deck),
      waitingTitle: 'Preparando el duelo',
      waitingSubtitle: 'El Sacristán está eligiendo sus cartas.',
    );
    if (mounted) {
      setState(() => _creating = false);
      await AppState.of(context).refreshDuels();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final textTheme = Theme.of(context).textTheme;
    final duels = state.duels ?? const <DuelSummary>[];
    final open = duels
        .where(
          (d) =>
              d.status == DuelStatus.active ||
              d.status == DuelStatus.pendingDeck,
        )
        .toList();
    final done = duels.where((d) => d.status == DuelStatus.finished).toList();

    return RefreshIndicator(
      color: Palette.gold,
      backgroundColor: Palette.inkRaised,
      onRefresh: state.refreshDuels,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          _GameTile(
            icon: Icons.smart_toy_outlined,
            title: 'Duelo contra El Sacristán',
            subtitle:
                'Cinco cartas, categorías a elección y una pregunta por '
                'carta. Practicá antes de desafiar a un amigo.',
            onTap: _creating ? null : _duelMachine,
          ),
          const SizedBox(height: 10),
          _GameTile(
            icon: Icons.group_outlined,
            title: 'Desafiar a un amigo',
            subtitle:
                'Un duelo por turnos: jugás cuando podés y te avisamos '
                'cuando es tu turno. Se arranca desde la pestaña Amigos.',
            onTap: () => showMessage(
              context,
              'Elegí un amigo en la pestaña Amigos y tocá el ícono de duelo.',
            ),
          ),
          const SizedBox(height: 10),
          _GameTile(
            icon: Icons.psychology_alt_outlined,
            title: 'Adivinar el puntaje',
            subtitle:
                'Te mostramos una carta tapada y tenés que decir cuál es '
                'su categoría más alta.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GuessScoreScreen()),
            ),
          ),
          const SizedBox(height: 28),
          if (open.isNotEmpty) ...[
            const Eyebrow('Duelos en curso'),
            const SizedBox(height: 10),
            for (final d in open) _DuelTile(duel: d),
            const SizedBox(height: 20),
          ],
          if (done.isNotEmpty) ...[
            const Eyebrow('Terminados'),
            const SizedBox(height: 10),
            for (final d in done.take(10)) _DuelTile(duel: d),
          ],
          if (duels.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Todavía no jugaste ningún duelo.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Palette.goldDark),
                ),
                child: Icon(icon, color: Palette.gold),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: Palette.parchmentDim,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Palette.parchmentDim,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DuelTile extends StatelessWidget {
  const _DuelTile({required this.duel});

  final DuelSummary duel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final d = duel;
    final String status;
    final Color color;
    if (d.status == DuelStatus.finished) {
      status = d.winnerIsMe == null
          ? 'Empate'
          : d.winnerIsMe!
          ? 'Ganaste'
          : 'Perdiste';
      color = d.winnerIsMe == true ? Palette.gold : Palette.parchmentDim;
    } else if (d.status == DuelStatus.pendingDeck) {
      status = d.isMyTurn ? 'Te desafiaron' : 'Esperando aceptación';
      color = d.isMyTurn ? Palette.crimsonLight : Palette.parchmentDim;
    } else {
      status = d.isMyTurn ? 'Tu turno' : 'Turno rival';
      color = d.isMyTurn ? Palette.goldLight : Palette.parchmentDim;
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => DuelScreen.open(context, d.duelId),
        leading: Icon(
          d.isVsMachine
              ? Icons.smart_toy_outlined
              : Icons.person_outline_rounded,
          color: Palette.gold,
        ),
        title: Text('vs ${d.opponentName}', style: textTheme.titleMedium),
        subtitle: Text(
          '${d.myScore} · ${d.opponentScore}  ·  ${dateTimeShort(d.updatedAt)}',
          style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
        ),
        trailing: Text(
          status.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(color: color),
        ),
      ),
    );
  }
}
