import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../saints/saint_mapper.dart';
import '../social/profile_service.dart';
import '../util/argentina_day.dart';

/// Business rules of the card collection.
class CollectionService {
  /// Number of cards granted to a new player.
  static const starterPackSize = 5;

  static final _random = Random();

  /// Gets or creates the player's profile.
  static Future<PlayerProfile> profileFor(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) => ProfileService.ensure(session, authUserId, transaction: transaction);

  /// The user's card for [saint], or null when not collected.
  static Future<CollectedCard?> cardFor(
    Session session,
    UuidValue authUserId,
    Saint saint,
  ) async {
    final row = await UserSaintCard.db.findFirstRow(
      session,
      where: (t) =>
          t.authUserId.equals(authUserId) & t.saintId.equals(saint.id!),
    );
    if (row == null) return null;
    return CollectedCard(
      saint: await SaintMapper.toInfo(session, saint),
      scores: SaintMapper.toScores(saint),
      obtainedAt: row.obtainedAt,
      source: row.source,
    );
  }

  /// All cards of the user, newest first. With [saintIds], only those.
  static Future<List<CollectedCard>> cardsOf(
    Session session,
    UuidValue authUserId, {
    Set<int>? saintIds,
    Transaction? transaction,
  }) async {
    if (saintIds != null && saintIds.isEmpty) return const [];
    final rows = await UserSaintCard.db.find(
      session,
      where: (t) {
        var expr =
            t.authUserId.equals(authUserId) &
            t.saint.status.equals(SaintStatus.published);
        if (saintIds != null) expr = expr & t.saintId.inSet(saintIds);
        return expr;
      },
      orderBy: (t) => t.obtainedAt.desc(),
      include: UserSaintCard.include(saint: Saint.include()),
      transaction: transaction,
    );
    final saints = rows.map((r) => r.saint!).toList();
    final infos = await SaintMapper.toInfos(session, saints);
    return [
      for (var i = 0; i < rows.length; i++)
        CollectedCard(
          saint: infos[i],
          scores: SaintMapper.toScores(saints[i]),
          obtainedAt: rows[i].obtainedAt,
          source: rows[i].source,
        ),
    ];
  }

  /// Published saints the user does not own yet.
  static Future<List<Saint>> missingSaints(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) async {
    final owned = await UserSaintCard.db.find(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    final ownedIds = owned.map((c) => c.saintId).toSet();
    final published = await Saint.db.find(
      session,
      where: (t) => t.status.equals(SaintStatus.published),
      transaction: transaction,
    );
    return published.where((s) => !ownedIds.contains(s.id)).toList();
  }

  /// Reads the profile inside [tx] with its row locked, so that two calls
  /// racing on the same player take turns instead of both acting.
  ///
  /// The app fires several endpoints at once on sign-in and each one needs the
  /// profile, so two transactions reach the same "did this already happen?"
  /// check at the same time. The naive check is unsafe under PostgreSQL's
  /// default READ COMMITTED, because every *statement* gets a fresh snapshot:
  /// both read `starterGranted == false`, then the second one reads a list of
  /// missing saints that already excludes the first one's cards, so its picks
  /// never collide with the unique index on (authUserId, saintId) and both
  /// grants land. That is how a new player could start with ten cards instead
  /// of five — or, back when the catalog had nine saints, with all nine.
  ///
  /// `for update` makes the second transaction wait for the first to commit and
  /// then read the flag it wrote. The profile is created first on purpose:
  /// locking a row that does not exist yet locks nothing, and it is the upsert
  /// in [ProfileService.ensure] that serializes the very first pair of calls.
  static Future<PlayerProfile> _lockedProfile(
    Session session,
    UuidValue authUserId,
    Transaction tx,
  ) async {
    await profileFor(session, authUserId, transaction: tx);
    await PlayerProfile.db.lockRows(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      lockMode: LockMode.forUpdate,
      transaction: tx,
    );
    // Re-read: whatever the waiting transaction wrote is only visible now.
    return profileFor(session, authUserId, transaction: tx);
  }

  /// Grants the starter pack once. Returns the granted cards.
  static Future<List<CollectedCard>> grantStarterPackIfNeeded(
    Session session,
    UuidValue authUserId,
  ) async {
    return session.db.transaction((tx) async {
      final profile = await _lockedProfile(session, authUserId, tx);
      if (profile.starterGranted) return const [];
      final missing = await missingSaints(session, authUserId, transaction: tx);
      missing.shuffle(_random);
      final picked = missing.take(starterPackSize).toList();
      final rows = await UserSaintCard.db.insert(
        session,
        [
          for (final saint in picked)
            UserSaintCard(
              authUserId: authUserId,
              saintId: saint.id!,
              source: CardSource.starter,
            ),
        ],
        transaction: tx,
      );
      await PlayerProfile.db.updateRow(
        session,
        profile.copyWith(starterGranted: true),
        // Only this column. `updateRow` writes the whole row by default, so an
        // endpoint that read the profile earlier and writes it back later would
        // revert this flag to the value it saw — which is exactly how players
        // ended up with a second starter pack.
        columns: (t) => [t.starterGranted],
        transaction: tx,
      );
      final infos = await SaintMapper.toInfos(session, picked);
      return [
        for (var i = 0; i < picked.length; i++)
          CollectedCard(
            saint: infos[i],
            scores: SaintMapper.toScores(picked[i]),
            obtainedAt: rows[i].obtainedAt,
            source: CardSource.starter,
          ),
      ];
    });
  }

  /// Claims today's card: the saint whose feast is today when available and
  /// not yet owned, otherwise a random missing saint.
  static Future<DailyClaimResult> claimDaily(
    Session session,
    UuidValue authUserId,
  ) async {
    return session.db.transaction((tx) async {
      // Same race as the starter pack: without the lock, two taps (or a retry
      // after a slow response) both read a day key that has not been written
      // yet and both grant a card.
      final profile = await _lockedProfile(session, authUserId, tx);
      final today = todayKey();
      if (profile.lastDailyClaimDay == today) {
        throw CollectionException(
          message: 'Ya reclamaste la carta de hoy. Volvé mañana.',
          code: CollectionErrorCode.alreadyClaimedToday,
        );
      }
      final missing = await missingSaints(session, authUserId, transaction: tx);
      if (missing.isEmpty) {
        throw CollectionException(
          message: 'Ya tenés todas las cartas. ¡Completaste el álbum!',
          code: CollectionErrorCode.noCardsLeft,
        );
      }
      final now = nowInArgentina();
      final feastToday = missing
          .where((s) => s.feastMonth == now.month && s.feastDay == now.day)
          .toList();
      final pool = feastToday.isNotEmpty ? feastToday : missing;
      final saint = pool[_random.nextInt(pool.length)];

      final row = await UserSaintCard.db.insertRow(
        session,
        UserSaintCard(
          authUserId: authUserId,
          saintId: saint.id!,
          source: CardSource.daily,
        ),
        transaction: tx,
      );
      await PlayerProfile.db.updateRow(
        session,
        profile.copyWith(lastDailyClaimDay: today),
        columns: (t) => [t.lastDailyClaimDay],
        transaction: tx,
      );
      return DailyClaimResult(
        card: CollectedCard(
          saint: await SaintMapper.toInfo(session, saint),
          scores: SaintMapper.toScores(saint),
          obtainedAt: row.obtainedAt,
          source: CardSource.daily,
        ),
        isFeastDay: feastToday.isNotEmpty,
      );
    });
  }

  /// Full collection state for the user, granting the starter pack if needed.
  static Future<CollectionOverview> overview(
    Session session,
    UuidValue authUserId,
  ) async {
    final starter = await grantStarterPackIfNeeded(session, authUserId);
    final profile = await profileFor(session, authUserId);
    final cards = await cardsOf(session, authUserId);
    final totalPublished = await Saint.db.count(
      session,
      where: (t) => t.status.equals(SaintStatus.published),
    );
    final today = todayKey();
    final claimedToday = profile.lastDailyClaimDay == today;
    CollectedCard? todayCard;
    if (claimedToday) {
      todayCard = cards
          .where(
            (c) =>
                c.source == CardSource.daily &&
                dayKey(c.obtainedAt.toUtc().add(argentinaOffset)) == today,
          )
          .firstOrNull;
    }
    return CollectionOverview(
      totalPublished: totalPublished,
      cards: cards,
      newStarterCards: starter,
      canClaimToday: !claimedToday && cards.length < totalPublished,
      todayCard: todayCard,
    );
  }

  /// Redeems an unlock code handed out during the stream.
  static Future<CollectedCard> redeem(
    Session session,
    UuidValue authUserId,
    String rawCode,
  ) async {
    final code = rawCode.trim().toUpperCase();
    return session.db.transaction((tx) async {
      final unlock = await UnlockCode.db.findFirstRow(
        session,
        where: (t) => t.code.equals(code) & t.active.equals(true),
        transaction: tx,
      );
      if (unlock == null) {
        throw CollectionException(
          message: 'Ese código no existe o ya no está activo.',
          code: CollectionErrorCode.invalidCode,
        );
      }
      final already = await UnlockRedemption.db.findFirstRow(
        session,
        where: (t) =>
            t.codeId.equals(unlock.id!) & t.authUserId.equals(authUserId),
        transaction: tx,
      );
      if (already != null) {
        throw CollectionException(
          message: 'Ya usaste ese código.',
          code: CollectionErrorCode.codeAlreadyUsed,
        );
      }
      final now = DateTime.now().toUtc();
      if (unlock.expiresAt != null && unlock.expiresAt!.isBefore(now)) {
        throw CollectionException(
          message: 'Ese código ya venció.',
          code: CollectionErrorCode.codeExpired,
        );
      }
      if (unlock.maxUses != null && unlock.uses >= unlock.maxUses!) {
        throw CollectionException(
          message: 'Ese código ya fue usado por el máximo de personas.',
          code: CollectionErrorCode.codeExhausted,
        );
      }
      final missing = await missingSaints(session, authUserId, transaction: tx);
      Saint? saint;
      if (unlock.saintId != null) {
        saint = missing.where((s) => s.id == unlock.saintId).firstOrNull;
        if (saint == null) {
          final target = await Saint.db.findById(
            session,
            unlock.saintId!,
            transaction: tx,
          );
          throw CollectionException(
            message: target == null
                ? 'La carta de ese código ya no existe.'
                : 'Ya tenés la carta de ${target.name}.',
            code: CollectionErrorCode.codeAlreadyUsed,
          );
        }
      } else {
        if (missing.isEmpty) {
          throw CollectionException(
            message: 'Ya tenés todas las cartas. ¡Completaste el álbum!',
            code: CollectionErrorCode.noCardsLeft,
          );
        }
        saint = missing[_random.nextInt(missing.length)];
      }
      final row = await UserSaintCard.db.insertRow(
        session,
        UserSaintCard(
          authUserId: authUserId,
          saintId: saint.id!,
          source: CardSource.code,
        ),
        transaction: tx,
      );
      await UnlockRedemption.db.insertRow(
        session,
        UnlockRedemption(codeId: unlock.id!, authUserId: authUserId),
        transaction: tx,
      );
      await UnlockCode.db.updateRow(
        session,
        unlock.copyWith(uses: unlock.uses + 1),
        transaction: tx,
      );
      return CollectedCard(
        saint: await SaintMapper.toInfo(session, saint),
        scores: SaintMapper.toScores(saint),
        obtainedAt: row.obtainedAt,
        source: CardSource.code,
      );
    });
  }
}
