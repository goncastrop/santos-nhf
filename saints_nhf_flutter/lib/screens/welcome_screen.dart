import 'package:flutter/material.dart';

import '../help_content.dart';
import '../holiness.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'guide_screen.dart';

/// Una pantalla de la bienvenida.
class _Page {
  const _Page({
    required this.icon,
    required this.title,
    required this.body,
    this.points = const [],
  });

  final IconData icon;
  final String title;
  final String body;
  final List<String> points;
}

/// La bienvenida que se ve una sola vez, la primera vez que se abre la app.
///
/// Contesta de entrada las tres preguntas que nos hacen —qué es esto, cómo se
/// consiguen las cartas, qué se hace con ellas— y termina en lo que importa:
/// por qué los santos. Se puede saltear, y volver a verla desde Perfil.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const WelcomeScreen(),
      ),
    );
  }

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pages = PageController();
  int _index = 0;

  /// La cita del final es la del llamado universal: es la que explica por qué
  /// esto no es solo un juego de figuritas.
  static final _closing = holinessTopics.firstWhere(
    (t) => t.id == 'llamado-universal',
    orElse: () => holinessTopics.first,
  );

  static final _steps = <_Page>[
    _Page(
      icon: Icons.auto_stories_rounded,
      title: 'El santo del día',
      body: helpChapters.first.lead,
    ),
    const _Page(
      icon: Icons.wb_twilight_rounded,
      title: 'Una carta por día',
      body:
          'Al empezar te damos 5 cartas. Después, cada día te espera una '
          'nueva en la pestaña Hoy.',
      points: [
        'Si el santo que la Iglesia celebra hoy todavía te falta, es el que '
            'te toca.',
        'Nunca salen repetidas: siempre es un santo que no tenés.',
        'Lo que juntaste no se pierde ni se apuesta jugando.',
      ],
    ),
    const _Page(
      icon: Icons.sports_esports_rounded,
      title: 'Para leer y para jugar',
      body:
          'Cada tarjeta trae la vida del santo, su oración, sus libros y el '
          'fragmento del programa. Y seis puntajes para jugar.',
      points: [
        'Duelos contra El Sacristán o contra tus amigos, cuando cada uno '
            'pueda.',
        'Una pregunta por día, con su racha.',
        'El catálogo entero se puede mirar sin cuenta.',
      ],
    ),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  int get _total => _steps.length + 1;

  void _next() {
    if (_index == _total - 1) {
      Navigator.of(context).pop();
      return;
    }
    _pages.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final last = _index == _total - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: Navigator.of(context).pop,
                child: Text(last ? 'CERRAR' : 'SALTEAR'),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pages,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  for (final step in _steps) _StepView(step: step),
                  _ClosingView(topic: _closing),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _total; i++)
                  Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _index ? Palette.gold : Palette.inkLine,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _next,
                      child: Text(last ? 'EMPEZAR' : 'SIGUIENTE'),
                    ),
                  ),
                  if (last)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        GuideScreen.open(context);
                      },
                      child: const Text('Ver la guía completa'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// El marco de cada pantalla: centrado cuando sobra alto y con el texto
/// acotado a un ancho de lectura, que en una tablet el renglón de punta a
/// punta no se lee.
class _PageFrame extends StatelessWidget {
  const _PageFrame({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepView extends StatelessWidget {
  const _StepView({required this.step});

  final _Page step;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _PageFrame(
      children: [
        Center(child: _Halo(icon: step.icon)),
        const SizedBox(height: 28),
        Text(
          step.title,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        const Center(child: Ornament(width: 120)),
        const SizedBox(height: 18),
        Text(
          step.body,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(height: 1.6),
        ),
        if (step.points.isNotEmpty) const SizedBox(height: 20),
        for (final point in step.points)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4, right: 10),
                  child: Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Palette.gold,
                  ),
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

/// La última: para qué sirve todo esto.
class _ClosingView extends StatelessWidget {
  const _ClosingView({required this.topic});

  final HolinessTopic topic;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _PageFrame(
      children: [
        const Center(child: _Halo(icon: Icons.local_fire_department_rounded)),
        const SizedBox(height: 28),
        Text(
          'Por qué los santos',
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        const Center(child: Ornament(width: 120)),
        const SizedBox(height: 18),
        Text(
          'Las tarjetas son un juego. Los santos no: son gente que le creyó '
          'a Dios hasta el final, y la Iglesia los muestra porque lo que '
          'hicieron ellos se puede hacer.',
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(height: 1.6),
        ),
        const SizedBox(height: 22),
        Text(
          '«${topic.quote}»',
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: Palette.goldLight,
            fontStyle: FontStyle.italic,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          topic.source,
          textAlign: TextAlign.center,
          style: textTheme.labelSmall?.copyWith(letterSpacing: 0.5),
        ),
      ],
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Palette.inkRaised,
        border: Border.all(color: Palette.gold.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Palette.gold.withValues(alpha: 0.22),
            blurRadius: 30,
          ),
        ],
      ),
      child: Icon(icon, size: 42, color: Palette.goldLight),
    );
  }
}
