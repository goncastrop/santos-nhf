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
import '../questions/quiz_question.dart' as _i2z4qq3v;
import '../saints/saint_info.dart' as _i38p9z6b;

/// What the app needs to draw La Letanía.
abstract class LitanyView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LitanyView._({
    this.runId,
    required this.lives,
    required this.score,
    required this.streak,
    required this.nextPoints,
    required this.multiplier,
    required this.answered,
    required this.correct,
    this.question,
    this.saint,
    this.lastWasCorrect,
    this.lastGain,
    this.correctIndex,
    this.chosenIndex,
    required this.finished,
    required this.maxLives,
    required this.maxMultiplier,
    required this.bestScore,
    required this.newRecord,
    this.unavailableReason,
  });

  factory LitanyView({
    int? runId,
    required int lives,
    required int score,
    required int streak,
    required int nextPoints,
    required int multiplier,
    required int answered,
    required int correct,
    _i2z4qq3v.QuizQuestion? question,
    _i38p9z6b.SaintInfo? saint,
    bool? lastWasCorrect,
    int? lastGain,
    int? correctIndex,
    int? chosenIndex,
    required bool finished,
    required int maxLives,
    required int maxMultiplier,
    required int bestScore,
    required bool newRecord,
    String? unavailableReason,
  }) = _LitanyViewImpl;

  factory LitanyView.fromJson(Map<String, dynamic> jsonSerialization) {
    return LitanyView(
      runId: jsonSerialization['runId'] as int?,
      lives: jsonSerialization['lives'] as int,
      score: jsonSerialization['score'] as int,
      streak: jsonSerialization['streak'] as int,
      nextPoints: jsonSerialization['nextPoints'] as int,
      multiplier: jsonSerialization['multiplier'] as int,
      answered: jsonSerialization['answered'] as int,
      correct: jsonSerialization['correct'] as int,
      question: jsonSerialization['question'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_i2z4qq3v.QuizQuestion>(
              jsonSerialization['question'],
            ),
      saint: jsonSerialization['saint'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_i38p9z6b.SaintInfo>(
              jsonSerialization['saint'],
            ),
      lastWasCorrect: jsonSerialization['lastWasCorrect'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['lastWasCorrect'],
            ),
      lastGain: jsonSerialization['lastGain'] as int?,
      correctIndex: jsonSerialization['correctIndex'] as int?,
      chosenIndex: jsonSerialization['chosenIndex'] as int?,
      finished: _isc.BoolJsonExtension.fromJson(jsonSerialization['finished']),
      maxLives: jsonSerialization['maxLives'] as int,
      maxMultiplier: jsonSerialization['maxMultiplier'] as int,
      bestScore: jsonSerialization['bestScore'] as int,
      newRecord: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['newRecord'],
      ),
      unavailableReason: jsonSerialization['unavailableReason'] as String?,
    );
  }

  /// Null when there is no run going on.
  int? runId;

  int lives;

  int score;

  int streak;

  /// What the next correct answer is worth, including the streak multiplier.
  int nextPoints;

  int multiplier;

  int answered;

  int correct;

  /// The question waiting to be answered. Null while showing the result of
  /// the previous one, and when the run is over.
  _i2z4qq3v.QuizQuestion? question;

  /// Who the current question is about.
  _i38p9z6b.SaintInfo? saint;

  /// Result of the question just answered, while it is still on screen.
  bool? lastWasCorrect;

  /// Points that answer was worth. The multiplier moves with the streak, so
  /// the app cannot infer it from [nextPoints] without duplicating the rules.
  int? lastGain;

  int? correctIndex;

  int? chosenIndex;

  bool finished;

  /// The rules, so the app draws the hearts and the ceiling without keeping
  /// its own copy of the numbers.
  int maxLives;

  int maxMultiplier;

  /// Best score this player ever reached.
  int bestScore;

  /// Set when the run beat the previous record.
  bool newRecord;

  /// Why no run can start, when [runId] is null.
  String? unavailableReason;

  /// Returns a shallow copy of this [LitanyView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LitanyView copyWith({
    int? runId,
    int? lives,
    int? score,
    int? streak,
    int? nextPoints,
    int? multiplier,
    int? answered,
    int? correct,
    _i2z4qq3v.QuizQuestion? question,
    _i38p9z6b.SaintInfo? saint,
    bool? lastWasCorrect,
    int? lastGain,
    int? correctIndex,
    int? chosenIndex,
    bool? finished,
    int? maxLives,
    int? maxMultiplier,
    int? bestScore,
    bool? newRecord,
    String? unavailableReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LitanyView',
      if (runId != null) 'runId': runId,
      'lives': lives,
      'score': score,
      'streak': streak,
      'nextPoints': nextPoints,
      'multiplier': multiplier,
      'answered': answered,
      'correct': correct,
      if (question != null) 'question': question?.toJson(),
      if (saint != null) 'saint': saint?.toJson(),
      if (lastWasCorrect != null) 'lastWasCorrect': lastWasCorrect,
      if (lastGain != null) 'lastGain': lastGain,
      if (correctIndex != null) 'correctIndex': correctIndex,
      if (chosenIndex != null) 'chosenIndex': chosenIndex,
      'finished': finished,
      'maxLives': maxLives,
      'maxMultiplier': maxMultiplier,
      'bestScore': bestScore,
      'newRecord': newRecord,
      if (unavailableReason != null) 'unavailableReason': unavailableReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LitanyView',
      if (runId != null) 'runId': runId,
      'lives': lives,
      'score': score,
      'streak': streak,
      'nextPoints': nextPoints,
      'multiplier': multiplier,
      'answered': answered,
      'correct': correct,
      if (question != null) 'question': question?.toJsonForProtocol(),
      if (saint != null) 'saint': saint?.toJsonForProtocol(),
      if (lastWasCorrect != null) 'lastWasCorrect': lastWasCorrect,
      if (lastGain != null) 'lastGain': lastGain,
      if (correctIndex != null) 'correctIndex': correctIndex,
      if (chosenIndex != null) 'chosenIndex': chosenIndex,
      'finished': finished,
      'maxLives': maxLives,
      'maxMultiplier': maxMultiplier,
      'bestScore': bestScore,
      'newRecord': newRecord,
      if (unavailableReason != null) 'unavailableReason': unavailableReason,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LitanyViewImpl extends LitanyView {
  _LitanyViewImpl({
    int? runId,
    required int lives,
    required int score,
    required int streak,
    required int nextPoints,
    required int multiplier,
    required int answered,
    required int correct,
    _i2z4qq3v.QuizQuestion? question,
    _i38p9z6b.SaintInfo? saint,
    bool? lastWasCorrect,
    int? lastGain,
    int? correctIndex,
    int? chosenIndex,
    required bool finished,
    required int maxLives,
    required int maxMultiplier,
    required int bestScore,
    required bool newRecord,
    String? unavailableReason,
  }) : super._(
         runId: runId,
         lives: lives,
         score: score,
         streak: streak,
         nextPoints: nextPoints,
         multiplier: multiplier,
         answered: answered,
         correct: correct,
         question: question,
         saint: saint,
         lastWasCorrect: lastWasCorrect,
         lastGain: lastGain,
         correctIndex: correctIndex,
         chosenIndex: chosenIndex,
         finished: finished,
         maxLives: maxLives,
         maxMultiplier: maxMultiplier,
         bestScore: bestScore,
         newRecord: newRecord,
         unavailableReason: unavailableReason,
       );

  /// Returns a shallow copy of this [LitanyView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LitanyView copyWith({
    Object? runId = _Undefined,
    int? lives,
    int? score,
    int? streak,
    int? nextPoints,
    int? multiplier,
    int? answered,
    int? correct,
    Object? question = _Undefined,
    Object? saint = _Undefined,
    Object? lastWasCorrect = _Undefined,
    Object? lastGain = _Undefined,
    Object? correctIndex = _Undefined,
    Object? chosenIndex = _Undefined,
    bool? finished,
    int? maxLives,
    int? maxMultiplier,
    int? bestScore,
    bool? newRecord,
    Object? unavailableReason = _Undefined,
  }) {
    return LitanyView(
      runId: runId is int? ? runId : this.runId,
      lives: lives ?? this.lives,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      nextPoints: nextPoints ?? this.nextPoints,
      multiplier: multiplier ?? this.multiplier,
      answered: answered ?? this.answered,
      correct: correct ?? this.correct,
      question: question is _i2z4qq3v.QuizQuestion?
          ? question
          : this.question?.copyWith(),
      saint: saint is _i38p9z6b.SaintInfo? ? saint : this.saint?.copyWith(),
      lastWasCorrect: lastWasCorrect is bool?
          ? lastWasCorrect
          : this.lastWasCorrect,
      lastGain: lastGain is int? ? lastGain : this.lastGain,
      correctIndex: correctIndex is int? ? correctIndex : this.correctIndex,
      chosenIndex: chosenIndex is int? ? chosenIndex : this.chosenIndex,
      finished: finished ?? this.finished,
      maxLives: maxLives ?? this.maxLives,
      maxMultiplier: maxMultiplier ?? this.maxMultiplier,
      bestScore: bestScore ?? this.bestScore,
      newRecord: newRecord ?? this.newRecord,
      unavailableReason: unavailableReason is String?
          ? unavailableReason
          : this.unavailableReason,
    );
  }
}
