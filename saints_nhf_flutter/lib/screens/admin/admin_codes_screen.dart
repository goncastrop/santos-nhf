import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import '../../utils/feast.dart';
import '../../widgets/common.dart';

/// Unlock codes handed out during the stream.
class AdminCodesScreen extends StatefulWidget {
  const AdminCodesScreen({super.key});

  @override
  State<AdminCodesScreen> createState() => _AdminCodesScreenState();
}

class _AdminCodesScreenState extends State<AdminCodesScreen> {
  List<UnlockCode>? _codes;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final codes = await client.adminCodes.list();
      if (mounted) {
        setState(() {
          _codes = codes;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _create() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => const _CodeDialog(),
    );
    if (created == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final catalog = AppState.of(context).catalog ?? const <SaintInfo>[];
    final nameById = {for (final s in catalog) s.id: s.name};
    return Scaffold(
      appBar: AppBar(title: const Text('CÓDIGOS')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Palette.gold,
        foregroundColor: Palette.ink,
        onPressed: _create,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo código'),
      ),
      body: _error != null
          ? ErrorView(error: _error!, onRetry: _load)
          : _codes == null
          ? const LoadingView()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                Text(
                  'Los códigos se reparten en el programa. Cada persona puede '
                  'canjear un código una sola vez.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                ),
                const SizedBox(height: 16),
                for (final c in _codes!)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        c.active
                            ? Icons.qr_code_2_rounded
                            : Icons.block_rounded,
                        color: c.active ? Palette.gold : Palette.parchmentDim,
                      ),
                      title: Text(
                        c.code,
                        style: textTheme.titleMedium?.copyWith(
                          letterSpacing: 2,
                        ),
                      ),
                      subtitle: Text(
                        [
                          c.saintId == null
                              ? 'Carta al azar'
                              : nameById[c.saintId] ?? 'Santo ${c.saintId}',
                          '${c.uses}${c.maxUses == null ? '' : ' de ${c.maxUses}'} usos',
                          if (c.expiresAt != null)
                            'vence ${dateTimeShort(c.expiresAt!)}',
                          if (c.note != null) c.note!,
                        ].join(' · '),
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                      trailing: Switch(
                        value: c.active,
                        onChanged: (v) async {
                          try {
                            await client.adminCodes.setActive(c.id!, v);
                            await _load();
                          } catch (e) {
                            if (context.mounted) {
                              showMessage(
                                context,
                                friendlyError(e),
                                error: true,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                if (_codes!.isEmpty)
                  Text(
                    'Todavía no hay códigos.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Palette.parchmentDim,
                    ),
                  ),
              ],
            ),
    );
  }
}

class _CodeDialog extends StatefulWidget {
  const _CodeDialog();

  @override
  State<_CodeDialog> createState() => _CodeDialogState();
}

class _CodeDialogState extends State<_CodeDialog> {
  final _code = TextEditingController();
  final _maxUses = TextEditingController();
  final _note = TextEditingController();
  int? _saintId;
  DateTime? _expires;
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    _maxUses.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await client.adminCodes.create(
        _code.text,
        _saintId,
        int.tryParse(_maxUses.text.trim()),
        _expires,
        _note.text,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = AppState.of(context).catalog ?? const <SaintInfo>[];
    return AlertDialog(
      title: const Text('Nuevo código'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _code,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Código (vacío = generar uno)',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: _saintId,
                dropdownColor: Palette.inkRaised,
                decoration: const InputDecoration(labelText: 'Carta'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Al azar entre las que falten'),
                  ),
                  for (final s in catalog)
                    DropdownMenuItem(value: s.id, child: Text(s.name)),
                ],
                onChanged: (v) => setState(() => _saintId = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _maxUses,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Usos máximos (vacío = sin límite)',
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                  );
                  if (picked != null) {
                    setState(
                      () => _expires = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        23,
                        59,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.event_outlined, size: 18),
                label: Text(
                  _expires == null
                      ? 'SIN VENCIMIENTO'
                      : 'VENCE ${dateTimeShort(_expires!).toUpperCase()}',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _note,
                decoration: const InputDecoration(labelText: 'Nota interna'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: const Text('CREAR'),
        ),
      ],
    );
  }
}
