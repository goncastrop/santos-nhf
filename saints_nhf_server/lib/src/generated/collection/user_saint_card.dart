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
import '../collection/card_source.dart' as _in4697tk;
import '../saints/saint.dart' as _iz4se2fa;

/// A saint card in a user's collection.
abstract class UserSaintCard
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserSaintCard._({
    this.id,
    required this.authUserId,
    required this.saintId,
    this.saint,
    required this.source,
    DateTime? obtainedAt,
  }) : obtainedAt = obtainedAt ?? DateTime.now();

  factory UserSaintCard({
    int? id,
    required _is.UuidValue authUserId,
    required int saintId,
    _iz4se2fa.Saint? saint,
    required _in4697tk.CardSource source,
    DateTime? obtainedAt,
  }) = _UserSaintCardImpl;

  factory UserSaintCard.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSaintCard(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      saintId: jsonSerialization['saintId'] as int,
      saint: jsonSerialization['saint'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<_iz4se2fa.Saint>(
              jsonSerialization['saint'],
            ),
      source: _in4697tk.CardSource.fromJson(
        (jsonSerialization['source'] as String),
      ),
      obtainedAt: jsonSerialization['obtainedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['obtainedAt']),
    );
  }

  static final t = UserSaintCardTable();

  static const db = UserSaintCardRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  int saintId;

  _iz4se2fa.Saint? saint;

  _in4697tk.CardSource source;

  DateTime obtainedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserSaintCard]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserSaintCard copyWith({
    int? id,
    _is.UuidValue? authUserId,
    int? saintId,
    _iz4se2fa.Saint? saint,
    _in4697tk.CardSource? source,
    DateTime? obtainedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSaintCard',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'saintId': saintId,
      if (saint != null) 'saint': saint?.toJson(),
      'source': source.toJson(),
      'obtainedAt': obtainedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserSaintCard',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'saintId': saintId,
      if (saint != null) 'saint': saint?.toJsonForProtocol(),
      'source': source.toJson(),
      'obtainedAt': obtainedAt.toJson(),
    };
  }

  static UserSaintCardInclude include({_iz4se2fa.SaintInclude? saint}) {
    return UserSaintCardInclude._(saint: saint);
  }

  static UserSaintCardIncludeList includeList({
    _is.WhereExpressionBuilder<UserSaintCardTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserSaintCardTable>? orderBy,
    _is.OrderByListBuilder<UserSaintCardTable>? orderByList,
    UserSaintCardInclude? include,
  }) {
    return UserSaintCardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserSaintCard.t),
      orderByList: orderByList?.call(UserSaintCard.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserSaintCardImpl extends UserSaintCard {
  _UserSaintCardImpl({
    int? id,
    required _is.UuidValue authUserId,
    required int saintId,
    _iz4se2fa.Saint? saint,
    required _in4697tk.CardSource source,
    DateTime? obtainedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         saintId: saintId,
         saint: saint,
         source: source,
         obtainedAt: obtainedAt,
       );

  /// Returns a shallow copy of this [UserSaintCard]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserSaintCard copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    int? saintId,
    Object? saint = _Undefined,
    _in4697tk.CardSource? source,
    DateTime? obtainedAt,
  }) {
    return UserSaintCard(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      saintId: saintId ?? this.saintId,
      saint: saint is _iz4se2fa.Saint? ? saint : this.saint?.copyWith(),
      source: source ?? this.source,
      obtainedAt: obtainedAt ?? this.obtainedAt,
    );
  }
}

class UserSaintCardUpdateTable extends _is.UpdateTable<UserSaintCardTable> {
  UserSaintCardUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<int, int> saintId(int value) => _is.ColumnValue(
    table.saintId,
    value,
  );

  _is.ColumnValue<_in4697tk.CardSource, _in4697tk.CardSource> source(
    _in4697tk.CardSource value,
  ) => _is.ColumnValue(
    table.source,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> obtainedAt(DateTime value) =>
      _is.ColumnValue(
        table.obtainedAt,
        value,
      );
}

class UserSaintCardTable extends _is.Table<int?> {
  UserSaintCardTable({super.tableRelation})
    : super(tableName: 'user_saint_card') {
    updateTable = UserSaintCardUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    saintId = _is.ColumnInt(
      'saintId',
      this,
    );
    source = _is.ColumnEnum(
      'source',
      this,
      _is.EnumSerialization.byName,
    );
    obtainedAt = _is.ColumnDateTime(
      'obtainedAt',
      this,
      hasDefault: true,
    );
  }

  late final UserSaintCardUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnInt saintId;

  _iz4se2fa.SaintTable? _saint;

  late final _is.ColumnEnum<_in4697tk.CardSource> source;

  late final _is.ColumnDateTime obtainedAt;

  _iz4se2fa.SaintTable get saint {
    if (_saint != null) return _saint!;
    _saint = _is.createRelationTable(
      relationFieldName: 'saint',
      field: UserSaintCard.t.saintId,
      foreignField: _iz4se2fa.Saint.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iz4se2fa.SaintTable(tableRelation: foreignTableRelation),
    );
    return _saint!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    saintId,
    source,
    obtainedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'saint') {
      return saint;
    }
    return null;
  }
}

class UserSaintCardInclude extends _is.IncludeObject {
  UserSaintCardInclude._({_iz4se2fa.SaintInclude? saint}) {
    _saint = saint;
  }

  _iz4se2fa.SaintInclude? _saint;

  @override
  Map<String, _is.Include?> get includes => {'saint': _saint};

  @override
  _is.Table<int?> get table => UserSaintCard.t;
}

class UserSaintCardIncludeList extends _is.IncludeList {
  UserSaintCardIncludeList._({
    _is.WhereExpressionBuilder<UserSaintCardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserSaintCard.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserSaintCard.t;
}

class UserSaintCardRepository {
  const UserSaintCardRepository._();

  final attachRow = const UserSaintCardAttachRowRepository._();

  /// Returns a list of [UserSaintCard]s matching the given query parameters.
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
  Future<List<UserSaintCard>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserSaintCardTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserSaintCardTable>? orderBy,
    _is.OrderByListBuilder<UserSaintCardTable>? orderByList,
    _is.Transaction? transaction,
    UserSaintCardInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserSaintCard>(
      where: where?.call(UserSaintCard.t),
      orderBy: orderBy?.call(UserSaintCard.t),
      orderByList: orderByList?.call(UserSaintCard.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserSaintCard] matching the given query parameters.
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
  Future<UserSaintCard?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserSaintCardTable>? where,
    int? offset,
    _is.OrderByBuilder<UserSaintCardTable>? orderBy,
    _is.OrderByListBuilder<UserSaintCardTable>? orderByList,
    _is.Transaction? transaction,
    UserSaintCardInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserSaintCard>(
      where: where?.call(UserSaintCard.t),
      orderBy: orderBy?.call(UserSaintCard.t),
      orderByList: orderByList?.call(UserSaintCard.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserSaintCard] by its [id] or null if no such row exists.
  Future<UserSaintCard?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    UserSaintCardInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserSaintCard>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserSaintCard]s in the list and returns the inserted rows.
  ///
  /// The returned [UserSaintCard]s will have their `id` fields set.
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
  Future<List<UserSaintCard>> insert(
    _is.DatabaseSession session,
    List<UserSaintCard> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserSaintCard>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserSaintCard] and returns the inserted row.
  ///
  /// The returned [UserSaintCard] will have its `id` field set.
  Future<UserSaintCard> insertRow(
    _is.DatabaseSession session,
    UserSaintCard row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserSaintCard>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserSaintCard]s in the list and returns the resulting rows.
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
  /// The returned [UserSaintCard]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserSaintCard>> upsert(
    _is.DatabaseSession session,
    List<UserSaintCard> rows, {
    required _is.ColumnSelections<UserSaintCardTable> conflictColumns,
    _is.ColumnSelections<UserSaintCardTable>? updateColumns,
    _is.WhereExpressionBuilder<UserSaintCardTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserSaintCard>(
      rows,
      conflictColumns: conflictColumns(UserSaintCard.t),
      updateColumns: updateColumns?.call(UserSaintCard.t),
      updateWhere: updateWhere?.call(UserSaintCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserSaintCard] and returns the resulting row.
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
  /// The returned [UserSaintCard] will have its `id` field set.
  Future<UserSaintCard?> upsertRow(
    _is.DatabaseSession session,
    UserSaintCard row, {
    required _is.ColumnSelections<UserSaintCardTable> conflictColumns,
    _is.ColumnSelections<UserSaintCardTable>? updateColumns,
    _is.WhereExpressionBuilder<UserSaintCardTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserSaintCard>(
      row,
      conflictColumns: conflictColumns(UserSaintCard.t),
      updateColumns: updateColumns?.call(UserSaintCard.t),
      updateWhere: updateWhere?.call(UserSaintCard.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserSaintCard]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserSaintCard>> update(
    _is.DatabaseSession session,
    List<UserSaintCard> rows, {
    _is.ColumnSelections<UserSaintCardTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserSaintCard>(
      rows,
      columns: columns?.call(UserSaintCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserSaintCard]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserSaintCard> updateRow(
    _is.DatabaseSession session,
    UserSaintCard row, {
    _is.ColumnSelections<UserSaintCardTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserSaintCard>(
      row,
      columns: columns?.call(UserSaintCard.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserSaintCard] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserSaintCard?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserSaintCardUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserSaintCard>(
      id,
      columnValues: columnValues(UserSaintCard.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserSaintCard]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserSaintCard>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserSaintCardUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserSaintCardTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserSaintCardTable>? orderBy,
    _is.OrderByListBuilder<UserSaintCardTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserSaintCard>(
      columnValues: columnValues(UserSaintCard.t.updateTable),
      where: where(UserSaintCard.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserSaintCard.t),
      orderByList: orderByList?.call(UserSaintCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserSaintCard]s in the list and returns the deleted rows.
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
  Future<List<UserSaintCard>> delete(
    _is.DatabaseSession session,
    List<UserSaintCard> rows, {
    _is.OrderByBuilder<UserSaintCardTable>? orderBy,
    _is.OrderByListBuilder<UserSaintCardTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserSaintCard>(
      rows,
      orderBy: orderBy?.call(UserSaintCard.t),
      orderByList: orderByList?.call(UserSaintCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserSaintCard].
  Future<UserSaintCard> deleteRow(
    _is.DatabaseSession session,
    UserSaintCard row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserSaintCard>(
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
  Future<List<UserSaintCard>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserSaintCardTable> where,
    _is.OrderByBuilder<UserSaintCardTable>? orderBy,
    _is.OrderByListBuilder<UserSaintCardTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserSaintCard>(
      where: where(UserSaintCard.t),
      orderBy: orderBy?.call(UserSaintCard.t),
      orderByList: orderByList?.call(UserSaintCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserSaintCardTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserSaintCard>(
      where: where?.call(UserSaintCard.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserSaintCard] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserSaintCardTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserSaintCard>(
      where: where(UserSaintCard.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class UserSaintCardAttachRowRepository {
  const UserSaintCardAttachRowRepository._();

  /// Creates a relation between the given [UserSaintCard] and [Saint]
  /// by setting the [UserSaintCard]'s foreign key `saintId` to refer to the [Saint].
  Future<void> saint(
    _is.DatabaseSession session,
    UserSaintCard userSaintCard,
    _iz4se2fa.Saint saint, {
    _is.Transaction? transaction,
  }) async {
    if (userSaintCard.id == null) {
      throw ArgumentError.notNull('userSaintCard.id');
    }
    if (saint.id == null) {
      throw ArgumentError.notNull('saint.id');
    }

    var $userSaintCard = userSaintCard.copyWith(saintId: saint.id);
    await session.db.updateRow<UserSaintCard>(
      $userSaintCard,
      columns: [UserSaintCard.t.saintId],
      transaction: transaction,
    );
  }
}
