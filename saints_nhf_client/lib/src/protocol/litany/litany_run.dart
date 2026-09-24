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

/// One run of La Letanía: questions about the saints in your album until you
/// run out of lives.
///
/// There is at most one unfinished run per player, so closing the app and
/// coming back picks it up where it was instead of losing the score.
abstract class LitanyRun
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LitanyRun._({
    this.id,
    required this.authUserId,
    int? lives,
    int? score,
    int? streak,
    int? bestStreak,
    int? answered,
    int? correct,
    this.questionId,
    this.chosenIndex,
    this.askedQuestionIds,
    bool? finished,
    bool? wasRecord,
    DateTime? startedAt,
    this.finishedAt,
  }) : lives = lives ?? 3,
       score = score ?? 0,
       streak = streak ?? 0,
       bestStreak = bestStreak ?? 0,
       answered = answered ?? 0,
       correct = correct ?? 0,
       finished = finished ?? false,
       wasRecord = wasRecord ?? false,
       startedAt = startedAt ?? DateTime.now();

  factory LitanyRun({
    int? id,
    required _isc.UuidValue authUserId,
    int? lives,
    int? score,
    int? streak,
    int? bestStreak,
    int? answered,
    int? correct,
    int? questionId,
    int? chosenIndex,
    List<int>? askedQuestionIds,
    bool? finished,
    bool? wasRecord,
    DateTime? startedAt,
    DateTime? finishedAt,
  }) = _LitanyRunImpl;

  factory LitanyRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return LitanyRun(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      lives: jsonSerialization['lives'] as int?,
      score: jsonSerialization['score'] as int?,
      streak: jsonSerialization['streak'] as int?,
      bestStreak: jsonSerialization['bestStreak'] as int?,
      answered: jsonSerialization['answered'] as int?,
      correct: jsonSerialization['correct'] as int?,
      questionId: jsonSerialization['questionId'] as int?,
      chosenIndex: jsonSerialization['chosenIndex'] as int?,
      askedQuestionIds: jsonSerialization['askedQuestionIds'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<List<int>>(
              jsonSerialization['askedQuestionIds'],
            ),
      finished: jsonSerialization['finished'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['finished']),
      wasRecord: jsonSerialization['wasRecord'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['wasRecord']),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
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

  _isc.UuidValue authUserId;

  int lives;

  int score;

  /// Correct answers in a row, which drives the multiplier.
  int streak;

  int bestStreak;

  int answered;

  int correct;

  /// Question on the table. Null when the run is over.
  int? questionId;

  /// Null while the current question has not been answered; set to the stored
  /// index the player picked once it is graded, so a reload still shows the
  /// result before moving on.
  int? chosenIndex;

  /// Questions already asked in this run. The global no-repeat rule can start
  /// reusing old questions once the pool is exhausted, and a run long enough
  /// to reach that point should still not ask the same thing twice.
  List<int>? askedQuestionIds;

  bool finished;

  /// Whether this run beat the player's previous best, so a tie is not
  /// announced as a record.
  bool wasRecord;

  DateTime startedAt;

  DateTime? finishedAt;

  /// Returns a shallow copy of this [LitanyRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LitanyRun copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? lives,
    int? score,
    int? streak,
    int? bestStreak,
    int? answered,
    int? correct,
    int? questionId,
    int? chosenIndex,
    List<int>? askedQuestionIds,
    bool? finished,
    bool? wasRecord,
    DateTime? startedAt,
    DateTime? finishedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LitanyRun',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'lives': lives,
      'score': score,
      'streak': streak,
      'bestStreak': bestStreak,
      'answered': answered,
      'correct': correct,
      if (questionId != null) 'questionId': questionId,
      if (chosenIndex != null) 'chosenIndex': chosenIndex,
      if (askedQuestionIds != null)
        'askedQuestionIds': askedQuestionIds?.toJson(),
      'finished': finished,
      'wasRecord': wasRecord,
      'startedAt': startedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LitanyRun',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'lives': lives,
      'score': score,
      'streak': streak,
      'bestStreak': bestStreak,
      'answered': answered,
      'correct': correct,
      if (questionId != null) 'questionId': questionId,
      if (chosenIndex != null) 'chosenIndex': chosenIndex,
      if (askedQuestionIds != null)
        'askedQuestionIds': askedQuestionIds?.toJson(),
      'finished': finished,
      'wasRecord': wasRecord,
      'startedAt': startedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LitanyRunImpl extends LitanyRun {
  _LitanyRunImpl({
    int? id,
    required _isc.UuidValue authUserId,
    int? lives,
    int? score,
    int? streak,
    int? bestStreak,
    int? answered,
    int? correct,
    int? questionId,
    int? chosenIndex,
    List<int>? askedQuestionIds,
    bool? finished,
    bool? wasRecord,
    DateTime? startedAt,
    DateTime? finishedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         lives: lives,
         score: score,
         streak: streak,
         bestStreak: bestStreak,
         answered: answered,
         correct: correct,
         questionId: questionId,
         chosenIndex: chosenIndex,
         askedQuestionIds: askedQuestionIds,
         finished: finished,
         wasRecord: wasRecord,
         startedAt: startedAt,
         finishedAt: finishedAt,
       );

  /// Returns a shallow copy of this [LitanyRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LitanyRun copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    int? lives,
    int? score,
    int? streak,
    int? bestStreak,
    int? answered,
    int? correct,
    Object? questionId = _Undefined,
    Object? chosenIndex = _Undefined,
    Object? askedQuestionIds = _Undefined,
    bool? finished,
    bool? wasRecord,
    DateTime? startedAt,
    Object? finishedAt = _Undefined,
  }) {
    return LitanyRun(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      lives: lives ?? this.lives,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      answered: answered ?? this.answered,
      correct: correct ?? this.correct,
      questionId: questionId is int? ? questionId : this.questionId,
      chosenIndex: chosenIndex is int? ? chosenIndex : this.chosenIndex,
      askedQuestionIds: askedQuestionIds is List<int>?
          ? askedQuestionIds
          : this.askedQuestionIds?.map((e0) => e0).toList(),
      finished: finished ?? this.finished,
      wasRecord: wasRecord ?? this.wasRecord,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
    );
  }
}
