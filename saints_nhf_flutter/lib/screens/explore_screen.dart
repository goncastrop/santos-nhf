import 'package:flutter/material.dart';

import '../theme.dart';
import 'catalog_screen.dart';
import 'map_screen.dart';
import 'timeline_screen.dart';

/// The Santos tab: the ways of exploring the catalog, behind one switcher.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

enum _View { list, timeline, map }

class _ExploreScreenState extends State<ExploreScreen> {
  _View _view = _View.list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: SegmentedButton<_View>(
            segments: const [
              // No icons: with them "LÍNEA DE TIEMPO" wraps to two lines on
              // a phone.
              ButtonSegment(value: _View.list, label: Text('LISTA')),
              ButtonSegment(
                value: _View.timeline,
                label: Text('LÍNEA DE TIEMPO'),
              ),
              ButtonSegment(value: _View.map, label: Text('MAPA')),
            ],
            selected: {_view},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _view = s.first),
            style: ButtonStyle(
              textStyle: WidgetStatePropertyAll(
                Theme.of(context).textTheme.labelSmall,
              ),
              side: const WidgetStatePropertyAll(
                BorderSide(color: Palette.inkLine),
              ),
              // "LÍNEA DE TIEMPO" se parte en dos renglones en un teléfono;
              // sin esto los dos quedan pegados al borde del botón.
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              ),
            ),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _view.index,
            children: const [CatalogScreen(), TimelineScreen(), MapScreen()],
          ),
        ),
      ],
    );
  }
}
