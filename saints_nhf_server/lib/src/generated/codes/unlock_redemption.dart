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

/// Who redeemed which code, so each player redeems a code once.
abstract class UnlockRedemption
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UnlockRedemption._({
    this.id,
    required this.codeId,
    required this.authUserId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UnlockRedemption({
    int? id,
    required int codeId,
    required _is.UuidValue authUserId,
    DateTime? createdAt,
  }) = _UnlockRedemptionImpl;

  factory UnlockRedemption.fromJson(Map<String, dynamic> jsonSerialization) {
    return UnlockRedemption(
      id: jsonSerialization['id'] as int?,
      codeId: jsonSerialization['codeId'] as int,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = UnlockRedemptionTable();

  static const db = UnlockRedemptionRepository._();

  @override
  int? id;

  int codeId;

  _is.UuidValue authUserId;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UnlockRedemption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UnlockRedemption copyWith({
    int? id,
    int? codeId,
    _is.UuidValue? authUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UnlockRedemption',
      if (id != null) 'id': id,
      'codeId': codeId,
      'authUserId': authUserId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UnlockRedemption',
      if (id != null) 'id': id,
      'codeId': codeId,
      'authUserId': authUserId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static UnlockRedemptionInclude include() {
    return UnlockRedemptionInclude._();
  }

  static UnlockRedemptionIncludeList includeList({
    _is.WhereExpressionBuilder<UnlockRedemptionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UnlockRedemptionTable>? orderBy,
    _is.OrderByListBuilder<UnlockRedemptionTable>? orderByList,
    UnlockRedemptionInclude? include,
  }) {
    return UnlockRedemptionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UnlockRedemption.t),
      orderByList: orderByList?.call(UnlockRedemption.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UnlockRedemptionImpl extends UnlockRedemption {
  _UnlockRedemptionImpl({
    int? id,
    required int codeId,
    required _is.UuidValue authUserId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         codeId: codeId,
         authUserId: authUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UnlockRedemption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UnlockRedemption copyWith({
    Object? id = _Undefined,
    int? codeId,
    _is.UuidValue? authUserId,
    DateTime? createdAt,
  }) {
    return UnlockRedemption(
      id: id is int? ? id : this.id,
      codeId: codeId ?? this.codeId,
      authUserId: authUserId ?? this.authUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UnlockRedemptionUpdateTable
    extends _is.UpdateTable<UnlockRedemptionTable> {
  UnlockRedemptionUpdateTable(super.table);

  _is.ColumnValue<int, int> codeId(int value) => _is.ColumnValue(
    table.codeId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class UnlockRedemptionTable extends _is.Table<int?> {
  UnlockRedemptionTable({super.tableRelation})
    : super(tableName: 'unlock_redemption') {
    updateTable = UnlockRedemptionUpdateTable(this);
    codeId = _is.ColumnInt(
      'codeId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final UnlockRedemptionUpdateTable updateTable;

  late final _is.ColumnInt codeId;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    codeId,
    authUserId,
    createdAt,
  ];
}

class UnlockRedemptionInclude extends _is.IncludeObject {
  UnlockRedemptionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UnlockRedemption.t;
}

class UnlockRedemptionIncludeList extends _is.IncludeList {
  UnlockRedemptionIncludeList._({
    _is.WhereExpressionBuilder<UnlockRedemptionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UnlockRedemption.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UnlockRedemption.t;
}

class UnlockRedemptionRepository {
  const UnlockRedemptionRepository._();

  /// Returns a list of [UnlockRedemption]s matching the given query parameters.
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
  Future<List<UnlockRedemption>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UnlockRedemptionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UnlockRedemptionTable>? orderBy,
    _is.OrderByListBuilder<UnlockRedemptionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UnlockRedemption>(
      where: where?.call(UnlockRedemption.t),
      orderBy: orderBy?.call(UnlockRedemption.t),
      orderByList: orderByList?.call(UnlockRedemption.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UnlockRedemption] matching the given query parameters.
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
  Future<UnlockRedemption?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UnlockRedemptionTable>? where,
    int? offset,
    _is.OrderByBuilder<UnlockRedemptionTable>? orderBy,
    _is.OrderByListBuilder<UnlockRedemptionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UnlockRedemption>(
      where: where?.call(UnlockRedemption.t),
      orderBy: orderBy?.call(UnlockRedemption.t),
      orderByList: orderByList?.call(UnlockRedemption.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UnlockRedemption] by its [id] or null if no such row exists.
  Future<UnlockRedemption?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UnlockRedemption>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UnlockRedemption]s in the list and returns the inserted rows.
  ///
  /// The returned [UnlockRedemption]s will have their `id` fields set.
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
  Future<List<UnlockRedemption>> insert(
    _is.DatabaseSession session,
    List<UnlockRedemption> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UnlockRedemption>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UnlockRedemption] and returns the inserted row.
  ///
  /// The returned [UnlockRedemption] will have its `id` field set.
  Future<UnlockRedemption> insertRow(
    _is.DatabaseSession session,
    UnlockRedemption row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UnlockRedemption>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UnlockRedemption]s in the list and returns the resulting rows.
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
  /// The returned [UnlockRedemption]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UnlockRedemption>> upsert(
    _is.DatabaseSession session,
    List<UnlockRedemption> rows, {
    required _is.ColumnSelections<UnlockRedemptionTable> conflictColumns,
    _is.ColumnSelections<UnlockRedemptionTable>? updateColumns,
    _is.WhereExpressionBuilder<UnlockRedemptionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UnlockRedemption>(
      rows,
      conflictColumns: conflictColumns(UnlockRedemption.t),
      updateColumns: updateColumns?.call(UnlockRedemption.t),
      updateWhere: updateWhere?.call(UnlockRedemption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UnlockRedemption] and returns the resulting row.
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
  /// The returned [UnlockRedemption] will have its `id` field set.
  Future<UnlockRedemption?> upsertRow(
    _is.DatabaseSession session,
    UnlockRedemption row, {
    required _is.ColumnSelections<UnlockRedemptionTable> conflictColumns,
    _is.ColumnSelections<UnlockRedemptionTable>? updateColumns,
    _is.WhereExpressionBuilder<UnlockRedemptionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UnlockRedemption>(
      row,
      conflictColumns: conflictColumns(UnlockRedemption.t),
      updateColumns: updateColumns?.call(UnlockRedemption.t),
      updateWhere: updateWhere?.call(UnlockRedemption.t),
      transaction: transaction,
    );
  }

  /// Updates all [UnlockRedemption]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UnlockRedemption>> update(
    _is.DatabaseSession session,
    List<UnlockRedemption> rows, {
    _is.ColumnSelections<UnlockRedemptionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UnlockRedemption>(
      rows,
      columns: columns?.call(UnlockRedemption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UnlockRedemption]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UnlockRedemption> updateRow(
    _is.DatabaseSession session,
    UnlockRedemption row, {
    _is.ColumnSelections<UnlockRedemptionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UnlockRedemption>(
      row,
      columns: columns?.call(UnlockRedemption.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UnlockRedemption] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UnlockRedemption?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UnlockRedemptionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UnlockRedemption>(
      id,
      columnValues: columnValues(UnlockRedemption.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UnlockRedemption]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UnlockRedemption>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UnlockRedemptionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<UnlockRedemptionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UnlockRedemptionTable>? orderBy,
    _is.OrderByListBuilder<UnlockRedemptionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UnlockRedemption>(
      columnValues: columnValues(UnlockRedemption.t.updateTable),
      where: where(UnlockRedemption.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UnlockRedemption.t),
      orderByList: orderByList?.call(UnlockRedemption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UnlockRedemption]s in the list and returns the deleted rows.
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
  Future<List<UnlockRedemption>> delete(
    _is.DatabaseSession session,
    List<UnlockRedemption> rows, {
    _is.OrderByBuilder<UnlockRedemptionTable>? orderBy,
    _is.OrderByListBuilder<UnlockRedemptionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UnlockRedemption>(
      rows,
      orderBy: orderBy?.call(UnlockRedemption.t),
      orderByList: orderByList?.call(UnlockRedemption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UnlockRedemption].
  Future<UnlockRedemption> deleteRow(
    _is.DatabaseSession session,
    UnlockRedemption row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UnlockRedemption>(
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
  Future<List<UnlockRedemption>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UnlockRedemptionTable> where,
    _is.OrderByBuilder<UnlockRedemptionTable>? orderBy,
    _is.OrderByListBuilder<UnlockRedemptionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UnlockRedemption>(
      where: where(UnlockRedemption.t),
      orderBy: orderBy?.call(UnlockRedemption.t),
      orderByList: orderByList?.call(UnlockRedemption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UnlockRedemptionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UnlockRedemption>(
      where: where?.call(UnlockRedemption.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UnlockRedemption] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UnlockRedemptionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UnlockRedemption>(
      where: where(UnlockRedemption.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
