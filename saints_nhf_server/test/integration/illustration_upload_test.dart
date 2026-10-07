import 'dart:io';
import 'dart:typed_data';

import 'package:saints_nhf_server/src/admin/illustration_optimizer.dart';
import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an admin and a saint', (sessionBuilder, endpoints) {
    test('when an illustration is uploaded through the server then it is '
        'stored, linked to the saint and served back', () async {
      final admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      final saint = await endpoints.adminSaint.save(
        admin,
        Saint(name: 'Con imagen', slug: 'con-imagen', bio: 'Bio'),
        null,
      );
      final png = ByteData.sublistView(
        Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10]),
      );

      final updated = await endpoints.adminSaint.uploadIllustration(
        admin,
        saint.id!,
        'png',
        png,
      );
      expect(updated.illustrationPath, 'saints/${saint.id}/illustration.png');

      final session = sessionBuilder.build();
      final stored = await session.storage.retrieveFile(
        storageId: 'public',
        path: updated.illustrationPath!,
      );
      expect(stored.lengthInBytes, png.lengthInBytes);

      final url = await endpoints.adminSaint.illustrationUrl(admin, saint.id!);
      expect(url, isNotNull);

      // Replacing it keeps a single file at the same path.
      final again = await endpoints.adminSaint.uploadIllustration(
        admin,
        saint.id!,
        'png',
        png,
      );
      expect(again.illustrationPath, updated.illustrationPath);
    });

    test('when a large PNG is uploaded then it is stored as a WebP of at '
        'most 1200 px that keeps its transparency', () async {
      if (!await IllustrationOptimizer.available()) {
        markTestSkipped('ImageMagick is not installed');
        return;
      }
      final admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      final saint = await endpoints.adminSaint.save(
        admin,
        Saint(name: 'Original', slug: 'original', bio: 'Bio'),
        null,
      );
      final dir = await Directory.systemTemp.createTemp('ilustracion-test');
      addTearDown(() => dir.delete(recursive: true));
      final source = '${dir.path}/grande.png';
      // Half transparent, like the drawings cut out on their background.
      await _magick([
        '-size',
        '2400x1200',
        'gradient:#D9B25F-#0C0B16',
        '-alpha',
        'set',
        '-channel',
        'A',
        '-evaluate',
        'set',
        '50%',
        '+channel',
        source,
      ]);
      final original = await File(source).readAsBytes();

      final updated = await endpoints.adminSaint.uploadIllustration(
        admin,
        saint.id!,
        'png',
        ByteData.sublistView(original),
      );
      expect(updated.illustrationPath, 'saints/${saint.id}/illustration.webp');

      final session = sessionBuilder.build();
      final stored = await session.storage.retrieveFile(
        storageId: 'public',
        path: updated.illustrationPath!,
      );
      final bytes = stored.buffer.asUint8List(
        stored.offsetInBytes,
        stored.lengthInBytes,
      );
      expect(String.fromCharCodes(bytes.sublist(8, 12)), 'WEBP');
      expect(bytes.length, lessThan(original.length));

      final storedPath = '${dir.path}/guardada.webp';
      await File(storedPath).writeAsBytes(bytes);
      final info = await _magick([
        'identify',
        '-format',
        '%w %h %[opaque]',
        storedPath,
      ], identify: true);
      expect(info, '1200 600 False');
    });

    test('when the file is empty or the format is not an image then it is '
        'rejected', () async {
      final admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
      final saint = await endpoints.adminSaint.save(
        admin,
        Saint(name: 'Sin imagen', slug: 'sin-imagen', bio: 'Bio'),
        null,
      );

      await expectLater(
        endpoints.adminSaint.uploadIllustration(
          admin,
          saint.id!,
          'png',
          ByteData(0),
        ),
        throwsA(isA<AdminException>()),
      );
      await expectLater(
        endpoints.adminSaint.uploadIllustration(
          admin,
          saint.id!,
          'pdf',
          ByteData.sublistView(Uint8List.fromList([1, 2, 3])),
        ),
        throwsA(isA<AdminException>()),
      );
    });
  });
}

/// Runs ImageMagick 7 (`magick`) or 6 (`convert`, `identify`).
Future<String> _magick(List<String> args, {bool identify = false}) async {
  ProcessResult result;
  try {
    result = await Process.run('magick', args);
  } on ProcessException {
    result = identify
        ? await Process.run(args.first, args.sublist(1))
        : await Process.run('convert', args);
  }
  if (result.exitCode != 0) fail('ImageMagick failed: ${result.stderr}');
  return (result.stdout as String).trim();
}
