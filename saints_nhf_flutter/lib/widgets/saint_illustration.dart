import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

/// Clips its child into a church-window arch: straight sides, rounded top.
class ArchClipper extends CustomClipper<Path> {
  const ArchClipper({this.archRatio = 0.5});

  /// Height of the arch as a fraction of the width.
  final double archRatio;

  @override
  Path getClip(Size size) {
    final r = size.width * archRatio;
    return Path()
      ..moveTo(0, size.height)
      ..lineTo(0, r)
      ..arcToPoint(
        Offset(size.width, r),
        radius: Radius.elliptical(size.width / 2, r),
      )
      ..lineTo(size.width, size.height)
      ..close();
  }

  @override
  bool shouldReclip(ArchClipper oldClipper) =>
      oldClipper.archRatio != archRatio;
}

/// The saint's illustration, or a gilded monogram when none was uploaded.
class SaintIllustration extends StatelessWidget {
  const SaintIllustration({
    super.key,
    required this.url,
    required this.name,
    this.fit = BoxFit.cover,
    this.grayscale = false,
    this.alignment = Alignment.center,
  });

  final String? url;
  final String name;
  final BoxFit fit;
  final bool grayscale;

  /// Which part of the image survives the crop when it does not fit.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    Widget child = url == null
        ? _Monogram(name: name)
        : kIsWeb
        // The browser already caches images, and the file cache used by
        // cached_network_image is not available on the web.
        ? Image.network(
            url!,
            fit: fit,
            alignment: alignment,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) => _Monogram(name: name),
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const ColoredBox(color: Palette.inkRaised),
          )
        : CachedNetworkImage(
            imageUrl: url!,
            fit: fit,
            alignment: alignment,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (_, _) => const ColoredBox(color: Palette.inkRaised),
            errorWidget: (_, _, _) => _Monogram(name: name),
          );
    if (grayscale) {
      child = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0, 0, 0, 1, 0,
        ]),
        child: child,
      );
    }
    return child;
  }
}

/// The one or two letters that stand for a saint without an illustration.
String saintInitials(String name) {
  final words = name
      .replaceAll(RegExp(r'^(San|Santa|Santo|Beato|Beata)\s+'), '')
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty && w[0].toUpperCase() == w[0])
      .toList();
  if (words.isEmpty) {
    return name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();
  }
  return words.take(2).map((w) => w[0].toUpperCase()).join();
}

class _Monogram extends StatelessWidget {
  const _Monogram({required this.name});

  final String name;

  String get _initials => saintInitials(name);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.2),
              radius: 0.9,
              colors: [Color(0xFF3A2F5C), Palette.inkRaised, Palette.ink],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Halo.
              Container(
                width: size * 0.62,
                height: size * 0.62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Palette.gold.withValues(alpha: 0.55),
                    width: size * 0.012,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.gold.withValues(alpha: 0.25),
                      blurRadius: size * 0.12,
                    ),
                  ],
                ),
              ),
              Text(
                _initials,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: size * 0.3,
                  color: Palette.goldLight,
                  height: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
