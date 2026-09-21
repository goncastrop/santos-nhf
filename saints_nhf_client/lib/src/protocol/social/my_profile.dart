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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// The caller's public identity and stats.
abstract class MyProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MyProfile._({
    required this.authUserId,
    required this.displayName,
    required this.friendCode,
    required this.cards,
    required this.streak,
    required this.bestStreak,
    required this.duelsWon,
    required this.duelsPlayed,
  });

  factory MyProfile({
    required _isc.UuidValue authUserId,
    required String displayName,
    required String friendCode,
    required int cards,
    required int streak,
    required int bestStreak,
    required int duelsWon,
    required int duelsPlayed,
  }) = _MyProfileImpl;

  factory MyProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyProfile(
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      friendCode: jsonSerialization['friendCode'] as String,
      cards: jsonSerialization['cards'] as int,
      streak: jsonSerialization['streak'] as int,
      bestStreak: jsonSerialization['bestStreak'] as int,
      duelsWon: jsonSerialization['duelsWon'] as int,
      duelsPlayed: jsonSerialization['duelsPlayed'] as int,
    );
  }

  _isc.UuidValue authUserId;

  String displayName;

  String friendCode;

  int cards;

  int streak;

  int bestStreak;

  int duelsWon;

  int duelsPlayed;

  /// Returns a shallow copy of this [MyProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MyProfile copyWith({
    _isc.UuidValue? authUserId,
    String? displayName,
    String? friendCode,
    int? cards,
    int? streak,
    int? bestStreak,
    int? duelsWon,
    int? duelsPlayed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MyProfile',
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'friendCode': friendCode,
      'cards': cards,
      'streak': streak,
      'bestStreak': bestStreak,
      'duelsWon': duelsWon,
      'duelsPlayed': duelsPlayed,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MyProfile',
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'friendCode': friendCode,
      'cards': cards,
      'streak': streak,
      'bestStreak': bestStreak,
      'duelsWon': duelsWon,
      'duelsPlayed': duelsPlayed,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MyProfileImpl extends MyProfile {
  _MyProfileImpl({
    required _isc.UuidValue authUserId,
    required String displayName,
    required String friendCode,
    required int cards,
    required int streak,
    required int bestStreak,
    required int duelsWon,
    required int duelsPlayed,
  }) : super._(
         authUserId: authUserId,
         displayName: displayName,
         friendCode: friendCode,
         cards: cards,
         streak: streak,
         bestStreak: bestStreak,
         duelsWon: duelsWon,
         duelsPlayed: duelsPlayed,
       );

  /// Returns a shallow copy of this [MyProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MyProfile copyWith({
    _isc.UuidValue? authUserId,
    String? displayName,
    String? friendCode,
    int? cards,
    int? streak,
    int? bestStreak,
    int? duelsWon,
    int? duelsPlayed,
  }) {
    return MyProfile(
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      friendCode: friendCode ?? this.friendCode,
      cards: cards ?? this.cards,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      duelsWon: duelsWon ?? this.duelsWon,
      duelsPlayed: duelsPlayed ?? this.duelsPlayed,
    );
  }
}
