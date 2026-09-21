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
import '../duel/duel_status.dart' as _i6u3xm2k;

/// A duel between two players (or a player and the machine).
abstract class Duel implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Duel._({
    this.id,
    required this.challengerId,
    required this.opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    this.attackerId,
    this.turnOf,
    int? challengerScore,
    int? opponentScore,
    this.winnerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.finishedAt,
  }) : isVsMachine = isVsMachine ?? false,
       status = status ?? _i6u3xm2k.DuelStatus.pendingDeck,
       roundNumber = roundNumber ?? 1,
       challengerScore = challengerScore ?? 0,
       opponentScore = opponentScore ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Duel({
    int? id,
    required _is.UuidValue challengerId,
    required _is.UuidValue opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    _is.UuidValue? attackerId,
    _is.UuidValue? turnOf,
    int? challengerScore,
    int? opponentScore,
    _is.UuidValue? winnerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? finishedAt,
  }) = _DuelImpl;

  factory Duel.fromJson(Map<String, dynamic> jsonSerialization) {
    return Duel(
      id: jsonSerialization['id'] as int?,
      challengerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengerId'],
      ),
      opponentId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['opponentId'],
      ),
      isVsMachine: jsonSerialization['isVsMachine'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isVsMachine']),
      status: jsonSerialization['status'] == null
          ? null
          : _i6u3xm2k.DuelStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      roundNumber: jsonSerialization['roundNumber'] as int?,
      attackerId: jsonSerialization['attackerId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['attackerId'],
            ),
      turnOf: jsonSerialization['turnOf'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['turnOf']),
      challengerScore: jsonSerialization['challengerScore'] as int?,
      opponentScore: jsonSerialization['opponentScore'] as int?,
      winnerId: jsonSerialization['winnerId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['winnerId']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
    );
  }

  static final t = DuelTable();

  static const db = DuelRepository._();

  @override
  int? id;

  _is.UuidValue challengerId;

  _is.UuidValue opponentId;

  bool isVsMachine;

  _i6u3xm2k.DuelStatus status;

  int roundNumber;

  /// Attacker of the current round.
  _is.UuidValue? attackerId;

  /// Player who has to act now. Null when finished.
  _is.UuidValue? turnOf;

  int challengerScore;

  int opponentScore;

  /// Null while unfinished, and on a draw.
  _is.UuidValue? winnerId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? finishedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Duel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Duel copyWith({
    int? id,
    _is.UuidValue? challengerId,
    _is.UuidValue? opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    _is.UuidValue? attackerId,
    _is.UuidValue? turnOf,
    int? challengerScore,
    int? opponentScore,
    _is.UuidValue? winnerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? finishedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Duel',
      if (id != null) 'id': id,
      'challengerId': challengerId.toJson(),
      'opponentId': opponentId.toJson(),
      'isVsMachine': isVsMachine,
      'status': status.toJson(),
      'roundNumber': roundNumber,
      if (attackerId != null) 'attackerId': attackerId?.toJson(),
      if (turnOf != null) 'turnOf': turnOf?.toJson(),
      'challengerScore': challengerScore,
      'opponentScore': opponentScore,
      if (winnerId != null) 'winnerId': winnerId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Duel',
      if (id != null) 'id': id,
      'challengerId': challengerId.toJson(),
      'opponentId': opponentId.toJson(),
      'isVsMachine': isVsMachine,
      'status': status.toJson(),
      'roundNumber': roundNumber,
      if (attackerId != null) 'attackerId': attackerId?.toJson(),
      if (turnOf != null) 'turnOf': turnOf?.toJson(),
      'challengerScore': challengerScore,
      'opponentScore': opponentScore,
      if (winnerId != null) 'winnerId': winnerId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  static DuelInclude include() {
    return DuelInclude._();
  }

  static DuelIncludeList includeList({
    _is.WhereExpressionBuilder<DuelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    DuelInclude? include,
  }) {
    return DuelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelImpl extends Duel {
  _DuelImpl({
    int? id,
    required _is.UuidValue challengerId,
    required _is.UuidValue opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    _is.UuidValue? attackerId,
    _is.UuidValue? turnOf,
    int? challengerScore,
    int? opponentScore,
    _is.UuidValue? winnerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? finishedAt,
  }) : super._(
         id: id,
         challengerId: challengerId,
         opponentId: opponentId,
         isVsMachine: isVsMachine,
         status: status,
         roundNumber: roundNumber,
         attackerId: attackerId,
         turnOf: turnOf,
         challengerScore: challengerScore,
         opponentScore: opponentScore,
         winnerId: winnerId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         finishedAt: finishedAt,
       );

  /// Returns a shallow copy of this [Duel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Duel copyWith({
    Object? id = _Undefined,
    _is.UuidValue? challengerId,
    _is.UuidValue? opponentId,
    bool? isVsMachine,
    _i6u3xm2k.DuelStatus? status,
    int? roundNumber,
    Object? attackerId = _Undefined,
    Object? turnOf = _Undefined,
    int? challengerScore,
    int? opponentScore,
    Object? winnerId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? finishedAt = _Undefined,
  }) {
    return Duel(
      id: id is int? ? id : this.id,
      challengerId: challengerId ?? this.challengerId,
      opponentId: opponentId ?? this.opponentId,
      isVsMachine: isVsMachine ?? this.isVsMachine,
      status: status ?? this.status,
      roundNumber: roundNumber ?? this.roundNumber,
      attackerId: attackerId is _is.UuidValue? ? attackerId : this.attackerId,
      turnOf: turnOf is _is.UuidValue? ? turnOf : this.turnOf,
      challengerScore: challengerScore ?? this.challengerScore,
      opponentScore: opponentScore ?? this.opponentScore,
      winnerId: winnerId is _is.UuidValue? ? winnerId : this.winnerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
    );
  }
}

class DuelUpdateTable extends _is.UpdateTable<DuelTable> {
  DuelUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> challengerId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.challengerId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> opponentId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.opponentId,
    value,
  );

  _is.ColumnValue<bool, bool> isVsMachine(bool value) => _is.ColumnValue(
    table.isVsMachine,
    value,
  );

  _is.ColumnValue<_i6u3xm2k.DuelStatus, _i6u3xm2k.DuelStatus> status(
    _i6u3xm2k.DuelStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> roundNumber(int value) => _is.ColumnValue(
    table.roundNumber,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> attackerId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.attackerId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> turnOf(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.turnOf,
        value,
      );

  _is.ColumnValue<int, int> challengerScore(int value) => _is.ColumnValue(
    table.challengerScore,
    value,
  );

  _is.ColumnValue<int, int> opponentScore(int value) => _is.ColumnValue(
    table.opponentScore,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> winnerId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.winnerId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.finishedAt,
        value,
      );
}

class DuelTable extends _is.Table<int?> {
  DuelTable({super.tableRelation}) : super(tableName: 'duel') {
    updateTable = DuelUpdateTable(this);
    challengerId = _is.ColumnUuid(
      'challengerId',
      this,
    );
    opponentId = _is.ColumnUuid(
      'opponentId',
      this,
    );
    isVsMachine = _is.ColumnBool(
      'isVsMachine',
      this,
      hasDefault: true,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    roundNumber = _is.ColumnInt(
      'roundNumber',
      this,
      hasDefault: true,
    );
    attackerId = _is.ColumnUuid(
      'attackerId',
      this,
    );
    turnOf = _is.ColumnUuid(
      'turnOf',
      this,
    );
    challengerScore = _is.ColumnInt(
      'challengerScore',
      this,
      hasDefault: true,
    );
    opponentScore = _is.ColumnInt(
      'opponentScore',
      this,
      hasDefault: true,
    );
    winnerId = _is.ColumnUuid(
      'winnerId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
    finishedAt = _is.ColumnDateTime(
      'finishedAt',
      this,
    );
  }

  late final DuelUpdateTable updateTable;

  late final _is.ColumnUuid challengerId;

  late final _is.ColumnUuid opponentId;

  late final _is.ColumnBool isVsMachine;

  late final _is.ColumnEnum<_i6u3xm2k.DuelStatus> status;

  late final _is.ColumnInt roundNumber;

  /// Attacker of the current round.
  late final _is.ColumnUuid attackerId;

  /// Player who has to act now. Null when finished.
  late final _is.ColumnUuid turnOf;

  late final _is.ColumnInt challengerScore;

  late final _is.ColumnInt opponentScore;

  /// Null while unfinished, and on a draw.
  late final _is.ColumnUuid winnerId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime finishedAt;

  @override
  List<_is.Column> get columns => [
    id,
    challengerId,
    opponentId,
    isVsMachine,
    status,
    roundNumber,
    attackerId,
    turnOf,
    challengerScore,
    opponentScore,
    winnerId,
    createdAt,
    updatedAt,
    finishedAt,
  ];
}

class DuelInclude extends _is.IncludeObject {
  DuelInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Duel.t;
}

class DuelIncludeList extends _is.IncludeList {
  DuelIncludeList._({
    _is.WhereExpressionBuilder<DuelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Duel.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Duel.t;
}

class DuelRepository {
  const DuelRepository._();

  /// Returns a list of [Duel]s matching the given query parameters.
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
  Future<List<Duel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Duel>(
      where: where?.call(Duel.t),
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Duel] matching the given query parameters.
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
  Future<Duel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelTable>? where,
    int? offset,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Duel>(
      where: where?.call(Duel.t),
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Duel] by its [id] or null if no such row exists.
  Future<Duel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Duel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Duel]s in the list and returns the inserted rows.
  ///
  /// The returned [Duel]s will have their `id` fields set.
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
  Future<List<Duel>> insert(
    _is.DatabaseSession session,
    List<Duel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Duel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Duel] and returns the inserted row.
  ///
  /// The returned [Duel] will have its `id` field set.
  Future<Duel> insertRow(
    _is.DatabaseSession session,
    Duel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Duel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Duel]s in the list and returns the resulting rows.
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
  /// The returned [Duel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Duel>> upsert(
    _is.DatabaseSession session,
    List<Duel> rows, {
    required _is.ColumnSelections<DuelTable> conflictColumns,
    _is.ColumnSelections<DuelTable>? updateColumns,
    _is.WhereExpressionBuilder<DuelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Duel>(
      rows,
      conflictColumns: conflictColumns(Duel.t),
      updateColumns: updateColumns?.call(Duel.t),
      updateWhere: updateWhere?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Duel] and returns the resulting row.
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
  /// The returned [Duel] will have its `id` field set.
  Future<Duel?> upsertRow(
    _is.DatabaseSession session,
    Duel row, {
    required _is.ColumnSelections<DuelTable> conflictColumns,
    _is.ColumnSelections<DuelTable>? updateColumns,
    _is.WhereExpressionBuilder<DuelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Duel>(
      row,
      conflictColumns: conflictColumns(Duel.t),
      updateColumns: updateColumns?.call(Duel.t),
      updateWhere: updateWhere?.call(Duel.t),
      transaction: transaction,
    );
  }

  /// Updates all [Duel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Duel>> update(
    _is.DatabaseSession session,
    List<Duel> rows, {
    _is.ColumnSelections<DuelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Duel>(
      rows,
      columns: columns?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Duel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Duel> updateRow(
    _is.DatabaseSession session,
    Duel row, {
    _is.ColumnSelections<DuelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Duel>(
      row,
      columns: columns?.call(Duel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Duel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Duel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DuelUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Duel>(
      id,
      columnValues: columnValues(Duel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Duel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Duel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DuelUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DuelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Duel>(
      columnValues: columnValues(Duel.t.updateTable),
      where: where(Duel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Duel]s in the list and returns the deleted rows.
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
  Future<List<Duel>> delete(
    _is.DatabaseSession session,
    List<Duel> rows, {
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Duel>(
      rows,
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Duel].
  Future<Duel> deleteRow(
    _is.DatabaseSession session,
    Duel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Duel>(
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
  Future<List<Duel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DuelTable> where,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Duel>(
      where: where(Duel.t),
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Duel>(
      where: where?.call(Duel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Duel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DuelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Duel>(
      where: where(Duel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
