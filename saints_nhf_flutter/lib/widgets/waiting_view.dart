import 'dart:math';

import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../utils/titles.dart';
import 'common.dart';
import 'saint_illustration.dart';

/// Full screen shown while something slow is happening, with a saint to read
/// about so the wait is not empty.
class WaitingView extends StatefulWidget {
  const WaitingView({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  State<WaitingView> createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  SaintInfo? _saint;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_saint != null) return;
    final state = AppState.of(context);
    // Prefer a saint the player already collected; fall back to the catalog.
    final owned =
        state.overview?.cards.map((c) => c.saint).toList() ?? const [];
    final pool = owned.isNotEmpty
        ? owned
        : (state.catalog ?? const <SaintInfo>[]);
    final withText = pool.where((s) => s.bio.trim().isNotEmpty).toList();
    if (withText.isEmpty) return;
    _saint = withText[Random().nextInt(withText.length)];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final saint = _saint;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Palette.gold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Eyebrow(widget.title),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.subtitle!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Palette.parchmentDim,
                      ),
                    ),
                  ],
                  if (saint != null) ...[
                    const SizedBox(height: 28),
                    const Ornament(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 96,
                      height: 124,
                      child: ClipPath(
                        clipper: const ArchClipper(),
                        child: SaintIllustration(
                          url: saint.illustrationUrl,
                          name: saint.name,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      saint.name,
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: Palette.gold,
                      ),
                    ),
                    if (titlesPhrase(saint.name, saint.titles) != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        titlesPhrase(saint.name, saint.titles)!,
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Text(
                      _snippet(saint.bio),
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(height: 1.6),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The first sentences of the biography, so the wait has something short
  /// and complete to read.
  static String _snippet(String bio) {
    final text = bio.trim();
    if (text.length <= 240) return text;
    final cut = text.lastIndexOf('. ', 240);
    return cut > 80 ? text.substring(0, cut + 1) : '${text.substring(0, 240)}…';
  }
}
