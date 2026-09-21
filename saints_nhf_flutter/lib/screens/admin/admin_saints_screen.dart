import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../theme.dart';
import '../../utils/feast.dart';
import '../../utils/scores.dart';
import '../../widgets/common.dart';
import 'admin_saint_edit_screen.dart';

/// Admin list of every saint, drafts included.
class AdminSaintsScreen extends StatefulWidget {
  const AdminSaintsScreen({super.key});

  @override
  State<AdminSaintsScreen> createState() => _AdminSaintsScreenState();
}

class _AdminSaintsScreenState extends State<AdminSaintsScreen> {
  List<Saint>? _saints;
  Object? _error;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final saints = await client.adminSaint.listAll();
      if (!mounted) return;
      setState(() {
        _saints = saints;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<void> _edit(int? saintId) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AdminSaintEditScreen(saintId: saintId),
      ),
    );
    // Always refresh: the edit screen may have saved, uploaded or deleted.
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('SANTOS · ADMIN')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Palette.gold,
        foregroundColor: Palette.ink,
        onPressed: () => _edit(null),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo santo'),
      ),
      body: Builder(
        builder: (context) {
          if (_error != null) {
            return ErrorView(error: _error!, onRetry: _load);
          }
          final saints = _saints;
          if (saints == null) return const LoadingView();
          final q = _filter.toLowerCase();
          final visible = saints
              .where((s) => q.isEmpty || s.name.toLowerCase().contains(q))
              .toList();
          final published = saints
              .where((s) => s.status == SaintStatus.published)
              .length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _filter = v),
                  decoration: const InputDecoration(
                    hintText: 'Filtrar por nombre',
                    prefixIcon: Icon(Icons.search_rounded, color: Palette.gold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Eyebrow(
                      '${saints.length} santos · $published publicados',
                      color: Palette.parchmentDim,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final s = visible[i];
                    final isDraft = s.status == SaintStatus.draft;
                    return Card(
                      child: ListTile(
                        onTap: () => _edit(s.id),
                        leading: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDraft
                                ? Palette.parchmentDim
                                : Palette.gold,
                          ),
                        ),
                        title: Text(s.name, style: textTheme.titleMedium),
                        subtitle: Text(
                          [
                            isDraft ? 'Borrador' : 'Publicado',
                            'Media ${overallOf(scoresOfSaint(s))}',
                            if (feastLong(s.feastMonth, s.feastDay) != null)
                              feastLong(s.feastMonth, s.feastDay)!,
                            if (s.season != null && s.episode != null)
                              'T${s.season} · Cap. ${s.episode}',
                            if (s.illustrationPath == null) 'sin ilustración',
                          ].join(' · '),
                          style: textTheme.bodySmall?.copyWith(
                            color: Palette.parchmentDim,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
