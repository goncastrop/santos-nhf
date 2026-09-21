import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../play/deck_picker_screen.dart';
import '../play/duel_screen.dart';
import 'friend_collection_screen.dart';

/// Friend code, friends list, challenges and rankings.
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<FriendSummary>? _friends;
  Leaderboard? _board;
  Object? _error;
  final _code = TextEditingController();
  bool _busy = false;

  String? _statsKey;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Rankings depend on my own stats: reload when they change.
    final p = AppState.of(context).profile;
    final key = p == null
        ? null
        : '${p.cards}-${p.streak}-${p.bestStreak}-${p.duelsWon}';
    if (_statsKey != null && key != _statsKey) _load();
    _statsKey = key;
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait<Object>([
        client.friends.list(),
        client.leaderboard.top(),
      ]);
      if (!mounted) return;
      setState(() {
        _friends = results[0] as List<FriendSummary>;
        _board = results[1] as Leaderboard;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _add() async {
    final code = _code.text.trim();
    if (code.isEmpty) return;
    setState(() => _busy = true);
    try {
      final friend = await client.friends.addByCode(code);
      _code.clear();
      await _load();
      if (mounted) {
        showMessage(context, '${friend.displayName} ya es tu amigo.');
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _rename() async {
    final state = AppState.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _NameDialog(initial: state.profile?.displayName ?? ''),
    );
    if (name == null || !mounted) return;
    try {
      await client.friends.setDisplayName(name);
      await state.refreshProfile();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  Future<void> _challenge(FriendSummary friend) async {
    final deck = await DeckPickerScreen.open(
      context,
      title: 'Desafiar a ${friend.displayName}',
      subtitle:
          'Elegí cinco de las cartas repartidas. ${friend.displayName} '
          'arma su mazo cuando acepte.',
    );
    if (deck == null || !mounted) return;
    await DuelScreen.openCreating(
      context,
      create: () => client.duel.challenge(friend.authUserId, deck),
      waitingTitle: 'Enviando el desafío',
      waitingSubtitle: 'Avisamos a ${friend.displayName} que lo esperás.',
    );
    if (mounted) await AppState.of(context).refreshDuels();
  }

  Future<void> _remove(FriendSummary friend) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitar amigo'),
        content: Text('¿Sacar a ${friend.displayName} de tu lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('QUITAR'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await client.friends.remove(friend.authUserId);
      await _load();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final textTheme = Theme.of(context).textTheme;
    final profile = state.profile;
    return RefreshIndicator(
      color: Palette.gold,
      backgroundColor: Palette.inkRaised,
      onRefresh: () async {
        await Future.wait([_load(), state.refreshProfile()]);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          if (profile != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.displayName,
                            style: textTheme.headlineSmall,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Cambiar nombre',
                          onPressed: _rename,
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Palette.gold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${profile.cards} cartas · racha ${profile.streak} '
                      '· ${profile.duelsWon} de ${profile.duelsPlayed} duelos ganados',
                      style: textTheme.bodySmall?.copyWith(
                        color: Palette.parchmentDim,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Eyebrow('Tu código de amigo'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          profile.friendCode,
                          style: textTheme.displaySmall?.copyWith(
                            color: Palette.goldLight,
                            letterSpacing: 6,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Copiar',
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: profile.friendCode),
                            );
                            showMessage(context, 'Código copiado.');
                          },
                          icon: const Icon(Icons.copy_rounded, size: 18),
                        ),
                      ],
                    ),
                    Text(
                      'Compartilo con quien quieras sumar. Con tu código te '
                      'agregan al instante.',
                      style: textTheme.bodySmall?.copyWith(
                        color: Palette.parchmentDim,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _code,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'Código de un amigo',
                    prefixIcon: Icon(
                      Icons.person_add_alt_1_outlined,
                      color: Palette.gold,
                    ),
                  ),
                  onSubmitted: (_) => _add(),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: _busy ? null : _add,
                child: const Text('SUMAR'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Eyebrow('Tus amigos'),
          const SizedBox(height: 10),
          if (_error != null)
            ErrorView(error: _error!, onRetry: _load)
          else if (_friends == null)
            const LoadingView()
          else if (_friends!.isEmpty)
            Text(
              'Todavía no sumaste amigos. Pediles su código o compartí el tuyo.',
              style: textTheme.bodyMedium?.copyWith(
                color: Palette.parchmentDim,
              ),
            )
          else
            for (final f in _friends!)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FriendCollectionScreen(friend: f),
                    ),
                  ),
                  leading: const Icon(
                    Icons.person_outline_rounded,
                    color: Palette.gold,
                  ),
                  title: Text(f.displayName, style: textTheme.titleMedium),
                  subtitle: Text(
                    '${f.cards} cartas · racha ${f.streak} · ${f.duelsWon} duelos ganados',
                    style: textTheme.bodySmall?.copyWith(
                      color: Palette.parchmentDim,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Desafiar',
                        onPressed: () => _challenge(f),
                        icon: const Icon(
                          Icons.sports_esports_outlined,
                          color: Palette.goldLight,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Quitar',
                        onPressed: () => _remove(f),
                        icon: const Icon(
                          Icons.person_remove_outlined,
                          color: Palette.parchmentDim,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 24),
          if (_board != null) _Rankings(board: _board!),
        ],
      ),
    );
  }
}

class _Rankings extends StatelessWidget {
  const _Rankings({required this.board});

  final Leaderboard board;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget table(
      String title,
      List<LeaderboardEntry> entries,
      String unit,
    ) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow(title),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          Text(
            'Sin datos todavía.',
            style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
          )
        else
          Card(
            child: Column(
              children: [
                for (final (i, e) in entries.take(10).indexed)
                  ListTile(
                    dense: true,
                    leading: Text(
                      '${i + 1}',
                      style: textTheme.titleMedium?.copyWith(
                        color: i == 0
                            ? Palette.goldLight
                            : Palette.parchmentDim,
                      ),
                    ),
                    title: Text(
                      e.displayName,
                      style: textTheme.bodyMedium?.copyWith(
                        color: e.isMe ? Palette.goldLight : Palette.parchment,
                        fontWeight: e.isMe ? FontWeight.w800 : null,
                      ),
                    ),
                    subtitle: e.isFriend
                        ? Text('amigo', style: textTheme.labelSmall)
                        : null,
                    trailing: Text(
                      '${e.value} $unit',
                      style: textTheme.labelLarge?.copyWith(
                        color: Palette.parchment,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        table('Ranking · álbum', board.byCards, 'cartas'),
        table('Ranking · mejor racha', board.byStreak, 'días'),
        table('Ranking · duelos ganados', board.byDuelsWon, 'duelos'),
      ],
    );
  }
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initial});

  final String initial;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final _name = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tu nombre'),
      content: TextField(
        controller: _name,
        autofocus: true,
        maxLength: 24,
        decoration: const InputDecoration(hintText: 'Cómo te ven tus amigos'),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _name.text),
          child: const Text('GUARDAR'),
        ),
      ],
    );
  }
}
