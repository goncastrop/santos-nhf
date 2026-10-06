import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';
import 'credits.dart';
import 'screens/home_shell.dart';
import 'state/app_state.dart';
import 'state/live_state.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const SantosApp());
}

class SantosApp extends StatefulWidget {
  const SantosApp({super.key});

  @override
  State<SantosApp> createState() => _SantosAppState();
}

class _SantosAppState extends State<SantosApp> {
  final _state = AppState();
  final _live = LiveState();

  @override
  void dispose() {
    _state.dispose();
    _live.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: _state,
      child: LiveStateScope(
        state: _live,
        child: MaterialApp(
          title: 'Santos NHF',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          // Let the mouse drag lists too, so pull-to-refresh works on web and
          // desktop, not only on touch screens.
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.stylus,
            },
          ),
          home: const _AuthGate(),
        ),
      ),
    );
  }
}

/// Keeps the app state in sync with the session: reloads on sign-in and
/// clears everything on sign-out. The catalog is public, so the shell is
/// always shown; sections that need an account show a prompt instead.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> with WidgetsBindingObserver {
  bool _wasSignedIn = false;

  @override
  void initState() {
    super.initState();
    _wasSignedIn = client.auth.isAuthenticated;
    client.auth.authInfoListenable.addListener(_onAuthChanged);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppState.of(context).watchDayChange();
      LiveState.of(context).start();
      // El logo va en el dorso de todas las cartas: cargado de antemano, no
      // aparece tarde en la primera animación de carta nueva.
      precacheImage(const AssetImage(programLogoAsset), context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A phone asleep or a background browser tab does not run timers, so the
    // rollover is also checked whenever the app comes back.
    if (state == AppLifecycleState.resumed) {
      AppState.of(context).checkDayChange();
      LiveState.of(context).start();
    } else if (state == AppLifecycleState.paused) {
      // In the background nobody sees the banner: no point keeping a socket.
      LiveState.of(context).stop();
    }
  }

  void _onAuthChanged() {
    final signedIn = client.auth.isAuthenticated;
    if (signedIn == _wasSignedIn) return;
    _wasSignedIn = signedIn;
    final state = AppState.of(context);
    LiveState.of(context).restart();
    if (signedIn) {
      state.loadAll();
    } else {
      state.reset();
      state.loadAll();
    }
  }

  @override
  Widget build(BuildContext context) => const HomeShell();
}
