import 'dart:async';

// Prefixed: `Message` also exists in Serverpod's re-exported Relic types.
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

/// Keys read from `config/passwords.yaml`, or from the environment as
/// `SERVERPOD_PASSWORD_<key>` (which is how production gets them, see
/// `deploy/env.example`).
const _hostKey = 'smtpHost';
const _portKey = 'smtpPort';
const _usernameKey = 'smtpUsername';
const _passwordKey = 'smtpPassword';
const _fromAddressKey = 'smtpFromAddress';
const _fromNameKey = 'smtpFromName';

/// The email identity provider of this app, sending its verification codes
/// through an SMTP relay (Brevo today, but nothing here is Brevo-specific:
/// changing provider is changing the five `smtp*` passwords).
///
/// When the SMTP settings are incomplete the code is written to the log
/// instead of being sent. That is the intended path in development — the
/// `serverpod` CLI shows the alert and copies the code to the clipboard, the
/// same behavior the project had with Serverpod Cloud — and a loud error in
/// production, where a missing setting would otherwise leave sign-ups silently
/// unable to finish.
///
/// Sending is best effort: a failure is logged and never thrown. Throwing
/// would break sign-up whenever the relay is down, and on a password reset it
/// would leak whether an account exists, because the send only runs for
/// addresses that do.
EmailIdpConfig appEmailIdpConfig({required String appDisplayName}) {
  return EmailIdpConfigFromPasswords(
    sendRegistrationVerificationCode:
        (
          final session, {
          required final email,
          required final accountRequestId,
          required final verificationCode,
          required final transaction,
        }) => _sendCode(
          session,
          appDisplayName: appDisplayName,
          email: email,
          code: verificationCode,
          subject: 'Tu código para entrar a $appDisplayName',
          intro:
              'Estás creando tu cuenta en $appDisplayName. '
              'Usá este código para confirmar tu email:',
          logLabel: 'Registration code',
        ),
    sendPasswordResetVerificationCode:
        (
          final session, {
          required final email,
          required final passwordResetRequestId,
          required final verificationCode,
          required final transaction,
        }) => _sendCode(
          session,
          appDisplayName: appDisplayName,
          email: email,
          code: verificationCode,
          subject: 'Restablecer tu contraseña en $appDisplayName',
          intro:
              'Pediste restablecer tu contraseña en $appDisplayName. '
              'Usá este código para elegir una nueva:',
          logLabel: 'Password reset code',
        ),
  );
}

/// What the relay needs to accept a message. Resolved on every send, so the
/// server boots with the settings missing and picks them up once they are set.
class _SmtpSettings {
  const _SmtpSettings({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.fromAddress,
    required this.fromName,
  });

  final String host;
  final int port;
  final String username;
  final String password;
  final String fromAddress;
  final String fromName;

  static _SmtpSettings? resolve(String appDisplayName) {
    final pod = Serverpod.instance;
    final host = pod.getPassword(_hostKey);
    final username = pod.getPassword(_usernameKey);
    final password = pod.getPassword(_passwordKey);
    final fromAddress = pod.getPassword(_fromAddressKey);
    if (host == null ||
        username == null ||
        password == null ||
        fromAddress == null) {
      return null;
    }
    return _SmtpSettings(
      host: host,
      port: int.tryParse(pod.getPassword(_portKey) ?? '') ?? 587,
      username: username,
      password: password,
      fromAddress: fromAddress,
      fromName: pod.getPassword(_fromNameKey) ?? appDisplayName,
    );
  }
}

Future<void> _sendCode(
  Session session, {
  required String appDisplayName,
  required String email,
  required String code,
  required String subject,
  required String intro,
  required String logLabel,
}) async {
  final settings = _SmtpSettings.resolve(appDisplayName);
  if (settings == null) {
    // `session.alert` renders as a copyable alert in the CLI's terminal UI and
    // auto-copies the `<...>` segment; elsewhere it is a normal log line.
    session.alert('$logLabel for $email: <$code>');
    final runMode = Serverpod.instance.runMode;
    if (runMode != ServerpodRunMode.development &&
        runMode != ServerpodRunMode.test) {
      session.log(
        'SMTP sin configurar en modo $runMode: el código de $email quedó solo '
        'en el log y el usuario no lo recibió. Faltan las claves '
        '$_hostKey / $_usernameKey / $_passwordKey / $_fromAddressKey.',
        level: LogLevel.error,
      );
    }
    return;
  }

  try {
    await mailer.send(
      mailer.Message()
        ..from = mailer.Address(settings.fromAddress, settings.fromName)
        ..recipients.add(email)
        ..subject = subject
        ..text = _textBody(intro: intro, code: code, appName: appDisplayName)
        ..html = _htmlBody(intro: intro, code: code, appName: appDisplayName),
      SmtpServer(
        settings.host,
        port: settings.port,
        username: settings.username,
        password: settings.password,
        // 465 is implicit TLS; 587 negotiates STARTTLS on a plain connection.
        ssl: settings.port == 465,
      ),
    );
  } catch (e, stackTrace) {
    session.log(
      'No se pudo enviar el email a $email ($logLabel).',
      level: LogLevel.error,
      exception: '$e',
      stackTrace: stackTrace,
    );
  }
}

String _textBody({
  required String intro,
  required String code,
  required String appName,
}) =>
    '''
$intro

$code

Si no fuiste vos, podés ignorar este mensaje.

$appName
''';

/// Inline styles only: every mail client strips or ignores a `<style>` block.
String _htmlBody({
  required String intro,
  required String code,
  required String appName,
}) =>
    '''
<div style="background:#14121f;padding:32px 16px;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif">
  <div style="max-width:440px;margin:0 auto;background:#1d1a2b;border:1px solid #c8a24a;border-radius:12px;padding:28px 24px;color:#f2ead9">
    <p style="margin:0 0 8px;font-size:12px;letter-spacing:2px;text-transform:uppercase;color:#c8a24a">$appName</p>
    <p style="margin:0 0 20px;font-size:15px;line-height:1.5">$intro</p>
    <p style="margin:0 0 20px;text-align:center;font-size:30px;letter-spacing:6px;font-weight:700;color:#f0d68c">$code</p>
    <p style="margin:0;font-size:13px;line-height:1.5;color:#b8ae99">Si no fuiste vos, podés ignorar este mensaje.</p>
  </div>
</div>
''';
