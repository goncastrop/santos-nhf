import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../credits.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/saint_card.dart';

/// Who makes the program and the cards.
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showMessage(context, 'No pudimos abrir el enlace.', error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('CRÉDITOS')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        children: [
          Center(
            child: Transform.rotate(
              angle: 0.06,
              child: const SaintCardBack(width: 110),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              programName.toUpperCase(),
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: Palette.gold,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(child: Ornament()),
          const SizedBox(height: 16),
          Text(
            creditsIntro,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: Palette.parchmentDim),
          ),
          const SizedBox(height: 28),
          for (final c in credits) ...[
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: c.url == null ? null : () => _open(context, c.url!),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Eyebrow(c.role),
                            const SizedBox(height: 6),
                            Text(c.name, style: textTheme.titleMedium),
                            if (c.handle != null)
                              Text(
                                c.handle!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: Palette.goldLight,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (c.url != null)
                        const Icon(
                          Icons.open_in_new_rounded,
                          size: 18,
                          color: Palette.parchmentDim,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
