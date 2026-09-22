import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../client.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../utils/books.dart';
import '../utils/feast.dart';
import '../utils/titles.dart';
import '../utils/years.dart';
import '../widgets/common.dart';
import '../widgets/saint_card.dart';
import '../widgets/saint_illustration.dart';
import '../widgets/share_card.dart';

/// Full page of a saint: illustration, card, life, prayer and stream link.
class SaintDetailScreen extends StatefulWidget {
  const SaintDetailScreen({super.key, required this.saintId});

  final int saintId;

  static Future<void> open(BuildContext context, int saintId) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SaintDetailScreen(saintId: saintId)),
    );
  }

  @override
  State<SaintDetailScreen> createState() => _SaintDetailScreenState();
}

class _SaintDetailScreenState extends State<SaintDetailScreen> {
  late Future<SaintDetail> _future = client.saint.detail(widget.saintId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<SaintDetail>(
        future: _future,
        builder: (context, snapshot) {
          final state = AppState.of(context);
          final cached = state.catalog
              ?.where((s) => s.id == widget.saintId)
              .firstOrNull;
          if (snapshot.hasError && cached == null) {
            return SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(onPressed: Navigator.of(context).pop),
                  ),
                  Expanded(
                    child: ErrorView(
                      error: snapshot.error!,
                      onRetry: () => setState(() {
                        _future = client.saint.detail(widget.saintId);
                      }),
                    ),
                  ),
                ],
              ),
            );
          }
          // Show what the state already knows while the detail loads, and
          // keep showing it when the server cannot be reached.
          final detail =
              snapshot.data ??
              (cached == null
                  ? null
                  : SaintDetail(
                      saint: cached,
                      card: state.cardFor(widget.saintId),
                      // The cached catalog has no books: offline the ficha
                      // shows everything else and skips the reading list.
                      books: const [],
                    ));
          if (detail == null) return const LoadingView();
          return _DetailBody(detail: detail);
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail});

  final SaintDetail detail;

  @override
  Widget build(BuildContext context) {
    final saint = detail.saint;
    final card = detail.card;
    final textTheme = Theme.of(context).textTheme;
    final feast = feastLong(saint.feastMonth, saint.feastDay);
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = (width - 48).clamp(200.0, 240.0);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          backgroundColor: Palette.ink,
          leading: const BackButton(),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'saint-${saint.id}',
                  child: SaintIllustration(
                    url: saint.illustrationUrl,
                    name: saint.name,
                    grayscale: card == null,
                    // Illustrations are portraits: crop from the top so the
                    // head stays whole when the banner is wider than tall.
                    alignment: Alignment.topCenter,
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Palette.ink],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          sliver: SliverList.list(
            children: [
              if (saint.title != null) Eyebrow(saint.title!),
              const SizedBox(height: 6),
              Text(saint.name, style: textTheme.headlineMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final t in sortedTitles(saint.titles))
                    InfoChip(
                      icon: t.icon,
                      label: t.labelFor(saint.name),
                      color: t.color,
                      borderColor: t.color.withValues(alpha: 0.5),
                    ),
                  if (feast != null)
                    InfoChip(icon: Icons.church_outlined, label: feast),
                  if (lifespanLabel(saint) case final years?)
                    InfoChip(
                      icon: Icons.hourglass_empty_rounded,
                      label: years,
                    ),
                  if (saint.birthPlace case final place?)
                    InfoChip(
                      icon: Icons.location_on_outlined,
                      label: 'n. $place',
                    ),
                  if (saint.deathPlace case final place?)
                    InfoChip(
                      icon: Icons.local_florist_outlined,
                      label: '† $place',
                    ),
                  if (saint.season != null && saint.episode != null)
                    InfoChip(
                      icon: Icons.live_tv_rounded,
                      label: 'T${saint.season} · Cap. ${saint.episode}',
                    ),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: Column(
                  children: [
                    SaintCard(
                      saint: saint,
                      scores: card?.scores,
                      width: cardWidth,
                    ),
                    const SizedBox(height: 14),
                    if (card == null)
                      Text(
                        'Todavía no tenés esta carta.\n'
                        'Puede aparecer como tu carta del día.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      )
                    else ...[
                      Text(
                        'En tu álbum desde el '
                        '${dateTimeShort(card.obtainedAt).split(',').first}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Solo las que ya tenés: la carta con sus puntajes es
                      // lo que hay para mostrar.
                      ShareCardButton(saint: saint, scores: card.scores),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (saint.youtubeUrl != null) ...[
                FilledButton.icon(
                  onPressed: () =>
                      openLink(context, saint.youtubeUrl!, what: 'YouTube'),
                  icon: const Icon(Icons.play_circle_outline_rounded),
                  label: const Text('VER EN EL PROGRAMA'),
                ),
                const SizedBox(height: 32),
              ],
              const Eyebrow('Su vida'),
              const SizedBox(height: 10),
              Text(
                saint.bio,
                style: textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
              if (saint.prayer != null && saint.prayer!.trim().isNotEmpty) ...[
                const SizedBox(height: 32),
                _PrayerBlock(prayer: saint.prayer!),
              ],
              if (detail.books.isNotEmpty) ...[
                const SizedBox(height: 32),
                _BooksSection(name: saint.name, books: detail.books),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PrayerBlock extends StatelessWidget {
  const _PrayerBlock({required this.prayer});

  final String prayer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        color: Palette.parchment,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Palette.goldDark.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.add_rounded, size: 16, color: Palette.goldDark),
              const SizedBox(width: 6),
              Text(
                'ORACIÓN',
                style: textTheme.labelSmall?.copyWith(color: Palette.goldDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prayer,
            style: textTheme.bodyLarge?.copyWith(
              color: Palette.ink,
              fontStyle: FontStyle.italic,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

/// The recommended reading, in two groups: what the saint wrote and what was
/// written about them.
class _BooksSection extends StatelessWidget {
  const _BooksSection({required this.name, required this.books});

  final String name;
  final List<SaintBook> books;

  @override
  Widget build(BuildContext context) {
    final own = writtenBySaint(books);
    final about = writtenAboutSaint(books);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Para leer'),
        if (own.isNotEmpty) ...[
          const SizedBox(height: 14),
          _BooksGroup(heading: writingsHeading(name), books: own),
        ],
        if (about.isNotEmpty) ...[
          const SizedBox(height: 14),
          _BooksGroup(heading: aboutHeading(name), books: about),
        ],
      ],
    );
  }
}

class _BooksGroup extends StatelessWidget {
  const _BooksGroup({required this.heading, required this.books});

  final String heading;
  final List<SaintBook> books;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: Palette.gold),
        ),
        const SizedBox(height: 8),
        for (final book in books) _BookTile(book: book),
      ],
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({required this.book});

  final SaintBook book;

  /// "Marcelle Auclair · 1950 · Sudamericana", skipping what is missing.
  String get _subtitle => [
    if (book.author != null) book.author!,
    if (book.year != null) yearLabel(book.year!),
    if (book.publisher != null) book.publisher!,
  ].join(' · ');

  Future<void> _open(BuildContext context) async {
    final uri = Uri.tryParse(book.url!.trim());
    if (uri == null || !uri.hasScheme) return;
    final opened = await launchUrl(
      uri,
      mode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    if (!opened && context.mounted) {
      await Clipboard.setData(ClipboardData(text: uri.toString()));
      if (!context.mounted) return;
      showMessage(context, 'Copiamos el link del libro.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subtitle = _subtitle;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Palette.inkRaised,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: book.url == null ? null : () => _open(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(book.kind.icon, size: 16, color: Palette.gold),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title, style: textTheme.bodyLarge),
                      const SizedBox(height: 2),
                      Text(
                        subtitle.isEmpty
                            ? book.kind.label
                            : '${book.kind.label} · $subtitle',
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                      if (book.note != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          book.note!,
                          style: textTheme.bodySmall?.copyWith(height: 1.45),
                        ),
                      ],
                    ],
                  ),
                ),
                if (book.url != null)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.open_in_new_rounded,
                      size: 14,
                      color: Palette.parchmentDim,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
