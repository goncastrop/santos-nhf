import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'delete_account_screen.dart';
import 'admin/admin_catalog_screen.dart';
import 'admin/admin_codes_screen.dart';
import 'admin/admin_live_screen.dart';
import 'admin/admin_saints_screen.dart';
import 'credits_screen.dart';
import 'guide_screen.dart';
import 'welcome_screen.dart';
import 'admin/admin_users_screen.dart';

/// Account info, sign-out and the door to the admin panel.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _busy = false;

  Future<void> _requestAccess() async {
    final state = AppState.of(context);
    setState(() => _busy = true);
    try {
      await client.adminAccess.requestAccess();
      // The scope lives in the token: force a refresh so it applies now.
      await client.auth.refreshAuthKey(force: true);
      await state.refreshAccess();
      if (mounted) showMessage(context, 'Ya tenés acceso de administrador.');
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    final state = AppState.of(context);
    await client.auth.signOutDevice();
    state.reset();
    if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final textTheme = Theme.of(context).textTheme;
    final overview = state.overview;
    return Scaffold(
      appBar: AppBar(title: const Text('PERFIL')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: Palette.goldGradient,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Palette.ink,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  state.access?.email ?? 'Tu cuenta',
                  style: textTheme.titleMedium,
                ),
                if (overview != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${overview.cards.length} de ${overview.totalPublished} cartas',
                    style: textTheme.bodySmall?.copyWith(
                      color: Palette.parchmentDim,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Eyebrow('Administración'),
          const SizedBox(height: 12),
          if (state.isAdmin) ...[
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.edit_note_rounded,
                      color: Palette.gold,
                    ),
                    title: const Text('Santos'),
                    subtitle: const Text('Cargar, editar y publicar santos'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AdminSaintsScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.table_view_rounded,
                      color: Palette.gold,
                    ),
                    title: const Text('Importar y exportar'),
                    subtitle: const Text(
                      'Mantener santos, preguntas y libros en una planilla',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AdminCatalogScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.podcasts_rounded,
                      color: Palette.gold,
                    ),
                    title: const Text('Trivia en vivo'),
                    subtitle: const Text(
                      'Lanzar y conducir la trivia durante el programa',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AdminLiveScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.qr_code_2_rounded,
                      color: Palette.gold,
                    ),
                    title: const Text('Códigos del programa'),
                    subtitle: const Text(
                      'Crear códigos que desbloquean cartas',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AdminCodesScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.admin_panel_settings_outlined,
                      color: Palette.gold,
                    ),
                    title: const Text('Administradores'),
                    subtitle: const Text('Dar o quitar acceso'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AdminUsersScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'El panel de administración es para el equipo del '
                      'programa. Si tu email está habilitado, podés pedir '
                      'acceso.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Palette.parchmentDim,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _busy ? null : _requestAccess,
                      child: const Text('SOLICITAR ACCESO'),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.help_outline_rounded,
                    color: Palette.gold,
                  ),
                  title: const Text('Cómo funciona'),
                  subtitle: const Text(
                    'Qué hace cada pestaña, por qué los santos y las '
                    'preguntas frecuentes',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => GuideScreen.open(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.waving_hand_outlined,
                    color: Palette.gold,
                  ),
                  title: const Text('Ver la bienvenida de nuevo'),
                  subtitle: const Text('La presentación de la primera vez'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => WelcomeScreen.open(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.favorite_border_rounded,
                color: Palette.gold,
              ),
              title: const Text('Créditos'),
              subtitle: const Text('El programa, el ilustrador y el equipo'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreditsScreen()),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Cerrar sesión'),
          ),
          if (state.signedIn) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => DeleteAccountScreen.open(context),
              style: TextButton.styleFrom(
                foregroundColor: Palette.crimsonLight,
              ),
              child: const Text('Borrar mi cuenta'),
            ),
          ],
        ],
      ),
    );
  }
}
