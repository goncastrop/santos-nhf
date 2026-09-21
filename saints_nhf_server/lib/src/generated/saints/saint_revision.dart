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
import 'package:serverpod/serverpod.dart' as _is;

/// Snapshot of a saint before an admin change, so edits can be reviewed and undone.
abstract class SaintRevision
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SaintRevision._({
    this.id,
    required this.saintId,
    required this.snapshotJson,
    this.note,
    this.changedByEmail,
    this.changedByAuthUserId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SaintRevision({
    int? id,
    required int saintId,
    required String snapshotJson,
    String? note,
    String? changedByEmail,
    _is.UuidValue? changedByAuthUserId,
    DateTime? createdAt,
  }) = _SaintRevisionImpl;

  factory SaintRevision.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaintRevision(
      id: jsonSerialization['id'] as int?,
      saintId: jsonSerialization['saintId'] as int,
      snapshotJson: jsonSerialization['snapshotJson'] as String,
      note: jsonSerialization['note'] as String?,
      changedByEmail: jsonSerialization['changedByEmail'] as String?,
      changedByAuthUserId: jsonSerialization['changedByAuthUserId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['changedByAuthUserId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = SaintRevisionTable();

  static const db = SaintRevisionRepository._();

  @override
  int? id;

  int saintId;

  /// JSON encoding of the [Saint] as it was before the change.
  String snapshotJson;

  /// Admin note describing the change that replaced this snapshot.
  String? note;

  String? changedByEmail;

  _is.UuidValue? changedByAuthUserId;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SaintRevision]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SaintRevision copyWith({
    int? id,
    int? saintId,
    String? snapshotJson,
    String? note,
    String? changedByEmail,
    _is.UuidValue? changedByAuthUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaintRevision',
      if (id != null) 'id': id,
      'saintId': saintId,
      'snapshotJson': snapshotJson,
      if (note != null) 'note': note,
      if (changedByEmail != null) 'changedByEmail': changedByEmail,
      if (changedByAuthUserId != null)
        'changedByAuthUserId': changedByAuthUserId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaintRevision',
      if (id != null) 'id': id,
      'saintId': saintId,
      'snapshotJson': snapshotJson,
      if (note != null) 'note': note,
      if (changedByEmail != null) 'changedByEmail': changedByEmail,
      if (changedByAuthUserId != null)
        'changedByAuthUserId': changedByAuthUserId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static SaintRevisionInclude include() {
    return SaintRevisionInclude._();
  }

  static SaintRevisionIncludeList includeList({
    _is.WhereExpressionBuilder<SaintRevisionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintRevisionTable>? orderBy,
    _is.OrderByListBuilder<SaintRevisionTable>? orderByList,
    SaintRevisionInclude? include,
  }) {
    return SaintRevisionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SaintRevision.t),
      orderByList: orderByList?.call(SaintRevision.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SaintRevisionImpl extends SaintRevision {
  _SaintRevisionImpl({
    int? id,
    required int saintId,
    required String snapshotJson,
    String? note,
    String? changedByEmail,
    _is.UuidValue? changedByAuthUserId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         saintId: saintId,
         snapshotJson: snapshotJson,
         note: note,
         changedByEmail: changedByEmail,
         changedByAuthUserId: changedByAuthUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SaintRevision]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SaintRevision copyWith({
    Object? id = _Undefined,
    int? saintId,
    String? snapshotJson,
    Object? note = _Undefined,
    Object? changedByEmail = _Undefined,
    Object? changedByAuthUserId = _Undefined,
    DateTime? createdAt,
  }) {
    return SaintRevision(
      id: id is int? ? id : this.id,
      saintId: saintId ?? this.saintId,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      note: note is String? ? note : this.note,
      changedByEmail: changedByEmail is String?
          ? changedByEmail
          : this.changedByEmail,
      changedByAuthUserId: changedByAuthUserId is _is.UuidValue?
          ? changedByAuthUserId
          : this.changedByAuthUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SaintRevisionUpdateTable extends _is.UpdateTable<SaintRevisionTable> {
  SaintRevisionUpdateTable(super.table);

  _is.ColumnValue<int, int> saintId(int value) => _is.ColumnValue(
    table.saintId,
    value,
  );

  _is.ColumnValue<String, String> snapshotJson(String value) => _is.ColumnValue(
    table.snapshotJson,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<String, String> changedByEmail(String? value) =>
      _is.ColumnValue(
        table.changedByEmail,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> changedByAuthUserId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.changedByAuthUserId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SaintRevisionTable extends _is.Table<int?> {
  SaintRevisionTable({super.tableRelation})
    : super(tableName: 'saint_revision') {
    updateTable = SaintRevisionUpdateTable(this);
    saintId = _is.ColumnInt(
      'saintId',
      this,
    );
    snapshotJson = _is.ColumnString(
      'snapshotJson',
      this,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    changedByEmail = _is.ColumnString(
      'changedByEmail',
      this,
    );
    changedByAuthUserId = _is.ColumnUuid(
      'changedByAuthUserId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final SaintRevisionUpdateTable updateTable;

  late final _is.ColumnInt saintId;

  /// JSON encoding of the [Saint] as it was before the change.
  late final _is.ColumnString snapshotJson;

  /// Admin note describing the change that replaced this snapshot.
  late final _is.ColumnString note;

  late final _is.ColumnString changedByEmail;

  late final _is.ColumnUuid changedByAuthUserId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    saintId,
    snapshotJson,
    note,
    changedByEmail,
    changedByAuthUserId,
    createdAt,
  ];
}

class SaintRevisionInclude extends _is.IncludeObject {
  SaintRevisionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SaintRevision.t;
}

class SaintRevisionIncludeList extends _is.IncludeList {
  SaintRevisionIncludeList._({
    _is.WhereExpressionBuilder<SaintRevisionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SaintRevision.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SaintRevision.t;
}

class SaintRevisionRepository {
  const SaintRevisionRepository._();

  /// Returns a list of [SaintRevision]s matching the given query parameters.
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
  Future<List<SaintRevision>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintRevisionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintRevisionTable>? orderBy,
    _is.OrderByListBuilder<SaintRevisionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SaintRevision>(
      where: where?.call(SaintRevision.t),
      orderBy: orderBy?.call(SaintRevision.t),
      orderByList: orderByList?.call(SaintRevision.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SaintRevision] matching the given query parameters.
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
  Future<SaintRevision?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintRevisionTable>? where,
    int? offset,
    _is.OrderByBuilder<SaintRevisionTable>? orderBy,
    _is.OrderByListBuilder<SaintRevisionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SaintRevision>(
      where: where?.call(SaintRevision.t),
      orderBy: orderBy?.call(SaintRevision.t),
      orderByList: orderByList?.call(SaintRevision.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SaintRevision] by its [id] or null if no such row exists.
  Future<SaintRevision?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SaintRevision>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SaintRevision]s in the list and returns the inserted rows.
  ///
  /// The returned [SaintRevision]s will have their `id` fields set.
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
  Future<List<SaintRevision>> insert(
    _is.DatabaseSession session,
    List<SaintRevision> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SaintRevision>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SaintRevision] and returns the inserted row.
  ///
  /// The returned [SaintRevision] will have its `id` field set.
  Future<SaintRevision> insertRow(
    _is.DatabaseSession session,
    SaintRevision row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SaintRevision>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SaintRevision]s in the list and returns the resulting rows.
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
  /// The returned [SaintRevision]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SaintRevision>> upsert(
    _is.DatabaseSession session,
    List<SaintRevision> rows, {
    required _is.ColumnSelections<SaintRevisionTable> conflictColumns,
    _is.ColumnSelections<SaintRevisionTable>? updateColumns,
    _is.WhereExpressionBuilder<SaintRevisionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SaintRevision>(
      rows,
      conflictColumns: conflictColumns(SaintRevision.t),
      updateColumns: updateColumns?.call(SaintRevision.t),
      updateWhere: updateWhere?.call(SaintRevision.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SaintRevision] and returns the resulting row.
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
  /// The returned [SaintRevision] will have its `id` field set.
  Future<SaintRevision?> upsertRow(
    _is.DatabaseSession session,
    SaintRevision row, {
    required _is.ColumnSelections<SaintRevisionTable> conflictColumns,
    _is.ColumnSelections<SaintRevisionTable>? updateColumns,
    _is.WhereExpressionBuilder<SaintRevisionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SaintRevision>(
      row,
      conflictColumns: conflictColumns(SaintRevision.t),
      updateColumns: updateColumns?.call(SaintRevision.t),
      updateWhere: updateWhere?.call(SaintRevision.t),
      transaction: transaction,
    );
  }

  /// Updates all [SaintRevision]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SaintRevision>> update(
    _is.DatabaseSession session,
    List<SaintRevision> rows, {
    _is.ColumnSelections<SaintRevisionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SaintRevision>(
      rows,
      columns: columns?.call(SaintRevision.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SaintRevision]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SaintRevision> updateRow(
    _is.DatabaseSession session,
    SaintRevision row, {
    _is.ColumnSelections<SaintRevisionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SaintRevision>(
      row,
      columns: columns?.call(SaintRevision.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SaintRevision] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SaintRevision?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SaintRevisionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SaintRevision>(
      id,
      columnValues: columnValues(SaintRevision.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SaintRevision]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SaintRevision>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SaintRevisionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SaintRevisionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintRevisionTable>? orderBy,
    _is.OrderByListBuilder<SaintRevisionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SaintRevision>(
      columnValues: columnValues(SaintRevision.t.updateTable),
      where: where(SaintRevision.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SaintRevision.t),
      orderByList: orderByList?.call(SaintRevision.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SaintRevision]s in the list and returns the deleted rows.
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
  Future<List<SaintRevision>> delete(
    _is.DatabaseSession session,
    List<SaintRevision> rows, {
    _is.OrderByBuilder<SaintRevisionTable>? orderBy,
    _is.OrderByListBuilder<SaintRevisionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SaintRevision>(
      rows,
      orderBy: orderBy?.call(SaintRevision.t),
      orderByList: orderByList?.call(SaintRevision.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SaintRevision].
  Future<SaintRevision> deleteRow(
    _is.DatabaseSession session,
    SaintRevision row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SaintRevision>(
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
  Future<List<SaintRevision>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SaintRevisionTable> where,
    _is.OrderByBuilder<SaintRevisionTable>? orderBy,
    _is.OrderByListBuilder<SaintRevisionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SaintRevision>(
      where: where(SaintRevision.t),
      orderBy: orderBy?.call(SaintRevision.t),
      orderByList: orderByList?.call(SaintRevision.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintRevisionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SaintRevision>(
      where: where?.call(SaintRevision.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SaintRevision] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SaintRevisionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SaintRevision>(
      where: where(SaintRevision.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
