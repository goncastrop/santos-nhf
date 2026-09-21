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
import 'package:saints_nhf_server/src/generated/protocol.dart' as _itw3ru38;
import 'package:serverpod/serverpod.dart' as _is;
import '../collection/collected_card.dart' as _izrixkci;
import '../duel/duel_phase.dart' as _ipq299lq;
import '../duel/duel_round_view.dart' as _i76twh41;
import '../duel/duel_status.dart' as _i6u3xm2k;
import '../questions/quiz_question.dart' as _i2z4qq3v;
import '../saints/saint_info.dart' as _i38p9z6b;
import '../saints/score_category.dart' as _ihft2aor;

/// Full state of a duel from the caller's point of view.
abstract class DuelView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DuelView._({
    required this.duelId,
    required this.status,
    required this.isVsMachine,
    required this.phase,
    required this.roundNumber,
    required this.myScore,
    required this.opponentScore,
    required this.opponentName,
    required this.opponentId,
    required this.myDeck,
    required this.opponentCardsLeft,
    required this.usedCategories,
    this.currentCategory,
    required this.attackerIsMe,
    this.pendingQuestion,
    this.pendingSaint,
    required this.rounds,
    this.winnerIsMe,
    required this.pointsToWin,
    required this.updatedAt,
  });

  factory DuelView({
    required int duelId,
    required _i6u3xm2k.DuelStatus status,
    required bool isVsMachine,
    required _ipq299lq.DuelPhase phase,
    required int roundNumber,
    required int myScore,
    required int opponentScore,
    required String opponentName,
    required _is.UuidValue opponentId,
    required List<_izrixkci.CollectedCard> myDeck,
    required int opponentCardsLeft,
    required List<_ihft2aor.ScoreCategory> usedCategories,
    _ihft2aor.ScoreCategory? currentCategory,
    required bool attackerIsMe,
    _i2z4qq3v.QuizQuestion? pendingQuestion,
    _i38p9z6b.SaintInfo? pendingSaint,
    required List<_i76twh41.DuelRoundView> rounds,
    bool? winnerIsMe,
    required int pointsToWin,
    required DateTime updatedAt,
  }) = _DuelViewImpl;

  factory DuelView.fromJson(Map<String, dynamic> jsonSerialization) {
    return DuelView(
      duelId: jsonSerialization['duelId'] as int,
      status: _i6u3xm2k.DuelStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      isVsMachine: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isVsMachine'],
      ),
      phase: _ipq299lq.DuelPhase.fromJson(
        (jsonSerialization['phase'] as String),
      ),
      roundNumber: jsonSerialization['roundNumber'] as int,
      myScore: jsonSerialization['myScore'] as int,
      opponentScore: jsonSerialization['opponentScore'] as int,
      opponentName: jsonSerialization['opponentName'] as String,
      opponentId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['opponentId'],
      ),
      myDeck: _itw3ru38.Protocol().deserialize<List<_izrixkci.CollectedCard>>(
        jsonSerialization['myDeck'],
      ),
      opponentCardsLeft: jsonSerialization['opponentCardsLeft'] as int,
      usedCategories: _itw3ru38.Protocol()
          .deserialize<List<_ihft2aor.ScoreCategory>>(
            jsonSerialization['usedCategories'],
          ),
      currentCategory: jsonSerialization['currentCategory'] == null
          ? null
          : _ihft2aor.ScoreCategory.fromJson(
              (jsonSerialization['currentCategory'] as String),
            ),
      attackerIsMe: _is.BoolJsonExtension.fromJson(
        jsonSerialization['attackerIsMe'],
      ),
      pendingQuestion: jsonSerialization['pendingQuestion'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<_i2z4qq3v.QuizQuestion>(
              jsonSerialization['pendingQuestion'],
            ),
      pendingSaint: jsonSerialization['pendingSaint'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<_i38p9z6b.SaintInfo>(
              jsonSerialization['pendingSaint'],
            ),
      rounds: _itw3ru38.Protocol().deserialize<List<_i76twh41.DuelRoundView>>(
        jsonSerialization['rounds'],
      ),
      winnerIsMe: jsonSerialization['winnerIsMe'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['winnerIsMe']),
      pointsToWin: jsonSerialization['pointsToWin'] as int,
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int duelId;

  _i6u3xm2k.DuelStatus status;

  bool isVsMachine;

  _ipq299lq.DuelPhase phase;

  int roundNumber;

  int myScore;

  int opponentScore;

  String opponentName;

  _is.UuidValue opponentId;

  /// My remaining cards, with scores.
  List<_izrixkci.CollectedCard> myDeck;

  /// Whether I still have to pick my deck.
  int opponentCardsLeft;

  List<_ihft2aor.ScoreCategory> usedCategories;

  /// Category of the round in progress, when defending or answering.
  _ihft2aor.ScoreCategory? currentCategory;

  bool attackerIsMe;

  /// Set when [phase] is answer.
  _i2z4qq3v.QuizQuestion? pendingQuestion;

  _i38p9z6b.SaintInfo? pendingSaint;

  List<_i76twh41.DuelRoundView> rounds;

  /// True/false when finished with a winner; null on a draw or unfinished.
  bool? winnerIsMe;

  int pointsToWin;

  DateTime updatedAt;

  /// Returns a shallow copy of this [DuelView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DuelView copyWith({
    int? duelId,
    _i6u3xm2k.DuelStatus? status,
    bool? isVsMachine,
    _ipq299lq.DuelPhase? phase,
    int? roundNumber,
    int? myScore,
    int? opponentScore,
    String? opponentName,
    _is.UuidValue? opponentId,
    List<_izrixkci.CollectedCard>? myDeck,
    int? opponentCardsLeft,
    List<_ihft2aor.ScoreCategory>? usedCategories,
    _ihft2aor.ScoreCategory? currentCategory,
    bool? attackerIsMe,
    _i2z4qq3v.QuizQuestion? pendingQuestion,
    _i38p9z6b.SaintInfo? pendingSaint,
    List<_i76twh41.DuelRoundView>? rounds,
    bool? winnerIsMe,
    int? pointsToWin,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuelView',
      'duelId': duelId,
      'status': status.toJson(),
      'isVsMachine': isVsMachine,
      'phase': phase.toJson(),
      'roundNumber': roundNumber,
      'myScore': myScore,
      'opponentScore': opponentScore,
      'opponentName': opponentName,
      'opponentId': opponentId.toJson(),
      'myDeck': myDeck.toJson(valueToJson: (v) => v.toJson()),
      'opponentCardsLeft': opponentCardsLeft,
      'usedCategories': usedCategories.toJson(valueToJson: (v) => v.toJson()),
      if (currentCategory != null) 'currentCategory': currentCategory?.toJson(),
      'attackerIsMe': attackerIsMe,
      if (pendingQuestion != null) 'pendingQuestion': pendingQuestion?.toJson(),
      if (pendingSaint != null) 'pendingSaint': pendingSaint?.toJson(),
      'rounds': rounds.toJson(valueToJson: (v) => v.toJson()),
      if (winnerIsMe != null) 'winnerIsMe': winnerIsMe,
      'pointsToWin': pointsToWin,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DuelView',
      'duelId': duelId,
      'status': status.toJson(),
      'isVsMachine': isVsMachine,
      'phase': phase.toJson(),
      'roundNumber': roundNumber,
      'myScore': myScore,
      'opponentScore': opponentScore,
      'opponentName': opponentName,
      'opponentId': opponentId.toJson(),
      'myDeck': myDeck.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'opponentCardsLeft': opponentCardsLeft,
      'usedCategories': usedCategories.toJson(valueToJson: (v) => v.toJson()),
      if (currentCategory != null) 'currentCategory': currentCategory?.toJson(),
      'attackerIsMe': attackerIsMe,
      if (pendingQuestion != null)
        'pendingQuestion': pendingQuestion?.toJsonForProtocol(),
      if (pendingSaint != null)
        'pendingSaint': pendingSaint?.toJsonForProtocol(),
      'rounds': rounds.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (winnerIsMe != null) 'winnerIsMe': winnerIsMe,
      'pointsToWin': pointsToWin,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelViewImpl extends DuelView {
  _DuelViewImpl({
    required int duelId,
    required _i6u3xm2k.DuelStatus status,
    required bool isVsMachine,
    required _ipq299lq.DuelPhase phase,
    required int roundNumber,
    required int myScore,
    required int opponentScore,
    required String opponentName,
    required _is.UuidValue opponentId,
    required List<_izrixkci.CollectedCard> myDeck,
    required int opponentCardsLeft,
    required List<_ihft2aor.ScoreCategory> usedCategories,
    _ihft2aor.ScoreCategory? currentCategory,
    required bool attackerIsMe,
    _i2z4qq3v.QuizQuestion? pendingQuestion,
    _i38p9z6b.SaintInfo? pendingSaint,
    required List<_i76twh41.DuelRoundView> rounds,
    bool? winnerIsMe,
    required int pointsToWin,
    required DateTime updatedAt,
  }) : super._(
         duelId: duelId,
         status: status,
         isVsMachine: isVsMachine,
         phase: phase,
         roundNumber: roundNumber,
         myScore: myScore,
         opponentScore: opponentScore,
         opponentName: opponentName,
         opponentId: opponentId,
         myDeck: myDeck,
         opponentCardsLeft: opponentCardsLeft,
         usedCategories: usedCategories,
         currentCategory: currentCategory,
         attackerIsMe: attackerIsMe,
         pendingQuestion: pendingQuestion,
         pendingSaint: pendingSaint,
         rounds: rounds,
         winnerIsMe: winnerIsMe,
         pointsToWin: pointsToWin,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DuelView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DuelView copyWith({
    int? duelId,
    _i6u3xm2k.DuelStatus? status,
    bool? isVsMachine,
    _ipq299lq.DuelPhase? phase,
    int? roundNumber,
    int? myScore,
    int? opponentScore,
    String? opponentName,
    _is.UuidValue? opponentId,
    List<_izrixkci.CollectedCard>? myDeck,
    int? opponentCardsLeft,
    List<_ihft2aor.ScoreCategory>? usedCategories,
    Object? currentCategory = _Undefined,
    bool? attackerIsMe,
    Object? pendingQuestion = _Undefined,
    Object? pendingSaint = _Undefined,
    List<_i76twh41.DuelRoundView>? rounds,
    Object? winnerIsMe = _Undefined,
    int? pointsToWin,
    DateTime? updatedAt,
  }) {
    return DuelView(
      duelId: duelId ?? this.duelId,
      status: status ?? this.status,
      isVsMachine: isVsMachine ?? this.isVsMachine,
      phase: phase ?? this.phase,
      roundNumber: roundNumber ?? this.roundNumber,
      myScore: myScore ?? this.myScore,
      opponentScore: opponentScore ?? this.opponentScore,
      opponentName: opponentName ?? this.opponentName,
      opponentId: opponentId ?? this.opponentId,
      myDeck: myDeck ?? this.myDeck.map((e0) => e0.copyWith()).toList(),
      opponentCardsLeft: opponentCardsLeft ?? this.opponentCardsLeft,
      usedCategories:
          usedCategories ?? this.usedCategories.map((e0) => e0).toList(),
      currentCategory: currentCategory is _ihft2aor.ScoreCategory?
          ? currentCategory
          : this.currentCategory,
      attackerIsMe: attackerIsMe ?? this.attackerIsMe,
      pendingQuestion: pendingQuestion is _i2z4qq3v.QuizQuestion?
          ? pendingQuestion
          : this.pendingQuestion?.copyWith(),
      pendingSaint: pendingSaint is _i38p9z6b.SaintInfo?
          ? pendingSaint
          : this.pendingSaint?.copyWith(),
      rounds: rounds ?? this.rounds.map((e0) => e0.copyWith()).toList(),
      winnerIsMe: winnerIsMe is bool? ? winnerIsMe : this.winnerIsMe,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
