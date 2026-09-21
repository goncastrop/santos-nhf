import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'auth_test_helper.dart';
import 'test_tools/serverpod_test_tools.dart';

Saint _saint(String slug, {int? feastMonth, int? feastDay}) => Saint(
  name: slug,
  slug: slug,
  bio: 'Bio de $slug',
  feastMonth: feastMonth,
  feastDay: feastDay,
  status: SaintStatus.published,
);

void main() {
  withServerpod('Given a catalog with seven published saints and one draft', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late TestSessionBuilder user;

    setUp(() async {
      user = await signedInUser(sessionBuilder);
      await Saint.db.insert(session, [
        for (var i = 1; i <= 7; i++) _saint('santo-$i'),
        _saint('borrador').copyWith(status: SaintStatus.draft),
      ]);
    });

    test('when listing the catalog then only published saints are returned '
        'without scores', () async {
      final saints = await endpoints.saint.list(sessionBuilder);
      expect(saints, hasLength(7));
      expect(saints.map((s) => s.slug), isNot(contains('borrador')));
    });

    test('when a new user opens the collection then a starter pack of five '
        'cards is granted once', () async {
      final first = await endpoints.collection.overview(user);
      expect(first.newStarterCards, hasLength(5));
      expect(first.cards, hasLength(5));
      expect(first.totalPublished, 7);
      expect(first.canClaimToday, isTrue);

      final second = await endpoints.collection.overview(user);
      expect(second.newStarterCards, isEmpty);
      expect(second.cards, hasLength(5));
    });

    test('when claiming the daily card twice then the second claim fails '
        'and the collection has one more card', () async {
      await endpoints.collection.overview(user);
      final claim = await endpoints.collection.claimDaily(user);
      expect(claim.card.source, CardSource.daily);

      await expectLater(
        endpoints.collection.claimDaily(user),
        throwsA(
          isA<CollectionException>().having(
            (e) => e.code,
            'code',
            CollectionErrorCode.alreadyClaimedToday,
          ),
        ),
      );

      final overview = await endpoints.collection.overview(user);
      expect(overview.cards, hasLength(6));
      expect(overview.canClaimToday, isFalse);
      expect(overview.todayCard?.saint.id, claim.card.saint.id);
    });

    test('when the saint detail is requested then the card is only included '
        'for owned saints', () async {
      final overview = await endpoints.collection.overview(user);
      final ownedIds = overview.cards.map((c) => c.saint.id).toSet();
      final all = await endpoints.saint.list(user);
      final owned = all.firstWhere((s) => ownedIds.contains(s.id));
      final missing = all.firstWhere((s) => !ownedIds.contains(s.id));

      final ownedDetail = await endpoints.saint.detail(user, owned.id);
      expect(ownedDetail.card, isNotNull);
      final missingDetail = await endpoints.saint.detail(user, missing.id);
      expect(missingDetail.card, isNull);

      final anonymous = await endpoints.saint.detail(sessionBuilder, owned.id);
      expect(anonymous.card, isNull);
    });

    test(
      'when unauthenticated then the collection is not accessible',
      () async {
        await expectLater(
          endpoints.collection.overview(
            sessionBuilder.copyWith(
              authentication: AuthenticationOverride.unauthenticated(),
            ),
          ),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );
  });

  withServerpod('Given the saint of the day is not yet collected', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();

    test(
      'when claiming the daily card then the feast day saint is chosen',
      () async {
        final user = await signedInUser(sessionBuilder);
        final now = DateTime.now().toUtc().subtract(const Duration(hours: 3));
        await Saint.db.insert(session, [
          _saint('otro-1'),
          _saint('otro-2'),
          _saint('fiesta-de-hoy', feastMonth: now.month, feastDay: now.day),
        ]);
        // With only 3 saints the starter pack would take them all, so mark the
        // profile as already granted instead of consuming it.
        await PlayerProfile.db.insertRow(
          session,
          PlayerProfile(
            authUserId: user.build().authenticated!.authUserId,
            starterGranted: true,
          ),
        );

        final claim = await endpoints.collection.claimDaily(user);
        expect(claim.isFeastDay, isTrue);
        expect(claim.card.saint.slug, 'fiesta-de-hoy');
      },
    );
  });

  withServerpod('Given an admin and a saint', (sessionBuilder, endpoints) {
    late TestSessionBuilder admin;

    setUp(() async {
      admin = await signedInUser(sessionBuilder, scopes: {Scope.admin});
    });

    test('when saving an edited saint then a revision keeps the previous '
        'state and restoring brings it back', () async {
      final created = await endpoints.adminSaint.save(
        admin,
        _saint('san-ejemplo').copyWith(viajes: 10),
        null,
      );
      final edited = await endpoints.adminSaint.save(
        admin,
        created.copyWith(viajes: 90),
        'Ajuste de balance',
      );
      expect(edited.viajes, 90);

      final revisions = await endpoints.adminSaint.revisions(
        admin,
        created.id!,
      );
      expect(revisions, hasLength(1));
      expect(revisions.single.note, 'Ajuste de balance');

      final restored = await endpoints.adminSaint.restore(
        admin,
        revisions.single.id!,
        null,
      );
      expect(restored.viajes, 10);
      expect(
        await endpoints.adminSaint.revisions(admin, created.id!),
        hasLength(2),
      );
    });

    test(
      'when a non-admin calls the admin endpoint then it is rejected',
      () async {
        final user = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            '550e8400-e29b-41d4-a716-446655440003',
            {},
          ),
        );
        await expectLater(
          endpoints.adminSaint.listAll(user),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );
      },
    );
  });
}
