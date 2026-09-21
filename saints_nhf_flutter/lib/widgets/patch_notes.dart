import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../screens/saint_detail_screen.dart';
import '../theme.dart';
import '../utils/feast.dart';
import '../utils/scores.dart';
import 'common.dart';

/// Recent score changes ("notas del parche").
class PatchNotes extends StatelessWidget {
  const PatchNotes({super.key, required this.entries});

  final List<PatchNoteEntry> entries;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Notas del parche'),
        const SizedBox(height: 4),
        Text(
          'Ajustes recientes en los puntajes.',
          style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
        ),
        const SizedBox(height: 12),
        for (final e in entries.take(6)) ...[
          Card(
            child: InkWell(
              onTap: () => SaintDetailScreen.open(context, e.saint.id),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.saint.name,
                            style: textTheme.titleMedium?.copyWith(
                              color: Palette.parchment,
                            ),
                          ),
                        ),
                        Text(
                          dateTimeShort(e.changedAt).split(',').first,
                          style: textTheme.labelSmall,
                        ),
                      ],
                    ),
                    if (e.note != null && e.note!.isNotEmpty)
                      Text(
                        e.note!,
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        for (final c in e.changes)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: c.increased
                                    ? Palette.goldDark
                                    : Palette.crimson,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  c.increased
                                      ? Icons.arrow_upward_rounded
                                      : Icons.arrow_downward_rounded,
                                  size: 12,
                                  color: c.increased
                                      ? Palette.gold
                                      : Palette.crimsonLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  c.from == null
                                      ? c.category.label
                                      : '${c.category.label} ${c.from} a ${c.to}',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: Palette.parchment,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
