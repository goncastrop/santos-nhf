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

/// The viewer's own standing in the live game.
abstract class LiveMe
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LiveMe._({
    required this.answered,
    this.chosenIndex,
    this.correct,
    this.lastPoints,
    required this.totalPoints,
    this.rank,
    required this.players,
    this.wonSaintId,
  });

  factory LiveMe({
    required bool answered,
    int? chosenIndex,
    bool? correct,
    int? lastPoints,
    required int totalPoints,
    int? rank,
    required int players,
    int? wonSaintId,
  }) = _LiveMeImpl;

  factory LiveMe.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveMe(
      answered: _isc.BoolJsonExtension.fromJson(jsonSerialization['answered']),
      chosenIndex: jsonSerialization['chosenIndex'] as int?,
      correct: jsonSerialization['correct'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['correct']),
      lastPoints: jsonSerialization['lastPoints'] as int?,
      totalPoints: jsonSerialization['totalPoints'] as int,
      rank: jsonSerialization['rank'] as int?,
      players: jsonSerialization['players'] as int,
      wonSaintId: jsonSerialization['wonSaintId'] as int?,
    );
  }

  /// Whether they already answered the current question, which option (in
  /// the order shown) and, once it closed, how it went.
  bool answered;

  int? chosenIndex;

  bool? correct;

  int? lastPoints;

  int totalPoints;

  /// Position among the players who answered at least once, and how many
  /// they are. Null before their first answer.
  int? rank;

  int players;

  /// At the end: the card this viewer won, if any.
  int? wonSaintId;

  /// Returns a shallow copy of this [LiveMe]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LiveMe copyWith({
    bool? answered,
    int? chosenIndex,
    bool? correct,
    int? lastPoints,
    int? totalPoints,
    int? rank,
    int? players,
    int? wonSaintId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveMe',
      'answered': answered,
      if (chosenIndex != null) 'chosenIndex': chosenIndex,
      if (correct != null) 'correct': correct,
      if (lastPoints != null) 'lastPoints': lastPoints,
      'totalPoints': totalPoints,
      if (rank != null) 'rank': rank,
      'players': players,
      if (wonSaintId != null) 'wonSaintId': wonSaintId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LiveMe',
      'answered': answered,
      if (chosenIndex != null) 'chosenIndex': chosenIndex,
      if (correct != null) 'correct': correct,
      if (lastPoints != null) 'lastPoints': lastPoints,
      'totalPoints': totalPoints,
      if (rank != null) 'rank': rank,
      'players': players,
      if (wonSaintId != null) 'wonSaintId': wonSaintId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveMeImpl extends LiveMe {
  _LiveMeImpl({
    required bool answered,
    int? chosenIndex,
    bool? correct,
    int? lastPoints,
    required int totalPoints,
    int? rank,
    required int players,
    int? wonSaintId,
  }) : super._(
         answered: answered,
         chosenIndex: chosenIndex,
         correct: correct,
         lastPoints: lastPoints,
         totalPoints: totalPoints,
         rank: rank,
         players: players,
         wonSaintId: wonSaintId,
       );

  /// Returns a shallow copy of this [LiveMe]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LiveMe copyWith({
    bool? answered,
    Object? chosenIndex = _Undefined,
    Object? correct = _Undefined,
    Object? lastPoints = _Undefined,
    int? totalPoints,
    Object? rank = _Undefined,
    int? players,
    Object? wonSaintId = _Undefined,
  }) {
    return LiveMe(
      answered: answered ?? this.answered,
      chosenIndex: chosenIndex is int? ? chosenIndex : this.chosenIndex,
      correct: correct is bool? ? correct : this.correct,
      lastPoints: lastPoints is int? ? lastPoints : this.lastPoints,
      totalPoints: totalPoints ?? this.totalPoints,
      rank: rank is int? ? rank : this.rank,
      players: players ?? this.players,
      wonSaintId: wonSaintId is int? ? wonSaintId : this.wonSaintId,
    );
  }
}
