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

/// State of the player's daily question.
abstract class DailyQuiz
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DailyQuiz._({
    this.question,
    this.saint,
    required this.answeredToday,
    this.wasCorrect,
    this.correctIndex,
    this.chosenIndex,
    required this.streak,
    required this.bestStreak,
    required this.totalAnswered,
    required this.totalCorrect,
    this.unavailableReason,
  });

  factory DailyQuiz({
    _i2z4qq3v.QuizQuestion? question,
    _i38p9z6b.SaintInfo? saint,
    required bool answeredToday,
    bool? wasCorrect,
    int? correctIndex,
    int? chosenIndex,
    required int streak,
    required int bestStreak,
    required int totalAnswered,
    required int totalCorrect,
    String? unavailableReason,
  }) = _DailyQuizImpl;

  factory DailyQuiz.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyQuiz(
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
      answeredToday: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['answeredToday'],
      ),
      wasCorrect: jsonSerialization['wasCorrect'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['wasCorrect']),
      correctIndex: jsonSerialization['correctIndex'] as int?,
      chosenIndex: jsonSerialization['chosenIndex'] as int?,
      streak: jsonSerialization['streak'] as int,
      bestStreak: jsonSerialization['bestStreak'] as int,
      totalAnswered: jsonSerialization['totalAnswered'] as int,
      totalCorrect: jsonSerialization['totalCorrect'] as int,
      unavailableReason: jsonSerialization['unavailableReason'] as String?,
    );
  }

  /// Null when already answered today or when no question is available.
  _i2z4qq3v.QuizQuestion? question;

  _i38p9z6b.SaintInfo? saint;

  bool answeredToday;

  /// Result of today's answer, when answered.
  bool? wasCorrect;

  int? correctIndex;

  int? chosenIndex;

  int streak;

  int bestStreak;

  int totalAnswered;

  int totalCorrect;

  /// Why there is no question, when [question] is null and not answered.
  String? unavailableReason;

  /// Returns a shallow copy of this [DailyQuiz]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DailyQuiz copyWith({
    _i2z4qq3v.QuizQuestion? question,
    _i38p9z6b.SaintInfo? saint,
    bool? answeredToday,
    bool? wasCorrect,
    int? correctIndex,
    int? chosenIndex,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    String? unavailableReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyQuiz',
      if (question != null) 'question': question?.toJson(),
      if (saint != null) 'saint': saint?.toJson(),
      'answeredToday': answeredToday,
      if (wasCorrect != null) 'wasCorrect': wasCorrect,
      if (correctIndex != null) 'correctIndex': correctIndex,
      if (chosenIndex != null) 'chosenIndex': chosenIndex,
      'streak': streak,
      'bestStreak': bestStreak,
      'totalAnswered': totalAnswered,
      'totalCorrect': totalCorrect,
      if (unavailableReason != null) 'unavailableReason': unavailableReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyQuiz',
      if (question != null) 'question': question?.toJsonForProtocol(),
      if (saint != null) 'saint': saint?.toJsonForProtocol(),
      'answeredToday': answeredToday,
      if (wasCorrect != null) 'wasCorrect': wasCorrect,
      if (correctIndex != null) 'correctIndex': correctIndex,
      if (chosenIndex != null) 'chosenIndex': chosenIndex,
      'streak': streak,
      'bestStreak': bestStreak,
      'totalAnswered': totalAnswered,
      'totalCorrect': totalCorrect,
      if (unavailableReason != null) 'unavailableReason': unavailableReason,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyQuizImpl extends DailyQuiz {
  _DailyQuizImpl({
    _i2z4qq3v.QuizQuestion? question,
    _i38p9z6b.SaintInfo? saint,
    required bool answeredToday,
    bool? wasCorrect,
    int? correctIndex,
    int? chosenIndex,
    required int streak,
    required int bestStreak,
    required int totalAnswered,
    required int totalCorrect,
    String? unavailableReason,
  }) : super._(
         question: question,
         saint: saint,
         answeredToday: answeredToday,
         wasCorrect: wasCorrect,
         correctIndex: correctIndex,
         chosenIndex: chosenIndex,
         streak: streak,
         bestStreak: bestStreak,
         totalAnswered: totalAnswered,
         totalCorrect: totalCorrect,
         unavailableReason: unavailableReason,
       );

  /// Returns a shallow copy of this [DailyQuiz]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DailyQuiz copyWith({
    Object? question = _Undefined,
    Object? saint = _Undefined,
    bool? answeredToday,
    Object? wasCorrect = _Undefined,
    Object? correctIndex = _Undefined,
    Object? chosenIndex = _Undefined,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    Object? unavailableReason = _Undefined,
  }) {
    return DailyQuiz(
      question: question is _i2z4qq3v.QuizQuestion?
          ? question
          : this.question?.copyWith(),
      saint: saint is _i38p9z6b.SaintInfo? ? saint : this.saint?.copyWith(),
      answeredToday: answeredToday ?? this.answeredToday,
      wasCorrect: wasCorrect is bool? ? wasCorrect : this.wasCorrect,
      correctIndex: correctIndex is int? ? correctIndex : this.correctIndex,
      chosenIndex: chosenIndex is int? ? chosenIndex : this.chosenIndex,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      unavailableReason: unavailableReason is String?
          ? unavailableReason
          : this.unavailableReason,
    );
  }
}
