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
import '../duel/duel_status.dart' as _i6u3xm2k;

/// A duel between two players (or a player and the machine).
abstract class Duel
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Duel._({
    this.id,
    required this.challengerId,
    required this.opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    this.attackerId,
    this.turnOf,
    int? challengerScore,
    int? opponentScore,
    this.winnerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.finishedAt,
  }) : isVsMachine = isVsMachine ?? false,
       status = status ?? _i6u3xm2k.DuelStatus.pendingDeck,
       roundNumber = roundNumber ?? 1,
       challengerScore = challengerScore ?? 0,
       opponentScore = opponentScore ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Duel({
    int? id,
    required _isc.UuidValue challengerId,
    required _isc.UuidValue opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    _isc.UuidValue? attackerId,
    _isc.UuidValue? turnOf,
    int? challengerScore,
    int? opponentScore,
    _isc.UuidValue? winnerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? finishedAt,
  }) = _DuelImpl;

  factory Duel.fromJson(Map<String, dynamic> jsonSerialization) {
    return Duel(
      id: jsonSerialization['id'] as int?,
      challengerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengerId'],
      ),
      opponentId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['opponentId'],
      ),
      isVsMachine: jsonSerialization['isVsMachine'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isVsMachine']),
      status: jsonSerialization['status'] == null
          ? null
          : _i6u3xm2k.DuelStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      roundNumber: jsonSerialization['roundNumber'] as int?,
      attackerId: jsonSerialization['attackerId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['attackerId'],
            ),
      turnOf: jsonSerialization['turnOf'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['turnOf']),
      challengerScore: jsonSerialization['challengerScore'] as int?,
      opponentScore: jsonSerialization['opponentScore'] as int?,
      winnerId: jsonSerialization['winnerId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['winnerId']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['finishedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue challengerId;

  _isc.UuidValue opponentId;

  bool isVsMachine;

  _i6u3xm2k.DuelStatus status;

  int roundNumber;

  /// Attacker of the current round.
  _isc.UuidValue? attackerId;

  /// Player who has to act now. Null when finished.
  _isc.UuidValue? turnOf;

  int challengerScore;

  int opponentScore;

  /// Null while unfinished, and on a draw.
  _isc.UuidValue? winnerId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? finishedAt;

  /// Returns a shallow copy of this [Duel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Duel copyWith({
    int? id,
    _isc.UuidValue? challengerId,
    _isc.UuidValue? opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    _isc.UuidValue? attackerId,
    _isc.UuidValue? turnOf,
    int? challengerScore,
    int? opponentScore,
    _isc.UuidValue? winnerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? finishedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Duel',
      if (id != null) 'id': id,
      'challengerId': challengerId.toJson(),
      'opponentId': opponentId.toJson(),
      'isVsMachine': isVsMachine,
      'status': status.toJson(),
      'roundNumber': roundNumber,
      if (attackerId != null) 'attackerId': attackerId?.toJson(),
      if (turnOf != null) 'turnOf': turnOf?.toJson(),
      'challengerScore': challengerScore,
      'opponentScore': opponentScore,
      if (winnerId != null) 'winnerId': winnerId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Duel',
      if (id != null) 'id': id,
      'challengerId': challengerId.toJson(),
      'opponentId': opponentId.toJson(),
      'isVsMachine': isVsMachine,
      'status': status.toJson(),
      'roundNumber': roundNumber,
      if (attackerId != null) 'attackerId': attackerId?.toJson(),
      if (turnOf != null) 'turnOf': turnOf?.toJson(),
      'challengerScore': challengerScore,
      'opponentScore': opponentScore,
      if (winnerId != null) 'winnerId': winnerId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelImpl extends Duel {
  _DuelImpl({
    int? id,
    required _isc.UuidValue challengerId,
    required _isc.UuidValue opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    _isc.UuidValue? attackerId,
    _isc.UuidValue? turnOf,
    int? challengerScore,
    int? opponentScore,
    _isc.UuidValue? winnerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? finishedAt,
  }) : super._(
         id: id,
         challengerId: challengerId,
         opponentId: opponentId,
         isVsMachine: isVsMachine,
         status: status,
         roundNumber: roundNumber,
         attackerId: attackerId,
         turnOf: turnOf,
         challengerScore: challengerScore,
         opponentScore: opponentScore,
         winnerId: winnerId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         finishedAt: finishedAt,
       );

  /// Returns a shallow copy of this [Duel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Duel copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? challengerId,
    _isc.UuidValue? opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    Object? attackerId = _Undefined,
    Object? turnOf = _Undefined,
    int? challengerScore,
    int? opponentScore,
    Object? winnerId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? finishedAt = _Undefined,
  }) {
    return Duel(
      id: id is int? ? id : this.id,
      challengerId: challengerId ?? this.challengerId,
      opponentId: opponentId ?? this.opponentId,
      isVsMachine: isVsMachine ?? this.isVsMachine,
      status: status ?? this.status,
      roundNumber: roundNumber ?? this.roundNumber,
      attackerId: attackerId is _isc.UuidValue? ? attackerId : this.attackerId,
      turnOf: turnOf is _isc.UuidValue? ? turnOf : this.turnOf,
      challengerScore: challengerScore ?? this.challengerScore,
      opponentScore: opponentScore ?? this.opponentScore,
      winnerId: winnerId is _isc.UuidValue? ? winnerId : this.winnerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
    );
  }
}
