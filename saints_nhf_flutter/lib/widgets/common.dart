import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../credits.dart';
import '../theme.dart';

/// Small uppercase label used as a section eyebrow.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color ?? Palette.gold,
      ),
    );
  }
}

/// El logo de No Hacemos Fotocopias, al alto o al ancho pedido. Para los
/// lectores de pantalla se lee como el nombre del programa.
class ProgramLogo extends StatelessWidget {
  const ProgramLogo({super.key, this.height, this.width})
    : assert(height != null || width != null);

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      programLogoAsset,
      height: height,
      width: width,
      semanticLabel: programName,
      filterQuality: FilterQuality.medium,
    );
  }
}

/// A gilded hairline with a small diamond in the middle.
class Ornament extends StatelessWidget {
  const Ornament({super.key, this.width = 140});

  final double width;

  @override
  Widget build(BuildContext context) {
    Widget line({required bool reversed}) => Expanded(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: reversed
                ? const [Palette.gold, Colors.transparent]
                : const [Colors.transparent, Palette.gold],
          ),
        ),
      ),
    );
    return SizedBox(
      width: width,
      child: Row(
        children: [
          line(reversed: false),
          Transform.rotate(
            angle: 0.785398,
            child: Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Palette.gold,
            ),
          ),
          line(reversed: true),
        ],
      ),
    );
  }
}

/// Centered progress indicator.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2, color: Palette.gold),
      ),
    );
  }
}

/// Error message with a retry button.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, color: Palette.parchmentDim),
            const SizedBox(height: 12),
            Text(
              friendlyError(error),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Turns server exceptions into a readable Spanish message.
String friendlyError(Object error) => switch (error) {
  CollectionException e => e.message,
  AdminException e => e.message,
  ServerpodClientUnauthorized() => 'Tu sesión expiró. Volvé a iniciar sesión.',
  ServerpodClientForbidden() => 'No tenés permisos para hacer esto.',
  _ => 'No pudimos conectarnos con el servidor. Probá de nuevo.',
};

/// Abre un link afuera de la app.
///
/// En la web el destino es una pestaña nueva, y el navegador puede
/// bloquearla por creerla un popup; entonces copiamos el link para que se
/// pueda pegar a mano.
Future<void> openLink(BuildContext context, String url, {String? what}) async {
  final uri = Uri.tryParse(url.trim());
  if (uri == null || !uri.hasScheme) {
    showMessage(
      context,
      'El link${what == null ? '' : ' de $what'} no es '
      'válido.',
      error: true,
    );
    return;
  }
  final opened = await launchUrl(
    uri,
    mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
    webOnlyWindowName: '_blank',
  );
  if (opened || !context.mounted) return;
  await Clipboard.setData(ClipboardData(text: uri.toString()));
  if (!context.mounted) return;
  showMessage(
    context,
    'No pudimos abrir ${what ?? 'el link'}. Lo copiamos para que lo pegues '
    'en el navegador.',
    error: true,
  );
}

void showMessage(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error ? const Color(0xFF4A1E1E) : Palette.inkRaised,
    ),
  );
}

/// A small labelled chip with an icon. Used for every piece of metadata on a
/// saint so they all share the same height and alignment.
class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.color = Palette.gold,
    this.borderColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Palette.goldDark),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Progress of the album: bar plus "x de y".
class AlbumProgress extends StatelessWidget {
  const AlbumProgress({super.key, required this.owned, required this.total});

  final int owned;
  final int total;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ratio = total == 0 ? 0.0 : owned / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Eyebrow('Álbum'),
            Text(
              '$owned de $total',
              style: textTheme.labelLarge?.copyWith(color: Palette.parchment),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: Palette.inkLine,
            color: Palette.gold,
          ),
        ),
      ],
    );
  }
}
