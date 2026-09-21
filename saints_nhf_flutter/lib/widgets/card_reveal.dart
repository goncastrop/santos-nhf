import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../theme.dart';
import 'saint_card.dart';

/// Ceremony for a newly obtained card.
///
/// The card back lifts and glows, flips over, a burst of gold sparks flies
/// out at the moment of the turn, a light sweep crosses the front and the
/// card settles with a small bounce. Runs once when [revealed] becomes true.
class CardReveal extends StatefulWidget {
  const CardReveal({
    super.key,
    required this.card,
    required this.width,
    required this.revealed,
    this.delay = Duration.zero,
    this.onDone,
  });

  final CollectedCard card;
  final double width;
  final bool revealed;

  /// Wait before starting, to stagger several reveals.
  final Duration delay;
  final VoidCallback? onDone;

  @override
  State<CardReveal> createState() => _CardRevealState();
}

class _CardRevealState extends State<CardReveal>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );
  final _sparks = List.generate(28, (i) => _Spark.random(i));

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone?.call();
    });
    if (widget.revealed) _start();
  }

  @override
  void didUpdateWidget(covariant CardReveal old) {
    super.didUpdateWidget(old);
    if (widget.revealed && !old.revealed) _start();
    if (widget.card.saint.id != old.card.saint.id && widget.revealed) {
      _controller.value = 1; // A different card already revealed: no replay.
    }
  }

  Future<void> _start() async {
    if (widget.delay > Duration.zero) await Future.delayed(widget.delay);
    if (mounted) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width;
    final h = w / cardAspectRatio;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        // Phases (fractions of the whole animation).
        final lift = Curves.easeOut.transform(_seg(t, 0.0, 0.22));
        final flip = Curves.easeInOutCubic.transform(_seg(t, 0.18, 0.55));
        final burst = _seg(t, 0.36, 0.95);
        final sweep = _seg(t, 0.55, 0.85);
        final settle = Curves.elasticOut.transform(_seg(t, 0.55, 1.0));
        final glow = math.sin(math.pi * _seg(t, 0.0, 0.6));

        final angle = flip * math.pi;
        final showFront = angle > math.pi / 2;
        final scale = 1 + 0.10 * lift - 0.10 * settle;
        final dy = -18.0 * lift + 18.0 * settle;

        Widget face = showFront
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(math.pi),
                child: _withSweep(
                  SaintCard(
                    saint: widget.card.saint,
                    scores: widget.card.scores,
                    width: w,
                  ),
                  sweep,
                ),
              )
            : SaintCardBack(width: w);

        return SizedBox(
          width: w + 80,
          height: h + 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Halo behind the card.
              IgnorePointer(
                child: Container(
                  width: w * (0.9 + 0.4 * glow),
                  height: h * (0.9 + 0.3 * glow),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Palette.gold.withValues(alpha: 0.55 * glow),
                        blurRadius: 60 * glow + 10,
                        spreadRadius: 10 * glow,
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, dy),
                child: Transform.scale(
                  scale: scale,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0012)
                      ..rotateY(angle),
                    child: face,
                  ),
                ),
              ),
              if (burst > 0 && burst < 1)
                IgnorePointer(
                  child: CustomPaint(
                    size: Size(w + 80, h + 80),
                    painter: _SparksPainter(sparks: _sparks, t: burst),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Progress of [t] inside the [from, to] segment, clamped to 0..1.
  static double _seg(double t, double from, double to) =>
      ((t - from) / (to - from)).clamp(0.0, 1.0);

  /// A diagonal band of light crossing the card once.
  Widget _withSweep(Widget child, double sweep) {
    if (sweep <= 0 || sweep >= 1) return child;
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.width * 0.075),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.5 + 3 * sweep, -1),
                    end: Alignment(-0.5 + 3 * sweep, 1),
                    colors: [
                      Colors.transparent,
                      Palette.goldLight.withValues(alpha: 0.35),
                      Colors.white.withValues(alpha: 0.55),
                      Palette.goldLight.withValues(alpha: 0.35),
                      Colors.transparent,
                    ],
                    stops: const [0.35, 0.45, 0.5, 0.55, 0.65],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Spark {
  _Spark(this.angle, this.distance, this.size, this.delay, this.isDiamond);

  factory _Spark.random(int seed) {
    final r = math.Random(seed * 7919);
    return _Spark(
      r.nextDouble() * 2 * math.pi,
      0.55 + r.nextDouble() * 0.6,
      2.0 + r.nextDouble() * 3.5,
      r.nextDouble() * 0.25,
      r.nextBool(),
    );
  }

  final double angle;
  final double distance; // Fraction of the half-diagonal.
  final double size;
  final double delay;
  final bool isDiamond;
}

class _SparksPainter extends CustomPainter {
  const _SparksPainter({required this.sparks, required this.t});

  final List<_Spark> sparks;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final reach = size.shortestSide * 0.55;
    for (final s in sparks) {
      final local = ((t - s.delay) / (1 - s.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final ease = Curves.easeOutCubic.transform(local);
      final fade = (1 - local).clamp(0.0, 1.0);
      final p =
          center +
          Offset(math.cos(s.angle), math.sin(s.angle)) *
              (reach * s.distance * ease) +
          Offset(0, 30 * local * local); // A little gravity.
      final paint = Paint()
        ..color = Color.lerp(
          Palette.goldLight,
          Palette.gold,
          local,
        )!.withValues(alpha: fade);
      final r = s.size * (1 - 0.5 * local);
      if (s.isDiamond) {
        final path = Path()
          ..moveTo(p.dx, p.dy - r * 1.6)
          ..lineTo(p.dx + r, p.dy)
          ..lineTo(p.dx, p.dy + r * 1.6)
          ..lineTo(p.dx - r, p.dy)
          ..close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawCircle(p, r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SparksPainter old) => old.t != t;
}
