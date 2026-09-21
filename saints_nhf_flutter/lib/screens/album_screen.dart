import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/saint_card.dart';
import 'saint_detail_screen.dart';

/// The sticker-album view: every published saint, owned ones in color.
class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final catalog = state.catalog ?? const <SaintInfo>[];
    final overview = state.overview;
    if (overview == null) return const LoadingView();

    // Owned first, by feast date; then the missing ones.
    int feastKey(SaintInfo s) => (s.feastMonth ?? 13) * 100 + (s.feastDay ?? 0);
    final owned = catalog.where((s) => state.ownedIds.contains(s.id)).toList()
      ..sort((a, b) => feastKey(a).compareTo(feastKey(b)));
    final missing =
        catalog.where((s) => !state.ownedIds.contains(s.id)).toList()
          ..sort((a, b) => feastKey(a).compareTo(feastKey(b)));
    final all = [...owned, ...missing];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 150).floor().clamp(2, 6);
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              sliver: SliverToBoxAdapter(
                child: AlbumProgress(
                  owned: owned.length,
                  total: overview.totalPublished,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: cardAspectRatio,
                ),
                itemCount: all.length,
                itemBuilder: (context, i) {
                  final saint = all[i];
                  final card = state.cardFor(saint.id);
                  return LayoutBuilder(
                    builder: (context, c) => GestureDetector(
                      onTap: () => SaintDetailScreen.open(context, saint.id),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: SaintCard(
                          saint: saint,
                          scores: card?.scores,
                          width: c.maxWidth - 6,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (all.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'Todavía no hay santos publicados.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Palette.parchmentDim,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
