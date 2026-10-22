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

/// Two saints who met in life, e.g. San Juan Pablo II and Santa Teresa de
/// Calcuta. It goes both ways, so each pair is stored once, with the lower
/// saint id first (see `MeetingService.pair`).
abstract class SaintMeeting
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SaintMeeting._({
    this.id,
    required this.saintAId,
    required this.saintBId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SaintMeeting({
    int? id,
    required int saintAId,
    required int saintBId,
    DateTime? createdAt,
  }) = _SaintMeetingImpl;

  factory SaintMeeting.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaintMeeting(
      id: jsonSerialization['id'] as int?,
      saintAId: jsonSerialization['saintAId'] as int,
      saintBId: jsonSerialization['saintBId'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = SaintMeetingTable();

  static const db = SaintMeetingRepository._();

  @override
  int? id;

  int saintAId;

  int saintBId;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SaintMeeting]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SaintMeeting copyWith({
    int? id,
    int? saintAId,
    int? saintBId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaintMeeting',
      if (id != null) 'id': id,
      'saintAId': saintAId,
      'saintBId': saintBId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaintMeeting',
      if (id != null) 'id': id,
      'saintAId': saintAId,
      'saintBId': saintBId,
      'createdAt': createdAt.toJson(),
    };
  }

  static SaintMeetingInclude include() {
    return SaintMeetingInclude._();
  }

  static SaintMeetingIncludeList includeList({
    _is.WhereExpressionBuilder<SaintMeetingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintMeetingTable>? orderBy,
    _is.OrderByListBuilder<SaintMeetingTable>? orderByList,
    SaintMeetingInclude? include,
  }) {
    return SaintMeetingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SaintMeeting.t),
      orderByList: orderByList?.call(SaintMeeting.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SaintMeetingImpl extends SaintMeeting {
  _SaintMeetingImpl({
    int? id,
    required int saintAId,
    required int saintBId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         saintAId: saintAId,
         saintBId: saintBId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SaintMeeting]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SaintMeeting copyWith({
    Object? id = _Undefined,
    int? saintAId,
    int? saintBId,
    DateTime? createdAt,
  }) {
    return SaintMeeting(
      id: id is int? ? id : this.id,
      saintAId: saintAId ?? this.saintAId,
      saintBId: saintBId ?? this.saintBId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SaintMeetingUpdateTable extends _is.UpdateTable<SaintMeetingTable> {
  SaintMeetingUpdateTable(super.table);

  _is.ColumnValue<int, int> saintAId(int value) => _is.ColumnValue(
    table.saintAId,
    value,
  );

  _is.ColumnValue<int, int> saintBId(int value) => _is.ColumnValue(
    table.saintBId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SaintMeetingTable extends _is.Table<int?> {
  SaintMeetingTable({super.tableRelation}) : super(tableName: 'saint_meeting') {
    updateTable = SaintMeetingUpdateTable(this);
    saintAId = _is.ColumnInt(
      'saintAId',
      this,
    );
    saintBId = _is.ColumnInt(
      'saintBId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final SaintMeetingUpdateTable updateTable;

  late final _is.ColumnInt saintAId;

  late final _is.ColumnInt saintBId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    saintAId,
    saintBId,
    createdAt,
  ];
}

class SaintMeetingInclude extends _is.IncludeObject {
  SaintMeetingInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SaintMeeting.t;
}

class SaintMeetingIncludeList extends _is.IncludeList {
  SaintMeetingIncludeList._({
    _is.WhereExpressionBuilder<SaintMeetingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SaintMeeting.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SaintMeeting.t;
}

class SaintMeetingRepository {
  const SaintMeetingRepository._();

  /// Returns a list of [SaintMeeting]s matching the given query parameters.
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
  Future<List<SaintMeeting>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintMeetingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintMeetingTable>? orderBy,
    _is.OrderByListBuilder<SaintMeetingTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SaintMeeting>(
      where: where?.call(SaintMeeting.t),
      orderBy: orderBy?.call(SaintMeeting.t),
      orderByList: orderByList?.call(SaintMeeting.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SaintMeeting] matching the given query parameters.
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
  Future<SaintMeeting?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintMeetingTable>? where,
    int? offset,
    _is.OrderByBuilder<SaintMeetingTable>? orderBy,
    _is.OrderByListBuilder<SaintMeetingTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SaintMeeting>(
      where: where?.call(SaintMeeting.t),
      orderBy: orderBy?.call(SaintMeeting.t),
      orderByList: orderByList?.call(SaintMeeting.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SaintMeeting] by its [id] or null if no such row exists.
  Future<SaintMeeting?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SaintMeeting>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SaintMeeting]s in the list and returns the inserted rows.
  ///
  /// The returned [SaintMeeting]s will have their `id` fields set.
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
  Future<List<SaintMeeting>> insert(
    _is.DatabaseSession session,
    List<SaintMeeting> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SaintMeeting>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SaintMeeting] and returns the inserted row.
  ///
  /// The returned [SaintMeeting] will have its `id` field set.
  Future<SaintMeeting> insertRow(
    _is.DatabaseSession session,
    SaintMeeting row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SaintMeeting>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SaintMeeting]s in the list and returns the resulting rows.
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
  /// The returned [SaintMeeting]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SaintMeeting>> upsert(
    _is.DatabaseSession session,
    List<SaintMeeting> rows, {
    required _is.ColumnSelections<SaintMeetingTable> conflictColumns,
    _is.ColumnSelections<SaintMeetingTable>? updateColumns,
    _is.WhereExpressionBuilder<SaintMeetingTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SaintMeeting>(
      rows,
      conflictColumns: conflictColumns(SaintMeeting.t),
      updateColumns: updateColumns?.call(SaintMeeting.t),
      updateWhere: updateWhere?.call(SaintMeeting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SaintMeeting] and returns the resulting row.
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
  /// The returned [SaintMeeting] will have its `id` field set.
  Future<SaintMeeting?> upsertRow(
    _is.DatabaseSession session,
    SaintMeeting row, {
    required _is.ColumnSelections<SaintMeetingTable> conflictColumns,
    _is.ColumnSelections<SaintMeetingTable>? updateColumns,
    _is.WhereExpressionBuilder<SaintMeetingTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SaintMeeting>(
      row,
      conflictColumns: conflictColumns(SaintMeeting.t),
      updateColumns: updateColumns?.call(SaintMeeting.t),
      updateWhere: updateWhere?.call(SaintMeeting.t),
      transaction: transaction,
    );
  }

  /// Updates all [SaintMeeting]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SaintMeeting>> update(
    _is.DatabaseSession session,
    List<SaintMeeting> rows, {
    _is.ColumnSelections<SaintMeetingTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SaintMeeting>(
      rows,
      columns: columns?.call(SaintMeeting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SaintMeeting]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SaintMeeting> updateRow(
    _is.DatabaseSession session,
    SaintMeeting row, {
    _is.ColumnSelections<SaintMeetingTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SaintMeeting>(
      row,
      columns: columns?.call(SaintMeeting.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SaintMeeting] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SaintMeeting?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SaintMeetingUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SaintMeeting>(
      id,
      columnValues: columnValues(SaintMeeting.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SaintMeeting]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SaintMeeting>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SaintMeetingUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SaintMeetingTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintMeetingTable>? orderBy,
    _is.OrderByListBuilder<SaintMeetingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SaintMeeting>(
      columnValues: columnValues(SaintMeeting.t.updateTable),
      where: where(SaintMeeting.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SaintMeeting.t),
      orderByList: orderByList?.call(SaintMeeting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SaintMeeting]s in the list and returns the deleted rows.
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
  Future<List<SaintMeeting>> delete(
    _is.DatabaseSession session,
    List<SaintMeeting> rows, {
    _is.OrderByBuilder<SaintMeetingTable>? orderBy,
    _is.OrderByListBuilder<SaintMeetingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SaintMeeting>(
      rows,
      orderBy: orderBy?.call(SaintMeeting.t),
      orderByList: orderByList?.call(SaintMeeting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SaintMeeting].
  Future<SaintMeeting> deleteRow(
    _is.DatabaseSession session,
    SaintMeeting row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SaintMeeting>(
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
  Future<List<SaintMeeting>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SaintMeetingTable> where,
    _is.OrderByBuilder<SaintMeetingTable>? orderBy,
    _is.OrderByListBuilder<SaintMeetingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SaintMeeting>(
      where: where(SaintMeeting.t),
      orderBy: orderBy?.call(SaintMeeting.t),
      orderByList: orderByList?.call(SaintMeeting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintMeetingTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SaintMeeting>(
      where: where?.call(SaintMeeting.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SaintMeeting] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SaintMeetingTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SaintMeeting>(
      where: where(SaintMeeting.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
