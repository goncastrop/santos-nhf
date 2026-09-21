import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

/// Grant and revoke admin access by email.
class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List<AdminUser>? _admins;
  Object? _error;
  final _email = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    try {
      final admins = await client.adminUsers.listAdmins();
      if (!mounted) return;
      setState(() {
        _admins = admins;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<void> _grant() async {
    final email = _email.text.trim();
    if (email.isEmpty) return;
    setState(() => _busy = true);
    try {
      await client.adminUsers.grantAdmin(email);
      _email.clear();
      _reload();
      if (mounted) {
        showMessage(
          context,
          'Listo. $email tendrá acceso la próxima vez que inicie sesión.',
        );
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _revoke(AdminUser user) async {
    if (user.email == null) return;
    try {
      await client.adminUsers.revokeAdmin(user.email!);
      _reload();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('ADMINISTRADORES')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Eyebrow('Dar acceso'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'email de un usuario registrado',
                  ),
                  onSubmitted: (_) => _grant(),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _busy ? null : _grant,
                child: const Text('DAR'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'La persona tiene que haber creado su cuenta en la app antes.',
            style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
          ),
          const SizedBox(height: 28),
          const Eyebrow('Con acceso'),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              if (_error != null) {
                return ErrorView(error: _error!, onRetry: _reload);
              }
              final admins = _admins;
              if (admins == null) return const LoadingView();
              return Card(
                child: Column(
                  children: [
                    for (final (i, a) in admins.indexed) ...[
                      if (i > 0) const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.admin_panel_settings_outlined,
                          color: Palette.gold,
                        ),
                        title: Text(a.email ?? a.authUserId.toString()),
                        trailing: IconButton(
                          tooltip: 'Quitar acceso',
                          icon: const Icon(Icons.person_remove_outlined),
                          onPressed: a.email == null ? null : () => _revoke(a),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
