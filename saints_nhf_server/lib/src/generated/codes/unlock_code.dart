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

/// A code handed out during the stream that unlocks a card.
abstract class UnlockCode
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UnlockCode._({
    this.id,
    required this.code,
    this.saintId,
    this.maxUses,
    int? uses,
    this.expiresAt,
    bool? active,
    this.note,
    DateTime? createdAt,
  }) : uses = uses ?? 0,
       active = active ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory UnlockCode({
    int? id,
    required String code,
    int? saintId,
    int? maxUses,
    int? uses,
    DateTime? expiresAt,
    bool? active,
    String? note,
    DateTime? createdAt,
  }) = _UnlockCodeImpl;

  factory UnlockCode.fromJson(Map<String, dynamic> jsonSerialization) {
    return UnlockCode(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      saintId: jsonSerialization['saintId'] as int?,
      maxUses: jsonSerialization['maxUses'] as int?,
      uses: jsonSerialization['uses'] as int?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
      note: jsonSerialization['note'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = UnlockCodeTable();

  static const db = UnlockCodeRepository._();

  @override
  int? id;

  String code;

  /// Null grants a random card the player is missing.
  int? saintId;

  /// Null means unlimited.
  int? maxUses;

  int uses;

  DateTime? expiresAt;

  bool active;

  String? note;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UnlockCode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UnlockCode copyWith({
    int? id,
    String? code,
    int? saintId,
    int? maxUses,
    int? uses,
    DateTime? expiresAt,
    bool? active,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UnlockCode',
      if (id != null) 'id': id,
      'code': code,
      if (saintId != null) 'saintId': saintId,
      if (maxUses != null) 'maxUses': maxUses,
      'uses': uses,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'active': active,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UnlockCode',
      if (id != null) 'id': id,
      'code': code,
      if (saintId != null) 'saintId': saintId,
      if (maxUses != null) 'maxUses': maxUses,
      'uses': uses,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'active': active,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  static UnlockCodeInclude include() {
    return UnlockCodeInclude._();
  }

  static UnlockCodeIncludeList includeList({
    _is.WhereExpressionBuilder<UnlockCodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UnlockCodeTable>? orderBy,
    _is.OrderByListBuilder<UnlockCodeTable>? orderByList,
    UnlockCodeInclude? include,
  }) {
    return UnlockCodeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UnlockCode.t),
      orderByList: orderByList?.call(UnlockCode.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UnlockCodeImpl extends UnlockCode {
  _UnlockCodeImpl({
    int? id,
    required String code,
    int? saintId,
    int? maxUses,
    int? uses,
    DateTime? expiresAt,
    bool? active,
    String? note,
    DateTime? createdAt,
  }) : super._(
         id: id,
         code: code,
         saintId: saintId,
         maxUses: maxUses,
         uses: uses,
         expiresAt: expiresAt,
         active: active,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UnlockCode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UnlockCode copyWith({
    Object? id = _Undefined,
    String? code,
    Object? saintId = _Undefined,
    Object? maxUses = _Undefined,
    int? uses,
    Object? expiresAt = _Undefined,
    bool? active,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return UnlockCode(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      saintId: saintId is int? ? saintId : this.saintId,
      maxUses: maxUses is int? ? maxUses : this.maxUses,
      uses: uses ?? this.uses,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      active: active ?? this.active,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UnlockCodeUpdateTable extends _is.UpdateTable<UnlockCodeTable> {
  UnlockCodeUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<int, int> saintId(int? value) => _is.ColumnValue(
    table.saintId,
    value,
  );

  _is.ColumnValue<int, int> maxUses(int? value) => _is.ColumnValue(
    table.maxUses,
    value,
  );

  _is.ColumnValue<int, int> uses(int value) => _is.ColumnValue(
    table.uses,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<bool, bool> active(bool value) => _is.ColumnValue(
    table.active,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class UnlockCodeTable extends _is.Table<int?> {
  UnlockCodeTable({super.tableRelation}) : super(tableName: 'unlock_code') {
    updateTable = UnlockCodeUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    saintId = _is.ColumnInt(
      'saintId',
      this,
    );
    maxUses = _is.ColumnInt(
      'maxUses',
      this,
    );
    uses = _is.ColumnInt(
      'uses',
      this,
      hasDefault: true,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    active = _is.ColumnBool(
      'active',
      this,
      hasDefault: true,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final UnlockCodeUpdateTable updateTable;

  late final _is.ColumnString code;

  /// Null grants a random card the player is missing.
  late final _is.ColumnInt saintId;

  /// Null means unlimited.
  late final _is.ColumnInt maxUses;

  late final _is.ColumnInt uses;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnBool active;

  late final _is.ColumnString note;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    saintId,
    maxUses,
    uses,
    expiresAt,
    active,
    note,
    createdAt,
  ];
}

class UnlockCodeInclude extends _is.IncludeObject {
  UnlockCodeInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UnlockCode.t;
}

class UnlockCodeIncludeList extends _is.IncludeList {
  UnlockCodeIncludeList._({
    _is.WhereExpressionBuilder<UnlockCodeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UnlockCode.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UnlockCode.t;
}

class UnlockCodeRepository {
  const UnlockCodeRepository._();

  /// Returns a list of [UnlockCode]s matching the given query parameters.
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
  Future<List<UnlockCode>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UnlockCodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UnlockCodeTable>? orderBy,
    _is.OrderByListBuilder<UnlockCodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UnlockCode>(
      where: where?.call(UnlockCode.t),
      orderBy: orderBy?.call(UnlockCode.t),
      orderByList: orderByList?.call(UnlockCode.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UnlockCode] matching the given query parameters.
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
  Future<UnlockCode?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UnlockCodeTable>? where,
    int? offset,
    _is.OrderByBuilder<UnlockCodeTable>? orderBy,
    _is.OrderByListBuilder<UnlockCodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UnlockCode>(
      where: where?.call(UnlockCode.t),
      orderBy: orderBy?.call(UnlockCode.t),
      orderByList: orderByList?.call(UnlockCode.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UnlockCode] by its [id] or null if no such row exists.
  Future<UnlockCode?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UnlockCode>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UnlockCode]s in the list and returns the inserted rows.
  ///
  /// The returned [UnlockCode]s will have their `id` fields set.
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
  Future<List<UnlockCode>> insert(
    _is.DatabaseSession session,
    List<UnlockCode> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UnlockCode>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UnlockCode] and returns the inserted row.
  ///
  /// The returned [UnlockCode] will have its `id` field set.
  Future<UnlockCode> insertRow(
    _is.DatabaseSession session,
    UnlockCode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UnlockCode>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UnlockCode]s in the list and returns the resulting rows.
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
  /// The returned [UnlockCode]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UnlockCode>> upsert(
    _is.DatabaseSession session,
    List<UnlockCode> rows, {
    required _is.ColumnSelections<UnlockCodeTable> conflictColumns,
    _is.ColumnSelections<UnlockCodeTable>? updateColumns,
    _is.WhereExpressionBuilder<UnlockCodeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UnlockCode>(
      rows,
      conflictColumns: conflictColumns(UnlockCode.t),
      updateColumns: updateColumns?.call(UnlockCode.t),
      updateWhere: updateWhere?.call(UnlockCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UnlockCode] and returns the resulting row.
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
  /// The returned [UnlockCode] will have its `id` field set.
  Future<UnlockCode?> upsertRow(
    _is.DatabaseSession session,
    UnlockCode row, {
    required _is.ColumnSelections<UnlockCodeTable> conflictColumns,
    _is.ColumnSelections<UnlockCodeTable>? updateColumns,
    _is.WhereExpressionBuilder<UnlockCodeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UnlockCode>(
      row,
      conflictColumns: conflictColumns(UnlockCode.t),
      updateColumns: updateColumns?.call(UnlockCode.t),
      updateWhere: updateWhere?.call(UnlockCode.t),
      transaction: transaction,
    );
  }

  /// Updates all [UnlockCode]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UnlockCode>> update(
    _is.DatabaseSession session,
    List<UnlockCode> rows, {
    _is.ColumnSelections<UnlockCodeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UnlockCode>(
      rows,
      columns: columns?.call(UnlockCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UnlockCode]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UnlockCode> updateRow(
    _is.DatabaseSession session,
    UnlockCode row, {
    _is.ColumnSelections<UnlockCodeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UnlockCode>(
      row,
      columns: columns?.call(UnlockCode.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UnlockCode] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UnlockCode?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UnlockCodeUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UnlockCode>(
      id,
      columnValues: columnValues(UnlockCode.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UnlockCode]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UnlockCode>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UnlockCodeUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UnlockCodeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UnlockCodeTable>? orderBy,
    _is.OrderByListBuilder<UnlockCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UnlockCode>(
      columnValues: columnValues(UnlockCode.t.updateTable),
      where: where(UnlockCode.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UnlockCode.t),
      orderByList: orderByList?.call(UnlockCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UnlockCode]s in the list and returns the deleted rows.
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
  Future<List<UnlockCode>> delete(
    _is.DatabaseSession session,
    List<UnlockCode> rows, {
    _is.OrderByBuilder<UnlockCodeTable>? orderBy,
    _is.OrderByListBuilder<UnlockCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UnlockCode>(
      rows,
      orderBy: orderBy?.call(UnlockCode.t),
      orderByList: orderByList?.call(UnlockCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UnlockCode].
  Future<UnlockCode> deleteRow(
    _is.DatabaseSession session,
    UnlockCode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UnlockCode>(
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
  Future<List<UnlockCode>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UnlockCodeTable> where,
    _is.OrderByBuilder<UnlockCodeTable>? orderBy,
    _is.OrderByListBuilder<UnlockCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UnlockCode>(
      where: where(UnlockCode.t),
      orderBy: orderBy?.call(UnlockCode.t),
      orderByList: orderByList?.call(UnlockCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UnlockCodeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UnlockCode>(
      where: where?.call(UnlockCode.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UnlockCode] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UnlockCodeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UnlockCode>(
      where: where(UnlockCode.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
