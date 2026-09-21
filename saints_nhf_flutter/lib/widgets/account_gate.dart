import 'package:flutter/material.dart';

import '../screens/sign_in_screen.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/saint_card.dart';
import 'common.dart';

/// Shows [child] when signed in; otherwise an invitation to create an account.
class AccountGate extends StatelessWidget {
  const AccountGate({
    super.key,
    required this.child,
    required this.title,
    required this.message,
    this.icon = Icons.style_rounded,
  });

  final Widget child;
  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    if (state.signedIn) return child;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: -0.08,
                child: const SaintCardBack(width: 110),
              ),
              const SizedBox(height: 24),
              Eyebrow(title),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => SignInScreen.open(context),
                icon: Icon(icon, size: 18),
                label: const Text('CREAR CUENTA O INGRESAR'),
              ),
              const SizedBox(height: 10),
              Text(
                'Es gratis. Solo hace falta un email o una cuenta de Google.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: Palette.parchmentDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
