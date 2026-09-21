import 'package:serverpod/serverpod.dart';

/// Scopes used by the app. Admins can edit the saints catalog.
class AppScope {
  static const Scope admin = Scope.admin;

  /// Key in `config/passwords.yaml` holding the comma-separated list of
  /// emails allowed to request admin access.
  static const adminEmailsPasswordKey = 'adminEmails';
}
