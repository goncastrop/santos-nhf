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
import '../live/live_phase.dart' as _i5luu9zi;
import '../live/live_results.dart' as _ilkb7raf;
import '../saints/saint.dart' as _iz4se2fa;

/// A live trivia game, played during the show by everyone with the app open.
///
/// The questions are asked one at a time. Each one is open for
/// [questionSeconds]; a right answer is worth between 500 and 1000 points
/// depending on how fast it came, measured with the server's clock from the
/// moment the question actually opened. At the end the [fastPrizes] best
/// totals win a card, plus [rafflePrizes] drawn among the rest who scored.
///
/// There is at most one game going on at a time.
abstract class LiveGame
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  LiveGame._({
    this.id,
    required this.saintId,
    this.saint,
    required this.questionIds,
    _i5luu9zi.LivePhase? phase,
    int? currentIndex,
    this.countdownTo,
    this.openedAt,
    this.closesAt,
    int? questionSeconds,
    required this.fastPrizes,
    required this.rafflePrizes,
    this.results,
    required this.createdBy,
    DateTime? createdAt,
    this.finishedAt,
  }) : phase = phase ?? _i5luu9zi.LivePhase.countdown,
       currentIndex = currentIndex ?? 0,
       questionSeconds = questionSeconds ?? 20,
       createdAt = createdAt ?? DateTime.now();

  factory LiveGame({
    int? id,
    required int saintId,
    _iz4se2fa.Saint? saint,
    required List<int> questionIds,
    _i5luu9zi.LivePhase? phase,
    int? currentIndex,
    DateTime? countdownTo,
    DateTime? openedAt,
    DateTime? closesAt,
    int? questionSeconds,
    required int fastPrizes,
    required int rafflePrizes,
    _ilkb7raf.LiveResults? results,
    required _is.UuidValue createdBy,
    DateTime? createdAt,
    DateTime? finishedAt,
  }) = _LiveGameImpl;

  factory LiveGame.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveGame(
      id: jsonSerialization['id'] as int?,
      saintId: jsonSerialization['saintId'] as int,
      saint: jsonSerialization['saint'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<_iz4se2fa.Saint>(
              jsonSerialization['saint'],
            ),
      questionIds: _itw3ru38.Protocol().deserialize<List<int>>(
        jsonSerialization['questionIds'],
      ),
      phase: jsonSerialization['phase'] == null
          ? null
          : _i5luu9zi.LivePhase.fromJson(
              (jsonSerialization['phase'] as String),
            ),
      currentIndex: jsonSerialization['currentIndex'] as int?,
      countdownTo: jsonSerialization['countdownTo'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['countdownTo'],
            ),
      openedAt: jsonSerialization['openedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['openedAt']),
      closesAt: jsonSerialization['closesAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['closesAt']),
      questionSeconds: jsonSerialization['questionSeconds'] as int?,
      fastPrizes: jsonSerialization['fastPrizes'] as int,
      rafflePrizes: jsonSerialization['rafflePrizes'] as int,
      results: jsonSerialization['results'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<_ilkb7raf.LiveResults>(
              jsonSerialization['results'],
            ),
      createdBy: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
    );
  }

  static final t = LiveGameTable();

  static const db = LiveGameRepository._();

  @override
  int? id;

  int saintId;

  _iz4se2fa.Saint? saint;

  /// Questions in the order they are asked.
  List<int> questionIds;

  _i5luu9zi.LivePhase phase;

  /// Question being asked, or about to be: 0-based. During the countdown it
  /// is the one that opens at [countdownTo].
  int currentIndex;

  /// When the next question opens. Set while in [LivePhase.countdown].
  DateTime? countdownTo;

  /// When the current question actually opened and when it closes.
  DateTime? openedAt;

  DateTime? closesAt;

  int questionSeconds;

  int fastPrizes;

  int rafflePrizes;

  _ilkb7raf.LiveResults? results;

  _is.UuidValue createdBy;

  DateTime createdAt;

  DateTime? finishedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LiveGame]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveGame copyWith({
    int? id,
    int? saintId,
    _iz4se2fa.Saint? saint,
    List<int>? questionIds,
    _i5luu9zi.LivePhase? phase,
    int? currentIndex,
    DateTime? countdownTo,
    DateTime? openedAt,
    DateTime? closesAt,
    int? questionSeconds,
    int? fastPrizes,
    int? rafflePrizes,
    _ilkb7raf.LiveResults? results,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
    DateTime? finishedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveGame',
      if (id != null) 'id': id,
      'saintId': saintId,
      if (saint != null) 'saint': saint?.toJson(),
      'questionIds': questionIds.toJson(),
      'phase': phase.toJson(),
      'currentIndex': currentIndex,
      if (countdownTo != null) 'countdownTo': countdownTo?.toJson(),
      if (openedAt != null) 'openedAt': openedAt?.toJson(),
      if (closesAt != null) 'closesAt': closesAt?.toJson(),
      'questionSeconds': questionSeconds,
      'fastPrizes': fastPrizes,
      'rafflePrizes': rafflePrizes,
      if (results != null) 'results': results?.toJson(),
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static LiveGameInclude include({_iz4se2fa.SaintInclude? saint}) {
    return LiveGameInclude._(saint: saint);
  }

  static LiveGameIncludeList includeList({
    _is.WhereExpressionBuilder<LiveGameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LiveGameTable>? orderBy,
    _is.OrderByListBuilder<LiveGameTable>? orderByList,
    LiveGameInclude? include,
  }) {
    return LiveGameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LiveGame.t),
      orderByList: orderByList?.call(LiveGame.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveGameImpl extends LiveGame {
  _LiveGameImpl({
    int? id,
    required int saintId,
    _iz4se2fa.Saint? saint,
    required List<int> questionIds,
    _i5luu9zi.LivePhase? phase,
    int? currentIndex,
    DateTime? countdownTo,
    DateTime? openedAt,
    DateTime? closesAt,
    int? questionSeconds,
    required int fastPrizes,
    required int rafflePrizes,
    _ilkb7raf.LiveResults? results,
    required _is.UuidValue createdBy,
    DateTime? createdAt,
    DateTime? finishedAt,
  }) : super._(
         id: id,
         saintId: saintId,
         saint: saint,
         questionIds: questionIds,
         phase: phase,
         currentIndex: currentIndex,
         countdownTo: countdownTo,
         openedAt: openedAt,
         closesAt: closesAt,
         questionSeconds: questionSeconds,
         fastPrizes: fastPrizes,
         rafflePrizes: rafflePrizes,
         results: results,
         createdBy: createdBy,
         createdAt: createdAt,
         finishedAt: finishedAt,
       );

  /// Returns a shallow copy of this [LiveGame]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveGame copyWith({
    Object? id = _Undefined,
    int? saintId,
    Object? saint = _Undefined,
    List<int>? questionIds,
    _i5luu9zi.LivePhase? phase,
    int? currentIndex,
    Object? countdownTo = _Undefined,
    Object? openedAt = _Undefined,
    Object? closesAt = _Undefined,
    int? questionSeconds,
    int? fastPrizes,
    int? rafflePrizes,
    Object? results = _Undefined,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
    Object? finishedAt = _Undefined,
  }) {
    return LiveGame(
      id: id is int? ? id : this.id,
      saintId: saintId ?? this.saintId,
      saint: saint is _iz4se2fa.Saint? ? saint : this.saint?.copyWith(),
      questionIds: questionIds ?? this.questionIds.map((e0) => e0).toList(),
      phase: phase ?? this.phase,
      currentIndex: currentIndex ?? this.currentIndex,
      countdownTo: countdownTo is DateTime? ? countdownTo : this.countdownTo,
      openedAt: openedAt is DateTime? ? openedAt : this.openedAt,
      closesAt: closesAt is DateTime? ? closesAt : this.closesAt,
      questionSeconds: questionSeconds ?? this.questionSeconds,
      fastPrizes: fastPrizes ?? this.fastPrizes,
      rafflePrizes: rafflePrizes ?? this.rafflePrizes,
      results: results is _ilkb7raf.LiveResults?
          ? results
          : this.results?.copyWith(),
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
    );
  }
}

class LiveGameUpdateTable extends _is.UpdateTable<LiveGameTable> {
  LiveGameUpdateTable(super.table);

  _is.ColumnValue<int, int> saintId(int value) => _is.ColumnValue(
    table.saintId,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> questionIds(List<int> value) =>
      _is.ColumnValue(
        table.questionIds,
        value,
      );

  _is.ColumnValue<_i5luu9zi.LivePhase, _i5luu9zi.LivePhase> phase(
    _i5luu9zi.LivePhase value,
  ) => _is.ColumnValue(
    table.phase,
    value,
  );

  _is.ColumnValue<int, int> currentIndex(int value) => _is.ColumnValue(
    table.currentIndex,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> countdownTo(DateTime? value) =>
      _is.ColumnValue(
        table.countdownTo,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> openedAt(DateTime? value) =>
      _is.ColumnValue(
        table.openedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> closesAt(DateTime? value) =>
      _is.ColumnValue(
        table.closesAt,
        value,
      );

  _is.ColumnValue<int, int> questionSeconds(int value) => _is.ColumnValue(
    table.questionSeconds,
    value,
  );

  _is.ColumnValue<int, int> fastPrizes(int value) => _is.ColumnValue(
    table.fastPrizes,
    value,
  );

  _is.ColumnValue<int, int> rafflePrizes(int value) => _is.ColumnValue(
    table.rafflePrizes,
    value,
  );

  _is.ColumnValue<_ilkb7raf.LiveResults, _ilkb7raf.LiveResults> results(
    _ilkb7raf.LiveResults? value,
  ) => _is.ColumnValue(
    table.results,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> createdBy(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.createdBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.finishedAt,
        value,
      );
}

class LiveGameTable extends _is.Table<int?> {
  LiveGameTable({super.tableRelation}) : super(tableName: 'live_game') {
    updateTable = LiveGameUpdateTable(this);
    saintId = _is.ColumnInt(
      'saintId',
      this,
    );
    questionIds = _is.ColumnSerializable<List<int>>(
      'questionIds',
      this,
    );
    phase = _is.ColumnEnum(
      'phase',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    currentIndex = _is.ColumnInt(
      'currentIndex',
      this,
      hasDefault: true,
    );
    countdownTo = _is.ColumnDateTime(
      'countdownTo',
      this,
    );
    openedAt = _is.ColumnDateTime(
      'openedAt',
      this,
    );
    closesAt = _is.ColumnDateTime(
      'closesAt',
      this,
    );
    questionSeconds = _is.ColumnInt(
      'questionSeconds',
      this,
      hasDefault: true,
    );
    fastPrizes = _is.ColumnInt(
      'fastPrizes',
      this,
    );
    rafflePrizes = _is.ColumnInt(
      'rafflePrizes',
      this,
    );
    results = _is.ColumnSerializable<_ilkb7raf.LiveResults>(
      'results',
      this,
    );
    createdBy = _is.ColumnUuid(
      'createdBy',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    finishedAt = _is.ColumnDateTime(
      'finishedAt',
      this,
    );
  }

  late final LiveGameUpdateTable updateTable;

  late final _is.ColumnInt saintId;

  _iz4se2fa.SaintTable? _saint;

  /// Questions in the order they are asked.
  late final _is.ColumnSerializable<List<int>> questionIds;

  late final _is.ColumnEnum<_i5luu9zi.LivePhase> phase;

  /// Question being asked, or about to be: 0-based. During the countdown it
  /// is the one that opens at [countdownTo].
  late final _is.ColumnInt currentIndex;

  /// When the next question opens. Set while in [LivePhase.countdown].
  late final _is.ColumnDateTime countdownTo;

  /// When the current question actually opened and when it closes.
  late final _is.ColumnDateTime openedAt;

  late final _is.ColumnDateTime closesAt;

  late final _is.ColumnInt questionSeconds;

  late final _is.ColumnInt fastPrizes;

  late final _is.ColumnInt rafflePrizes;

  late final _is.ColumnSerializable<_ilkb7raf.LiveResults> results;

  late final _is.ColumnUuid createdBy;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime finishedAt;

  _iz4se2fa.SaintTable get saint {
    if (_saint != null) return _saint!;
    _saint = _is.createRelationTable(
      relationFieldName: 'saint',
      field: LiveGame.t.saintId,
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
    saintId,
    questionIds,
    phase,
    currentIndex,
    countdownTo,
    openedAt,
    closesAt,
    questionSeconds,
    fastPrizes,
    rafflePrizes,
    results,
    createdBy,
    createdAt,
    finishedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'saint') {
      return saint;
    }
    return null;
  }
}

class LiveGameInclude extends _is.IncludeObject {
  LiveGameInclude._({_iz4se2fa.SaintInclude? saint}) {
    _saint = saint;
  }

  _iz4se2fa.SaintInclude? _saint;

  @override
  Map<String, _is.Include?> get includes => {'saint': _saint};

  @override
  _is.Table<int?> get table => LiveGame.t;
}

class LiveGameIncludeList extends _is.IncludeList {
  LiveGameIncludeList._({
    _is.WhereExpressionBuilder<LiveGameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LiveGame.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LiveGame.t;
}

class LiveGameRepository {
  const LiveGameRepository._();

  final attachRow = const LiveGameAttachRowRepository._();

  /// Returns a list of [LiveGame]s matching the given query parameters.
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
  Future<List<LiveGame>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LiveGameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LiveGameTable>? orderBy,
    _is.OrderByListBuilder<LiveGameTable>? orderByList,
    _is.Transaction? transaction,
    LiveGameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LiveGame>(
      where: where?.call(LiveGame.t),
      orderBy: orderBy?.call(LiveGame.t),
      orderByList: orderByList?.call(LiveGame.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LiveGame] matching the given query parameters.
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
  Future<LiveGame?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LiveGameTable>? where,
    int? offset,
    _is.OrderByBuilder<LiveGameTable>? orderBy,
    _is.OrderByListBuilder<LiveGameTable>? orderByList,
    _is.Transaction? transaction,
    LiveGameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LiveGame>(
      where: where?.call(LiveGame.t),
      orderBy: orderBy?.call(LiveGame.t),
      orderByList: orderByList?.call(LiveGame.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LiveGame] by its [id] or null if no such row exists.
  Future<LiveGame?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    LiveGameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LiveGame>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LiveGame]s in the list and returns the inserted rows.
  ///
  /// The returned [LiveGame]s will have their `id` fields set.
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
  Future<List<LiveGame>> insert(
    _is.DatabaseSession session,
    List<LiveGame> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LiveGame>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LiveGame] and returns the inserted row.
  ///
  /// The returned [LiveGame] will have its `id` field set.
  Future<LiveGame> insertRow(
    _is.DatabaseSession session,
    LiveGame row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LiveGame>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LiveGame]s in the list and returns the resulting rows.
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
  /// The returned [LiveGame]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LiveGame>> upsert(
    _is.DatabaseSession session,
    List<LiveGame> rows, {
    required _is.ColumnSelections<LiveGameTable> conflictColumns,
    _is.ColumnSelections<LiveGameTable>? updateColumns,
    _is.WhereExpressionBuilder<LiveGameTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LiveGame>(
      rows,
      conflictColumns: conflictColumns(LiveGame.t),
      updateColumns: updateColumns?.call(LiveGame.t),
      updateWhere: updateWhere?.call(LiveGame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LiveGame] and returns the resulting row.
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
  /// The returned [LiveGame] will have its `id` field set.
  Future<LiveGame?> upsertRow(
    _is.DatabaseSession session,
    LiveGame row, {
    required _is.ColumnSelections<LiveGameTable> conflictColumns,
    _is.ColumnSelections<LiveGameTable>? updateColumns,
    _is.WhereExpressionBuilder<LiveGameTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LiveGame>(
      row,
      conflictColumns: conflictColumns(LiveGame.t),
      updateColumns: updateColumns?.call(LiveGame.t),
      updateWhere: updateWhere?.call(LiveGame.t),
      transaction: transaction,
    );
  }

  /// Updates all [LiveGame]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LiveGame>> update(
    _is.DatabaseSession session,
    List<LiveGame> rows, {
    _is.ColumnSelections<LiveGameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LiveGame>(
      rows,
      columns: columns?.call(LiveGame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LiveGame]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LiveGame> updateRow(
    _is.DatabaseSession session,
    LiveGame row, {
    _is.ColumnSelections<LiveGameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LiveGame>(
      row,
      columns: columns?.call(LiveGame.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LiveGame] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LiveGame?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LiveGameUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LiveGame>(
      id,
      columnValues: columnValues(LiveGame.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LiveGame]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LiveGame>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LiveGameUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LiveGameTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LiveGameTable>? orderBy,
    _is.OrderByListBuilder<LiveGameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LiveGame>(
      columnValues: columnValues(LiveGame.t.updateTable),
      where: where(LiveGame.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LiveGame.t),
      orderByList: orderByList?.call(LiveGame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LiveGame]s in the list and returns the deleted rows.
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
  Future<List<LiveGame>> delete(
    _is.DatabaseSession session,
    List<LiveGame> rows, {
    _is.OrderByBuilder<LiveGameTable>? orderBy,
    _is.OrderByListBuilder<LiveGameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LiveGame>(
      rows,
      orderBy: orderBy?.call(LiveGame.t),
      orderByList: orderByList?.call(LiveGame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LiveGame].
  Future<LiveGame> deleteRow(
    _is.DatabaseSession session,
    LiveGame row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LiveGame>(
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
  Future<List<LiveGame>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LiveGameTable> where,
    _is.OrderByBuilder<LiveGameTable>? orderBy,
    _is.OrderByListBuilder<LiveGameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LiveGame>(
      where: where(LiveGame.t),
      orderBy: orderBy?.call(LiveGame.t),
      orderByList: orderByList?.call(LiveGame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LiveGameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LiveGame>(
      where: where?.call(LiveGame.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LiveGame] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LiveGameTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LiveGame>(
      where: where(LiveGame.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class LiveGameAttachRowRepository {
  const LiveGameAttachRowRepository._();

  /// Creates a relation between the given [LiveGame] and [Saint]
  /// by setting the [LiveGame]'s foreign key `saintId` to refer to the [Saint].
  Future<void> saint(
    _is.DatabaseSession session,
    LiveGame liveGame,
    _iz4se2fa.Saint saint, {
    _is.Transaction? transaction,
  }) async {
    if (liveGame.id == null) {
      throw ArgumentError.notNull('liveGame.id');
    }
    if (saint.id == null) {
      throw ArgumentError.notNull('saint.id');
    }

    var $liveGame = liveGame.copyWith(saintId: saint.id);
    await session.db.updateRow<LiveGame>(
      $liveGame,
      columns: [LiveGame.t.saintId],
      transaction: transaction,
    );
  }
}
