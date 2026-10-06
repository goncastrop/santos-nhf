/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:saints_nhf_server/src/generated/protocol.dart' as _itw3ru38;
import 'package:serverpod/serverpod.dart' as _is;
import '../live/live_game.dart' as _i7zs88ky;

/// One player's answer to one question of a live game.
abstract class LiveAnswer
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  LiveAnswer._({
    this.id,
    required this.gameId,
    this.game,
    required this.questionIndex,
    required this.authUserId,
    required this.chosenIndex,
    required this.correct,
    required this.points,
    required this.elapsedMs,
    DateTime? answeredAt,
  }) : answeredAt = answeredAt ?? DateTime.now();

  factory LiveAnswer({
    int? id,
    required int gameId,
    _i7zs88ky.LiveGame? game,
    required int questionIndex,
    required _is.UuidValue authUserId,
    required int chosenIndex,
    required bool correct,
    required int points,
    required int elapsedMs,
    DateTime? answeredAt,
  }) = _LiveAnswerImpl;

  factory LiveAnswer.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveAnswer(
      id: jsonSerialization['id'] as int?,
      gameId: jsonSerialization['gameId'] as int,
      game: jsonSerialization['game'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<_i7zs88ky.LiveGame>(
              jsonSerialization['game'],
            ),
      questionIndex: jsonSerialization['questionIndex'] as int,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      chosenIndex: jsonSerialization['chosenIndex'] as int,
      correct: _is.BoolJsonExtension.fromJson(jsonSerialization['correct']),
      points: jsonSerialization['points'] as int,
      elapsedMs: jsonSerialization['elapsedMs'] as int,
      answeredAt: jsonSerialization['answeredAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['answeredAt']),
    );
  }

  static final t = LiveAnswerTable();

  static const db = LiveAnswerRepository._();

  @override
  int? id;

  int gameId;

  _i7zs88ky.LiveGame? game;

  int questionIndex;

  _is.UuidValue authUserId;

  /// Stored index of the option picked, as in [Question.options].
  int chosenIndex;

  bool correct;

  int points;

  /// Milliseconds from the question opening to the answer reaching the
  /// server. Breaks ties in the final ranking.
  int elapsedMs;

  DateTime answeredAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LiveAnswer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveAnswer copyWith({
    int? id,
    int? gameId,
    _i7zs88ky.LiveGame? game,
    int? questionIndex,
    _is.UuidValue? authUserId,
    int? chosenIndex,
    bool? correct,
    int? points,
    int? elapsedMs,
    DateTime? answeredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveAnswer',
      if (id != null) 'id': id,
      'gameId': gameId,
      if (game != null) 'game': game?.toJson(),
      'questionIndex': questionIndex,
      'authUserId': authUserId.toJson(),
      'chosenIndex': chosenIndex,
      'correct': correct,
      'points': points,
      'elapsedMs': elapsedMs,
      'answeredAt': answeredAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static LiveAnswerInclude include({_i7zs88ky.LiveGameInclude? game}) {
    return LiveAnswerInclude._(game: game);
  }

  static LiveAnswerIncludeList includeList({
    _is.WhereExpressionBuilder<LiveAnswerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LiveAnswerTable>? orderBy,
    _is.OrderByListBuilder<LiveAnswerTable>? orderByList,
    LiveAnswerInclude? include,
  }) {
    return LiveAnswerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LiveAnswer.t),
      orderByList: orderByList?.call(LiveAnswer.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveAnswerImpl extends LiveAnswer {
  _LiveAnswerImpl({
    int? id,
    required int gameId,
    _i7zs88ky.LiveGame? game,
    required int questionIndex,
    required _is.UuidValue authUserId,
    required int chosenIndex,
    required bool correct,
    required int points,
    required int elapsedMs,
    DateTime? answeredAt,
  }) : super._(
         id: id,
         gameId: gameId,
         game: game,
         questionIndex: questionIndex,
         authUserId: authUserId,
         chosenIndex: chosenIndex,
         correct: correct,
         points: points,
         elapsedMs: elapsedMs,
         answeredAt: answeredAt,
       );

  /// Returns a shallow copy of this [LiveAnswer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveAnswer copyWith({
    Object? id = _Undefined,
    int? gameId,
    Object? game = _Undefined,
    int? questionIndex,
    _is.UuidValue? authUserId,
    int? chosenIndex,
    bool? correct,
    int? points,
    int? elapsedMs,
    DateTime? answeredAt,
  }) {
    return LiveAnswer(
      id: id is int? ? id : this.id,
      gameId: gameId ?? this.gameId,
      game: game is _i7zs88ky.LiveGame? ? game : this.game?.copyWith(),
      questionIndex: questionIndex ?? this.questionIndex,
      authUserId: authUserId ?? this.authUserId,
      chosenIndex: chosenIndex ?? this.chosenIndex,
      correct: correct ?? this.correct,
      points: points ?? this.points,
      elapsedMs: elapsedMs ?? this.elapsedMs,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }
}

class LiveAnswerUpdateTable extends _is.UpdateTable<LiveAnswerTable> {
  LiveAnswerUpdateTable(super.table);

  _is.ColumnValue<int, int> gameId(int value) => _is.ColumnValue(
    table.gameId,
    value,
  );

  _is.ColumnValue<int, int> questionIndex(int value) => _is.ColumnValue(
    table.questionIndex,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<int, int> chosenIndex(int value) => _is.ColumnValue(
    table.chosenIndex,
    value,
  );

  _is.ColumnValue<bool, bool> correct(bool value) => _is.ColumnValue(
    table.correct,
    value,
  );

  _is.ColumnValue<int, int> points(int value) => _is.ColumnValue(
    table.points,
    value,
  );

  _is.ColumnValue<int, int> elapsedMs(int value) => _is.ColumnValue(
    table.elapsedMs,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> answeredAt(DateTime value) =>
      _is.ColumnValue(
        table.answeredAt,
        value,
      );
}

class LiveAnswerTable extends _is.Table<int?> {
  LiveAnswerTable({super.tableRelation}) : super(tableName: 'live_answer') {
    updateTable = LiveAnswerUpdateTable(this);
    gameId = _is.ColumnInt(
      'gameId',
      this,
    );
    questionIndex = _is.ColumnInt(
      'questionIndex',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    chosenIndex = _is.ColumnInt(
      'chosenIndex',
      this,
    );
    correct = _is.ColumnBool(
      'correct',
      this,
    );
    points = _is.ColumnInt(
      'points',
      this,
    );
    elapsedMs = _is.ColumnInt(
      'elapsedMs',
      this,
    );
    answeredAt = _is.ColumnDateTime(
      'answeredAt',
      this,
      hasDefault: true,
    );
  }

  late final LiveAnswerUpdateTable updateTable;

  late final _is.ColumnInt gameId;

  _i7zs88ky.LiveGameTable? _game;

  late final _is.ColumnInt questionIndex;

  late final _is.ColumnUuid authUserId;

  /// Stored index of the option picked, as in [Question.options].
  late final _is.ColumnInt chosenIndex;

  late final _is.ColumnBool correct;

  late final _is.ColumnInt points;

  /// Milliseconds from the question opening to the answer reaching the
  /// server. Breaks ties in the final ranking.
  late final _is.ColumnInt elapsedMs;

  late final _is.ColumnDateTime answeredAt;

  _i7zs88ky.LiveGameTable get game {
    if (_game != null) return _game!;
    _game = _is.createRelationTable(
      relationFieldName: 'game',
      field: LiveAnswer.t.gameId,
      foreignField: _i7zs88ky.LiveGame.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7zs88ky.LiveGameTable(tableRelation: foreignTableRelation),
    );
    return _game!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    gameId,
    questionIndex,
    authUserId,
    chosenIndex,
    correct,
    points,
    elapsedMs,
    answeredAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'game') {
      return game;
    }
    return null;
  }
}

class LiveAnswerInclude extends _is.IncludeObject {
  LiveAnswerInclude._({_i7zs88ky.LiveGameInclude? game}) {
    _game = game;
  }

  _i7zs88ky.LiveGameInclude? _game;

  @override
  Map<String, _is.Include?> get includes => {'game': _game};

  @override
  _is.Table<int?> get table => LiveAnswer.t;
}

class LiveAnswerIncludeList extends _is.IncludeList {
  LiveAnswerIncludeList._({
    _is.WhereExpressionBuilder<LiveAnswerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LiveAnswer.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LiveAnswer.t;
}

class LiveAnswerRepository {
  const LiveAnswerRepository._();

  final attachRow = const LiveAnswerAttachRowRepository._();

  /// Returns a list of [LiveAnswer]s matching the given query parameters.
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
  Future<List<LiveAnswer>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LiveAnswerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LiveAnswerTable>? orderBy,
    _is.OrderByListBuilder<LiveAnswerTable>? orderByList,
    _is.Transaction? transaction,
    LiveAnswerInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LiveAnswer>(
      where: where?.call(LiveAnswer.t),
      orderBy: orderBy?.call(LiveAnswer.t),
      orderByList: orderByList?.call(LiveAnswer.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LiveAnswer] matching the given query parameters.
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
  Future<LiveAnswer?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LiveAnswerTable>? where,
    int? offset,
    _is.OrderByBuilder<LiveAnswerTable>? orderBy,
    _is.OrderByListBuilder<LiveAnswerTable>? orderByList,
    _is.Transaction? transaction,
    LiveAnswerInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LiveAnswer>(
      where: where?.call(LiveAnswer.t),
      orderBy: orderBy?.call(LiveAnswer.t),
      orderByList: orderByList?.call(LiveAnswer.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LiveAnswer] by its [id] or null if no such row exists.
  Future<LiveAnswer?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    LiveAnswerInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LiveAnswer>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LiveAnswer]s in the list and returns the inserted rows.
  ///
  /// The returned [LiveAnswer]s will have their `id` fields set.
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
  Future<List<LiveAnswer>> insert(
    _is.DatabaseSession session,
    List<LiveAnswer> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LiveAnswer>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LiveAnswer] and returns the inserted row.
  ///
  /// The returned [LiveAnswer] will have its `id` field set.
  Future<LiveAnswer> insertRow(
    _is.DatabaseSession session,
    LiveAnswer row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LiveAnswer>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LiveAnswer]s in the list and returns the resulting rows.
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
  /// The returned [LiveAnswer]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LiveAnswer>> upsert(
    _is.DatabaseSession session,
    List<LiveAnswer> rows, {
    required _is.ColumnSelections<LiveAnswerTable> conflictColumns,
    _is.ColumnSelections<LiveAnswerTable>? updateColumns,
    _is.WhereExpressionBuilder<LiveAnswerTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LiveAnswer>(
      rows,
      conflictColumns: conflictColumns(LiveAnswer.t),
      updateColumns: updateColumns?.call(LiveAnswer.t),
      updateWhere: updateWhere?.call(LiveAnswer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LiveAnswer] and returns the resulting row.
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
  /// The returned [LiveAnswer] will have its `id` field set.
  Future<LiveAnswer?> upsertRow(
    _is.DatabaseSession session,
    LiveAnswer row, {
    required _is.ColumnSelections<LiveAnswerTable> conflictColumns,
    _is.ColumnSelections<LiveAnswerTable>? updateColumns,
    _is.WhereExpressionBuilder<LiveAnswerTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LiveAnswer>(
      row,
      conflictColumns: conflictColumns(LiveAnswer.t),
      updateColumns: updateColumns?.call(LiveAnswer.t),
      updateWhere: updateWhere?.call(LiveAnswer.t),
      transaction: transaction,
    );
  }

  /// Updates all [LiveAnswer]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LiveAnswer>> update(
    _is.DatabaseSession session,
    List<LiveAnswer> rows, {
    _is.ColumnSelections<LiveAnswerTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LiveAnswer>(
      rows,
      columns: columns?.call(LiveAnswer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LiveAnswer]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LiveAnswer> updateRow(
    _is.DatabaseSession session,
    LiveAnswer row, {
    _is.ColumnSelections<LiveAnswerTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LiveAnswer>(
      row,
      columns: columns?.call(LiveAnswer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LiveAnswer] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LiveAnswer?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LiveAnswerUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LiveAnswer>(
      id,
      columnValues: columnValues(LiveAnswer.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LiveAnswer]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LiveAnswer>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LiveAnswerUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LiveAnswerTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LiveAnswerTable>? orderBy,
    _is.OrderByListBuilder<LiveAnswerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LiveAnswer>(
      columnValues: columnValues(LiveAnswer.t.updateTable),
      where: where(LiveAnswer.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LiveAnswer.t),
      orderByList: orderByList?.call(LiveAnswer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LiveAnswer]s in the list and returns the deleted rows.
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
  Future<List<LiveAnswer>> delete(
    _is.DatabaseSession session,
    List<LiveAnswer> rows, {
    _is.OrderByBuilder<LiveAnswerTable>? orderBy,
    _is.OrderByListBuilder<LiveAnswerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LiveAnswer>(
      rows,
      orderBy: orderBy?.call(LiveAnswer.t),
      orderByList: orderByList?.call(LiveAnswer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LiveAnswer].
  Future<LiveAnswer> deleteRow(
    _is.DatabaseSession session,
    LiveAnswer row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LiveAnswer>(
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
  Future<List<LiveAnswer>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LiveAnswerTable> where,
    _is.OrderByBuilder<LiveAnswerTable>? orderBy,
    _is.OrderByListBuilder<LiveAnswerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LiveAnswer>(
      where: where(LiveAnswer.t),
      orderBy: orderBy?.call(LiveAnswer.t),
      orderByList: orderByList?.call(LiveAnswer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LiveAnswerTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LiveAnswer>(
      where: where?.call(LiveAnswer.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LiveAnswer] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LiveAnswerTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LiveAnswer>(
      where: where(LiveAnswer.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class LiveAnswerAttachRowRepository {
  const LiveAnswerAttachRowRepository._();

  /// Creates a relation between the given [LiveAnswer] and [LiveGame]
  /// by setting the [LiveAnswer]'s foreign key `gameId` to refer to the [LiveGame].
  Future<void> game(
    _is.DatabaseSession session,
    LiveAnswer liveAnswer,
    _i7zs88ky.LiveGame game, {
    _is.Transaction? transaction,
  }) async {
    if (liveAnswer.id == null) {
      throw ArgumentError.notNull('liveAnswer.id');
    }
    if (game.id == null) {
      throw ArgumentError.notNull('game.id');
    }

    var $liveAnswer = liveAnswer.copyWith(gameId: game.id);
    await session.db.updateRow<LiveAnswer>(
      $liveAnswer,
      columns: [LiveAnswer.t.gameId],
      transaction: transaction,
    );
  }
}
