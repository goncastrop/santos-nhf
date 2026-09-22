import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:share_plus/share_plus.dart';

import '../credits.dart';
import '../theme.dart';
import '../utils/feast.dart';
import 'common.dart';
import 'saint_card.dart';

/// El lienzo de la imagen que se comparte: vertical 4:5, la proporción que
/// las redes muestran entera sin recortar.
const shareImageSize = Size(1080, 1350);

/// La tarjeta preparada para publicar: la misma que dibuja la app, agrandada
/// y con el nombre del programa, sobre el fondo de capilla.
///
/// Es de tamaño fijo y no de la pantalla: la imagen que sale de un teléfono
/// chico tiene que ser igual a la que sale de una tablet.
class ShareCardImage extends StatelessWidget {
  const ShareCardImage({super.key, required this.saint, required this.scores});

  final SaintInfo saint;
  final SaintScores? scores;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final feast = feastLong(saint.feastMonth, saint.feastDay);

    return SizedBox(
      width: shareImageSize.width,
      height: shareImageSize.height,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.25),
            radius: 1,
            colors: [Color(0xFF241D44), Palette.ink],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(90, 64, 90, 56),
          child: Column(
            children: [
              Text(
                'EL SANTO DEL DÍA',
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                  color: Palette.gold,
                  letterSpacing: 10,
                ),
              ),
              const SizedBox(height: 18),
              const Ornament(width: 260),
              const Spacer(),
              SaintCard(saint: saint, scores: scores, width: 620),
              const Spacer(),
              if (feast != null) ...[
                Text(
                  feast.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 24,
                    color: Palette.gold,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 18),
              ],
              Text(
                programName,
                style: textTheme.headlineSmall?.copyWith(fontSize: 34),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Saca la foto de [ShareCardImage] y devuelve el PNG.
///
/// La dibuja fuera de la pantalla en el overlay, que es la forma de que se
/// pinte de verdad —un `Offstage` no pinta y no habría nada que fotografiar—,
/// y la saca de ahí apenas termina.
Future<Uint8List> captureShareCard(
  BuildContext context, {
  required SaintInfo saint,
  required SaintScores? scores,
}) async {
  // La ilustración viaja por red: si no está lista, la foto sale con el
  // fondo del placeholder.
  if (saint.illustrationUrl case final url?) {
    final ImageProvider provider = kIsWeb
        ? NetworkImage(url)
        : CachedNetworkImageProvider(url);
    try {
      if (context.mounted) await precacheImage(provider, context);
    } catch (_) {
      // Sin ilustración la tarjeta cae en el monograma, que también se
      // comparte bien.
    }
  }
  if (!context.mounted) {
    throw StateError('La pantalla se cerró antes de armar la imagen.');
  }

  final boundary = GlobalKey();
  final entry = OverlayEntry(
    builder: (_) => Positioned(
      // Lejos de la pantalla, pero dentro del árbol: se pinta igual.
      left: -shareImageSize.width - 100,
      top: 0,
      child: RepaintBoundary(
        key: boundary,
        child: ShareCardImage(saint: saint, scores: scores),
      ),
    ),
  );
  Overlay.of(context, rootOverlay: true).insert(entry);
  try {
    // La ilustración aparece con un fundido de 200 ms: sacarla antes deja la
    // cara a medio aparecer.
    await Future<void>.delayed(const Duration(milliseconds: 320));
    await WidgetsBinding.instance.endOfFrame;
    final render =
        boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await render.toImage();
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw StateError('No se pudo generar la imagen.');
      return data.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  } finally {
    entry.remove();
  }
}

/// Botón de compartir de la ficha: arma la imagen y la pasa al menú de
/// compartir del sistema.
///
/// No todos los navegadores saben compartir archivos —en una computadora casi
/// ninguno—, así que en la web, cuando compartir no sale, bajamos la imagen
/// nosotros y lo decimos. El plan B del plugin no sirve acá: mete la imagen
/// entera dentro de la URL de un ancla, y con una tarjeta de 1080 × 1350 eso
/// es un megabyte de URL que algunos navegadores rechazan sin avisar.
class ShareCardButton extends StatefulWidget {
  const ShareCardButton({super.key, required this.saint, required this.scores});

  final SaintInfo saint;
  final SaintScores? scores;

  @override
  State<ShareCardButton> createState() => _ShareCardButtonState();
}

class _ShareCardButtonState extends State<ShareCardButton> {
  bool _working = false;

  Future<void> _share() async {
    if (_working) return;
    setState(() => _working = true);
    try {
      final bytes = await captureShareCard(
        context,
        saint: widget.saint,
        scores: widget.scores,
      );
      final name = '${widget.saint.slug}.png';
      try {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile.fromData(bytes, mimeType: 'image/png', name: name)],
            // XFile.fromData no tiene ruta y algunas plataformas necesitan el
            // nombre aparte.
            fileNameOverrides: [name],
            text: '${widget.saint.name} · El santo del día de $programName',
            subject: widget.saint.name,
            // En iPad y en Mac la hoja de compartir sale de acá.
            sharePositionOrigin: _origin(),
            downloadFallbackEnabled: false,
          ),
        );
      } catch (e) {
        // Fuera de la web no hay plan B: si el sistema no pudo compartir, es
        // un error de verdad.
        if (!kIsWeb) rethrow;
        debugPrint('Compartir falló, bajamos la imagen: $e');
        await FileSaver.instance.saveFile(
          name: widget.saint.slug,
          bytes: bytes,
          fileExtension: 'png',
          mimeType: MimeType.png,
        );
        if (mounted) {
          showMessage(
            context,
            'Tu navegador no puede compartir archivos: te descargamos la '
            'imagen. Desde el celular, el botón abre el menú para compartir.',
          );
        }
      }
    } catch (e) {
      debugPrint('No pudimos compartir la tarjeta: $e');
      if (mounted) {
        showMessage(context, 'No pudimos compartir la tarjeta.', error: true);
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Rect? _origin() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _working ? null : _share,
      icon: _working
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Palette.gold,
              ),
            )
          : const Icon(Icons.ios_share_rounded),
      label: Text(_working ? 'ARMANDO LA IMAGEN…' : 'COMPARTIR LA TARJETA'),
    );
  }
}
