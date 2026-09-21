import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/saint_card.dart';

/// Sign-in and sign-up screen, opened from any section that needs an account.
/// It closes itself once the user is authenticated.
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SignInScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  static void _close(BuildContext context) {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  static void _showError(BuildContext context, Object error) {
    showMessage(context, translateAuthError(error), error: true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // On short screens the decorative header is dropped so the whole form
    // fits without scrolling.
    final compact = MediaQuery.sizeOf(context).height < 860;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const CloseButton(),
      ),
      extendBodyBehindAppBar: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.6),
            radius: 1.2,
            colors: [Color(0xFF2A2248), Palette.ink],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!compact) ...[
                      Transform.rotate(
                        angle: -0.08,
                        child: const SaintCardBack(width: 100),
                      ),
                      const SizedBox(height: 20),
                    ],
                    const Eyebrow('No Hacemos Fotocopias'),
                    const SizedBox(height: 6),
                    Text(
                      'SANTOS',
                      style: textTheme.displaySmall?.copyWith(
                        color: Palette.gold,
                        letterSpacing: 10,
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 10),
                      const Ornament(),
                      const SizedBox(height: 10),
                      Text(
                        'Coleccioná las tarjetas del santo del día, '
                        'conocé sus vidas y rezá con ellos.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        // The widget's forms have a fixed height, so the
                        // password requirement rows are kept compact.
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: textTheme.copyWith(
                              // The form title; smaller than our headline so
                              // the fixed-height form keeps room for errors.
                              headlineMedium: textTheme.headlineSmall?.copyWith(
                                fontSize: 22,
                              ),
                              bodySmall: textTheme.bodySmall?.copyWith(
                                fontSize: 11.5,
                                height: 1.2,
                              ),
                            ),
                          ),
                          child: SignInLocalizationProvider(
                            basic: _basicTexts,
                            email: _emailTexts,
                            passwordRequirementTexts: _passwordTexts,
                            child: SignInWidget(
                              client: client,
                              onAuthenticated: () => _close(context),
                              onError: (error) => _showError(context, error),
                              // Same rules as the server (see server.dart).
                              emailSignInWidget: EmailSignInWidget(
                                client: client,
                                passwordRequirements: passwordRequirements,
                                onAuthenticated: () => _close(context),
                                onError: (error) => _showError(context, error),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _basicTexts = BasicSignInTexts(
  noAuthenticationProvidersConfigured: 'No hay formas de ingreso configuradas',
  orContinueWith: 'o continuá con',
);

const _emailTexts = EmailSignInTexts(
  title: 'Ingresá con tu email',
  forgotPassword: '¿Olvidaste la contraseña?',
  signIn: 'Ingresar',
  dontHaveAnAccount: '¿No tenés cuenta?',
  signUp: 'Crear cuenta',
  signUpTitle: 'Creá tu cuenta',
  continueAction: 'Continuar',
  alreadyHaveAnAccount: '¿Ya tenés cuenta?',
  verifyAccountTitle: 'Tu código',
  verifyResetCodeTitle: 'Tu código',
  verificationMessage:
      'Te enviamos un código por email. Revisá tu casilla y escribilo acá.',
  verify: 'Verificar',
  setAccountPasswordTitle: 'Tu contraseña',
  passwordLabel: 'Contraseña',
  backToSignUp: 'Volver a crear cuenta',
  setNewPasswordTitle: 'Nueva contraseña',
  newPasswordLabel: 'Nueva contraseña',
  resetPasswordTitle: 'Recuperar clave',
  resetPasswordDescription: 'Escribí tu email y te enviamos un código.',
  requestPasswordReset: 'Enviar código',
  resetPassword: 'Cambiar contraseña',
  backToSignIn: 'Volver a ingresar',
  emailLabel: 'Email',
  termsIntro: 'Leí y acepto los ',
  termsAndConditions: 'Términos y Condiciones',
  andText: ' y la ',
  privacyPolicy: 'Política de Privacidad',
);

/// Password rules shown and checked in the app. Keep in sync with the
/// server's `passwordValidationFunction` in server.dart.
const passwordMinLength = 10;

final passwordRequirements = <PasswordRequirement>[
  PasswordRequirement.minLength(passwordMinLength),
  PasswordRequirement.containsUppercase(),
  PasswordRequirement.containsLowercase(),
  PasswordRequirement.containsNumber(),
  PasswordRequirement.containsSpecialCharacter(),
];

/// Short labels: the requirement rows of the sign-in widget do not wrap, so
/// long texts would overflow on narrow screens.
const _passwordTexts = PasswordRequirementTexts(
  minLengthTemplate: 'Mínimo {length} caracteres',
  maxLengthTemplate: 'Máximo {length} caracteres',
  containsLowercase: 'Una letra minúscula',
  containsUppercase: 'Una letra mayúscula',
  containsNumber: 'Un número',
  containsSpecialCharacter: 'Un símbolo (por ejemplo ! o #)',
);

/// Spanish version of the sign-in widget's English error messages.
String translateAuthError(Object error) {
  final text = error.toString();
  const map = <String, String>{
    'Invalid email or password': 'Email o contraseña incorrectos.',
    'Too many failed login attempts':
        'Demasiados intentos. Esperá un rato y probá de nuevo.',
    'Too many failed registration attempts':
        'Demasiados intentos de registro. Probá más tarde.',
    'Too many failed password reset attempts':
        'Demasiados intentos. Probá más tarde.',
    'verification code has expired': 'El código venció. Pedí uno nuevo.',
    'Invalid verification code': 'El código no es válido. Revisalo.',
    'reset code has expired': 'El código venció. Pedí uno nuevo.',
    'does not meet the requirements': 'La contraseña no cumple los requisitos.',
    'Invalid email address': 'El email no es válido.',
    'Email aliases are not allowed': 'No se permiten alias de email.',
    'error occurred during login': 'No pudimos iniciar sesión. Probá de nuevo.',
    'error occurred during registration':
        'No pudimos crear la cuenta. Probá de nuevo más tarde.',
    'error occurred during password reset':
        'No pudimos cambiar la contraseña. Probá de nuevo.',
  };
  for (final entry in map.entries) {
    if (text.contains(entry.key)) return entry.value;
  }
  return 'No pudimos conectarnos con el servidor. Probá de nuevo.';
}
