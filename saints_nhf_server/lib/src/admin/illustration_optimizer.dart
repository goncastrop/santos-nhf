import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

/// Turns an uploaded illustration into what the app serves: WebP with its
/// transparency, the longer side at most [maxSide] pixels, and no metadata.
/// The same as `tools/optimizar_ilustraciones.sh`, which prepared the first
/// batch, so the originals can be uploaded as they come from the
/// illustrator.
///
/// It runs ImageMagick: `magick` (version 7, the one in the server image and
/// in Homebrew) or `convert` (version 6, the one on Ubuntu). Without either,
/// or when the conversion fails, [optimize] returns null and the upload keeps
/// the original file, so a missing tool never blocks an upload.
class IllustrationOptimizer {
  /// Enough for the 1080 × 1350 share image.
  static const maxSide = 1200;
  static const quality = 82;
  static const _timeout = Duration(seconds: 60);

  /// The optimized WebP bytes, or null when they could not be produced.
  static Future<Uint8List?> optimize(Session session, Uint8List input) async {
    final dir = await Directory.systemTemp.createTemp('ilustracion');
    try {
      final source = File('${dir.path}/original');
      final target = '${dir.path}/optimizada.webp';
      await source.writeAsBytes(input, flush: true);
      final args = [
        // Only the first frame, in case of an animated GIF or WebP.
        '${source.path}[0]',
        // The `>` only shrinks: a small image is not blown up.
        '-resize', '${maxSide}x$maxSide>',
        '-strip',
        '-define', 'webp:method=6',
        '-quality', '$quality',
        target,
      ];
      final result = await _run(args);
      if (result == null) {
        session.log(
          'ImageMagick is not installed: the illustration is stored as '
          'uploaded.',
          level: LogLevel.warning,
        );
        return null;
      }
      if (result.exitCode != 0) {
        session.log(
          'Could not optimize the illustration: ${result.stderr}',
          level: LogLevel.warning,
        );
        return null;
      }
      return await File(target).readAsBytes();
    } catch (e) {
      session.log(
        'Could not optimize the illustration: $e',
        level: LogLevel.warning,
      );
      return null;
    } finally {
      await dir.delete(recursive: true);
    }
  }

  /// Whether there is an ImageMagick that can write WebP. For the tests: a
  /// build without the WebP coder would make every upload keep its original.
  static Future<bool> available() async {
    final result = await _run(['-list', 'format']);
    if (result == null || result.exitCode != 0) return false;
    return (result.stdout as String)
        .split('\n')
        .any((line) => RegExp(r'^\s*WEBP\*?\s+\S+\s+rw').hasMatch(line));
  }

  /// Runs `magick`, or `convert` when there is no `magick`. Null when neither
  /// is installed.
  static Future<ProcessResult?> _run(List<String> args) async {
    for (final command in ['magick', 'convert']) {
      try {
        return await Process.run(command, args).timeout(_timeout);
      } on ProcessException {
        // Not installed under this name: try the next one.
      }
    }
    return null;
  }
}
