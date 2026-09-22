import 'package:flutter/material.dart';

import '../help_content.dart';
import '../holiness.dart';
import '../screens/guide_screen.dart';
import '../theme.dart';
import 'common.dart';

/// La idea sobre la santidad que toca hoy, en la pestaña Hoy.
///
/// Rota sola con el día y es la misma para todos. Está acá y no solo en la
/// guía porque esto es lo que la app quiere decir, y a la ayuda entra el que
/// tiene una duda, no el que viene todos los días a buscar su carta.
class HolinessCard extends StatelessWidget {
  const HolinessCard({super.key, required this.day});

  /// Clave del día argentino (`yyyy-MM-dd`).
  final String day;

  @override
  Widget build(BuildContext context) {
    final topic = topicOfTheDay(day);
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => GuideScreen.open(context, section: HelpSection.holiness),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 14,
                    color: Palette.gold,
                  ),
                  const SizedBox(width: 6),
                  const Eyebrow('Sobre la santidad'),
                  const Spacer(),
                  Text(
                    'LEER MÁS',
                    style: textTheme.labelSmall?.copyWith(
                      color: Palette.goldLight,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                topic.title,
                style: textTheme.titleSmall?.copyWith(
                  color: Palette.parchment,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '«${topic.quote}»',
                style: textTheme.bodyMedium?.copyWith(
                  color: Palette.parchmentDim,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                topic.source,
                style: textTheme.labelSmall?.copyWith(
                  color: Palette.gold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
