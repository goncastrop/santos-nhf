import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../theme.dart';
import '../../utils/scores.dart';
import '../../utils/years.dart';
import '../../widgets/common.dart';

/// The saints [saint] met in life. Each change is saved right away and shows
/// on the ficha of both, so it does not wait for the saint's own form.
class AdminMeetingsScreen extends StatefulWidget {
  const AdminMeetingsScreen({super.key, required this.saint});

  final Saint saint;

  @override
  State<AdminMeetingsScreen> createState() => _AdminMeetingsScreenState();
}

class _AdminMeetingsScreenState extends State<AdminMeetingsScreen> {
  List<Saint>? _met;
  Object? _error;
  bool _busy = false;

  int get _id => widget.saint.id!;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final met = await client.adminMeeting.listFor(_id);
      if (mounted) {
        setState(() {
          _met = met;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _add() async {
    setState(() => _busy = true);
    try {
      final all = await client.adminSaint.listAll();
      if (!mounted) return;
      final taken = {_id, for (final s in _met ?? const <Saint>[]) s.id};
      final picked = await showDialog<Saint>(
        context: context,
        builder: (_) => _SaintPicker(
          candidates: [
            for (final s in all)
              if (!taken.contains(s.id)) s,
          ],
        ),
      );
      if (picked == null) return;
      final met = await client.adminMeeting.add(_id, picked.id!);
      if (mounted) setState(() => _met = met);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(Saint other) async {
    setState(() => _busy = true);
    try {
      final met = await client.adminMeeting.remove(_id, other.id!);
      if (mounted) setState(() => _met = met);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final met = _met;
    return Scaffold(
      appBar: AppBar(title: const Text('SE CONOCIÓ CON')),
      floatingActionButton: met == null
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Palette.gold,
              foregroundColor: Palette.ink,
              onPressed: _busy ? null : _add,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Agregar'),
            ),
      body: _error != null
          ? ErrorView(error: _error!, onRetry: _load)
          : met == null
          ? const LoadingView()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                Text(widget.saint.name, style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Los santos con los que se conoció en vida. Cada uno '
                  'aparece en la ficha del otro, y en la app solo se ven los '
                  'publicados. Si no hay nadie, la ficha no muestra la '
                  'sección.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                ),
                const SizedBox(height: 16),
                if (met.isEmpty)
                  Text(
                    'Todavía no hay nadie cargado.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Palette.parchmentDim,
                    ),
                  ),
                for (final other in met)
                  Card(
                    child: ListTile(
                      title: Text(other.name),
                      subtitle: Text(_subtitle(other)),
                      trailing: IconButton(
                        tooltip: 'Quitar',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: _busy ? null : () => _remove(other),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// "1910 – 1997 · Borrador", skipping what is missing.
String _subtitle(Saint saint) => [
  ?lifespanLabel(infoOfSaint(saint)),
  if (saint.status == SaintStatus.draft) 'Borrador',
].join(' · ');

/// Picks one saint of [candidates], searching by name.
class _SaintPicker extends StatefulWidget {
  const _SaintPicker({required this.candidates});

  final List<Saint> candidates;

  @override
  State<_SaintPicker> createState() => _SaintPickerState();
}

class _SaintPickerState extends State<_SaintPicker> {
  String _query = '';

  static String _normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp('[áàä]'), 'a')
      .replaceAll(RegExp('[éèë]'), 'e')
      .replaceAll(RegExp('[íìï]'), 'i')
      .replaceAll(RegExp('[óòö]'), 'o')
      .replaceAll(RegExp('[úùü]'), 'u');

  @override
  Widget build(BuildContext context) {
    final query = _normalize(_query.trim());
    final shown = [
      for (final s in widget.candidates)
        if (query.isEmpty || _normalize(s.name).contains(query)) s,
    ];
    return AlertDialog(
      title: const Text('¿Con quién se conoció?'),
      content: SizedBox(
        width: 420,
        height: 440,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: shown.isEmpty
                  ? const Center(child: Text('Nadie con ese nombre.'))
                  : ListView(
                      children: [
                        for (final s in shown)
                          ListTile(
                            title: Text(s.name),
                            subtitle: Text(_subtitle(s)),
                            onTap: () => Navigator.of(context).pop(s),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
