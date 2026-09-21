import 'dart:typed_data';

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
