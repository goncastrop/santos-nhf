import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import '../../utils/feast.dart';
import '../../utils/scores.dart';
import '../../widgets/common.dart';

/// Change history of a saint, with the option to restore a previous state.
class AdminRevisionsScreen extends StatefulWidget {
  const AdminRevisionsScreen({super.key, required this.saintId});

  final int saintId;

  @override
  State<AdminRevisionsScreen> createState() => _AdminRevisionsScreenState();
}

class _AdminRevisionsScreenState extends State<AdminRevisionsScreen> {
  late Future<_History> _future = _load();

  Future<_History> _load() async {
    final results = await Future.wait<Object>([
      client.adminSaint.get(widget.saintId),
      client.adminSaint.revisions(widget.saintId),
    ]);
    return _History(
      current: results[0] as Saint,
      revisions: results[1] as List<SaintRevision>,
    );
  }

  Future<void> _restore(SaintRevision revision) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar revisión'),
        content: Text(
          'El santo vuelve al estado del ${dateTimeShort(revision.createdAt)}. '
          'El estado actual se guarda como una revisión nueva.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('RESTAURAR'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final restored = await client.adminSaint.restore(revision.id!, null);
      if (!mounted) return;
      final state = AppState.of(context);
      await Future.wait([state.refreshCatalog(), state.refreshCollection()]);
      if (mounted) Navigator.of(context).pop(restored);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('HISTORIAL')),
      body: FutureBuilder<_History>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorView(
              error: snapshot.error!,
              onRetry: () => setState(() => _future = _load()),
            );
          }
          final history = snapshot.data;
          if (history == null) return const LoadingView();
          final current = history.current;
          final revisions = history.revisions;
          if (revisions.isEmpty) {
            return Center(
              child: Text(
                'Todavía no hay cambios guardados para ${current.name}.',
                style: textTheme.bodyMedium?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: revisions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final r = revisions[i];
              final snap = Saint.fromJson(
                jsonDecode(r.snapshotJson) as Map<String, dynamic>,
              );
              final diffs = _diff(snap, current);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              r.note?.isNotEmpty == true ? r.note! : 'Sin nota',
                              style: textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            dateTimeShort(r.createdAt),
                            style: textTheme.labelSmall,
                          ),
                        ],
                      ),
                      if (r.changedByEmail != null)
                        Text(
                          'por ${r.changedByEmail}',
                          style: textTheme.bodySmall?.copyWith(
                            color: Palette.parchmentDim,
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        diffs.isEmpty
                            ? 'Igual al estado actual.'
                            : 'Diferencias con el estado actual:',
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                      for (final d in diffs)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('• $d', style: textTheme.bodySmall),
                        ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: diffs.isEmpty ? null : () => _restore(r),
                          icon: const Icon(Icons.restore_rounded, size: 18),
                          label: const Text('RESTAURAR'),
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
    );
  }

  /// Human-readable differences between a snapshot and the current saint.
  List<String> _diff(Saint snap, Saint current) {
    final out = <String>[];
    void field(String label, Object? a, Object? b) {
      if (a != b) out.add('$label: de ${a ?? 'vacío'} a ${b ?? 'vacío'}');
    }

    field('Nombre', snap.name, current.name);
    field('Slug', snap.slug, current.slug);
    field('Título', snap.title, current.title);
    field(
      'Fiesta',
      feastLong(snap.feastMonth, snap.feastDay),
      feastLong(current.feastMonth, current.feastDay),
    );
    field('Temporada', snap.season, current.season);
    field('Capítulo', snap.episode, current.episode);
    field('Link', snap.youtubeUrl, current.youtubeUrl);
    field('Estado', snap.status.name, current.status.name);
    if (snap.bio != current.bio) out.add('Biografía modificada');
    if (snap.prayer != current.prayer) out.add('Oración modificada');
    final a = scoresOfSaint(snap);
    final b = scoresOfSaint(current);
    for (final c in ScoreCategory.values) {
      field(c.label, c.of(a), c.of(b));
    }
    return out;
  }
}

class _History {
  const _History({required this.current, required this.revisions});

  final Saint current;
  final List<SaintRevision> revisions;
}
