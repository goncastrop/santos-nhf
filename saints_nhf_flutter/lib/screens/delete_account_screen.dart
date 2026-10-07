import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Deleting the account for good. The button only wakes up once the player
/// typed the word, and the server checks the word again.
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  /// Same word as `AccountService.confirmationWord` on the server.
  static const confirmationWord = 'BORRAR';

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const DeleteAccountScreen()),
    );
  }

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _controller = TextEditingController();
  bool _busy = false;

  bool get _confirmed =>
      _controller.text.trim().toUpperCase() ==
      DeleteAccountScreen.confirmationWord;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (!_confirmed || _busy) return;
    setState(() => _busy = true);
    final state = AppState.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await client.account.deleteMyAccount(_controller.text);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showMessage(context, friendlyError(e), error: true);
      }
      return;
    }
    // The sessions are gone on the server already: only forget this one.
    await client.auth.updateSignedInUser(null);
    state.reset();
    await state.loadAll();
    navigator.popUntil((r) => r.isFirst);
    messenger.showSnackBar(
      const SnackBar(content: Text('Tu cuenta se borró. Gracias por jugar.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = AppState.of(context);
    final cards = state.overview?.cards.length ?? 0;
    final name = state.profile?.displayName;
    return Scaffold(
      appBar: AppBar(title: const Text('BORRAR LA CUENTA')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 44,
            color: Palette.crimsonLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Esto no se puede deshacer',
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              color: Palette.crimsonLight,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Si borrás tu cuenta${name == null ? '' : ' ($name)'}, se pierde '
            'para siempre:',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          for (final line in [
            cards == 1
                ? 'Tu álbum, con la carta que tenés.'
                : 'Tu álbum, con las $cards cartas que tenés.',
            'Tus rachas, tus récords y tus puestos en los rankings.',
            'Tus amigos y tus duelos, también para ellos.',
            'Tu nombre en las trivias que ganaste, que pasa a decir '
                '"Cuenta borrada".',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6, right: 10),
                    child: Icon(Icons.circle, size: 6, color: Palette.gold),
                  ),
                  Expanded(child: Text(line, style: textTheme.bodyMedium)),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Text(
            'Si después querés volver, podés crear una cuenta nueva con el '
            'mismo email, pero empieza de cero.',
            style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
          ),
          const SizedBox(height: 28),
          Text(
            'Para confirmar, escribí ${DeleteAccountScreen.confirmationWord}:',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            enabled: !_busy,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              hintText: DeleteAccountScreen.confirmationWord,
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _delete(),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Palette.crimson,
              foregroundColor: Palette.parchment,
              disabledBackgroundColor: Palette.inkLine,
            ),
            onPressed: _confirmed && !_busy ? _delete : null,
            child: Text(_busy ? 'BORRANDO…' : 'BORRAR MI CUENTA PARA SIEMPRE'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _busy ? null : () => Navigator.of(context).pop(),
            child: const Text('MEJOR NO'),
          ),
        ],
      ),
    );
  }
}
