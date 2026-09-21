import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../utils/world.dart';
import '../utils/years.dart';
import '../widgets/common.dart';
import '../widgets/saint_illustration.dart';
import 'saint_detail_screen.dart';

/// Where the saints came from and where they died, on a world map drawn by
/// the app itself: no tiles, no map service, no key. It works offline like
/// the rest of the catalog.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

/// Which end of the life the map is showing.
enum _Moment {
  birth('NACIÓ'),
  death('MURIÓ');

  const _Moment(this.label);

  final String label;
}

/// A saint placed on the map: the point being shown and, when it is known,
/// the other end of their life.
typedef _Placed = ({SaintInfo saint, Offset at, Offset? other, String? place});

/// One marker: a single saint, or the several that fall on the same spot.
/// [separable] is false when they are so close together that no amount of
/// zoom pulls them apart — several saints of the same city, typically.
typedef _Group = ({List<_Placed> members, Offset at, bool separable});

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  final _view = TransformationController();
  late final Future<WorldOutlines> _world = WorldOutlines.load();
  late final AnimationController _zoomer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  Animation<Matrix4>? _zoomTo;

  _Moment _moment = _Moment.birth;
  Size _viewport = Size.zero;

  static const _minScale = 1.0;

  /// Al ancho de un teléfono, 60x deja unos 60 px por grado: alcanza para
  /// separar ciudades vecinas. Con 12x, Roma y Nápoles quedaban pegadas.
  static const _maxScale = 60.0;

  /// Above this the markers are worth drawing as faces instead of dots.
  static const _faceFrom = 2.4;

  /// Saints closer than this on screen are shown as one marker with a count.
  static const _clusterPx = 30.0;

  @override
  void initState() {
    super.initState();
    _zoomer.addListener(() {
      if (_zoomTo case final tween?) _view.value = tween.value;
    });
  }

  @override
  void dispose() {
    _zoomer.dispose();
    _view.dispose();
    super.dispose();
  }

  double get _scale => _view.value.getMaxScaleOnAxis();

  /// Zooms about the middle of the screen, which is what the buttons mean.
  void _zoomBy(double factor) {
    if (_viewport.isEmpty) return;
    _zoomAround(_viewport.center(Offset.zero), factor);
  }

  /// Zooms about [focus], a point in viewport coordinates.
  void _zoomAround(Offset focus, double factor) {
    final from = _scale;
    final to = (from * factor).clamp(_minScale, _maxScale);
    if (to == from) return;
    final step = to / from;
    final zoom = Matrix4.identity()
      ..translateByDouble(focus.dx, focus.dy, 0, 1)
      ..scaleByDouble(step, step, 1, 1)
      ..translateByDouble(-focus.dx, -focus.dy, 0, 1);
    _animateTo(zoom * _view.value);
  }

  void _reset() => _animateTo(Matrix4.identity());

  void _animateTo(Matrix4 target) {
    _zoomTo = Matrix4Tween(begin: _view.value, end: target).animate(
      CurvedAnimation(parent: _zoomer, curve: Curves.easeOutCubic),
    );
    _zoomer.forward(from: 0);
  }

  ({double lat, double lng})? _coords(SaintInfo saint, _Moment moment) {
    final lat = moment == _Moment.birth ? saint.birthLat : saint.deathLat;
    final lng = moment == _Moment.birth ? saint.birthLng : saint.deathLng;
    if (lat == null || lng == null) return null;
    return (lat: lat, lng: lng);
  }

  /// The saints that can be drawn right now, in map coordinates.
  List<_Placed> _place(List<SaintInfo> catalog, Size map, Set<int> owned) {
    final other = _moment == _Moment.birth ? _Moment.death : _Moment.birth;
    Offset at(({double lat, double lng}) c) => Offset(
      Mercator.x(c.lng) * map.width,
      Mercator.yInCrop(c.lat) * map.height,
    );
    final placed = [
      for (final saint in catalog)
        if (_coords(saint, _moment) case final here?)
          (
            saint: saint,
            at: at(here),
            other: switch (_coords(saint, other)) {
              final there? => at(there),
              _ => null,
            },
            place: _moment == _Moment.birth
                ? saint.birthPlace
                : saint.deathPlace,
          ),
    ];
    // The ones already in the album go last so they land on top.
    placed.sort(
      (a, b) => (owned.contains(a.saint.id) ? 1 : 0).compareTo(
        owned.contains(b.saint.id) ? 1 : 0,
      ),
    );
    return placed;
  }

  /// Buckets the saints that land on the same patch of screen, so Italy is
  /// not a pile of overlapping faces. Zooming in makes the buckets smaller
  /// in map units, so the groups come apart on their own.
  List<_Group> _cluster(List<_Placed> placed, double scale) {
    final cell = _clusterPx / scale;
    final buckets = <({int x, int y}), List<_Placed>>{};
    for (final p in placed) {
      final key = (x: (p.at.dx / cell).floor(), y: (p.at.dy / cell).floor());
      buckets.putIfAbsent(key, () => []).add(p);
    }
    return [
      for (final members in buckets.values)
        (
          members: members,
          at: members.length == 1
              ? members.single.at
              : Offset(
                  members.map((m) => m.at.dx).reduce((a, b) => a + b) /
                      members.length,
                  members.map((m) => m.at.dy).reduce((a, b) => a + b) /
                      members.length,
                ),
          separable:
              members.length > 1 && _spread(members) * _maxScale >= _clusterPx,
        ),
    ];
  }

  /// How far apart the two most distant members are, in map units.
  double _spread(List<_Placed> members) {
    var worst = 0.0;
    for (var i = 0; i < members.length; i++) {
      for (var j = i + 1; j < members.length; j++) {
        worst = math.max(worst, (members[i].at - members[j].at).distance);
      }
    }
    return worst;
  }

  /// Several saints of the same city never come apart, so tapping the group
  /// lists them instead of zooming into a pile that will not change.
  void _openGroup(_Group group, Size map) {
    if (group.separable) {
      _zoomAround(_focusOf(group.at, map), 2.4);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Palette.inkRaised,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: Eyebrow(
                group.members.first.place ??
                    '${group.members.length} santos acá',
              ),
            ),
            for (final member in group.members)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Palette.ink,
                  child: Text(
                    saintInitials(member.saint.name),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Palette.gold,
                    ),
                  ),
                ),
                title: Text(member.saint.name),
                subtitle: Text(
                  [?member.place, ?lifespanLabel(member.saint)].join(' · '),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  SaintDetailScreen.open(context, member.saint.id);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final catalog = state.catalog ?? const <SaintInfo>[];
    final withPlace = catalog.where((s) => _coords(s, _moment) != null).length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  withPlace == catalog.length
                      ? '${catalog.length} santos'
                      : '$withPlace ubicados · '
                            '${catalog.length - withPlace} sin lugar',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Palette.parchmentDim),
                ),
              ),
              for (final moment in _Moment.values)
                _MomentButton(
                  label: moment.label,
                  selected: moment == _moment,
                  onTap: () => setState(() => _moment = moment),
                ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<WorldOutlines>(
            future: _world,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ErrorView(
                  error: snapshot.error!,
                  onRetry: () => setState(() {}),
                );
              }
              final world = snapshot.data;
              if (world == null) return const LoadingView();
              return LayoutBuilder(
                builder: (context, constraints) {
                  _viewport = constraints.biggest;
                  // `InteractiveViewer` lays its child out at the size of the
                  // viewport, so the map is drawn inside that box, as big as
                  // it can be without losing Mercator's proportions.
                  final width = math.min(
                    constraints.maxWidth,
                    constraints.maxHeight / Mercator.aspectRatio,
                  );
                  final map = Size(width, width * Mercator.aspectRatio);
                  final placed = _place(catalog, map, state.ownedIds);
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: InteractiveViewer(
                          transformationController: _view,
                          minScale: _minScale,
                          maxScale: _maxScale,
                          boundaryMargin: const EdgeInsets.all(40),
                          child: Center(
                            child: SizedBox.fromSize(
                              size: map,
                              // Both the coastline and the markers have to
                              // undo the zoom: otherwise the outline thickens
                              // into a gold smear and the faces balloon.
                              child: AnimatedBuilder(
                                animation: _view,
                                builder: (context, _) => _chart(
                                  world: world,
                                  placed: placed,
                                  owned: state.ownedIds,
                                  map: map,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: AnimatedBuilder(
                          animation: _view,
                          builder: (context, _) => _ZoomButtons(
                            canZoomIn: _scale < _maxScale - 0.01,
                            canZoomOut: _scale > _minScale + 0.01,
                            onIn: () => _zoomBy(1.8),
                            onOut: () => _zoomBy(1 / 1.8),
                            onReset: _scale > _minScale + 0.01 ? _reset : null,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _chart({
    required WorldOutlines world,
    required List<_Placed> placed,
    required Set<int> owned,
    required Size map,
  }) {
    final scale = _scale;
    final groups = _cluster(placed, scale);
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _WorldPainter(
              world: world,
              placed: placed,
              scale: scale,
              owned: owned,
            ),
          ),
        ),
        for (final group in groups)
          if (group.members.length == 1)
            _Marker(
              placed: group.members.single,
              owned: owned.contains(group.members.single.saint.id),
              scale: scale,
              showFace: scale >= _faceFrom,
            )
          else
            _Cluster(
              group: group,
              owned: owned,
              scale: scale,
              onTap: () => _openGroup(group, map),
            ),
      ],
    );
  }

  /// Turns a point in map coordinates into one in viewport coordinates, for
  /// zooming about a marker.
  Offset _focusOf(Offset inMap, Size map) {
    final centred =
        inMap + (_viewport.center(Offset.zero) - map.center(Offset.zero));
    return MatrixUtils.transformPoint(_view.value, centred);
  }
}

/// A saint's place on the map: a dot from far away, a face up close.
class _Marker extends StatelessWidget {
  const _Marker({
    required this.placed,
    required this.owned,
    required this.scale,
    required this.showFace,
  });

  static const _dotSize = 11.0;
  static const _faceSize = 30.0;

  /// The tap target never shrinks below this, however small the dot looks.
  static const touchSize = 34.0;

  final _Placed placed;
  final bool owned;
  final double scale;
  final bool showFace;

  SaintInfo get saint => placed.saint;

  @override
  Widget build(BuildContext context) {
    final color = owned ? Palette.gold : Palette.parchmentDim;
    final size = showFace ? _faceSize : _dotSize;
    return _Anchored(
      at: placed.at,
      scale: scale,
      child: Tooltip(
        message: [saint.name, ?placed.place, ?lifespanLabel(saint)].join('\n'),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => SaintDetailScreen.open(context, saint.id),
            child: Center(
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: showFace
                      ? Palette.inkRaised
                      : color.withValues(alpha: owned ? 0.95 : 0.6),
                  border: Border.all(
                    color: color.withValues(alpha: owned ? 0.95 : 0.6),
                    width: showFace ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 5,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: showFace ? _face(color) : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _face(Color color) {
    if (saint.illustrationUrl == null) {
      return Center(
        child: Text(
          saintInitials(saint.name),
          maxLines: 1,
          style: TextStyle(fontSize: 11, height: 1, color: color),
        ),
      );
    }
    return SaintIllustration(
      url: saint.illustrationUrl,
      name: saint.name,
      grayscale: !owned,
      alignment: Alignment.topCenter,
    );
  }
}

/// Several saints on the same patch of map, as one marker with the count.
class _Cluster extends StatelessWidget {
  const _Cluster({
    required this.group,
    required this.owned,
    required this.scale,
    required this.onTap,
  });

  final _Group group;
  final Set<int> owned;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mine = group.members.where((m) => owned.contains(m.saint.id)).length;
    final color = mine > 0 ? Palette.gold : Palette.parchmentDim;
    final names = group.members.map((m) => m.saint.name).toList();
    return _Anchored(
      at: group.at,
      scale: scale,
      child: Tooltip(
        message: [
          group.separable
              ? '${names.length} santos acá · tocá para acercar'
              : '${names.length} santos acá · tocá para verlos',
          ...names.take(6),
          if (names.length > 6) 'y ${names.length - 6} más',
        ].join('\n'),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Palette.ink.withValues(alpha: 0.92),
                  border: Border.all(
                    color: color.withValues(alpha: 0.9),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  '${group.members.length}',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1,
                    color: color,
                    fontWeight: FontWeight.w600,
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

/// Pins its child on a point of the map at a size the zoom does not change.
class _Anchored extends StatelessWidget {
  const _Anchored({
    required this.at,
    required this.scale,
    required this.child,
  });

  final Offset at;
  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // The box is centred on the point and sized in the map's own units, so
    // scaling its contents down by the zoom leaves the marker the same size
    // on screen, still anchored on the point.
    return Positioned(
      left: at.dx - _Marker.touchSize / 2,
      top: at.dy - _Marker.touchSize / 2,
      width: _Marker.touchSize,
      height: _Marker.touchSize,
      child: Transform.scale(scale: 1 / scale, child: child),
    );
  }
}

class _WorldPainter extends CustomPainter {
  const _WorldPainter({
    required this.world,
    required this.placed,
    required this.scale,
    required this.owned,
  });

  final WorldOutlines world;
  final List<_Placed> placed;
  final Set<int> owned;

  /// The zoom the map is at, so the coastline keeps its hairline width.
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Palette.inkRaised.withValues(alpha: 0.45),
    );
    final land = Paint()..color = const Color(0xFF221D3C);
    final coast = Paint()
      ..color = Palette.goldDark.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9 / scale;

    for (final ring in world.rings) {
      final path = Path();
      for (var i = 0; i < ring.length; i += 2) {
        final x = Mercator.x(ring[i]) * size.width;
        final y = Mercator.yInCrop(ring[i + 1]) * size.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, land);
      canvas.drawPath(path, coast);
    }

    // The thread to the other end of each life: from where they were born to
    // where they died, or the other way round. Faint, because fifty-seven of
    // them at once would be a net.
    for (final p in placed) {
      if (p.other case final there?) {
        final mine = owned.contains(p.saint.id);
        canvas.drawLine(
          p.at,
          there,
          Paint()
            ..color = (mine ? Palette.gold : Palette.parchmentDim).withValues(
              alpha: mine ? 0.5 : 0.22,
            )
            ..strokeWidth = (mine ? 1.2 : 0.9) / scale,
        );
        canvas.drawCircle(
          there,
          2.2 / scale,
          Paint()
            ..color = (mine ? Palette.gold : Palette.parchmentDim).withValues(
              alpha: mine ? 0.7 : 0.35,
            ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_WorldPainter old) =>
      old.world != world || old.scale != scale || old.placed != placed;
}

/// The zoom controls. A trackpad or two fingers do the same thing, but with
/// a mouse on the desktop app there is no obvious way in.
class _ZoomButtons extends StatelessWidget {
  const _ZoomButtons({
    required this.canZoomIn,
    required this.canZoomOut,
    required this.onIn,
    required this.onOut,
    required this.onReset,
  });

  final bool canZoomIn;
  final bool canZoomOut;
  final VoidCallback onIn;
  final VoidCallback onOut;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onReset != null) ...[
          _ZoomButton(
            icon: Icons.fullscreen_exit_rounded,
            tooltip: 'Ver todo el mundo',
            onTap: onReset,
          ),
          const SizedBox(height: 8),
        ],
        _ZoomButton(
          icon: Icons.add_rounded,
          tooltip: 'Acercar',
          onTap: canZoomIn ? onIn : null,
        ),
        const SizedBox(height: 8),
        _ZoomButton(
          icon: Icons.remove_rounded,
          tooltip: 'Alejar',
          onTap: canZoomOut ? onOut : null,
        ),
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Palette.ink.withValues(alpha: 0.85),
        shape: CircleBorder(
          side: BorderSide(
            color: Palette.gold.withValues(alpha: enabled ? 0.6 : 0.2),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(
              icon,
              size: 20,
              color: Palette.gold.withValues(alpha: enabled ? 1 : 0.3),
            ),
          ),
        ),
      ),
    );
  }
}

class _MomentButton extends StatelessWidget {
  const _MomentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
            label,
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
