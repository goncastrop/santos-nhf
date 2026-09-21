import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Player identity helpers: display names and friend codes.
class ProfileService {
  static const _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final _random = Random.secure();

  /// Gets or creates the profile, making sure it has a friend code.
  static Future<PlayerProfile> ensure(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) async {
    var profile = await PlayerProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    if (profile == null) {
      // The app calls several endpoints in parallel on sign-in and each one
      // needs the profile, so two of them can try to create it at once. An
      // upsert that never overwrites keeps the race from aborting the
      // surrounding transaction, which a failed plain insert would do.
      profile = await PlayerProfile.db.upsertRow(
        session,
        PlayerProfile(authUserId: authUserId),
        conflictColumns: (t) => [t.authUserId],
        updateWhere: (_) => Constant.bool(false),
        transaction: transaction,
      );
      // Null means the row already existed and was left untouched.
      profile ??= await PlayerProfile.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: transaction,
      );
      if (profile == null) {
        throw StateError('Could not create the profile for $authUserId.');
      }
    }
    if (profile.friendCode == null || _isBlank(profile.displayName)) {
      profile = await PlayerProfile.db.updateRow(
        session,
        profile.copyWith(
          friendCode:
              profile.friendCode ??
              await _freeCode(session, transaction: transaction),
          // A random public name, unrelated to the friend code so rankings
          // never leak it.
          displayName: _isBlank(profile.displayName)
              ? _randomName()
              : profile.displayName,
        ),
        transaction: transaction,
      );
    }
    return profile;
  }

  static bool _isBlank(String? s) => s == null || s.trim().isEmpty;

  static const _adjectives = [
    'Peregrino',
    'Caminante',
    'Discípulo',
    'Romero',
    'Escriba',
    'Lector',
    'Cantor',
    'Custodio',
  ];

  static String _randomName() {
    final word = _adjectives[_random.nextInt(_adjectives.length)];
    final number = 100 + _random.nextInt(900);
    return '$word $number';
  }

  static Future<PlayerProfile?> byUserId(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) {
    return PlayerProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
  }

  /// Name shown to other players. Never derived from the friend code.
  static String nameOf(PlayerProfile? profile) {
    final name = profile?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return 'Peregrino';
  }

  /// Number of published cards the player owns.
  static Future<int> cardCount(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) {
    return UserSaintCard.db.count(
      session,
      where: (t) =>
          t.authUserId.equals(authUserId) &
          t.saint.status.equals(SaintStatus.published),
      transaction: transaction,
    );
  }

  static Future<String> _freeCode(
    Session session, {
    Transaction? transaction,
  }) async {
    for (var attempt = 0; attempt < 20; attempt++) {
      final code = List.generate(
        6,
        (_) => _alphabet[_random.nextInt(_alphabet.length)],
      ).join();
      final taken = await PlayerProfile.db.findFirstRow(
        session,
        where: (t) => t.friendCode.equals(code),
        transaction: transaction,
      );
      if (taken == null) return code;
    }
    throw StateError('Could not generate a free friend code.');
  }
}
