/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// A friend as shown in the friends list.
abstract class FriendSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  FriendSummary._({
    required this.authUserId,
    required this.displayName,
    required this.cards,
    required this.streak,
    required this.bestStreak,
    required this.duelsWon,
    required this.since,
  });

  factory FriendSummary({
    required _is.UuidValue authUserId,
    required String displayName,
    required int cards,
    required int streak,
    required int bestStreak,
    required int duelsWon,
    required DateTime since,
  }) = _FriendSummaryImpl;

  factory FriendSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return FriendSummary(
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      cards: jsonSerialization['cards'] as int,
      streak: jsonSerialization['streak'] as int,
      bestStreak: jsonSerialization['bestStreak'] as int,
      duelsWon: jsonSerialization['duelsWon'] as int,
      since: _is.DateTimeJsonExtension.fromJson(jsonSerialization['since']),
    );
  }

  _is.UuidValue authUserId;

  String displayName;

  int cards;

  int streak;

  int bestStreak;

  int duelsWon;

  DateTime since;

  /// Returns a shallow copy of this [FriendSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FriendSummary copyWith({
    _is.UuidValue? authUserId,
    String? displayName,
    int? cards,
    int? streak,
    int? bestStreak,
    int? duelsWon,
    DateTime? since,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FriendSummary',
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'cards': cards,
      'streak': streak,
      'bestStreak': bestStreak,
      'duelsWon': duelsWon,
      'since': since.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FriendSummary',
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'cards': cards,
      'streak': streak,
      'bestStreak': bestStreak,
      'duelsWon': duelsWon,
      'since': since.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _FriendSummaryImpl extends FriendSummary {
  _FriendSummaryImpl({
    required _is.UuidValue authUserId,
    required String displayName,
    required int cards,
    required int streak,
    required int bestStreak,
    required int duelsWon,
    required DateTime since,
  }) : super._(
         authUserId: authUserId,
         displayName: displayName,
         cards: cards,
         streak: streak,
         bestStreak: bestStreak,
         duelsWon: duelsWon,
         since: since,
       );

  /// Returns a shallow copy of this [FriendSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FriendSummary copyWith({
    _is.UuidValue? authUserId,
    String? displayName,
    int? cards,
    int? streak,
    int? bestStreak,
    int? duelsWon,
    DateTime? since,
  }) {
    return FriendSummary(
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      cards: cards ?? this.cards,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      duelsWon: duelsWon ?? this.duelsWon,
      since: since ?? this.since,
    );
  }
}
