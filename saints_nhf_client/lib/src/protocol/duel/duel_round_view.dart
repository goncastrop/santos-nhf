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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../saints/saint_info.dart' as _i38p9z6b;
import '../saints/score_category.dart' as _ihft2aor;

/// A round as seen by one of the players. The opponent's card is only
/// revealed once the round is resolved.
abstract class DuelRoundView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DuelRoundView._({
    required this.roundNumber,
    required this.category,
    required this.attackerIsMe,
    required this.resolved,
    this.mySaint,
    this.myScore,
    this.myCorrect,
    this.opponentSaint,
    this.opponentScore,
    this.opponentCorrect,
    this.pointToMe,
    this.myQuestionPrompt,
    this.myAnswer,
    this.myRightAnswer,
  });

  factory DuelRoundView({
    required int roundNumber,
    required _ihft2aor.ScoreCategory category,
    required bool attackerIsMe,
    required bool resolved,
    _i38p9z6b.SaintInfo? mySaint,
    int? myScore,
    bool? myCorrect,
    _i38p9z6b.SaintInfo? opponentSaint,
    int? opponentScore,
    bool? opponentCorrect,
    bool? pointToMe,
    String? myQuestionPrompt,
    String? myAnswer,
    String? myRightAnswer,
  }) = _DuelRoundViewImpl;

  factory DuelRoundView.fromJson(Map<String, dynamic> jsonSerialization) {
    return DuelRoundView(
      roundNumber: jsonSerialization['roundNumber'] as int,
      category: _ihft2aor.ScoreCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      attackerIsMe: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['attackerIsMe'],
      ),
      resolved: _isc.BoolJsonExtension.fromJson(jsonSerialization['resolved']),
      mySaint: jsonSerialization['mySaint'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_i38p9z6b.SaintInfo>(
              jsonSerialization['mySaint'],
            ),
      myScore: jsonSerialization['myScore'] as int?,
      myCorrect: jsonSerialization['myCorrect'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['myCorrect']),
      opponentSaint: jsonSerialization['opponentSaint'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_i38p9z6b.SaintInfo>(
              jsonSerialization['opponentSaint'],
            ),
      opponentScore: jsonSerialization['opponentScore'] as int?,
      opponentCorrect: jsonSerialization['opponentCorrect'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['opponentCorrect'],
            ),
      pointToMe: jsonSerialization['pointToMe'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['pointToMe']),
      myQuestionPrompt: jsonSerialization['myQuestionPrompt'] as String?,
      myAnswer: jsonSerialization['myAnswer'] as String?,
      myRightAnswer: jsonSerialization['myRightAnswer'] as String?,
    );
  }

  int roundNumber;

  _ihft2aor.ScoreCategory category;

  bool attackerIsMe;

  bool resolved;

  _i38p9z6b.SaintInfo? mySaint;

  int? myScore;

  bool? myCorrect;

  _i38p9z6b.SaintInfo? opponentSaint;

  int? opponentScore;

  bool? opponentCorrect;

  /// True: I got the point. False: the opponent did. Null: nobody.
  bool? pointToMe;

  /// My question in the round, and the two answers as text. Only once I
  /// answered: before that the round is still in front of me.
  String? myQuestionPrompt;

  String? myAnswer;

  String? myRightAnswer;

  /// Returns a shallow copy of this [DuelRoundView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DuelRoundView copyWith({
    int? roundNumber,
    _ihft2aor.ScoreCategory? category,
    bool? attackerIsMe,
    bool? resolved,
    _i38p9z6b.SaintInfo? mySaint,
    int? myScore,
    bool? myCorrect,
    _i38p9z6b.SaintInfo? opponentSaint,
    int? opponentScore,
    bool? opponentCorrect,
    bool? pointToMe,
    String? myQuestionPrompt,
    String? myAnswer,
    String? myRightAnswer,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuelRoundView',
      'roundNumber': roundNumber,
      'category': category.toJson(),
      'attackerIsMe': attackerIsMe,
      'resolved': resolved,
      if (mySaint != null) 'mySaint': mySaint?.toJson(),
      if (myScore != null) 'myScore': myScore,
      if (myCorrect != null) 'myCorrect': myCorrect,
      if (opponentSaint != null) 'opponentSaint': opponentSaint?.toJson(),
      if (opponentScore != null) 'opponentScore': opponentScore,
      if (opponentCorrect != null) 'opponentCorrect': opponentCorrect,
      if (pointToMe != null) 'pointToMe': pointToMe,
      if (myQuestionPrompt != null) 'myQuestionPrompt': myQuestionPrompt,
      if (myAnswer != null) 'myAnswer': myAnswer,
      if (myRightAnswer != null) 'myRightAnswer': myRightAnswer,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DuelRoundView',
      'roundNumber': roundNumber,
      'category': category.toJson(),
      'attackerIsMe': attackerIsMe,
      'resolved': resolved,
      if (mySaint != null) 'mySaint': mySaint?.toJsonForProtocol(),
      if (myScore != null) 'myScore': myScore,
      if (myCorrect != null) 'myCorrect': myCorrect,
      if (opponentSaint != null)
        'opponentSaint': opponentSaint?.toJsonForProtocol(),
      if (opponentScore != null) 'opponentScore': opponentScore,
      if (opponentCorrect != null) 'opponentCorrect': opponentCorrect,
      if (pointToMe != null) 'pointToMe': pointToMe,
      if (myQuestionPrompt != null) 'myQuestionPrompt': myQuestionPrompt,
      if (myAnswer != null) 'myAnswer': myAnswer,
      if (myRightAnswer != null) 'myRightAnswer': myRightAnswer,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelRoundViewImpl extends DuelRoundView {
  _DuelRoundViewImpl({
    required int roundNumber,
    required _ihft2aor.ScoreCategory category,
    required bool attackerIsMe,
    required bool resolved,
    _i38p9z6b.SaintInfo? mySaint,
    int? myScore,
    bool? myCorrect,
    _i38p9z6b.SaintInfo? opponentSaint,
    int? opponentScore,
    bool? opponentCorrect,
    bool? pointToMe,
    String? myQuestionPrompt,
    String? myAnswer,
    String? myRightAnswer,
  }) : super._(
         roundNumber: roundNumber,
         category: category,
         attackerIsMe: attackerIsMe,
         resolved: resolved,
         mySaint: mySaint,
         myScore: myScore,
         myCorrect: myCorrect,
         opponentSaint: opponentSaint,
         opponentScore: opponentScore,
         opponentCorrect: opponentCorrect,
         pointToMe: pointToMe,
         myQuestionPrompt: myQuestionPrompt,
         myAnswer: myAnswer,
         myRightAnswer: myRightAnswer,
       );

  /// Returns a shallow copy of this [DuelRoundView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DuelRoundView copyWith({
    int? roundNumber,
    _ihft2aor.ScoreCategory? category,
    bool? attackerIsMe,
    bool? resolved,
    Object? mySaint = _Undefined,
    Object? myScore = _Undefined,
    Object? myCorrect = _Undefined,
    Object? opponentSaint = _Undefined,
    Object? opponentScore = _Undefined,
    Object? opponentCorrect = _Undefined,
    Object? pointToMe = _Undefined,
    Object? myQuestionPrompt = _Undefined,
    Object? myAnswer = _Undefined,
    Object? myRightAnswer = _Undefined,
  }) {
    return DuelRoundView(
      roundNumber: roundNumber ?? this.roundNumber,
      category: category ?? this.category,
      attackerIsMe: attackerIsMe ?? this.attackerIsMe,
      resolved: resolved ?? this.resolved,
      mySaint: mySaint is _i38p9z6b.SaintInfo?
          ? mySaint
          : this.mySaint?.copyWith(),
      myScore: myScore is int? ? myScore : this.myScore,
      myCorrect: myCorrect is bool? ? myCorrect : this.myCorrect,
      opponentSaint: opponentSaint is _i38p9z6b.SaintInfo?
          ? opponentSaint
          : this.opponentSaint?.copyWith(),
      opponentScore: opponentScore is int? ? opponentScore : this.opponentScore,
      opponentCorrect: opponentCorrect is bool?
          ? opponentCorrect
          : this.opponentCorrect,
      pointToMe: pointToMe is bool? ? pointToMe : this.pointToMe,
      myQuestionPrompt: myQuestionPrompt is String?
          ? myQuestionPrompt
          : this.myQuestionPrompt,
      myAnswer: myAnswer is String? ? myAnswer : this.myAnswer,
      myRightAnswer: myRightAnswer is String?
          ? myRightAnswer
          : this.myRightAnswer,
    );
  }
}
