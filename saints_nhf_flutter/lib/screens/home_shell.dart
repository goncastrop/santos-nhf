import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../utils/feast.dart';
import '../widgets/common.dart';
import 'album_screen.dart';
import 'explore_screen.dart';
import 'friends/friends_screen.dart';
import 'play/play_screen.dart';
import 'profile_screen.dart';
import 'sign_in_screen.dart';
import '../widgets/account_gate.dart';
import 'today_screen.dart';

/// Bottom-navigation shell shown once the user is signed in.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  bool _initialised = false;

  static const _titles = ['Hoy', 'Santos', 'Álbum', 'Jugar', 'Amigos'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = AppState.of(context);
      if (state.catalog == null && !state.loading) state.loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    if (!_initialised) {
      _initialised = true;
      if (!state.signedIn) _index = 1; // Visitors land on the catalog.
    }
    final pending = state.pendingTurns;
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index].toUpperCase()),
        actions: [
          if (!state.signedIn)
            TextButton(
              onPressed: () => SignInScreen.open(context),
              child: const Text('INGRESAR'),
            )
          else
            IconButton(
              tooltip: 'Perfil',
              icon: Icon(
                state.isAdmin
                    ? Icons.admin_panel_settings_outlined
                    : Icons.person_outline_rounded,
                color: Palette.gold,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
            ),
        ],
      ),
      body: switch ((state.catalog == null, state.error)) {
        (true, null) => const LoadingView(),
        (true, final Object error) => ErrorView(
          error: error,
          onRetry: state.loadAll,
        ),
        _ => Column(
          children: [
            if (state.offline) _OfflineBanner(state: state),
            Expanded(
              child: IndexedStack(
                index: _index,
                children: const [
                  AccountGate(
                    title: 'Tu carta del día',
                    message:
                        'Con una cuenta recibís una carta nueva cada día, '
                        'respondés la pregunta diaria y armás tu álbum.',
                    icon: Icons.wb_twilight_rounded,
                    child: TodayScreen(),
                  ),
                  ExploreScreen(),
                  AccountGate(
                    title: 'Tu álbum',
                    message:
                        'Las cartas que vas coleccionando se guardan en tu '
                        'cuenta, con los puntajes de cada santo.',
                    child: AlbumScreen(),
                  ),
                  AccountGate(
                    title: 'Jugar',
                    message:
                        'Los duelos y los juegos usan las cartas de tu '
                        'álbum. Creá tu cuenta para empezar a jugar.',
                    icon: Icons.sports_esports_rounded,
                    child: PlayScreen(),
                  ),
                  AccountGate(
                    title: 'Amigos',
                    message:
                        'Sumá amigos con su código, mirá sus álbumes y '
                        'desafialos a un duelo.',
                    icon: Icons.group_rounded,
                    child: FriendsScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.wb_twilight_outlined),
            selectedIcon: Icon(Icons.wb_twilight_rounded),
            label: 'HOY',
          ),
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'SANTOS',
          ),
          const NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style_rounded),
            label: 'ÁLBUM',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: pending > 0,
              label: Text('$pending'),
              backgroundColor: Palette.crimson,
              child: const Icon(Icons.sports_esports_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: pending > 0,
              label: Text('$pending'),
              backgroundColor: Palette.crimson,
              child: const Icon(Icons.sports_esports_rounded),
            ),
            label: 'JUGAR',
          ),
          const NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group_rounded),
            label: 'AMIGOS',
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final when = state.cachedAt;
    return Material(
      color: const Color(0xFF3A2A12),
      child: InkWell(
        onTap: state.loading ? null : state.loadAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 16,
                color: Palette.gold,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  when == null
                      ? 'Sin conexión. Ves tu álbum guardado en el dispositivo.'
                      : 'Sin conexión. Datos guardados el ${dateTimeShort(when)}.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Palette.parchment,
                  ),
                ),
              ),
              Text(
                state.loading ? '…' : 'REINTENTAR',
                style: textTheme.labelSmall?.copyWith(color: Palette.goldLight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
