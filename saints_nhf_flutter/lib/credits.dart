/// Credits shown in the app. Edit these values; nothing else is needed.
class Credit {
  const Credit({
    required this.role,
    required this.name,
    this.url,
    this.handle,
  });

  /// What this person or entity did, e.g. "Ilustraciones".
  final String role;
  final String name;

  /// Link to open when tapped.
  final String? url;

  /// Shown under the name, e.g. an Instagram handle.
  final String? handle;
}

const programName = 'No Hacemos Fotocopias';

/// El logo del programa: letras blancas con sombra negra sobre fondo
/// transparente, pensado para ir sobre el fondo oscuro de la app.
const programLogoAsset = 'assets/nhf_logo.png';

const credits = <Credit>[
  Credit(
    role: 'El programa',
    name: programName,
    handle: 'Canal de YouTube',
    url: 'https://www.youtube.com/@Nohacemosfotocopias/streams',
  ),
  Credit(
    role: 'Ilustraciones de los santos',
    name: 'Laucha',
    handle: '@cebandosantosmomentos',
    url: 'https://www.instagram.com/cebandosantosmomentos/',
  ),
  Credit(
    role: 'Idea y contenidos',
    name: 'Equipo de No Hacemos Fotocopias',
  ),
];

/// Short text shown above the credits.
const creditsIntro =
    'Esta app nace de la sección "El santo del día" del programa. Las '
    'tarjetas, sus puntajes y las historias que las acompañan se cuentan en '
    'cada emisión.';
