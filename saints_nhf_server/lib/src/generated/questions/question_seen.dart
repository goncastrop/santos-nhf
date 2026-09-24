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
import '../questions/question.dart' as _i5m8psqj;

/// One row per question a player has already been asked, so the same one does
/// not come back while there are unseen ones left. [seenAt] is refreshed every
/// time it comes up, so once the pool runs out the oldest are reused first.
///
/// Only real players are recorded: the machine opponent picks its questions
/// without looking here.
abstract class QuestionSeen
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  QuestionSeen._({
    this.id,
    required this.authUserId,
    required this.questionId,
    this.question,
    DateTime? seenAt,
  }) : seenAt = seenAt ?? DateTime.now();

  factory QuestionSeen({
    int? id,
    required _is.UuidValue authUserId,
    required int questionId,
    _i5m8psqj.Question? question,
    DateTime? seenAt,
  }) = _QuestionSeenImpl;

  factory QuestionSeen.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuestionSeen(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      questionId: jsonSerialization['questionId'] as int,
      question: jsonSerialization['question'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<_i5m8psqj.Question>(
              jsonSerialization['question'],
            ),
      seenAt: jsonSerialization['seenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['seenAt']),
    );
  }

  static final t = QuestionSeenTable();

  static const db = QuestionSeenRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  int questionId;

  _i5m8psqj.Question? question;

  DateTime seenAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [QuestionSeen]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  QuestionSeen copyWith({
    int? id,
    _is.UuidValue? authUserId,
    int? questionId,
    _i5m8psqj.Question? question,
    DateTime? seenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuestionSeen',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'questionId': questionId,
      if (question != null) 'question': question?.toJson(),
      'seenAt': seenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuestionSeen',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'questionId': questionId,
      if (question != null) 'question': question?.toJsonForProtocol(),
      'seenAt': seenAt.toJson(),
    };
  }

  static QuestionSeenInclude include({_i5m8psqj.QuestionInclude? question}) {
    return QuestionSeenInclude._(question: question);
  }

  static QuestionSeenIncludeList includeList({
    _is.WhereExpressionBuilder<QuestionSeenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QuestionSeenTable>? orderBy,
    _is.OrderByListBuilder<QuestionSeenTable>? orderByList,
    QuestionSeenInclude? include,
  }) {
    return QuestionSeenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QuestionSeen.t),
      orderByList: orderByList?.call(QuestionSeen.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionSeenImpl extends QuestionSeen {
  _QuestionSeenImpl({
    int? id,
    required _is.UuidValue authUserId,
    required int questionId,
    _i5m8psqj.Question? question,
    DateTime? seenAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         questionId: questionId,
         question: question,
         seenAt: seenAt,
       );

  /// Returns a shallow copy of this [QuestionSeen]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  QuestionSeen copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    int? questionId,
    Object? question = _Undefined,
    DateTime? seenAt,
  }) {
    return QuestionSeen(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      questionId: questionId ?? this.questionId,
      question: question is _i5m8psqj.Question?
          ? question
          : this.question?.copyWith(),
      seenAt: seenAt ?? this.seenAt,
    );
  }
}

class QuestionSeenUpdateTable extends _is.UpdateTable<QuestionSeenTable> {
  QuestionSeenUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<int, int> questionId(int value) => _is.ColumnValue(
    table.questionId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> seenAt(DateTime value) => _is.ColumnValue(
    table.seenAt,
    value,
  );
}

class QuestionSeenTable extends _is.Table<int?> {
  QuestionSeenTable({super.tableRelation}) : super(tableName: 'question_seen') {
    updateTable = QuestionSeenUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    questionId = _is.ColumnInt(
      'questionId',
      this,
    );
    seenAt = _is.ColumnDateTime(
      'seenAt',
      this,
      hasDefault: true,
    );
  }

  late final QuestionSeenUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnInt questionId;

  _i5m8psqj.QuestionTable? _question;

  late final _is.ColumnDateTime seenAt;

  _i5m8psqj.QuestionTable get question {
    if (_question != null) return _question!;
    _question = _is.createRelationTable(
      relationFieldName: 'question',
      field: QuestionSeen.t.questionId,
      foreignField: _i5m8psqj.Question.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5m8psqj.QuestionTable(tableRelation: foreignTableRelation),
    );
    return _question!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    questionId,
    seenAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'question') {
      return question;
    }
    return null;
  }
}

class QuestionSeenInclude extends _is.IncludeObject {
  QuestionSeenInclude._({_i5m8psqj.QuestionInclude? question}) {
    _question = question;
  }

  _i5m8psqj.QuestionInclude? _question;

  @override
  Map<String, _is.Include?> get includes => {'question': _question};

  @override
  _is.Table<int?> get table => QuestionSeen.t;
}

class QuestionSeenIncludeList extends _is.IncludeList {
  QuestionSeenIncludeList._({
    _is.WhereExpressionBuilder<QuestionSeenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(QuestionSeen.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => QuestionSeen.t;
}

class QuestionSeenRepository {
  const QuestionSeenRepository._();

  final attachRow = const QuestionSeenAttachRowRepository._();

  /// Returns a list of [QuestionSeen]s matching the given query parameters.
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
  Future<List<QuestionSeen>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QuestionSeenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QuestionSeenTable>? orderBy,
    _is.OrderByListBuilder<QuestionSeenTable>? orderByList,
    _is.Transaction? transaction,
    QuestionSeenInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<QuestionSeen>(
      where: where?.call(QuestionSeen.t),
      orderBy: orderBy?.call(QuestionSeen.t),
      orderByList: orderByList?.call(QuestionSeen.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [QuestionSeen] matching the given query parameters.
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
  Future<QuestionSeen?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QuestionSeenTable>? where,
    int? offset,
    _is.OrderByBuilder<QuestionSeenTable>? orderBy,
    _is.OrderByListBuilder<QuestionSeenTable>? orderByList,
    _is.Transaction? transaction,
    QuestionSeenInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<QuestionSeen>(
      where: where?.call(QuestionSeen.t),
      orderBy: orderBy?.call(QuestionSeen.t),
      orderByList: orderByList?.call(QuestionSeen.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [QuestionSeen] by its [id] or null if no such row exists.
  Future<QuestionSeen?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    QuestionSeenInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<QuestionSeen>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [QuestionSeen]s in the list and returns the inserted rows.
  ///
  /// The returned [QuestionSeen]s will have their `id` fields set.
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
  Future<List<QuestionSeen>> insert(
    _is.DatabaseSession session,
    List<QuestionSeen> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<QuestionSeen>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [QuestionSeen] and returns the inserted row.
  ///
  /// The returned [QuestionSeen] will have its `id` field set.
  Future<QuestionSeen> insertRow(
    _is.DatabaseSession session,
    QuestionSeen row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<QuestionSeen>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [QuestionSeen]s in the list and returns the resulting rows.
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
  /// The returned [QuestionSeen]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QuestionSeen>> upsert(
    _is.DatabaseSession session,
    List<QuestionSeen> rows, {
    required _is.ColumnSelections<QuestionSeenTable> conflictColumns,
    _is.ColumnSelections<QuestionSeenTable>? updateColumns,
    _is.WhereExpressionBuilder<QuestionSeenTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<QuestionSeen>(
      rows,
      conflictColumns: conflictColumns(QuestionSeen.t),
      updateColumns: updateColumns?.call(QuestionSeen.t),
      updateWhere: updateWhere?.call(QuestionSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [QuestionSeen] and returns the resulting row.
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
  /// The returned [QuestionSeen] will have its `id` field set.
  Future<QuestionSeen?> upsertRow(
    _is.DatabaseSession session,
    QuestionSeen row, {
    required _is.ColumnSelections<QuestionSeenTable> conflictColumns,
    _is.ColumnSelections<QuestionSeenTable>? updateColumns,
    _is.WhereExpressionBuilder<QuestionSeenTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<QuestionSeen>(
      row,
      conflictColumns: conflictColumns(QuestionSeen.t),
      updateColumns: updateColumns?.call(QuestionSeen.t),
      updateWhere: updateWhere?.call(QuestionSeen.t),
      transaction: transaction,
    );
  }

  /// Updates all [QuestionSeen]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QuestionSeen>> update(
    _is.DatabaseSession session,
    List<QuestionSeen> rows, {
    _is.ColumnSelections<QuestionSeenTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<QuestionSeen>(
      rows,
      columns: columns?.call(QuestionSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [QuestionSeen]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<QuestionSeen> updateRow(
    _is.DatabaseSession session,
    QuestionSeen row, {
    _is.ColumnSelections<QuestionSeenTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<QuestionSeen>(
      row,
      columns: columns?.call(QuestionSeen.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QuestionSeen] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<QuestionSeen?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<QuestionSeenUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<QuestionSeen>(
      id,
      columnValues: columnValues(QuestionSeen.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [QuestionSeen]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QuestionSeen>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<QuestionSeenUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<QuestionSeenTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QuestionSeenTable>? orderBy,
    _is.OrderByListBuilder<QuestionSeenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<QuestionSeen>(
      columnValues: columnValues(QuestionSeen.t.updateTable),
      where: where(QuestionSeen.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QuestionSeen.t),
      orderByList: orderByList?.call(QuestionSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [QuestionSeen]s in the list and returns the deleted rows.
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
  Future<List<QuestionSeen>> delete(
    _is.DatabaseSession session,
    List<QuestionSeen> rows, {
    _is.OrderByBuilder<QuestionSeenTable>? orderBy,
    _is.OrderByListBuilder<QuestionSeenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<QuestionSeen>(
      rows,
      orderBy: orderBy?.call(QuestionSeen.t),
      orderByList: orderByList?.call(QuestionSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [QuestionSeen].
  Future<QuestionSeen> deleteRow(
    _is.DatabaseSession session,
    QuestionSeen row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<QuestionSeen>(
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
  Future<List<QuestionSeen>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QuestionSeenTable> where,
    _is.OrderByBuilder<QuestionSeenTable>? orderBy,
    _is.OrderByListBuilder<QuestionSeenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<QuestionSeen>(
      where: where(QuestionSeen.t),
      orderBy: orderBy?.call(QuestionSeen.t),
      orderByList: orderByList?.call(QuestionSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QuestionSeenTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<QuestionSeen>(
      where: where?.call(QuestionSeen.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [QuestionSeen] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QuestionSeenTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<QuestionSeen>(
      where: where(QuestionSeen.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class QuestionSeenAttachRowRepository {
  const QuestionSeenAttachRowRepository._();

  /// Creates a relation between the given [QuestionSeen] and [Question]
  /// by setting the [QuestionSeen]'s foreign key `questionId` to refer to the [Question].
  Future<void> question(
    _is.DatabaseSession session,
    QuestionSeen questionSeen,
    _i5m8psqj.Question question, {
    _is.Transaction? transaction,
  }) async {
    if (questionSeen.id == null) {
      throw ArgumentError.notNull('questionSeen.id');
    }
    if (question.id == null) {
      throw ArgumentError.notNull('question.id');
    }

    var $questionSeen = questionSeen.copyWith(questionId: question.id);
    await session.db.updateRow<QuestionSeen>(
      $questionSeen,
      columns: [QuestionSeen.t.questionId],
      transaction: transaction,
    );
  }
}
