import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../theme.dart';
import '../utils/feast.dart';
import '../utils/scores.dart';
import '../utils/titles.dart';
import 'saint_illustration.dart';

/// Width-to-height ratio of a card.
const cardAspectRatio = 2 / 3;

/// The saint card, drawn from the illustration and the scores. When [scores]
/// is null the card is shown locked: grayscale with hidden values.
class SaintCard extends StatelessWidget {
  const SaintCard({
    super.key,
    required this.saint,
    required this.scores,
    required this.width,
  });

  final SaintInfo saint;
  final SaintScores? scores;
  final double width;

  bool get locked => scores == null;

  @override
  Widget build(BuildContext context) {
    // Guard against transient zero or negative layout widths, which would
    // produce negative blur radii and fail painting assertions.
    final width = math.max(1.0, this.width);
    final s = width / 240; // Design scale; the card was laid out at 240px.
    final height = width / cardAspectRatio;
    final radius = 18 * s;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: locked
              ? const LinearGradient(
                  colors: [Color(0xFF6E6A7C), Color(0xFF3B384A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : Palette.goldGradient,
          boxShadow: [
            BoxShadow(
              color: (locked ? Colors.black : Palette.goldDark).withValues(
                alpha: 0.45,
              ),
              blurRadius: 24 * s,
              offset: Offset(0, 10 * s),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(5 * s),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius - 4 * s),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1E1936), Palette.ink],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 58,
                    child: _Top(saint: saint, scores: scores, s: s),
                  ),
                  _NameBanner(saint: saint, s: s, locked: locked),
                  Expanded(
                    flex: 30,
                    child: _ScoreGrid(scores: scores, s: s),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Top extends StatelessWidget {
  const _Top({required this.saint, required this.scores, required this.s});

  final SaintInfo saint;
  final SaintScores? scores;
  final double s;

  @override
  Widget build(BuildContext context) {
    final titles = sortedTitles(saint.titles);
    final feast = feastShort(saint.feastMonth, saint.feastDay);
    final overall = scores == null ? null : overallOf(scores!);
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(34 * s, 12 * s, 34 * s, 0),
          child: ClipPath(
            clipper: const ArchClipper(archRatio: 0.55),
            child: SaintIllustration(
              url: saint.illustrationUrl,
              name: saint.name,
              grayscale: scores == null,
            ),
          ),
        ),
        // Thin gilded outline of the arch.
        Padding(
          padding: EdgeInsets.fromLTRB(32 * s, 10 * s, 32 * s, 0),
          child: CustomPaint(
            painter: _ArchOutlinePainter(
              color: scores == null ? Palette.parchmentDim : Palette.gold,
              strokeWidth: 1.4 * s,
            ),
          ),
        ),
        Positioned(
          left: 8 * s,
          top: 10 * s,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                overall?.toString() ?? '?',
                style: textTheme.displayMedium?.copyWith(
                  fontSize: 30 * s,
                  height: 1,
                  color: scores == null
                      ? Palette.parchmentDim
                      : Palette.goldLight,
                ),
              ),
              if (feast != null) ...[
                SizedBox(height: 4 * s),
                Text(
                  feast,
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 7.5 * s,
                    letterSpacing: 1,
                    color: Palette.parchmentDim,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (scores == null)
          Positioned(
            right: 8 * s,
            top: 10 * s,
            child: Icon(
              Icons.lock_outline_rounded,
              size: 16 * s,
              color: Palette.parchmentDim,
            ),
          )
        else if (titles.isNotEmpty)
          Positioned(
            right: 7 * s,
            top: 9 * s,
            child: _TitleEmblems(titles: titles, s: s),
          ),
      ],
    );
  }
}

class _ArchOutlinePainter extends CustomPainter {
  const _ArchOutlinePainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = const ArchClipper(archRatio: 0.55).getClip(size);
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(_ArchOutlinePainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

/// The medals on the card, one per liturgical title, from the most
/// distinctive down. Too many would run into the arch, so the rest are
/// summed up in a last medal with the count.
class _TitleEmblems extends StatelessWidget {
  const _TitleEmblems({required this.titles, required this.s});

  /// Medals that fit beside the arch without crowding it.
  static const _maxEmblems = 4;

  final List<SaintTitle> titles;
  final double s;

  @override
  Widget build(BuildContext context) {
    final shown = titles.length > _maxEmblems
        ? titles.take(_maxEmblems - 1).toList()
        : titles;
    final hidden = titles.length - shown.length;
    return Column(
      children: [
        for (final title in shown) ...[
          _TitleEmblem(title: title, s: s),
          SizedBox(height: 4 * s),
        ],
        if (hidden > 0)
          _MoreTitlesEmblem(
            titles: titles.sublist(shown.length),
            count: hidden,
            s: s,
          ),
      ],
    );
  }
}

/// A small medal on the card showing one liturgical title of the saint.
class _TitleEmblem extends StatelessWidget {
  const _TitleEmblem({required this.title, required this.s});

  final SaintTitle title;
  final double s;

  @override
  Widget build(BuildContext context) {
    return _Medal(
      color: title.color,
      s: s,
      tooltip: title.adminLabel,
      child: Icon(title.icon, size: 12 * s, color: title.color),
    );
  }
}

/// The medal that stands for the titles that did not fit, e.g. "+2".
class _MoreTitlesEmblem extends StatelessWidget {
  const _MoreTitlesEmblem({
    required this.titles,
    required this.count,
    required this.s,
  });

  final List<SaintTitle> titles;
  final int count;
  final double s;

  @override
  Widget build(BuildContext context) {
    return _Medal(
      color: Palette.goldLight,
      s: s,
      tooltip: titles.map((t) => t.adminLabel).join(' · '),
      child: Text(
        '+$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 9 * s,
          height: 1,
          color: Palette.goldLight,
        ),
      ),
    );
  }
}

/// The round gilded frame shared by every medal on the card.
class _Medal extends StatelessWidget {
  const _Medal({
    required this.color,
    required this.s,
    required this.tooltip,
    required this.child,
  });

  final Color color;
  final double s;
  final String tooltip;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 22 * s,
        height: 22 * s,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.35),
              Palette.ink.withValues(alpha: 0.85),
            ],
          ),
          border: Border.all(
            color: color.withValues(alpha: 0.9),
            width: 1.1 * s,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 6 * s,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _NameBanner extends StatelessWidget {
  const _NameBanner({
    required this.saint,
    required this.s,
    required this.locked,
  });

  final SaintInfo saint;
  final double s;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final line = Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            locked ? Palette.parchmentDim : Palette.gold,
            Colors.transparent,
          ],
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12 * s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          line,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5 * s),
            child: Text(
              saint.name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontSize: 11.5 * s,
                letterSpacing: 1.4 * s,
                color: locked ? Palette.parchmentDim : Palette.goldLight,
              ),
            ),
          ),
          line,
        ],
      ),
    );
  }
}

class _ScoreGrid extends StatelessWidget {
  const _ScoreGrid({required this.scores, required this.s});

  final SaintScores? scores;
  final double s;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final left = ScoreCategory.values.sublist(0, 3);
    final right = ScoreCategory.values.sublist(3);

    Widget column(List<ScoreCategory> cats, {required bool alignLeft}) =>
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final c in cats)
              Row(
                mainAxisAlignment: alignLeft
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  if (!alignLeft) _abbr(c, textTheme),
                  if (!alignLeft) SizedBox(width: 5 * s),
                  Text(
                    scores == null ? '??' : c.of(scores!).toString(),
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: 15 * s,
                      height: 1,
                      color: scores == null
                          ? Palette.parchmentDim
                          : Palette.parchment,
                    ),
                  ),
                  if (alignLeft) SizedBox(width: 5 * s),
                  if (alignLeft) _abbr(c, textTheme),
                ],
              ),
          ],
        );

    return Padding(
      padding: EdgeInsets.fromLTRB(22 * s, 4 * s, 22 * s, 8 * s),
      child: Row(
        children: [
          Expanded(child: column(left, alignLeft: true)),
          Container(
            width: 1,
            margin: EdgeInsets.symmetric(vertical: 6 * s),
            color: Palette.inkLine,
          ),
          Expanded(child: column(right, alignLeft: false)),
        ],
      ),
    );
  }

  Widget _abbr(ScoreCategory c, TextTheme textTheme) => Text(
    c.abbreviation,
    style: textTheme.labelSmall?.copyWith(
      fontSize: 7.5 * s,
      letterSpacing: 1.2,
      color: scores == null ? Palette.parchmentDim : Palette.gold,
    ),
  );
}

/// The back of a card: ink field with a gilded rosette and the NHF mark.
class SaintCardBack extends StatelessWidget {
  const SaintCardBack({super.key, required this.width, this.dimmed = false});

  final double width;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final width = math.max(1.0, this.width);
    final s = width / 240;
    return SizedBox(
      width: width,
      height: width / cardAspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18 * s),
          gradient: dimmed
              ? const LinearGradient(
                  colors: [Color(0xFF4A4658), Color(0xFF2B2836)],
                )
              : Palette.goldGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24 * s,
              offset: Offset(0, 10 * s),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(5 * s),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14 * s),
            child: CustomPaint(
              painter: _CardBackPainter(dimmed: dimmed),
              child: Center(
                child: Text(
                  'NHF',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 34 * s,
                    letterSpacing: 6 * s,
                    color: dimmed ? Palette.parchmentDim : Palette.goldLight,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardBackPainter extends CustomPainter {
  const _CardBackPainter({required this.dimmed});

  final bool dimmed;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E1936), Palette.ink],
        ).createShader(rect),
    );
    final gold = (dimmed ? Palette.parchmentDim : Palette.gold);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 240;

    final center = size.center(Offset.zero);
    // A single fine ring frames the monogram.
    canvas.drawCircle(
      center,
      size.width * 0.30,
      stroke..color = gold.withValues(alpha: 0.7),
    );
    // Corner ornaments.
    final inset = size.width * 0.08;
    final len = size.width * 0.12;
    final corners = [
      (Offset(inset, inset), const Offset(1, 0), const Offset(0, 1)),
      (
        Offset(size.width - inset, inset),
        const Offset(-1, 0),
        const Offset(0, 1),
      ),
      (
        Offset(inset, size.height - inset),
        const Offset(1, 0),
        const Offset(0, -1),
      ),
      (
        Offset(size.width - inset, size.height - inset),
        const Offset(-1, 0),
        const Offset(0, -1),
      ),
    ];
    for (final (origin, dx, dy) in corners) {
      canvas.drawLine(origin, origin + dx * len, stroke..color = gold);
      canvas.drawLine(origin, origin + dy * len, stroke..color = gold);
    }
  }

  @override
  bool shouldRepaint(_CardBackPainter old) => old.dimmed != dimmed;
}

/// Flips from the card back to the front when [revealed] turns true.
class FlipCard extends StatelessWidget {
  const FlipCard({
    super.key,
    required this.revealed,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 900),
  });

  final bool revealed;
  final Widget front;
  final Widget back;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: revealed ? 1 : 0),
      duration: duration,
      curve: Curves.easeInOutCubic,
      builder: (context, t, _) {
        final angle = t * math.pi;
        final showFront = angle > math.pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(angle),
          child: showFront
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: front,
                )
              : back,
        );
      },
    );
  }
}
