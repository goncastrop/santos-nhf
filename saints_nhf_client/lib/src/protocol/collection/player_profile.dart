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
import 'package:saints_nhf_client/src/protocol/protocol.dart' as _ipd1p8hh;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Per-user game state.
abstract class PlayerProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlayerProfile._({
    this.id,
    required this.authUserId,
    this.authUser,
    this.lastDailyClaimDay,
    bool? starterGranted,
    this.displayName,
    this.friendCode,
    this.quizDay,
    this.quizQuestionId,
    this.quizChosenIndex,
    bool? quizAnswered,
    this.lastCorrectDay,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    this.pendingHand,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  }) : starterGranted = starterGranted ?? false,
       quizAnswered = quizAnswered ?? false,
       streak = streak ?? 0,
       bestStreak = bestStreak ?? 0,
       totalAnswered = totalAnswered ?? 0,
       totalCorrect = totalCorrect ?? 0,
       duelsWon = duelsWon ?? 0,
       duelsPlayed = duelsPlayed ?? 0,
       litanyBest = litanyBest ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory PlayerProfile({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    String? lastDailyClaimDay,
    bool? starterGranted,
    String? displayName,
    String? friendCode,
    String? quizDay,
    int? quizQuestionId,
    int? quizChosenIndex,
    bool? quizAnswered,
    String? lastCorrectDay,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    List<int>? pendingHand,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  }) = _PlayerProfileImpl;

  factory PlayerProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlayerProfile(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      lastDailyClaimDay: jsonSerialization['lastDailyClaimDay'] as String?,
      starterGranted: jsonSerialization['starterGranted'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['starterGranted'],
            ),
      displayName: jsonSerialization['displayName'] as String?,
      friendCode: jsonSerialization['friendCode'] as String?,
      quizDay: jsonSerialization['quizDay'] as String?,
      quizQuestionId: jsonSerialization['quizQuestionId'] as int?,
      quizChosenIndex: jsonSerialization['quizChosenIndex'] as int?,
      quizAnswered: jsonSerialization['quizAnswered'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['quizAnswered']),
      lastCorrectDay: jsonSerialization['lastCorrectDay'] as String?,
      streak: jsonSerialization['streak'] as int?,
      bestStreak: jsonSerialization['bestStreak'] as int?,
      totalAnswered: jsonSerialization['totalAnswered'] as int?,
      totalCorrect: jsonSerialization['totalCorrect'] as int?,
      pendingHand: jsonSerialization['pendingHand'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<List<int>>(
              jsonSerialization['pendingHand'],
            ),
      duelsWon: jsonSerialization['duelsWon'] as int?,
      duelsPlayed: jsonSerialization['duelsPlayed'] as int?,
      litanyBest: jsonSerialization['litanyBest'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  _iacc.AuthUser? authUser;

  /// Calendar day (yyyy-MM-dd, Argentina time) of the last daily claim.
  String? lastDailyClaimDay;

  bool starterGranted;

  /// Public name shown to friends and in rankings.
  String? displayName;

  /// Code friends use to add this player.
  String? friendCode;

  /// Daily quiz: current question and stats.
  String? quizDay;

  int? quizQuestionId;

  int? quizChosenIndex;

  bool quizAnswered;

  /// Day of the last correct daily answer, to continue the streak.
  String? lastCorrectDay;

  int streak;

  int bestStreak;

  int totalAnswered;

  int totalCorrect;

  /// Cards dealt for the next duel deck; the deck must come from here.
  List<int>? pendingHand;

  /// Duel stats.
  int duelsWon;

  int duelsPlayed;

  /// Best score ever reached in La Letanía.
  int litanyBest;

  DateTime createdAt;

  /// Returns a shallow copy of this [PlayerProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlayerProfile copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    String? lastDailyClaimDay,
    bool? starterGranted,
    String? displayName,
    String? friendCode,
    String? quizDay,
    int? quizQuestionId,
    int? quizChosenIndex,
    bool? quizAnswered,
    String? lastCorrectDay,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    List<int>? pendingHand,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlayerProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (lastDailyClaimDay != null) 'lastDailyClaimDay': lastDailyClaimDay,
      'starterGranted': starterGranted,
      if (displayName != null) 'displayName': displayName,
      if (friendCode != null) 'friendCode': friendCode,
      if (quizDay != null) 'quizDay': quizDay,
      if (quizQuestionId != null) 'quizQuestionId': quizQuestionId,
      if (quizChosenIndex != null) 'quizChosenIndex': quizChosenIndex,
      'quizAnswered': quizAnswered,
      if (lastCorrectDay != null) 'lastCorrectDay': lastCorrectDay,
      'streak': streak,
      'bestStreak': bestStreak,
      'totalAnswered': totalAnswered,
      'totalCorrect': totalCorrect,
      if (pendingHand != null) 'pendingHand': pendingHand?.toJson(),
      'duelsWon': duelsWon,
      'duelsPlayed': duelsPlayed,
      'litanyBest': litanyBest,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlayerProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (lastDailyClaimDay != null) 'lastDailyClaimDay': lastDailyClaimDay,
      'starterGranted': starterGranted,
      if (displayName != null) 'displayName': displayName,
      if (friendCode != null) 'friendCode': friendCode,
      if (quizDay != null) 'quizDay': quizDay,
      if (quizQuestionId != null) 'quizQuestionId': quizQuestionId,
      if (quizChosenIndex != null) 'quizChosenIndex': quizChosenIndex,
      'quizAnswered': quizAnswered,
      if (lastCorrectDay != null) 'lastCorrectDay': lastCorrectDay,
      'streak': streak,
      'bestStreak': bestStreak,
      'totalAnswered': totalAnswered,
      'totalCorrect': totalCorrect,
      if (pendingHand != null) 'pendingHand': pendingHand?.toJson(),
      'duelsWon': duelsWon,
      'duelsPlayed': duelsPlayed,
      'litanyBest': litanyBest,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlayerProfileImpl extends PlayerProfile {
  _PlayerProfileImpl({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    String? lastDailyClaimDay,
    bool? starterGranted,
    String? displayName,
    String? friendCode,
    String? quizDay,
    int? quizQuestionId,
    int? quizChosenIndex,
    bool? quizAnswered,
    String? lastCorrectDay,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    List<int>? pendingHand,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         lastDailyClaimDay: lastDailyClaimDay,
         starterGranted: starterGranted,
         displayName: displayName,
         friendCode: friendCode,
         quizDay: quizDay,
         quizQuestionId: quizQuestionId,
         quizChosenIndex: quizChosenIndex,
         quizAnswered: quizAnswered,
         lastCorrectDay: lastCorrectDay,
         streak: streak,
         bestStreak: bestStreak,
         totalAnswered: totalAnswered,
         totalCorrect: totalCorrect,
         pendingHand: pendingHand,
         duelsWon: duelsWon,
         duelsPlayed: duelsPlayed,
         litanyBest: litanyBest,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PlayerProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlayerProfile copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? lastDailyClaimDay = _Undefined,
    bool? starterGranted,
    Object? displayName = _Undefined,
    Object? friendCode = _Undefined,
    Object? quizDay = _Undefined,
    Object? quizQuestionId = _Undefined,
    Object? quizChosenIndex = _Undefined,
    bool? quizAnswered,
    Object? lastCorrectDay = _Undefined,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    Object? pendingHand = _Undefined,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  }) {
    return PlayerProfile(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      lastDailyClaimDay: lastDailyClaimDay is String?
          ? lastDailyClaimDay
          : this.lastDailyClaimDay,
      starterGranted: starterGranted ?? this.starterGranted,
      displayName: displayName is String? ? displayName : this.displayName,
      friendCode: friendCode is String? ? friendCode : this.friendCode,
      quizDay: quizDay is String? ? quizDay : this.quizDay,
      quizQuestionId: quizQuestionId is int?
          ? quizQuestionId
          : this.quizQuestionId,
      quizChosenIndex: quizChosenIndex is int?
          ? quizChosenIndex
          : this.quizChosenIndex,
      quizAnswered: quizAnswered ?? this.quizAnswered,
      lastCorrectDay: lastCorrectDay is String?
          ? lastCorrectDay
          : this.lastCorrectDay,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      pendingHand: pendingHand is List<int>?
          ? pendingHand
          : this.pendingHand?.map((e0) => e0).toList(),
      duelsWon: duelsWon ?? this.duelsWon,
      duelsPlayed: duelsPlayed ?? this.duelsPlayed,
      litanyBest: litanyBest ?? this.litanyBest,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
