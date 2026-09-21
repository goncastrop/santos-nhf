import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/saint_card.dart';
import '../saint_detail_screen.dart';

/// A friend's album. Scores are shown only for cards you also own.
class FriendCollectionScreen extends StatefulWidget {
  const FriendCollectionScreen({super.key, required this.friend});

  final FriendSummary friend;

  @override
  State<FriendCollectionScreen> createState() => _FriendCollectionScreenState();
}

class _FriendCollectionScreenState extends State<FriendCollectionScreen> {
  FriendCollection? _collection;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final c = await client.friends.collectionOf(widget.friend.authUserId);
      if (mounted) setState(() => _collection = c);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final textTheme = Theme.of(context).textTheme;
    final total = state.overview?.totalPublished ?? 0;
    return Scaffold(
      appBar: AppBar(title: Text(widget.friend.displayName.toUpperCase())),
      body: _error != null
          ? ErrorView(error: _error!, onRetry: _load)
          : _collection == null
          ? const LoadingView()
          : LayoutBuilder(
              builder: (context, constraints) {
                final columns = (constraints.maxWidth / 150).floor().clamp(
                  2,
                  6,
                );
                final saints = _collection!.saints;
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AlbumProgress(owned: saints.length, total: total),
                            const SizedBox(height: 8),
                            Text(
                              'Ves los puntajes solo de las cartas que también tenés.',
                              style: textTheme.bodySmall?.copyWith(
                                color: Palette.parchmentDim,
                              ),
                            ),
                          ],
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
                        itemCount: saints.length,
                        itemBuilder: (context, i) {
                          final saint = saints[i];
                          final mine = state.cardFor(saint.id);
                          return LayoutBuilder(
                            builder: (context, c) => GestureDetector(
                              onTap: () =>
                                  SaintDetailScreen.open(context, saint.id),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: SaintCard(
                                  saint: saint,
                                  scores: mine?.scores,
                                  width: c.maxWidth - 6,
                                ),
                              ),
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
