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

/// A duel in the player's list.
abstract class DuelSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DuelSummary._({
    required this.duelId,
    required this.status,
    required this.isVsMachine,
    required this.opponentName,
    required this.myScore,
    required this.opponentScore,
    required this.isMyTurn,
    this.winnerIsMe,
    required this.updatedAt,
  });

  factory DuelSummary({
    required int duelId,
    required _i6u3xm2k.DuelStatus status,
    required bool isVsMachine,
    required String opponentName,
    required int myScore,
    required int opponentScore,
    required bool isMyTurn,
    bool? winnerIsMe,
    required DateTime updatedAt,
  }) = _DuelSummaryImpl;

  factory DuelSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return DuelSummary(
      duelId: jsonSerialization['duelId'] as int,
      status: _i6u3xm2k.DuelStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      isVsMachine: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isVsMachine'],
      ),
      opponentName: jsonSerialization['opponentName'] as String,
      myScore: jsonSerialization['myScore'] as int,
      opponentScore: jsonSerialization['opponentScore'] as int,
      isMyTurn: _isc.BoolJsonExtension.fromJson(jsonSerialization['isMyTurn']),
      winnerIsMe: jsonSerialization['winnerIsMe'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['winnerIsMe']),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int duelId;

  _i6u3xm2k.DuelStatus status;

  bool isVsMachine;

  String opponentName;

  int myScore;

  int opponentScore;

  bool isMyTurn;

  bool? winnerIsMe;

  DateTime updatedAt;

  /// Returns a shallow copy of this [DuelSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DuelSummary copyWith({
    int? duelId,
    _i6u3xm2k.DuelStatus? status,
    bool? isVsMachine,
    String? opponentName,
    int? myScore,
    int? opponentScore,
    bool? isMyTurn,
    bool? winnerIsMe,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuelSummary',
      'duelId': duelId,
      'status': status.toJson(),
      'isVsMachine': isVsMachine,
      'opponentName': opponentName,
      'myScore': myScore,
      'opponentScore': opponentScore,
      'isMyTurn': isMyTurn,
      if (winnerIsMe != null) 'winnerIsMe': winnerIsMe,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DuelSummary',
      'duelId': duelId,
      'status': status.toJson(),
      'isVsMachine': isVsMachine,
      'opponentName': opponentName,
      'myScore': myScore,
      'opponentScore': opponentScore,
      'isMyTurn': isMyTurn,
      if (winnerIsMe != null) 'winnerIsMe': winnerIsMe,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelSummaryImpl extends DuelSummary {
  _DuelSummaryImpl({
    required int duelId,
    required _i6u3xm2k.DuelStatus status,
    required bool isVsMachine,
    required String opponentName,
    required int myScore,
    required int opponentScore,
    required bool isMyTurn,
    bool? winnerIsMe,
    required DateTime updatedAt,
  }) : super._(
         duelId: duelId,
         status: status,
         isVsMachine: isVsMachine,
         opponentName: opponentName,
         myScore: myScore,
         opponentScore: opponentScore,
         isMyTurn: isMyTurn,
         winnerIsMe: winnerIsMe,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DuelSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DuelSummary copyWith({
    int? duelId,
    _i6u3xm2k.DuelStatus? status,
    bool? isVsMachine,
    String? opponentName,
    int? myScore,
    int? opponentScore,
    bool? isMyTurn,
    Object? winnerIsMe = _Undefined,
    DateTime? updatedAt,
  }) {
    return DuelSummary(
      duelId: duelId ?? this.duelId,
      status: status ?? this.status,
      isVsMachine: isVsMachine ?? this.isVsMachine,
      opponentName: opponentName ?? this.opponentName,
      myScore: myScore ?? this.myScore,
      opponentScore: opponentScore ?? this.opponentScore,
      isMyTurn: isMyTurn ?? this.isMyTurn,
      winnerIsMe: winnerIsMe is bool? ? winnerIsMe : this.winnerIsMe,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
