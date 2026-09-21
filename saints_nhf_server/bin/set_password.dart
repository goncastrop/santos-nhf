// One-off maintenance tool: sets the password of an email account.
// Usage: dart run bin/set_password.dart <email> <password>
import 'dart:io';

import 'package:saints_nhf_server/src/generated/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

Future<void> main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run bin/set_password.dart <email> <password>');
    exit(64);
  }
  final pod = Serverpod(['--mode', 'development', '--role', 'maintenance']);
  pod.initializeAuthServices(
    tokenManagerBuilders: [JwtConfigFromPasswords()],
    identityProviderBuilders: [
      ServerpodCloudEmailIdpConfig(appDisplayName: 'Santos NHF'),
    ],
  );
  await pod.start();
  final session = await pod.createSession();
  try {
    await AuthServices.instance.emailIdp.admin.setPassword(
      session,
      email: args[0],
      password: args[1],
    );
    stdout.writeln('Password updated for ${args[0]}.');
  } finally {
    await session.close();
  }
  await pod.shutdown(exitProcess: true);
}
