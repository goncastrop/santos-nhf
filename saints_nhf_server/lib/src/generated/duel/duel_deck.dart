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

/// The five cards a player brings to a duel.
abstract class DuelDeck
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DuelDeck._({
    this.id,
    required this.duelId,
    required this.playerId,
    required this.saintIds,
    required this.usedSaintIds,
  });

  factory DuelDeck({
    int? id,
    required int duelId,
    required _is.UuidValue playerId,
    required List<int> saintIds,
    required List<int> usedSaintIds,
  }) = _DuelDeckImpl;

  factory DuelDeck.fromJson(Map<String, dynamic> jsonSerialization) {
    return DuelDeck(
      id: jsonSerialization['id'] as int?,
      duelId: jsonSerialization['duelId'] as int,
      playerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['playerId'],
      ),
      saintIds: _itw3ru38.Protocol().deserialize<List<int>>(
        jsonSerialization['saintIds'],
      ),
      usedSaintIds: _itw3ru38.Protocol().deserialize<List<int>>(
        jsonSerialization['usedSaintIds'],
      ),
    );
  }

  static final t = DuelDeckTable();

  static const db = DuelDeckRepository._();

  @override
  int? id;

  int duelId;

  _is.UuidValue playerId;

  List<int> saintIds;

  List<int> usedSaintIds;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DuelDeck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DuelDeck copyWith({
    int? id,
    int? duelId,
    _is.UuidValue? playerId,
    List<int>? saintIds,
    List<int>? usedSaintIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuelDeck',
      if (id != null) 'id': id,
      'duelId': duelId,
      'playerId': playerId.toJson(),
      'saintIds': saintIds.toJson(),
      'usedSaintIds': usedSaintIds.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DuelDeck',
      if (id != null) 'id': id,
      'duelId': duelId,
      'playerId': playerId.toJson(),
      'saintIds': saintIds.toJson(),
      'usedSaintIds': usedSaintIds.toJson(),
    };
  }

  static DuelDeckInclude include() {
    return DuelDeckInclude._();
  }

  static DuelDeckIncludeList includeList({
    _is.WhereExpressionBuilder<DuelDeckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelDeckTable>? orderBy,
    _is.OrderByListBuilder<DuelDeckTable>? orderByList,
    DuelDeckInclude? include,
  }) {
    return DuelDeckIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DuelDeck.t),
      orderByList: orderByList?.call(DuelDeck.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelDeckImpl extends DuelDeck {
  _DuelDeckImpl({
    int? id,
    required int duelId,
    required _is.UuidValue playerId,
    required List<int> saintIds,
    required List<int> usedSaintIds,
  }) : super._(
         id: id,
         duelId: duelId,
         playerId: playerId,
         saintIds: saintIds,
         usedSaintIds: usedSaintIds,
       );

  /// Returns a shallow copy of this [DuelDeck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DuelDeck copyWith({
    Object? id = _Undefined,
    int? duelId,
    _is.UuidValue? playerId,
    List<int>? saintIds,
    List<int>? usedSaintIds,
  }) {
    return DuelDeck(
      id: id is int? ? id : this.id,
      duelId: duelId ?? this.duelId,
      playerId: playerId ?? this.playerId,
      saintIds: saintIds ?? this.saintIds.map((e0) => e0).toList(),
      usedSaintIds: usedSaintIds ?? this.usedSaintIds.map((e0) => e0).toList(),
    );
  }
}

class DuelDeckUpdateTable extends _is.UpdateTable<DuelDeckTable> {
  DuelDeckUpdateTable(super.table);

  _is.ColumnValue<int, int> duelId(int value) => _is.ColumnValue(
    table.duelId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> playerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.playerId,
        value,
      );

  _is.ColumnValue<List<int>, List<int>> saintIds(List<int> value) =>
      _is.ColumnValue(
        table.saintIds,
        value,
      );

  _is.ColumnValue<List<int>, List<int>> usedSaintIds(List<int> value) =>
      _is.ColumnValue(
        table.usedSaintIds,
        value,
      );
}

class DuelDeckTable extends _is.Table<int?> {
  DuelDeckTable({super.tableRelation}) : super(tableName: 'duel_deck') {
    updateTable = DuelDeckUpdateTable(this);
    duelId = _is.ColumnInt(
      'duelId',
      this,
    );
    playerId = _is.ColumnUuid(
      'playerId',
      this,
    );
    saintIds = _is.ColumnSerializable<List<int>>(
      'saintIds',
      this,
    );
    usedSaintIds = _is.ColumnSerializable<List<int>>(
      'usedSaintIds',
      this,
    );
  }

  late final DuelDeckUpdateTable updateTable;

  late final _is.ColumnInt duelId;

  late final _is.ColumnUuid playerId;

  late final _is.ColumnSerializable<List<int>> saintIds;

  late final _is.ColumnSerializable<List<int>> usedSaintIds;

  @override
  List<_is.Column> get columns => [
    id,
    duelId,
    playerId,
    saintIds,
    usedSaintIds,
  ];
}

class DuelDeckInclude extends _is.IncludeObject {
  DuelDeckInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DuelDeck.t;
}

class DuelDeckIncludeList extends _is.IncludeList {
  DuelDeckIncludeList._({
    _is.WhereExpressionBuilder<DuelDeckTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DuelDeck.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DuelDeck.t;
}

class DuelDeckRepository {
  const DuelDeckRepository._();

  /// Returns a list of [DuelDeck]s matching the given query parameters.
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
  Future<List<DuelDeck>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelDeckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelDeckTable>? orderBy,
    _is.OrderByListBuilder<DuelDeckTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DuelDeck>(
      where: where?.call(DuelDeck.t),
      orderBy: orderBy?.call(DuelDeck.t),
      orderByList: orderByList?.call(DuelDeck.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DuelDeck] matching the given query parameters.
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
  Future<DuelDeck?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelDeckTable>? where,
    int? offset,
    _is.OrderByBuilder<DuelDeckTable>? orderBy,
    _is.OrderByListBuilder<DuelDeckTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DuelDeck>(
      where: where?.call(DuelDeck.t),
      orderBy: orderBy?.call(DuelDeck.t),
      orderByList: orderByList?.call(DuelDeck.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DuelDeck] by its [id] or null if no such row exists.
  Future<DuelDeck?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DuelDeck>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DuelDeck]s in the list and returns the inserted rows.
  ///
  /// The returned [DuelDeck]s will have their `id` fields set.
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
  Future<List<DuelDeck>> insert(
    _is.DatabaseSession session,
    List<DuelDeck> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DuelDeck>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DuelDeck] and returns the inserted row.
  ///
  /// The returned [DuelDeck] will have its `id` field set.
  Future<DuelDeck> insertRow(
    _is.DatabaseSession session,
    DuelDeck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DuelDeck>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DuelDeck]s in the list and returns the resulting rows.
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
  /// The returned [DuelDeck]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DuelDeck>> upsert(
    _is.DatabaseSession session,
    List<DuelDeck> rows, {
    required _is.ColumnSelections<DuelDeckTable> conflictColumns,
    _is.ColumnSelections<DuelDeckTable>? updateColumns,
    _is.WhereExpressionBuilder<DuelDeckTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DuelDeck>(
      rows,
      conflictColumns: conflictColumns(DuelDeck.t),
      updateColumns: updateColumns?.call(DuelDeck.t),
      updateWhere: updateWhere?.call(DuelDeck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DuelDeck] and returns the resulting row.
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
  /// The returned [DuelDeck] will have its `id` field set.
  Future<DuelDeck?> upsertRow(
    _is.DatabaseSession session,
    DuelDeck row, {
    required _is.ColumnSelections<DuelDeckTable> conflictColumns,
    _is.ColumnSelections<DuelDeckTable>? updateColumns,
    _is.WhereExpressionBuilder<DuelDeckTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DuelDeck>(
      row,
      conflictColumns: conflictColumns(DuelDeck.t),
      updateColumns: updateColumns?.call(DuelDeck.t),
      updateWhere: updateWhere?.call(DuelDeck.t),
      transaction: transaction,
    );
  }

  /// Updates all [DuelDeck]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DuelDeck>> update(
    _is.DatabaseSession session,
    List<DuelDeck> rows, {
    _is.ColumnSelections<DuelDeckTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DuelDeck>(
      rows,
      columns: columns?.call(DuelDeck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DuelDeck]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DuelDeck> updateRow(
    _is.DatabaseSession session,
    DuelDeck row, {
    _is.ColumnSelections<DuelDeckTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DuelDeck>(
      row,
      columns: columns?.call(DuelDeck.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DuelDeck] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DuelDeck?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DuelDeckUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DuelDeck>(
      id,
      columnValues: columnValues(DuelDeck.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DuelDeck]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DuelDeck>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DuelDeckUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DuelDeckTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelDeckTable>? orderBy,
    _is.OrderByListBuilder<DuelDeckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DuelDeck>(
      columnValues: columnValues(DuelDeck.t.updateTable),
      where: where(DuelDeck.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DuelDeck.t),
      orderByList: orderByList?.call(DuelDeck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DuelDeck]s in the list and returns the deleted rows.
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
  Future<List<DuelDeck>> delete(
    _is.DatabaseSession session,
    List<DuelDeck> rows, {
    _is.OrderByBuilder<DuelDeckTable>? orderBy,
    _is.OrderByListBuilder<DuelDeckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DuelDeck>(
      rows,
      orderBy: orderBy?.call(DuelDeck.t),
      orderByList: orderByList?.call(DuelDeck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DuelDeck].
  Future<DuelDeck> deleteRow(
    _is.DatabaseSession session,
    DuelDeck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DuelDeck>(
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
  Future<List<DuelDeck>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DuelDeckTable> where,
    _is.OrderByBuilder<DuelDeckTable>? orderBy,
    _is.OrderByListBuilder<DuelDeckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DuelDeck>(
      where: where(DuelDeck.t),
      orderBy: orderBy?.call(DuelDeck.t),
      orderByList: orderByList?.call(DuelDeck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelDeckTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DuelDeck>(
      where: where?.call(DuelDeck.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DuelDeck] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DuelDeckTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DuelDeck>(
      where: where(DuelDeck.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
