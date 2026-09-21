import 'dart:convert';
import 'dart:math' as math;

import 'dart:typed_data';

import 'package:flutter/services.dart';

/// The coastlines and national borders that the map is drawn from, loaded
/// once from `assets/world.json`.
///
/// There is no map service behind the map: the outlines travel inside the app
/// and get painted by us, so it works offline and costs nothing. See
/// `assets/world.LEEME.md` for where the data comes from.
class WorldOutlines {
  const WorldOutlines._(this.rings);

  /// Each ring is a flat list of `lng, lat, lng, lat, …`.
  final List<Float32List> rings;

  static WorldOutlines? _loaded;
  static Future<WorldOutlines>? _loading;

  /// Reads the asset the first time and keeps it: switching views should not
  /// re-parse it.
  static Future<WorldOutlines> load() {
    if (_loaded case final ready?) return Future.value(ready);
    return _loading ??= rootBundle.loadString('assets/world.json').then((raw) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final rings = [
        for (final ring in decoded)
          Float32List.fromList([
            for (final value in ring as List<dynamic>)
              (value as num).toDouble(),
          ]),
      ];
      return _loaded = WorldOutlines._(rings);
    });
  }
}

/// Web Mercator, the projection every map reader already has in their head.
///
/// It is cut off near the poles, where it stretches to infinity; nothing in
/// the catalog lives there.
class Mercator {
  const Mercator._();

  /// Beyond this the stretching is absurd and no saint is up there anyway.
  static const maxLatitude = 83.0;

  /// Longitude to a 0..1 fraction of the world's width.
  static double x(double lng) => (lng + 180) / 360;

  /// Latitude to a 0..1 fraction of the world's height, top down.
  static double y(double lat) {
    final clamped = lat.clamp(-maxLatitude, maxLatitude);
    final radians = clamped * math.pi / 180;
    final merc = math.log(math.tan(math.pi / 4 + radians / 2));
    return 0.5 - merc / (2 * math.pi);
  }

  /// The height of the whole world, as a fraction of its width.
  static double get aspectRatio => y(-maxLatitude) - y(maxLatitude);

  /// [y] measured from the top of the cropped world instead of the equator,
  /// so the drawing has no empty bands above and below.
  static double yInCrop(double lat) => (y(lat) - y(maxLatitude)) / aspectRatio;
}
