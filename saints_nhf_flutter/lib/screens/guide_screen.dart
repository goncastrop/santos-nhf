import 'package:flutter/material.dart';

import '../help_content.dart';
import '../holiness.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// "Cómo funciona": qué es la app, qué hace cada pestaña, por qué los santos
/// y las preguntas que nos hacen.
///
/// Se abre desde el signo de pregunta de la barra de arriba, y llega con la
/// sección de la pestaña donde estaba el lector ya desplegada: el que pregunta
/// desde Jugar quiere leer sobre Jugar, no el índice entero.
class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key, this.initial = HelpSection.app});

  final HelpSection initial;

  static Future<void> open(
    BuildContext context, {
    HelpSection section = HelpSection.app,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GuideScreen(initial: section)),
    );
  }

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  late final Set<HelpSection> _open = {widget.initial};
  final _keys = {
    for (final section in HelpSection.values) section: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    // Con la sección de más abajo desplegada hay que ir hasta ella; en la
    // primera no se mueve nada.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _keys[widget.initial];
      final context = key?.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 350),
        alignment: 0.05,
      );
    });
  }

  void _toggle(HelpSection section) {
    setState(() {
      if (!_open.remove(section)) _open.add(section);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CÓMO FUNCIONA')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          for (final chapter in helpChapters)
            _Section(
              key: _keys[chapter.section],
              icon: chapter.icon,
              title: chapter.title,
              open: _open.contains(chapter.section),
              onTap: () => _toggle(chapter.section),
              child: _ChapterBody(chapter: chapter),
            ),
          _Section(
            key: _keys[HelpSection.holiness],
            icon: Icons.local_fire_department_rounded,
            title: 'Por qué los santos',
            open: _open.contains(HelpSection.holiness),
            onTap: () => _toggle(HelpSection.holiness),
            child: const _HolinessBody(),
          ),
          _Section(
            key: _keys[HelpSection.faq],
            icon: Icons.help_outline_rounded,
            title: 'Preguntas frecuentes',
            open: _open.contains(HelpSection.faq),
            onTap: () => _toggle(HelpSection.faq),
            child: const _FaqBody(),
          ),
        ],
      ),
    );
  }
}

/// Un capítulo plegado, con su título siempre a la vista.
class _Section extends StatelessWidget {
  const _Section({
    super.key,
    required this.icon,
    required this.title,
    required this.open,
    required this.onTap,
    required this.child,
  });

  final IconData icon;
  final String title;
  final bool open;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(
                children: [
                  Icon(icon, color: Palette.gold, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Palette.parchment,
                      ),
                    ),
                  ),
                  Icon(
                    open
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Palette.parchmentDim,
                  ),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              child: child,
            ),
        ],
      ),
    );
  }
}

class _ChapterBody extends StatelessWidget {
  const _ChapterBody({required this.chapter});

  final HelpChapter chapter;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chapter.lead,
          style: textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        if (chapter.points.isNotEmpty) const SizedBox(height: 12),
        for (final point in chapter.points)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 7, right: 10),
                  child: _Diamond(),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Palette.parchmentDim,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Los conceptos sobre la santidad, cada uno con su cita y de dónde sale.
class _HolinessBody extends StatelessWidget {
  const _HolinessBody();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Las tarjetas son un juego, pero los santos no. Esto es lo que la '
          'Iglesia dice de ellos, con la fuente a mano para leerla entera.',
          style: textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 18),
        for (final topic in holinessTopics) ...[
          HolinessTopicView(topic: topic),
          if (topic != holinessTopics.last) const SizedBox(height: 22),
        ],
      ],
    );
  }
}

/// Un concepto: el título, la explicación, la cita y su referencia.
class HolinessTopicView extends StatelessWidget {
  const HolinessTopicView({super.key, required this.topic});

  final HolinessTopic topic;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topic.title,
          style: textTheme.titleSmall?.copyWith(
            color: Palette.goldLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          topic.body,
          style: textTheme.bodyMedium?.copyWith(
            color: Palette.parchmentDim,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: const BoxDecoration(
            color: Palette.ink,
            border: Border(left: BorderSide(color: Palette.gold, width: 2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '«${topic.quote}»',
                style: textTheme.bodyMedium?.copyWith(
                  color: Palette.parchment,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => openLink(context, topic.url),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        topic.source,
                        style: textTheme.labelSmall?.copyWith(
                          color: Palette.gold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 14,
                      color: Palette.gold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqBody extends StatelessWidget {
  const _FaqBody();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final faq in faqs)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: textTheme.titleSmall?.copyWith(
                    color: Palette.goldLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  faq.answer,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Palette.parchmentDim,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Diamond extends StatelessWidget {
  const _Diamond();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398,
      child: Container(width: 5, height: 5, color: Palette.gold),
    );
  }
}
