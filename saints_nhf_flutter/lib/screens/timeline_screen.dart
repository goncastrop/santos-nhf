import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../church_events.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../utils/years.dart';
import '../widgets/common.dart';
import '../widgets/saint_illustration.dart';
import 'saint_detail_screen.dart';

/// The saints laid out in history: time runs to the right and each saint is a
/// bar from birth to death, so whoever shares a vertical slice of the screen
/// lived at the same time.
///
/// Horizontal and not vertical because the bar's length is the life: a long
/// one has room for the face, the name and the years written along it. The
/// contemporaries then stack against the height of the screen, which on a
/// phone is twice as generous as the width.
///
/// Behind them run the councils and the big moments of the Church, so a life
/// can be read against what the Church was living at the time.
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

/// How much of history fits on screen. The widest is the global view and the
/// narrowest reads year by year.
enum _Zoom {
  centuries('SIGLOS', 0.34),
  decades('DÉCADAS', 1.8),
  years('AÑOS', 6);

  const _Zoom(this.label, this.pxPerYear);

  final String label;
  final double pxPerYear;
}

class _TimelineScreenState extends State<TimelineScreen> {
  /// Scrolls time. Shared by the ruler and the bars.
  final _time = ScrollController();

  /// Scrolls the stack of lanes, on the rare screen that cannot hold them.
  final _lanes = ScrollController();

  _Zoom _zoom = _Zoom.decades;

  /// Whether the councils and the big moments of the Church are drawn behind
  /// the saints. Se puede apagar para quedarse solo con las vidas. Como el
  /// zoom, vale para esta visita y no se guarda.
  bool _showEvents = true;

  static const _rulerHeight = 22.0;
  static const _laneHeight = 34.0;
  static const _laneGap = 6.0;
  static const _sidePadding = 16.0;

  @override
  void initState() {
    super.initState();
    // The map draws the visible window from the chart's scroll position, and
    // on the first frame the controller is not attached to anything yet. One
    // rebuild after layout and the window appears without having to scroll.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _time.dispose();
    _lanes.dispose();
    super.dispose();
  }

  /// Keeps the year in the middle of the screen in place when zooming, so the
  /// view does not jump to another century.
  void _setZoom(_Zoom next, int fromYear) {
    final before = _zoom;
    setState(() => _zoom = next);
    if (!_time.hasClients) return;
    final viewport = _time.position.viewportDimension;
    final centerYear =
        fromYear +
        (_time.offset + viewport / 2 - _sidePadding) / before.pxPerYear;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_time.hasClients) return;
      final target =
          (centerYear - fromYear) * next.pxPerYear +
          _sidePadding -
          viewport / 2;
      _time.jumpTo(target.clamp(0.0, _time.position.maxScrollExtent));
    });
  }

  /// Puts [year] in the middle of the screen, so it lands where the window
  /// on the map says it will.
  void _centerOnYear(int year, int fromYear) {
    if (!_time.hasClients) return;
    final target =
        (year - fromYear) * _zoom.pxPerYear +
        _sidePadding -
        _time.position.viewportDimension / 2;
    _time.jumpTo(target.clamp(0.0, _time.position.maxScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final catalog = state.catalog ?? const <SaintInfo>[];
    final dated = [
      for (final saint in catalog)
        if (lifeSpan(saint) case final span?) (saint: saint, span: span),
    ]..sort((a, b) => a.span.from.compareTo(b.span.from));
    final undated = catalog.length - dated.length;

    if (dated.isEmpty) return _EmptyTimeline(total: catalog.length);

    // Round the ends to whole centuries so the ruler starts on a label.
    final first = dated.map((e) => e.span.from).reduce(math.min);
    final last = dated.map((e) => e.span.to).reduce(math.max);
    final fromYear = (first / 100).floor() * 100;
    final toYear = (last / 100).ceil() * 100;

    // The background only covers the years the saints already span: the
    // axis is theirs, and a council outside it would stretch it for nothing.
    final inRange = churchEventsBetween(first, last);
    final events = _showEvents ? inRange : const <ChurchEvent>[];

    final placed = _place(dated, _zoom.pxPerYear);
    final laneCount = placed.map((p) => p.lane).reduce(math.max) + 1;
    final chartWidth = (toYear - fromYear) * _zoom.pxPerYear + _sidePadding * 2;
    final lanesHeight = laneCount * (_laneHeight + _laneGap);

    return Column(
      children: [
        _TimeMinimap(
          spans: [for (final e in dated) e.span],
          fromYear: fromYear,
          toYear: toYear,
          time: _time,
          pxPerYear: _zoom.pxPerYear,
          sidePadding: _sidePadding,
          onSeekYear: (year) => _centerOnYear(year, fromYear),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  undated == 0
                      ? '${dated.length} santos'
                      : '${dated.length} ubicados · $undated sin fechas',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Palette.parchmentDim),
                ),
              ),
              // Sin hitos en estos años no hay nada que apagar.
              if (inRange.isNotEmpty)
                _EventsToggle(
                  showing: _showEvents,
                  onTap: () => setState(() => _showEvents = !_showEvents),
                ),
              for (final zoom in _Zoom.values)
                _ZoomButton(
                  zoom: zoom,
                  selected: zoom == _zoom,
                  onTap: () => _setZoom(zoom, fromYear),
                ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _time,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: _rulerHeight,
                    child: CustomPaint(
                      painter: _RulerPainter(
                        fromYear: fromYear,
                        toYear: toYear,
                        pxPerYear: _zoom.pxPerYear,
                        sidePadding: _sidePadding,
                        textStyle:
                            Theme.of(context).textTheme.labelSmall ??
                            const TextStyle(fontSize: 10),
                        everyFifty: _zoom != _Zoom.centuries,
                      ),
                    ),
                  ),
                  if (events.isNotEmpty)
                    _EventRail(
                      events: events,
                      fromYear: fromYear,
                      pxPerYear: _zoom.pxPerYear,
                      sidePadding: _sidePadding,
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _lanes,
                      child: SizedBox(
                        height: lanesHeight,
                        child: CustomPaint(
                          painter: _GridPainter(
                            fromYear: fromYear,
                            toYear: toYear,
                            pxPerYear: _zoom.pxPerYear,
                            sidePadding: _sidePadding,
                            events: events,
                          ),
                          // Every bar is built, not just the visible ones.
                          // Fine for a catalog of this size; a few hundred
                          // saints would want a viewport-aware list.
                          child: Stack(
                            children: [
                              for (final p in placed)
                                Positioned(
                                  left:
                                      (p.span.from - fromYear) *
                                          _zoom.pxPerYear +
                                      _sidePadding,
                                  top: p.lane * (_laneHeight + _laneGap),
                                  width: p.widthPx,
                                  height: _laneHeight,
                                  child: _LifeBar(
                                    saint: p.saint,
                                    owned: state.ownedIds.contains(
                                      p.saint.id,
                                    ),
                                    width: p.widthPx,
                                    left:
                                        (p.span.from - fromYear) *
                                            _zoom.pxPerYear +
                                        _sidePadding,
                                    time: _time,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Packs the saints into lanes: each one goes in the topmost lane that is
  /// already free at its birth year, which puts contemporaries one under the
  /// other. A life too short to draw reserves the room it needs anyway.
  List<_Placed> _place(
    List<({SaintInfo saint, ({int from, int to}) span})> dated,
    double pxPerYear,
  ) {
    const minBarPx = 10.0;
    const gapPx = 6.0;
    final laneFreeFrom = <double>[];
    final placed = <_Placed>[];
    for (final entry in dated) {
      final widthPx = math.max(
        minBarPx,
        (entry.span.to - entry.span.from) * pxPerYear,
      );
      final start = entry.span.from.toDouble();
      var lane = laneFreeFrom.indexWhere((free) => free <= start);
      if (lane == -1) {
        lane = laneFreeFrom.length;
        laneFreeFrom.add(0);
      }
      laneFreeFrom[lane] = start + (widthPx + gapPx) / pxPerYear;
      placed.add(
        _Placed(
          saint: entry.saint,
          span: entry.span,
          lane: lane,
          widthPx: widthPx,
        ),
      );
    }
    return placed;
  }
}

class _Placed {
  const _Placed({
    required this.saint,
    required this.span,
    required this.lane,
    required this.widthPx,
  });

  final SaintInfo saint;
  final ({int from, int to}) span;
  final int lane;
  final double widthPx;
}

/// One saint's life as a bar. Saints already in the album are gilded; the
/// rest stay muted, like the locked cards.
///
/// How much it says depends on how long the life is on screen: the bar shows
/// the face, then the name, then the years, as it gets room for them. So a
/// crowded century is not a wall of initials — the long lives keep their
/// names.
class _LifeBar extends StatelessWidget {
  const _LifeBar({
    required this.saint,
    required this.owned,
    required this.width,
    required this.left,
    required this.time,
  });

  /// Room a bar needs before the name fits beside the face.
  static const _nameNeedsPx = 96.0;

  /// Room it needs before the years fit after the name.
  static const _yearsNeedsPx = 190.0;

  /// Below this a bar is a plain tick: not even a shrunken face fits.
  static const _faceNeedsPx = 24.0;

  /// The face on a full-size bar. A narrower one gets a smaller circle
  /// instead of overflowing.
  static const _faceSize = 26.0;

  /// Room the face and a readable piece of the name need: a sticky label
  /// refuses to give up this much of the bar.
  static const _labelNeedsPx = 116.0;

  final SaintInfo saint;
  final bool owned;
  final double width;

  /// Where the bar starts, in the chart's own coordinates.
  final double left;

  /// The chart's horizontal scroll, so a bar that runs off the left edge can
  /// keep its face and name in view.
  final ScrollController time;

  @override
  Widget build(BuildContext context) {
    final exact = hasBothYears(saint);
    final color = owned ? Palette.gold : Palette.parchmentDim;
    final showFace = width >= _faceNeedsPx;
    final radius = showFace ? 17.0 : 3.0;

    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Tooltip(
        message: '${saint.name}\n${lifespanLabel(saint) ?? ''}'.trim(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: () => SaintDetailScreen.open(context, saint.id),
            // Clipped, because the label slides inside the bar and has to
            // stop at its edges.
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  // A tick is read by its fill, a wide bar by what it holds.
                  color: color.withValues(
                    alpha: showFace
                        ? (owned ? 0.16 : 0.08)
                        : (owned ? 0.75 : 0.3),
                  ),
                  border: Border.all(
                    // A guessed end is drawn faded so it does not read as
                    // data.
                    color: color.withValues(alpha: exact ? 0.7 : 0.3),
                  ),
                ),
                child: !showFace
                    ? const SizedBox.expand()
                    : _label(context, color),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Keeps the face and the name on screen when the bar is wider than the
  /// window: a life of ninety years at the closest zoom is longer than the
  /// screen, and scrolling into the middle of it used to leave a nameless
  /// stripe. The label slides along inside the bar instead, and stops before
  /// it would fall off the far end.
  Widget _label(BuildContext context, Color color) {
    return AnimatedBuilder(
      animation: time,
      builder: (context, _) {
        final visibleLeft = time.hasClients ? time.offset : 0.0;
        // Slides with the scroll, and stops before falling off the far end.
        final slide = (visibleLeft - left)
            .clamp(0.0, math.max(0.0, width - _labelNeedsPx))
            .toDouble();
        return Padding(
          padding: EdgeInsets.only(left: slide),
          child: _content(context, color, width - slide),
        );
      },
    );
  }

  /// What the bar says in [available] pixels. It has to be measured against
  /// what is left after the label slides, not against the whole bar, or a
  /// long life shows the years and then overflows once it sticks.
  Widget _content(BuildContext context, Color color, double available) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: ClipOval(
            // The bar's own frame eats 4px and the padding another 6, so the
            // circle takes what is left.
            child: _face((available - 12).clamp(12.0, _faceSize), color),
          ),
        ),
        if (available >= _nameNeedsPx)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 2, right: 6),
              child: Text(
                saint.shortLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: owned ? Palette.parchment : Palette.parchmentDim,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        if (available >= _yearsNeedsPx)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              lifespanLabel(saint) ?? '',
              maxLines: 1,
              style: textTheme.labelSmall?.copyWith(
                fontSize: 9,
                color: color,
                letterSpacing: 0,
              ),
            ),
          ),
      ],
    );
  }

  /// The saint's face at [size]. Without an illustration the full monogram is
  /// unreadable this small — its halo and gradient collapse into a dark disc —
  /// so the initials are drawn on their own instead.
  Widget _face(double size, Color color) {
    if (saint.illustrationUrl == null) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Palette.inkRaised,
          border: Border.all(color: color.withValues(alpha: 0.55)),
        ),
        child: Text(
          saintInitials(saint.name),
          maxLines: 1,
          style: TextStyle(
            fontSize: size * 0.4,
            height: 1,
            color: color,
            letterSpacing: 0,
          ),
        ),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: SaintIllustration(
        url: saint.illustrationUrl,
        name: saint.name,
        grayscale: !owned,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

/// The map of the whole timeline, above the chart: how many saints lived in
/// each century, which slice of time is on screen right now, and a way to
/// jump anywhere by tapping or dragging.
class _TimeMinimap extends StatelessWidget {
  const _TimeMinimap({
    required this.spans,
    required this.fromYear,
    required this.toYear,
    required this.time,
    required this.pxPerYear,
    required this.sidePadding,
    required this.onSeekYear,
  });

  static const height = 52.0;
  static const _sideMargin = 20.0;

  final List<({int from, int to})> spans;
  final int fromYear;
  final int toYear;

  /// The chart's horizontal scroll, so the window can follow it.
  final ScrollController time;
  final double pxPerYear;
  final double sidePadding;

  /// Called with the year the reader picked on the map.
  final void Function(int year) onSeekYear;

  @override
  Widget build(BuildContext context) {
    final starts = [for (var y = fromYear; y < toYear; y += 100) y];
    final counts = [
      for (final start in starts)
        spans.where((s) => s.from < start + 100 && s.to >= start).length,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(_sideMargin, 0, _sideMargin, 6),
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            int yearAt(double x) {
              final t = (x / width).clamp(0.0, 1.0);
              return fromYear + (t * (toYear - fromYear)).round();
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => onSeekYear(yearAt(d.localPosition.dx)),
              onHorizontalDragUpdate: (d) =>
                  onSeekYear(yearAt(d.localPosition.dx)),
              child: AnimatedBuilder(
                // Repaints as the chart scrolls, so the window follows.
                animation: time,
                builder: (context, _) => CustomPaint(
                  size: Size(width, height),
                  painter: _MinimapPainter(
                    starts: starts,
                    counts: counts,
                    fromYear: fromYear,
                    toYear: toYear,
                    window: _window(),
                    labelStyle:
                        Theme.of(context).textTheme.labelSmall ??
                        const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// The years currently on screen, or null before the chart has laid out.
  ({double from, double to})? _window() {
    if (!time.hasClients || !time.position.hasViewportDimension) return null;
    final viewport = time.position.viewportDimension;
    final left = fromYear + (time.offset - sidePadding) / pxPerYear;
    return (from: left, to: left + viewport / pxPerYear);
  }
}

class _MinimapPainter extends CustomPainter {
  const _MinimapPainter({
    required this.starts,
    required this.counts,
    required this.fromYear,
    required this.toYear,
    required this.window,
    required this.labelStyle,
  });

  final List<int> starts;
  final List<int> counts;
  final int fromYear;
  final int toYear;
  final ({double from, double to})? window;
  final TextStyle labelStyle;

  static const _labelHeight = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final span = (toYear - fromYear).toDouble();
    if (span <= 0 || starts.isEmpty) return;
    double xOf(num year) => (year - fromYear) / span * size.width;

    final chartHeight = size.height - _labelHeight - 3;
    final peak = math.max(1, counts.reduce(math.max));
    final baseline = chartHeight;

    // The window first, as a lit panel the density sits on top of.
    if (window case final w?) {
      final left = xOf(w.from).clamp(0.0, size.width);
      final right = xOf(w.to).clamp(0.0, size.width);
      final rect = Rect.fromLTRB(left, 0, math.max(right, left + 2), baseline);
      canvas.drawRect(
        rect,
        Paint()..color = Palette.gold.withValues(alpha: 0.13),
      );
      canvas.drawRect(
        rect,
        Paint()
          ..color = Palette.gold.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Density: one column per century, touching, so it reads as a histogram.
    for (var i = 0; i < starts.length; i++) {
      final left = xOf(starts[i]);
      final right = xOf(starts[i] + 100);
      final inWindow =
          window != null &&
          starts[i] + 100 > window!.from &&
          starts[i] < window!.to;
      if (counts[i] == 0) {
        canvas.drawLine(
          Offset(left, baseline),
          Offset(right, baseline),
          Paint()
            ..color = Palette.inkLine
            ..strokeWidth = 1.5,
        );
        continue;
      }
      final barHeight = 4 + (chartHeight - 6) * counts[i] / peak;
      canvas.drawRect(
        Rect.fromLTRB(left + 0.5, baseline - barHeight, right - 0.5, baseline),
        Paint()..color = Palette.gold.withValues(alpha: inWindow ? 0.9 : 0.42),
      );
    }

    canvas.drawLine(
      Offset(0, baseline),
      Offset(size.width, baseline),
      Paint()
        ..color = Palette.inkLine
        ..strokeWidth = 1,
    );

    // Centuries in roman numerals, as many as fit without touching.
    var lastRight = double.negativeInfinity;
    for (var i = 0; i < starts.length; i++) {
      final label = centuryLabel(centuryOf(starts[i] + 1)).replaceFirst(
        's. ',
        '',
      );
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: labelStyle.copyWith(
            fontSize: 8,
            letterSpacing: 0,
            color: Palette.parchmentDim,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final center = (xOf(starts[i]) + xOf(starts[i] + 100)) / 2;
      final left = center - painter.width / 2;
      if (left < lastRight + 4 ||
          left < 0 ||
          left + painter.width > size.width) {
        continue;
      }
      painter.paint(canvas, Offset(left, size.height - _labelHeight));
      lastRight = left + painter.width;
    }
  }

  @override
  bool shouldRepaint(_MinimapPainter old) =>
      old.window != window ||
      old.counts != counts ||
      old.fromYear != fromYear ||
      old.toYear != toYear;
}

/// Prende y apaga el fondo de concilios y hechos de la Iglesia, para poder
/// quedarse solo con las vidas.
class _EventsToggle extends StatelessWidget {
  const _EventsToggle({required this.showing, required this.onTap});

  final bool showing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: showing
          ? 'Ocultar los hechos de la Iglesia'
          : 'Mostrar los hechos de la Iglesia',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: showing
                ? Palette.crimsonLight.withValues(alpha: 0.16)
                : Colors.transparent,
            border: Border.all(
              color: showing ? Palette.crimsonLight : Palette.inkLine,
            ),
          ),
          child: Icon(
            showing
                ? Icons.account_balance_rounded
                : Icons.account_balance_outlined,
            size: 13,
            color: showing ? Palette.crimsonLight : Palette.parchmentDim,
          ),
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.zoom,
    required this.selected,
    required this.onTap,
  });

  final _Zoom zoom;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: selected
                ? Palette.gold.withValues(alpha: 0.18)
                : Colors.transparent,
            border: Border.all(
              color: selected ? Palette.gold : Palette.inkLine,
            ),
          ),
          child: Text(
            zoom.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9,
              color: selected ? Palette.gold : Palette.parchmentDim,
            ),
          ),
        ),
      ),
    );
  }
}

/// The years along the top: a labelled tick every century, and a fainter one
/// every fifty years once the view is close enough for it to help.
class _RulerPainter extends CustomPainter {
  const _RulerPainter({
    required this.fromYear,
    required this.toYear,
    required this.pxPerYear,
    required this.sidePadding,
    required this.textStyle,
    required this.everyFifty,
  });

  final int fromYear;
  final int toYear;
  final double pxPerYear;
  final double sidePadding;
  final TextStyle textStyle;
  final bool everyFifty;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Palette.inkLine
      ..strokeWidth = 1;
    for (var year = fromYear; year <= toYear; year += 50) {
      final x = (year - fromYear) * pxPerYear + sidePadding;
      final isCentury = year % 100 == 0;
      if (!isCentury && !everyFifty) continue;
      canvas.drawLine(
        Offset(x, isCentury ? 2 : size.height - 5),
        Offset(x, size.height),
        line,
      );
      if (!isCentury || year == toYear) continue;
      final painter = TextPainter(
        text: TextSpan(
          text: centuryLabel(centuryOf(year + 1)),
          style: textStyle.copyWith(
            fontSize: 9,
            color: Palette.parchmentDim,
            letterSpacing: 0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(x + 4, 3));
    }
  }

  @override
  bool shouldRepaint(_RulerPainter old) =>
      old.fromYear != fromYear ||
      old.toYear != toYear ||
      old.pxPerYear != pxPerYear ||
      old.everyFifty != everyFifty;
}

/// The century lines continued down behind the bars, so a vertical slice can
/// be read as one moment in time, and with them the councils and the big
/// moments of the Church, which is the same reading by another name: what
/// was the Church living while this one was alive.
class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.fromYear,
    required this.toYear,
    required this.pxPerYear,
    required this.sidePadding,
    this.events = const [],
  });

  final int fromYear;
  final int toYear;
  final double pxPerYear;
  final double sidePadding;
  final List<ChurchEvent> events;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Palette.inkLine.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (var year = fromYear; year <= toYear; year += 100) {
      final x = (year - fromYear) * pxPerYear + sidePadding;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }

    // Fainter than the century lines: this is the background, and the saints
    // have to keep reading as the subject.
    final eventLine = Paint()
      ..color = Palette.crimsonLight.withValues(alpha: 0.22)
      ..strokeWidth = 1;
    final band = Paint()..color = Palette.crimsonLight.withValues(alpha: 0.07);
    for (final event in events) {
      final x = (event.year - fromYear) * pxPerYear + sidePadding;
      if (event.endYear case final end?) {
        final right = (end - fromYear) * pxPerYear + sidePadding;
        if (right - x >= 2) {
          canvas.drawRect(Rect.fromLTRB(x, 0, right, size.height), band);
        }
      }
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), eventLine);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.fromYear != fromYear ||
      old.toYear != toYear ||
      old.pxPerYear != pxPerYear ||
      old.events.length != events.length;
}

/// The rail between the ruler and the saints: every council and every big
/// moment of the Church at its year, with as many names as fit.
///
/// Councils are drawn solid and the rest hollow, which is all the difference
/// the background needs. Tapping one tells what it was.
class _EventRail extends StatelessWidget {
  const _EventRail({
    required this.events,
    required this.fromYear,
    required this.pxPerYear,
    required this.sidePadding,
  });

  static const height = 30.0;

  final List<ChurchEvent> events;
  final int fromYear;
  final double pxPerYear;
  final double sidePadding;

  double _xOf(num year) => (year - fromYear) * pxPerYear + sidePadding;

  /// The event the reader meant. The name is written to the right of its
  /// mark, so there is more room to hit on that side.
  ChurchEvent? _at(double x) {
    ChurchEvent? best;
    var nearest = double.infinity;
    for (final event in events) {
      final left = _xOf(event.year);
      final right = _xOf(event.lastYear);
      final distance = x < left
          ? left - x
          : x > right
          ? x - right
          : 0.0;
      final reach = x < left ? 12.0 : 64.0;
      if (distance <= reach && distance < nearest) {
        best = event;
        nearest = distance;
      }
    }
    return best;
  }

  void _open(BuildContext context, ChurchEvent event) {
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Palette.inkRaised,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(event.kind.label, color: Palette.crimsonLight),
              const SizedBox(height: 8),
              Text(event.name, style: textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                event.yearsLabel,
                style: textTheme.labelSmall?.copyWith(color: Palette.gold),
              ),
              const SizedBox(height: 12),
              Text(
                event.note,
                style: textTheme.bodyMedium?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (d) {
        if (_at(d.localPosition.dx) case final event?) _open(context, event);
      },
      child: SizedBox(
        height: height,
        child: CustomPaint(
          painter: _EventRailPainter(
            events: events,
            fromYear: fromYear,
            pxPerYear: pxPerYear,
            sidePadding: sidePadding,
            textStyle:
                Theme.of(context).textTheme.labelSmall ??
                const TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}

class _EventRailPainter extends CustomPainter {
  const _EventRailPainter({
    required this.events,
    required this.fromYear,
    required this.pxPerYear,
    required this.sidePadding,
    required this.textStyle,
  });

  final List<ChurchEvent> events;
  final int fromYear;
  final double pxPerYear;
  final double sidePadding;
  final TextStyle textStyle;

  static const _markY = 7.0;
  static const _labelTop = 15.0;
  static const _labelHeight = 11.0;

  @override
  void paint(Canvas canvas, Size size) {
    double xOf(num year) => (year - fromYear) * pxPerYear + sidePadding;

    final fill = Paint()..color = Palette.crimsonLight;
    final stroke = Paint()
      ..color = Palette.crimsonLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final stem = Paint()
      ..color = Palette.crimsonLight.withValues(alpha: 0.35)
      ..strokeWidth = 1;

    for (final event in events) {
      final left = xOf(event.year);
      final right = xOf(event.lastYear);
      final paint = event.kind == ChurchEventKind.concilio ? fill : stroke;
      if (right - left >= 4) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(left, _markY - 2.5, right, _markY + 2.5),
            const Radius.circular(2.5),
          ),
          paint,
        );
      } else {
        canvas.drawPath(
          Path()
            ..moveTo(left, _markY - 4)
            ..lineTo(left + 3.5, _markY)
            ..lineTo(left, _markY + 4)
            ..lineTo(left - 3.5, _markY)
            ..close(),
          paint,
        );
      }
      canvas.drawLine(
        Offset(left, _markY + 5),
        Offset(left, size.height),
        stem,
      );
    }

    // The names, laid out big ones first: when they do not all fit, the ones
    // that cannot be missing keep their place and the rest give way.
    final ordered = [
      for (final event in events)
        if (event.major) event,
      for (final event in events)
        if (!event.major) event,
    ];
    final taken = <Rect>[];
    for (final event in ordered) {
      final painter = TextPainter(
        text: TextSpan(
          text: event.label,
          style: textStyle.copyWith(
            fontSize: 9,
            letterSpacing: 0,
            color: event.major ? Palette.crimsonLight : Palette.parchmentDim,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      final rect = Rect.fromLTWH(
        xOf(event.year) + 5,
        _labelTop,
        painter.width,
        _labelHeight,
      );
      if (rect.right > size.width - 2) continue;
      if (taken.any((other) => other.overlaps(rect.inflate(2)))) continue;
      taken.add(rect);
      painter.paint(canvas, rect.topLeft);
    }
  }

  @override
  bool shouldRepaint(_EventRailPainter old) =>
      old.fromYear != fromYear ||
      old.pxPerYear != pxPerYear ||
      old.events.length != events.length;
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timeline_rounded, color: Palette.gold, size: 36),
            const SizedBox(height: 14),
            Text(
              total == 0
                  ? 'Todavía no hay santos en el catálogo.'
                  : 'Todavía ninguno de los $total santos tiene cargados sus '
                        'años de vida.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Palette.parchmentDim),
            ),
          ],
        ),
      ),
    );
  }
}

extension on SaintInfo {
  /// The name without the "San"/"Santa" prefix, which every bar would repeat.
  String get shortLabel {
    for (final prefix in ['San ', 'Santa ', 'Santo ', 'Beato ', 'Beata ']) {
      if (name.startsWith(prefix)) return name.substring(prefix.length);
    }
    return name;
  }
}
