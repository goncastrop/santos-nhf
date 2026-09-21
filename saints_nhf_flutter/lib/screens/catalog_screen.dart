import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../utils/feast.dart';
import '../widgets/common.dart';
import '../widgets/saint_illustration.dart';
import 'saint_detail_screen.dart';

/// Ways of ordering the catalog list.
enum _Sort {
  name('Por nombre', 'A–Z'),
  feast('Por fecha de fiesta', 'FIESTA');

  const _Sort(this.label, this.short);

  /// Full wording, for the menu.
  final String label;

  /// Two or three letters, for the button next to the search field.
  final String short;
}

/// Searchable list of all published saints.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _query = TextEditingController();
  _Sort _sort = _Sort.name;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  String _normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp('[áàä]'), 'a')
      .replaceAll(RegExp('[éèë]'), 'e')
      .replaceAll(RegExp('[íìï]'), 'i')
      .replaceAll(RegExp('[óòö]'), 'o')
      .replaceAll(RegExp('[úùü]'), 'u');

  int _byName(SaintInfo a, SaintInfo b) =>
      _normalize(a.name).compareTo(_normalize(b.name));

  /// Calendar order, from January. Saints with no feast day go last, and
  /// saints sharing a day keep the alphabetical order.
  int _byFeast(SaintInfo a, SaintInfo b) {
    final da = _feastKey(a);
    final db = _feastKey(b);
    if (da != db) return da.compareTo(db);
    return _byName(a, b);
  }

  int _feastKey(SaintInfo s) {
    final month = s.feastMonth;
    final day = s.feastDay;
    if (month == null || day == null) return 9999;
    return month * 100 + day;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final catalog = state.catalog ?? const <SaintInfo>[];
    final q = _normalize(_query.text.trim());
    final visible = q.isEmpty
        ? [...catalog]
        : catalog
              .where(
                (s) =>
                    _normalize(s.name).contains(q) ||
                    _normalize(s.title ?? '').contains(q),
              )
              .toList();
    visible.sort(_sort == _Sort.name ? _byName : _byFeast);
    final owned = state.ownedIds;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _query,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Buscar un santo',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Palette.gold,
                    ),
                    suffixIcon: _query.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => setState(_query.clear),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _SortButton(
                sort: _sort,
                onChanged: (s) => setState(() => _sort = s),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Eyebrow('${visible.length} santos', color: Palette.parchmentDim),
              const Spacer(),
              if (state.signedIn) ...[
                const Icon(Icons.style_rounded, size: 12, color: Palette.gold),
                const SizedBox(width: 4),
                Eyebrow(
                  '${owned.length} en tu álbum',
                  color: Palette.parchmentDim,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: visible.isEmpty
              ? Center(
                  child: Text(
                    'Ningún santo coincide con la búsqueda.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Palette.parchmentDim,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _SaintTile(
                    saint: visible[i],
                    owned: owned.contains(visible[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _SaintTile extends StatelessWidget {
  const _SaintTile({required this.saint, required this.owned});

  final SaintInfo saint;
  final bool owned;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final feast = feastLong(saint.feastMonth, saint.feastDay);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => SaintDetailScreen.open(context, saint.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'saint-${saint.id}',
                child: SizedBox(
                  width: 56,
                  height: 72,
                  child: ClipPath(
                    clipper: const ArchClipper(),
                    child: SaintIllustration(
                      url: saint.illustrationUrl,
                      name: saint.name,
                      grayscale: !owned,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      saint.name,
                      style: textTheme.titleMedium?.copyWith(
                        color: Palette.parchment,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (saint.title != null)
                      Text(
                        saint.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                    if (feast != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        feast,
                        style: textTheme.labelSmall?.copyWith(
                          color: Palette.gold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                owned ? Icons.style_rounded : Icons.lock_outline_rounded,
                size: 18,
                color: owned ? Palette.gold : Palette.inkLine,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pill next to the search field: shows how the list is ordered right now and
/// opens the menu with the two criteria.
class _SortButton extends StatelessWidget {
  const _SortButton({required this.sort, required this.onChanged});

  final _Sort sort;
  final ValueChanged<_Sort> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Sort>(
      tooltip: 'Ordenar',
      initialValue: sort,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final option in _Sort.values)
          PopupMenuItem(
            value: option,
            child: Row(
              children: [
                Icon(
                  option == sort
                      ? Icons.check_rounded
                      : Icons.check_box_outline_blank_rounded,
                  size: 16,
                  color: option == sort ? Palette.gold : Colors.transparent,
                ),
                const SizedBox(width: 10),
                Text(option.label),
              ],
            ),
          ),
      ],
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Palette.inkRaised,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Palette.inkLine),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert_rounded, size: 18, color: Palette.gold),
            const SizedBox(width: 4),
            Eyebrow(sort.short, color: Palette.parchmentDim),
          ],
        ),
      ),
    );
  }
}
