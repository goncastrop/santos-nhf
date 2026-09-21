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
import '../books/book_kind.dart' as _idzj8z5t;

/// A book recommended on a saint's page: either one they wrote or one written
/// about them. Public, like the rest of the saint's content.
abstract class SaintBook
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SaintBook._({
    this.id,
    required this.saintId,
    required this.title,
    this.author,
    required this.kind,
    this.year,
    this.publisher,
    this.note,
    this.url,
    int? position,
    DateTime? createdAt,
  }) : position = position ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory SaintBook({
    int? id,
    required int saintId,
    required String title,
    String? author,
    required _idzj8z5t.BookKind kind,
    int? year,
    String? publisher,
    String? note,
    String? url,
    int? position,
    DateTime? createdAt,
  }) = _SaintBookImpl;

  factory SaintBook.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaintBook(
      id: jsonSerialization['id'] as int?,
      saintId: jsonSerialization['saintId'] as int,
      title: jsonSerialization['title'] as String,
      author: jsonSerialization['author'] as String?,
      kind: _idzj8z5t.BookKind.fromJson((jsonSerialization['kind'] as String)),
      year: jsonSerialization['year'] as int?,
      publisher: jsonSerialization['publisher'] as String?,
      note: jsonSerialization['note'] as String?,
      url: jsonSerialization['url'] as String?,
      position: jsonSerialization['position'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = SaintBookTable();

  static const db = SaintBookRepository._();

  @override
  int? id;

  int saintId;

  String title;

  /// Author, e.g. "Marcelle Auclair". Empty for the saint's own works.
  String? author;

  _idzj8z5t.BookKind kind;

  /// Year of writing or of the edition recommended.
  int? year;

  String? publisher;

  /// Why it is worth reading, one or two sentences.
  String? note;

  /// Where to read or get it.
  String? url;

  /// Order within its group, lowest first.
  int position;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SaintBook]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SaintBook copyWith({
    int? id,
    int? saintId,
    String? title,
    String? author,
    _idzj8z5t.BookKind? kind,
    int? year,
    String? publisher,
    String? note,
    String? url,
    int? position,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaintBook',
      if (id != null) 'id': id,
      'saintId': saintId,
      'title': title,
      if (author != null) 'author': author,
      'kind': kind.toJson(),
      if (year != null) 'year': year,
      if (publisher != null) 'publisher': publisher,
      if (note != null) 'note': note,
      if (url != null) 'url': url,
      'position': position,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaintBook',
      if (id != null) 'id': id,
      'saintId': saintId,
      'title': title,
      if (author != null) 'author': author,
      'kind': kind.toJson(),
      if (year != null) 'year': year,
      if (publisher != null) 'publisher': publisher,
      if (note != null) 'note': note,
      if (url != null) 'url': url,
      'position': position,
      'createdAt': createdAt.toJson(),
    };
  }

  static SaintBookInclude include() {
    return SaintBookInclude._();
  }

  static SaintBookIncludeList includeList({
    _is.WhereExpressionBuilder<SaintBookTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintBookTable>? orderBy,
    _is.OrderByListBuilder<SaintBookTable>? orderByList,
    SaintBookInclude? include,
  }) {
    return SaintBookIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SaintBook.t),
      orderByList: orderByList?.call(SaintBook.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SaintBookImpl extends SaintBook {
  _SaintBookImpl({
    int? id,
    required int saintId,
    required String title,
    String? author,
    required _idzj8z5t.BookKind kind,
    int? year,
    String? publisher,
    String? note,
    String? url,
    int? position,
    DateTime? createdAt,
  }) : super._(
         id: id,
         saintId: saintId,
         title: title,
         author: author,
         kind: kind,
         year: year,
         publisher: publisher,
         note: note,
         url: url,
         position: position,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SaintBook]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SaintBook copyWith({
    Object? id = _Undefined,
    int? saintId,
    String? title,
    Object? author = _Undefined,
    _idzj8z5t.BookKind? kind,
    Object? year = _Undefined,
    Object? publisher = _Undefined,
    Object? note = _Undefined,
    Object? url = _Undefined,
    int? position,
    DateTime? createdAt,
  }) {
    return SaintBook(
      id: id is int? ? id : this.id,
      saintId: saintId ?? this.saintId,
      title: title ?? this.title,
      author: author is String? ? author : this.author,
      kind: kind ?? this.kind,
      year: year is int? ? year : this.year,
      publisher: publisher is String? ? publisher : this.publisher,
      note: note is String? ? note : this.note,
      url: url is String? ? url : this.url,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SaintBookUpdateTable extends _is.UpdateTable<SaintBookTable> {
  SaintBookUpdateTable(super.table);

  _is.ColumnValue<int, int> saintId(int value) => _is.ColumnValue(
    table.saintId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> author(String? value) => _is.ColumnValue(
    table.author,
    value,
  );

  _is.ColumnValue<_idzj8z5t.BookKind, _idzj8z5t.BookKind> kind(
    _idzj8z5t.BookKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<int, int> year(int? value) => _is.ColumnValue(
    table.year,
    value,
  );

  _is.ColumnValue<String, String> publisher(String? value) => _is.ColumnValue(
    table.publisher,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<String, String> url(String? value) => _is.ColumnValue(
    table.url,
    value,
  );

  _is.ColumnValue<int, int> position(int value) => _is.ColumnValue(
    table.position,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SaintBookTable extends _is.Table<int?> {
  SaintBookTable({super.tableRelation}) : super(tableName: 'saint_book') {
    updateTable = SaintBookUpdateTable(this);
    saintId = _is.ColumnInt(
      'saintId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    author = _is.ColumnString(
      'author',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    year = _is.ColumnInt(
      'year',
      this,
    );
    publisher = _is.ColumnString(
      'publisher',
      this,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    url = _is.ColumnString(
      'url',
      this,
    );
    position = _is.ColumnInt(
      'position',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final SaintBookUpdateTable updateTable;

  late final _is.ColumnInt saintId;

  late final _is.ColumnString title;

  /// Author, e.g. "Marcelle Auclair". Empty for the saint's own works.
  late final _is.ColumnString author;

  late final _is.ColumnEnum<_idzj8z5t.BookKind> kind;

  /// Year of writing or of the edition recommended.
  late final _is.ColumnInt year;

  late final _is.ColumnString publisher;

  /// Why it is worth reading, one or two sentences.
  late final _is.ColumnString note;

  /// Where to read or get it.
  late final _is.ColumnString url;

  /// Order within its group, lowest first.
  late final _is.ColumnInt position;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    saintId,
    title,
    author,
    kind,
    year,
    publisher,
    note,
    url,
    position,
    createdAt,
  ];
}

class SaintBookInclude extends _is.IncludeObject {
  SaintBookInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SaintBook.t;
}

class SaintBookIncludeList extends _is.IncludeList {
  SaintBookIncludeList._({
    _is.WhereExpressionBuilder<SaintBookTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SaintBook.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SaintBook.t;
}

class SaintBookRepository {
  const SaintBookRepository._();

  /// Returns a list of [SaintBook]s matching the given query parameters.
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
  Future<List<SaintBook>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintBookTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintBookTable>? orderBy,
    _is.OrderByListBuilder<SaintBookTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SaintBook>(
      where: where?.call(SaintBook.t),
      orderBy: orderBy?.call(SaintBook.t),
      orderByList: orderByList?.call(SaintBook.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SaintBook] matching the given query parameters.
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
  Future<SaintBook?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintBookTable>? where,
    int? offset,
    _is.OrderByBuilder<SaintBookTable>? orderBy,
    _is.OrderByListBuilder<SaintBookTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SaintBook>(
      where: where?.call(SaintBook.t),
      orderBy: orderBy?.call(SaintBook.t),
      orderByList: orderByList?.call(SaintBook.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SaintBook] by its [id] or null if no such row exists.
  Future<SaintBook?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SaintBook>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SaintBook]s in the list and returns the inserted rows.
  ///
  /// The returned [SaintBook]s will have their `id` fields set.
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
  Future<List<SaintBook>> insert(
    _is.DatabaseSession session,
    List<SaintBook> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SaintBook>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SaintBook] and returns the inserted row.
  ///
  /// The returned [SaintBook] will have its `id` field set.
  Future<SaintBook> insertRow(
    _is.DatabaseSession session,
    SaintBook row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SaintBook>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SaintBook]s in the list and returns the resulting rows.
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
  /// The returned [SaintBook]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SaintBook>> upsert(
    _is.DatabaseSession session,
    List<SaintBook> rows, {
    required _is.ColumnSelections<SaintBookTable> conflictColumns,
    _is.ColumnSelections<SaintBookTable>? updateColumns,
    _is.WhereExpressionBuilder<SaintBookTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SaintBook>(
      rows,
      conflictColumns: conflictColumns(SaintBook.t),
      updateColumns: updateColumns?.call(SaintBook.t),
      updateWhere: updateWhere?.call(SaintBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SaintBook] and returns the resulting row.
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
  /// The returned [SaintBook] will have its `id` field set.
  Future<SaintBook?> upsertRow(
    _is.DatabaseSession session,
    SaintBook row, {
    required _is.ColumnSelections<SaintBookTable> conflictColumns,
    _is.ColumnSelections<SaintBookTable>? updateColumns,
    _is.WhereExpressionBuilder<SaintBookTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SaintBook>(
      row,
      conflictColumns: conflictColumns(SaintBook.t),
      updateColumns: updateColumns?.call(SaintBook.t),
      updateWhere: updateWhere?.call(SaintBook.t),
      transaction: transaction,
    );
  }

  /// Updates all [SaintBook]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SaintBook>> update(
    _is.DatabaseSession session,
    List<SaintBook> rows, {
    _is.ColumnSelections<SaintBookTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SaintBook>(
      rows,
      columns: columns?.call(SaintBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SaintBook]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SaintBook> updateRow(
    _is.DatabaseSession session,
    SaintBook row, {
    _is.ColumnSelections<SaintBookTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SaintBook>(
      row,
      columns: columns?.call(SaintBook.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SaintBook] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SaintBook?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SaintBookUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SaintBook>(
      id,
      columnValues: columnValues(SaintBook.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SaintBook]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SaintBook>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SaintBookUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SaintBookTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintBookTable>? orderBy,
    _is.OrderByListBuilder<SaintBookTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SaintBook>(
      columnValues: columnValues(SaintBook.t.updateTable),
      where: where(SaintBook.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SaintBook.t),
      orderByList: orderByList?.call(SaintBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SaintBook]s in the list and returns the deleted rows.
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
  Future<List<SaintBook>> delete(
    _is.DatabaseSession session,
    List<SaintBook> rows, {
    _is.OrderByBuilder<SaintBookTable>? orderBy,
    _is.OrderByListBuilder<SaintBookTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SaintBook>(
      rows,
      orderBy: orderBy?.call(SaintBook.t),
      orderByList: orderByList?.call(SaintBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SaintBook].
  Future<SaintBook> deleteRow(
    _is.DatabaseSession session,
    SaintBook row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SaintBook>(
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
  Future<List<SaintBook>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SaintBookTable> where,
    _is.OrderByBuilder<SaintBookTable>? orderBy,
    _is.OrderByListBuilder<SaintBookTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SaintBook>(
      where: where(SaintBook.t),
      orderBy: orderBy?.call(SaintBook.t),
      orderByList: orderByList?.call(SaintBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintBookTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SaintBook>(
      where: where?.call(SaintBook.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SaintBook] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SaintBookTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SaintBook>(
      where: where(SaintBook.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
