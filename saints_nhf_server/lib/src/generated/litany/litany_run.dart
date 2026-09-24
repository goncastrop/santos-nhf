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

/// One run of La Letanía: questions about the saints in your album until you
/// run out of lives.
///
/// There is at most one unfinished run per player, so closing the app and
/// coming back picks it up where it was instead of losing the score.
abstract class LitanyRun
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue authUserId,
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
      authUserId: _is.UuidValueJsonExtension.fromJson(
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
          : _itw3ru38.Protocol().deserialize<List<int>>(
              jsonSerialization['askedQuestionIds'],
            ),
      finished: jsonSerialization['finished'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['finished']),
      wasRecord: jsonSerialization['wasRecord'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['wasRecord']),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
    );
  }

  static final t = LitanyRunTable();

  static const db = LitanyRunRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LitanyRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LitanyRun copyWith({
    int? id,
    _is.UuidValue? authUserId,
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

  static LitanyRunInclude include() {
    return LitanyRunInclude._();
  }

  static LitanyRunIncludeList includeList({
    _is.WhereExpressionBuilder<LitanyRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LitanyRunTable>? orderBy,
    _is.OrderByListBuilder<LitanyRunTable>? orderByList,
    LitanyRunInclude? include,
  }) {
    return LitanyRunIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LitanyRun.t),
      orderByList: orderByList?.call(LitanyRun.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LitanyRunImpl extends LitanyRun {
  _LitanyRunImpl({
    int? id,
    required _is.UuidValue authUserId,
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
  @_is.useResult
  @override
  LitanyRun copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
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

class LitanyRunUpdateTable extends _is.UpdateTable<LitanyRunTable> {
  LitanyRunUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<int, int> lives(int value) => _is.ColumnValue(
    table.lives,
    value,
  );

  _is.ColumnValue<int, int> score(int value) => _is.ColumnValue(
    table.score,
    value,
  );

  _is.ColumnValue<int, int> streak(int value) => _is.ColumnValue(
    table.streak,
    value,
  );

  _is.ColumnValue<int, int> bestStreak(int value) => _is.ColumnValue(
    table.bestStreak,
    value,
  );

  _is.ColumnValue<int, int> answered(int value) => _is.ColumnValue(
    table.answered,
    value,
  );

  _is.ColumnValue<int, int> correct(int value) => _is.ColumnValue(
    table.correct,
    value,
  );

  _is.ColumnValue<int, int> questionId(int? value) => _is.ColumnValue(
    table.questionId,
    value,
  );

  _is.ColumnValue<int, int> chosenIndex(int? value) => _is.ColumnValue(
    table.chosenIndex,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> askedQuestionIds(List<int>? value) =>
      _is.ColumnValue(
        table.askedQuestionIds,
        value,
      );

  _is.ColumnValue<bool, bool> finished(bool value) => _is.ColumnValue(
    table.finished,
    value,
  );

  _is.ColumnValue<bool, bool> wasRecord(bool value) => _is.ColumnValue(
    table.wasRecord,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.finishedAt,
        value,
      );
}

class LitanyRunTable extends _is.Table<int?> {
  LitanyRunTable({super.tableRelation}) : super(tableName: 'litany_run') {
    updateTable = LitanyRunUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    lives = _is.ColumnInt(
      'lives',
      this,
      hasDefault: true,
    );
    score = _is.ColumnInt(
      'score',
      this,
      hasDefault: true,
    );
    streak = _is.ColumnInt(
      'streak',
      this,
      hasDefault: true,
    );
    bestStreak = _is.ColumnInt(
      'bestStreak',
      this,
      hasDefault: true,
    );
    answered = _is.ColumnInt(
      'answered',
      this,
      hasDefault: true,
    );
    correct = _is.ColumnInt(
      'correct',
      this,
      hasDefault: true,
    );
    questionId = _is.ColumnInt(
      'questionId',
      this,
    );
    chosenIndex = _is.ColumnInt(
      'chosenIndex',
      this,
    );
    askedQuestionIds = _is.ColumnSerializable<List<int>>(
      'askedQuestionIds',
      this,
    );
    finished = _is.ColumnBool(
      'finished',
      this,
      hasDefault: true,
    );
    wasRecord = _is.ColumnBool(
      'wasRecord',
      this,
      hasDefault: true,
    );
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
      hasDefault: true,
    );
    finishedAt = _is.ColumnDateTime(
      'finishedAt',
      this,
    );
  }

  late final LitanyRunUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnInt lives;

  late final _is.ColumnInt score;

  /// Correct answers in a row, which drives the multiplier.
  late final _is.ColumnInt streak;

  late final _is.ColumnInt bestStreak;

  late final _is.ColumnInt answered;

  late final _is.ColumnInt correct;

  /// Question on the table. Null when the run is over.
  late final _is.ColumnInt questionId;

  /// Null while the current question has not been answered; set to the stored
  /// index the player picked once it is graded, so a reload still shows the
  /// result before moving on.
  late final _is.ColumnInt chosenIndex;

  /// Questions already asked in this run. The global no-repeat rule can start
  /// reusing old questions once the pool is exhausted, and a run long enough
  /// to reach that point should still not ask the same thing twice.
  late final _is.ColumnSerializable<List<int>> askedQuestionIds;

  late final _is.ColumnBool finished;

  /// Whether this run beat the player's previous best, so a tie is not
  /// announced as a record.
  late final _is.ColumnBool wasRecord;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnDateTime finishedAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    lives,
    score,
    streak,
    bestStreak,
    answered,
    correct,
    questionId,
    chosenIndex,
    askedQuestionIds,
    finished,
    wasRecord,
    startedAt,
    finishedAt,
  ];
}

class LitanyRunInclude extends _is.IncludeObject {
  LitanyRunInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => LitanyRun.t;
}

class LitanyRunIncludeList extends _is.IncludeList {
  LitanyRunIncludeList._({
    _is.WhereExpressionBuilder<LitanyRunTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LitanyRun.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LitanyRun.t;
}

class LitanyRunRepository {
  const LitanyRunRepository._();

  /// Returns a list of [LitanyRun]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<LitanyRun>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LitanyRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LitanyRunTable>? orderBy,
    _is.OrderByListBuilder<LitanyRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LitanyRun>(
      where: where?.call(LitanyRun.t),
      orderBy: orderBy?.call(LitanyRun.t),
      orderByList: orderByList?.call(LitanyRun.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LitanyRun] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<LitanyRun?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LitanyRunTable>? where,
    int? offset,
    _is.OrderByBuilder<LitanyRunTable>? orderBy,
    _is.OrderByListBuilder<LitanyRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LitanyRun>(
      where: where?.call(LitanyRun.t),
      orderBy: orderBy?.call(LitanyRun.t),
      orderByList: orderByList?.call(LitanyRun.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LitanyRun] by its [id] or null if no such row exists.
  Future<LitanyRun?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LitanyRun>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LitanyRun]s in the list and returns the inserted rows.
  ///
  /// The returned [LitanyRun]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LitanyRun>> insert(
    _is.DatabaseSession session,
    List<LitanyRun> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LitanyRun>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LitanyRun] and returns the inserted row.
  ///
  /// The returned [LitanyRun] will have its `id` field set.
  Future<LitanyRun> insertRow(
    _is.DatabaseSession session,
    LitanyRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LitanyRun>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LitanyRun]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [LitanyRun]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LitanyRun>> upsert(
    _is.DatabaseSession session,
    List<LitanyRun> rows, {
    required _is.ColumnSelections<LitanyRunTable> conflictColumns,
    _is.ColumnSelections<LitanyRunTable>? updateColumns,
    _is.WhereExpressionBuilder<LitanyRunTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LitanyRun>(
      rows,
      conflictColumns: conflictColumns(LitanyRun.t),
      updateColumns: updateColumns?.call(LitanyRun.t),
      updateWhere: updateWhere?.call(LitanyRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LitanyRun] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [LitanyRun] will have its `id` field set.
  Future<LitanyRun?> upsertRow(
    _is.DatabaseSession session,
    LitanyRun row, {
    required _is.ColumnSelections<LitanyRunTable> conflictColumns,
    _is.ColumnSelections<LitanyRunTable>? updateColumns,
    _is.WhereExpressionBuilder<LitanyRunTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LitanyRun>(
      row,
      conflictColumns: conflictColumns(LitanyRun.t),
      updateColumns: updateColumns?.call(LitanyRun.t),
      updateWhere: updateWhere?.call(LitanyRun.t),
      transaction: transaction,
    );
  }

  /// Updates all [LitanyRun]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LitanyRun>> update(
    _is.DatabaseSession session,
    List<LitanyRun> rows, {
    _is.ColumnSelections<LitanyRunTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LitanyRun>(
      rows,
      columns: columns?.call(LitanyRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LitanyRun]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LitanyRun> updateRow(
    _is.DatabaseSession session,
    LitanyRun row, {
    _is.ColumnSelections<LitanyRunTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LitanyRun>(
      row,
      columns: columns?.call(LitanyRun.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LitanyRun] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LitanyRun?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LitanyRunUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LitanyRun>(
      id,
      columnValues: columnValues(LitanyRun.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LitanyRun]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LitanyRun>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LitanyRunUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LitanyRunTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LitanyRunTable>? orderBy,
    _is.OrderByListBuilder<LitanyRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LitanyRun>(
      columnValues: columnValues(LitanyRun.t.updateTable),
      where: where(LitanyRun.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LitanyRun.t),
      orderByList: orderByList?.call(LitanyRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LitanyRun]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LitanyRun>> delete(
    _is.DatabaseSession session,
    List<LitanyRun> rows, {
    _is.OrderByBuilder<LitanyRunTable>? orderBy,
    _is.OrderByListBuilder<LitanyRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LitanyRun>(
      rows,
      orderBy: orderBy?.call(LitanyRun.t),
      orderByList: orderByList?.call(LitanyRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LitanyRun].
  Future<LitanyRun> deleteRow(
    _is.DatabaseSession session,
    LitanyRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LitanyRun>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LitanyRun>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LitanyRunTable> where,
    _is.OrderByBuilder<LitanyRunTable>? orderBy,
    _is.OrderByListBuilder<LitanyRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LitanyRun>(
      where: where(LitanyRun.t),
      orderBy: orderBy?.call(LitanyRun.t),
      orderByList: orderByList?.call(LitanyRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LitanyRunTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LitanyRun>(
      where: where?.call(LitanyRun.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LitanyRun] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LitanyRunTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LitanyRun>(
      where: where(LitanyRun.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
