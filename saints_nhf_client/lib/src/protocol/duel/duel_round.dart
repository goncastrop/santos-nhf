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
import '../saints/score_category.dart' as _ihft2aor;

/// One round of a duel: attacker and defender each play a card and answer a
/// question about it.
abstract class DuelRound
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DuelRound._({
    this.id,
    required this.duelId,
    required this.roundNumber,
    required this.category,
    required this.attackerId,
    required this.defenderId,
    required this.attackerSaintId,
    this.attackerQuestionId,
    this.attackerAnswerIndex,
    this.attackerCorrect,
    this.defenderSaintId,
    this.defenderQuestionId,
    this.defenderAnswerIndex,
    this.defenderCorrect,
    this.attackerScore,
    this.defenderScore,
    this.pointTo,
    bool? resolved,
    DateTime? createdAt,
  }) : resolved = resolved ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory DuelRound({
    int? id,
    required int duelId,
    required int roundNumber,
    required _ihft2aor.ScoreCategory category,
    required _isc.UuidValue attackerId,
    required _isc.UuidValue defenderId,
    required int attackerSaintId,
    int? attackerQuestionId,
    int? attackerAnswerIndex,
    bool? attackerCorrect,
    int? defenderSaintId,
    int? defenderQuestionId,
    int? defenderAnswerIndex,
    bool? defenderCorrect,
    int? attackerScore,
    int? defenderScore,
    _isc.UuidValue? pointTo,
    bool? resolved,
    DateTime? createdAt,
  }) = _DuelRoundImpl;

  factory DuelRound.fromJson(Map<String, dynamic> jsonSerialization) {
    return DuelRound(
      id: jsonSerialization['id'] as int?,
      duelId: jsonSerialization['duelId'] as int,
      roundNumber: jsonSerialization['roundNumber'] as int,
      category: _ihft2aor.ScoreCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      attackerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['attackerId'],
      ),
      defenderId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['defenderId'],
      ),
      attackerSaintId: jsonSerialization['attackerSaintId'] as int,
      attackerQuestionId: jsonSerialization['attackerQuestionId'] as int?,
      attackerAnswerIndex: jsonSerialization['attackerAnswerIndex'] as int?,
      attackerCorrect: jsonSerialization['attackerCorrect'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['attackerCorrect'],
            ),
      defenderSaintId: jsonSerialization['defenderSaintId'] as int?,
      defenderQuestionId: jsonSerialization['defenderQuestionId'] as int?,
      defenderAnswerIndex: jsonSerialization['defenderAnswerIndex'] as int?,
      defenderCorrect: jsonSerialization['defenderCorrect'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['defenderCorrect'],
            ),
      attackerScore: jsonSerialization['attackerScore'] as int?,
      defenderScore: jsonSerialization['defenderScore'] as int?,
      pointTo: jsonSerialization['pointTo'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['pointTo']),
      resolved: jsonSerialization['resolved'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['resolved']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int duelId;

  int roundNumber;

  _ihft2aor.ScoreCategory category;

  _isc.UuidValue attackerId;

  _isc.UuidValue defenderId;

  int attackerSaintId;

  int? attackerQuestionId;

  int? attackerAnswerIndex;

  bool? attackerCorrect;

  int? defenderSaintId;

  int? defenderQuestionId;

  int? defenderAnswerIndex;

  bool? defenderCorrect;

  int? attackerScore;

  int? defenderScore;

  _isc.UuidValue? pointTo;

  bool resolved;

  DateTime createdAt;

  /// Returns a shallow copy of this [DuelRound]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DuelRound copyWith({
    int? id,
    int? duelId,
    int? roundNumber,
    _ihft2aor.ScoreCategory? category,
    _isc.UuidValue? attackerId,
    _isc.UuidValue? defenderId,
    int? attackerSaintId,
    int? attackerQuestionId,
    int? attackerAnswerIndex,
    bool? attackerCorrect,
    int? defenderSaintId,
    int? defenderQuestionId,
    int? defenderAnswerIndex,
    bool? defenderCorrect,
    int? attackerScore,
    int? defenderScore,
    _isc.UuidValue? pointTo,
    bool? resolved,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuelRound',
      if (id != null) 'id': id,
      'duelId': duelId,
      'roundNumber': roundNumber,
      'category': category.toJson(),
      'attackerId': attackerId.toJson(),
      'defenderId': defenderId.toJson(),
      'attackerSaintId': attackerSaintId,
      if (attackerQuestionId != null) 'attackerQuestionId': attackerQuestionId,
      if (attackerAnswerIndex != null)
        'attackerAnswerIndex': attackerAnswerIndex,
      if (attackerCorrect != null) 'attackerCorrect': attackerCorrect,
      if (defenderSaintId != null) 'defenderSaintId': defenderSaintId,
      if (defenderQuestionId != null) 'defenderQuestionId': defenderQuestionId,
      if (defenderAnswerIndex != null)
        'defenderAnswerIndex': defenderAnswerIndex,
      if (defenderCorrect != null) 'defenderCorrect': defenderCorrect,
      if (attackerScore != null) 'attackerScore': attackerScore,
      if (defenderScore != null) 'defenderScore': defenderScore,
      if (pointTo != null) 'pointTo': pointTo?.toJson(),
      'resolved': resolved,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DuelRound',
      if (id != null) 'id': id,
      'duelId': duelId,
      'roundNumber': roundNumber,
      'category': category.toJson(),
      'attackerId': attackerId.toJson(),
      'defenderId': defenderId.toJson(),
      'attackerSaintId': attackerSaintId,
      if (attackerQuestionId != null) 'attackerQuestionId': attackerQuestionId,
      if (attackerAnswerIndex != null)
        'attackerAnswerIndex': attackerAnswerIndex,
      if (attackerCorrect != null) 'attackerCorrect': attackerCorrect,
      if (defenderSaintId != null) 'defenderSaintId': defenderSaintId,
      if (defenderQuestionId != null) 'defenderQuestionId': defenderQuestionId,
      if (defenderAnswerIndex != null)
        'defenderAnswerIndex': defenderAnswerIndex,
      if (defenderCorrect != null) 'defenderCorrect': defenderCorrect,
      if (attackerScore != null) 'attackerScore': attackerScore,
      if (defenderScore != null) 'defenderScore': defenderScore,
      if (pointTo != null) 'pointTo': pointTo?.toJson(),
      'resolved': resolved,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelRoundImpl extends DuelRound {
  _DuelRoundImpl({
    int? id,
    required int duelId,
    required int roundNumber,
    required _ihft2aor.ScoreCategory category,
    required _isc.UuidValue attackerId,
    required _isc.UuidValue defenderId,
    required int attackerSaintId,
    int? attackerQuestionId,
    int? attackerAnswerIndex,
    bool? attackerCorrect,
    int? defenderSaintId,
    int? defenderQuestionId,
    int? defenderAnswerIndex,
    bool? defenderCorrect,
    int? attackerScore,
    int? defenderScore,
    _isc.UuidValue? pointTo,
    bool? resolved,
    DateTime? createdAt,
  }) : super._(
         id: id,
         duelId: duelId,
         roundNumber: roundNumber,
         category: category,
         attackerId: attackerId,
         defenderId: defenderId,
         attackerSaintId: attackerSaintId,
         attackerQuestionId: attackerQuestionId,
         attackerAnswerIndex: attackerAnswerIndex,
         attackerCorrect: attackerCorrect,
         defenderSaintId: defenderSaintId,
         defenderQuestionId: defenderQuestionId,
         defenderAnswerIndex: defenderAnswerIndex,
         defenderCorrect: defenderCorrect,
         attackerScore: attackerScore,
         defenderScore: defenderScore,
         pointTo: pointTo,
         resolved: resolved,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DuelRound]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DuelRound copyWith({
    Object? id = _Undefined,
    int? duelId,
    int? roundNumber,
    _ihft2aor.ScoreCategory? category,
    _isc.UuidValue? attackerId,
    _isc.UuidValue? defenderId,
    int? attackerSaintId,
    Object? attackerQuestionId = _Undefined,
    Object? attackerAnswerIndex = _Undefined,
    Object? attackerCorrect = _Undefined,
    Object? defenderSaintId = _Undefined,
    Object? defenderQuestionId = _Undefined,
    Object? defenderAnswerIndex = _Undefined,
    Object? defenderCorrect = _Undefined,
    Object? attackerScore = _Undefined,
    Object? defenderScore = _Undefined,
    Object? pointTo = _Undefined,
    bool? resolved,
    DateTime? createdAt,
  }) {
    return DuelRound(
      id: id is int? ? id : this.id,
      duelId: duelId ?? this.duelId,
      roundNumber: roundNumber ?? this.roundNumber,
      category: category ?? this.category,
      attackerId: attackerId ?? this.attackerId,
      defenderId: defenderId ?? this.defenderId,
      attackerSaintId: attackerSaintId ?? this.attackerSaintId,
      attackerQuestionId: attackerQuestionId is int?
          ? attackerQuestionId
          : this.attackerQuestionId,
      attackerAnswerIndex: attackerAnswerIndex is int?
          ? attackerAnswerIndex
          : this.attackerAnswerIndex,
      attackerCorrect: attackerCorrect is bool?
          ? attackerCorrect
          : this.attackerCorrect,
      defenderSaintId: defenderSaintId is int?
          ? defenderSaintId
          : this.defenderSaintId,
      defenderQuestionId: defenderQuestionId is int?
          ? defenderQuestionId
          : this.defenderQuestionId,
      defenderAnswerIndex: defenderAnswerIndex is int?
          ? defenderAnswerIndex
          : this.defenderAnswerIndex,
      defenderCorrect: defenderCorrect is bool?
          ? defenderCorrect
          : this.defenderCorrect,
      attackerScore: attackerScore is int? ? attackerScore : this.attackerScore,
      defenderScore: defenderScore is int? ? defenderScore : this.defenderScore,
      pointTo: pointTo is _isc.UuidValue? ? pointTo : this.pointTo,
      resolved: resolved ?? this.resolved,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
