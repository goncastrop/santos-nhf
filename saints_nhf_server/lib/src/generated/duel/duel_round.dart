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
import '../saints/score_category.dart' as _ihft2aor;

/// One round of a duel: attacker and defender each play a card and answer a
/// question about it.
abstract class DuelRound
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DuelRound._({
    this.id,
    required this.duelId,
    required this.roundNumber,
    required this.category,
    required this.attackerId,
    required this.defenderId,
    required this.attackerSaintId,
    this.attackerQuestionId,
    this.attackerAnswerIndex,
    this.attackerCorrect,
    this.defenderSaintId,
    this.defenderQuestionId,
    this.defenderAnswerIndex,
    this.defenderCorrect,
    this.attackerScore,
    this.defenderScore,
    this.pointTo,
    bool? resolved,
    DateTime? createdAt,
  }) : resolved = resolved ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory DuelRound({
    int? id,
    required int duelId,
    required int roundNumber,
    required _ihft2aor.ScoreCategory category,
    required _is.UuidValue attackerId,
    required _is.UuidValue defenderId,
    required int attackerSaintId,
    int? attackerQuestionId,
    int? attackerAnswerIndex,
    bool? attackerCorrect,
    int? defenderSaintId,
    int? defenderQuestionId,
    int? defenderAnswerIndex,
    bool? defenderCorrect,
    int? attackerScore,
    int? defenderScore,
    _is.UuidValue? pointTo,
    bool? resolved,
    DateTime? createdAt,
  }) = _DuelRoundImpl;

  factory DuelRound.fromJson(Map<String, dynamic> jsonSerialization) {
    return DuelRound(
      id: jsonSerialization['id'] as int?,
      duelId: jsonSerialization['duelId'] as int,
      roundNumber: jsonSerialization['roundNumber'] as int,
      category: _ihft2aor.ScoreCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      attackerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['attackerId'],
      ),
      defenderId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['defenderId'],
      ),
      attackerSaintId: jsonSerialization['attackerSaintId'] as int,
      attackerQuestionId: jsonSerialization['attackerQuestionId'] as int?,
      attackerAnswerIndex: jsonSerialization['attackerAnswerIndex'] as int?,
      attackerCorrect: jsonSerialization['attackerCorrect'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['attackerCorrect'],
            ),
      defenderSaintId: jsonSerialization['defenderSaintId'] as int?,
      defenderQuestionId: jsonSerialization['defenderQuestionId'] as int?,
      defenderAnswerIndex: jsonSerialization['defenderAnswerIndex'] as int?,
      defenderCorrect: jsonSerialization['defenderCorrect'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['defenderCorrect'],
            ),
      attackerScore: jsonSerialization['attackerScore'] as int?,
      defenderScore: jsonSerialization['defenderScore'] as int?,
      pointTo: jsonSerialization['pointTo'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['pointTo']),
      resolved: jsonSerialization['resolved'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['resolved']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = DuelRoundTable();

  static const db = DuelRoundRepository._();

  @override
  int? id;

  int duelId;

  int roundNumber;

  _ihft2aor.ScoreCategory category;

  _is.UuidValue attackerId;

  _is.UuidValue defenderId;

  int attackerSaintId;

  int? attackerQuestionId;

  int? attackerAnswerIndex;

  bool? attackerCorrect;

  int? defenderSaintId;

  int? defenderQuestionId;

  int? defenderAnswerIndex;

  bool? defenderCorrect;

  int? attackerScore;

  int? defenderScore;

  _is.UuidValue? pointTo;

  bool resolved;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DuelRound]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DuelRound copyWith({
    int? id,
    int? duelId,
    int? roundNumber,
    _ihft2aor.ScoreCategory? category,
    _is.UuidValue? attackerId,
    _is.UuidValue? defenderId,
    int? attackerSaintId,
    int? attackerQuestionId,
    int? attackerAnswerIndex,
    bool? attackerCorrect,
    int? defenderSaintId,
    int? defenderQuestionId,
    int? defenderAnswerIndex,
    bool? defenderCorrect,
    int? attackerScore,
    int? defenderScore,
    _is.UuidValue? pointTo,
    bool? resolved,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuelRound',
      if (id != null) 'id': id,
      'duelId': duelId,
      'roundNumber': roundNumber,
      'category': category.toJson(),
      'attackerId': attackerId.toJson(),
      'defenderId': defenderId.toJson(),
      'attackerSaintId': attackerSaintId,
      if (attackerQuestionId != null) 'attackerQuestionId': attackerQuestionId,
      if (attackerAnswerIndex != null)
        'attackerAnswerIndex': attackerAnswerIndex,
      if (attackerCorrect != null) 'attackerCorrect': attackerCorrect,
      if (defenderSaintId != null) 'defenderSaintId': defenderSaintId,
      if (defenderQuestionId != null) 'defenderQuestionId': defenderQuestionId,
      if (defenderAnswerIndex != null)
        'defenderAnswerIndex': defenderAnswerIndex,
      if (defenderCorrect != null) 'defenderCorrect': defenderCorrect,
      if (attackerScore != null) 'attackerScore': attackerScore,
      if (defenderScore != null) 'defenderScore': defenderScore,
      if (pointTo != null) 'pointTo': pointTo?.toJson(),
      'resolved': resolved,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DuelRound',
      if (id != null) 'id': id,
      'duelId': duelId,
      'roundNumber': roundNumber,
      'category': category.toJson(),
      'attackerId': attackerId.toJson(),
      'defenderId': defenderId.toJson(),
      'attackerSaintId': attackerSaintId,
      if (attackerQuestionId != null) 'attackerQuestionId': attackerQuestionId,
      if (attackerAnswerIndex != null)
        'attackerAnswerIndex': attackerAnswerIndex,
      if (attackerCorrect != null) 'attackerCorrect': attackerCorrect,
      if (defenderSaintId != null) 'defenderSaintId': defenderSaintId,
      if (defenderQuestionId != null) 'defenderQuestionId': defenderQuestionId,
      if (defenderAnswerIndex != null)
        'defenderAnswerIndex': defenderAnswerIndex,
      if (defenderCorrect != null) 'defenderCorrect': defenderCorrect,
      if (attackerScore != null) 'attackerScore': attackerScore,
      if (defenderScore != null) 'defenderScore': defenderScore,
      if (pointTo != null) 'pointTo': pointTo?.toJson(),
      'resolved': resolved,
      'createdAt': createdAt.toJson(),
    };
  }

  static DuelRoundInclude include() {
    return DuelRoundInclude._();
  }

  static DuelRoundIncludeList includeList({
    _is.WhereExpressionBuilder<DuelRoundTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelRoundTable>? orderBy,
    _is.OrderByListBuilder<DuelRoundTable>? orderByList,
    DuelRoundInclude? include,
  }) {
    return DuelRoundIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DuelRound.t),
      orderByList: orderByList?.call(DuelRound.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelRoundImpl extends DuelRound {
  _DuelRoundImpl({
    int? id,
    required int duelId,
    required int roundNumber,
    required _ihft2aor.ScoreCategory category,
    required _is.UuidValue attackerId,
    required _is.UuidValue defenderId,
    required int attackerSaintId,
    int? attackerQuestionId,
    int? attackerAnswerIndex,
    bool? attackerCorrect,
    int? defenderSaintId,
    int? defenderQuestionId,
    int? defenderAnswerIndex,
    bool? defenderCorrect,
    int? attackerScore,
    int? defenderScore,
    _is.UuidValue? pointTo,
    bool? resolved,
    DateTime? createdAt,
  }) : super._(
         id: id,
         duelId: duelId,
         roundNumber: roundNumber,
         category: category,
         attackerId: attackerId,
         defenderId: defenderId,
         attackerSaintId: attackerSaintId,
         attackerQuestionId: attackerQuestionId,
         attackerAnswerIndex: attackerAnswerIndex,
         attackerCorrect: attackerCorrect,
         defenderSaintId: defenderSaintId,
         defenderQuestionId: defenderQuestionId,
         defenderAnswerIndex: defenderAnswerIndex,
         defenderCorrect: defenderCorrect,
         attackerScore: attackerScore,
         defenderScore: defenderScore,
         pointTo: pointTo,
         resolved: resolved,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DuelRound]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DuelRound copyWith({
    Object? id = _Undefined,
    int? duelId,
    int? roundNumber,
    _ihft2aor.ScoreCategory? category,
    _is.UuidValue? attackerId,
    _is.UuidValue? defenderId,
    int? attackerSaintId,
    Object? attackerQuestionId = _Undefined,
    Object? attackerAnswerIndex = _Undefined,
    Object? attackerCorrect = _Undefined,
    Object? defenderSaintId = _Undefined,
    Object? defenderQuestionId = _Undefined,
    Object? defenderAnswerIndex = _Undefined,
    Object? defenderCorrect = _Undefined,
    Object? attackerScore = _Undefined,
    Object? defenderScore = _Undefined,
    Object? pointTo = _Undefined,
    bool? resolved,
    DateTime? createdAt,
  }) {
    return DuelRound(
      id: id is int? ? id : this.id,
      duelId: duelId ?? this.duelId,
      roundNumber: roundNumber ?? this.roundNumber,
      category: category ?? this.category,
      attackerId: attackerId ?? this.attackerId,
      defenderId: defenderId ?? this.defenderId,
      attackerSaintId: attackerSaintId ?? this.attackerSaintId,
      attackerQuestionId: attackerQuestionId is int?
          ? attackerQuestionId
          : this.attackerQuestionId,
      attackerAnswerIndex: attackerAnswerIndex is int?
          ? attackerAnswerIndex
          : this.attackerAnswerIndex,
      attackerCorrect: attackerCorrect is bool?
          ? attackerCorrect
          : this.attackerCorrect,
      defenderSaintId: defenderSaintId is int?
          ? defenderSaintId
          : this.defenderSaintId,
      defenderQuestionId: defenderQuestionId is int?
          ? defenderQuestionId
          : this.defenderQuestionId,
      defenderAnswerIndex: defenderAnswerIndex is int?
          ? defenderAnswerIndex
          : this.defenderAnswerIndex,
      defenderCorrect: defenderCorrect is bool?
          ? defenderCorrect
          : this.defenderCorrect,
      attackerScore: attackerScore is int? ? attackerScore : this.attackerScore,
      defenderScore: defenderScore is int? ? defenderScore : this.defenderScore,
      pointTo: pointTo is _is.UuidValue? ? pointTo : this.pointTo,
      resolved: resolved ?? this.resolved,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DuelRoundUpdateTable extends _is.UpdateTable<DuelRoundTable> {
  DuelRoundUpdateTable(super.table);

  _is.ColumnValue<int, int> duelId(int value) => _is.ColumnValue(
    table.duelId,
    value,
  );

  _is.ColumnValue<int, int> roundNumber(int value) => _is.ColumnValue(
    table.roundNumber,
    value,
  );

  _is.ColumnValue<_ihft2aor.ScoreCategory, _ihft2aor.ScoreCategory> category(
    _ihft2aor.ScoreCategory value,
  ) => _is.ColumnValue(
    table.category,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> attackerId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.attackerId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> defenderId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.defenderId,
    value,
  );

  _is.ColumnValue<int, int> attackerSaintId(int value) => _is.ColumnValue(
    table.attackerSaintId,
    value,
  );

  _is.ColumnValue<int, int> attackerQuestionId(int? value) => _is.ColumnValue(
    table.attackerQuestionId,
    value,
  );

  _is.ColumnValue<int, int> attackerAnswerIndex(int? value) => _is.ColumnValue(
    table.attackerAnswerIndex,
    value,
  );

  _is.ColumnValue<bool, bool> attackerCorrect(bool? value) => _is.ColumnValue(
    table.attackerCorrect,
    value,
  );

  _is.ColumnValue<int, int> defenderSaintId(int? value) => _is.ColumnValue(
    table.defenderSaintId,
    value,
  );

  _is.ColumnValue<int, int> defenderQuestionId(int? value) => _is.ColumnValue(
    table.defenderQuestionId,
    value,
  );

  _is.ColumnValue<int, int> defenderAnswerIndex(int? value) => _is.ColumnValue(
    table.defenderAnswerIndex,
    value,
  );

  _is.ColumnValue<bool, bool> defenderCorrect(bool? value) => _is.ColumnValue(
    table.defenderCorrect,
    value,
  );

  _is.ColumnValue<int, int> attackerScore(int? value) => _is.ColumnValue(
    table.attackerScore,
    value,
  );

  _is.ColumnValue<int, int> defenderScore(int? value) => _is.ColumnValue(
    table.defenderScore,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> pointTo(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.pointTo,
        value,
      );

  _is.ColumnValue<bool, bool> resolved(bool value) => _is.ColumnValue(
    table.resolved,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class DuelRoundTable extends _is.Table<int?> {
  DuelRoundTable({super.tableRelation}) : super(tableName: 'duel_round') {
    updateTable = DuelRoundUpdateTable(this);
    duelId = _is.ColumnInt(
      'duelId',
      this,
    );
    roundNumber = _is.ColumnInt(
      'roundNumber',
      this,
    );
    category = _is.ColumnEnum(
      'category',
      this,
      _is.EnumSerialization.byName,
    );
    attackerId = _is.ColumnUuid(
      'attackerId',
      this,
    );
    defenderId = _is.ColumnUuid(
      'defenderId',
      this,
    );
    attackerSaintId = _is.ColumnInt(
      'attackerSaintId',
      this,
    );
    attackerQuestionId = _is.ColumnInt(
      'attackerQuestionId',
      this,
    );
    attackerAnswerIndex = _is.ColumnInt(
      'attackerAnswerIndex',
      this,
    );
    attackerCorrect = _is.ColumnBool(
      'attackerCorrect',
      this,
    );
    defenderSaintId = _is.ColumnInt(
      'defenderSaintId',
      this,
    );
    defenderQuestionId = _is.ColumnInt(
      'defenderQuestionId',
      this,
    );
    defenderAnswerIndex = _is.ColumnInt(
      'defenderAnswerIndex',
      this,
    );
    defenderCorrect = _is.ColumnBool(
      'defenderCorrect',
      this,
    );
    attackerScore = _is.ColumnInt(
      'attackerScore',
      this,
    );
    defenderScore = _is.ColumnInt(
      'defenderScore',
      this,
    );
    pointTo = _is.ColumnUuid(
      'pointTo',
      this,
    );
    resolved = _is.ColumnBool(
      'resolved',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final DuelRoundUpdateTable updateTable;

  late final _is.ColumnInt duelId;

  late final _is.ColumnInt roundNumber;

  late final _is.ColumnEnum<_ihft2aor.ScoreCategory> category;

  late final _is.ColumnUuid attackerId;

  late final _is.ColumnUuid defenderId;

  late final _is.ColumnInt attackerSaintId;

  late final _is.ColumnInt attackerQuestionId;

  late final _is.ColumnInt attackerAnswerIndex;

  late final _is.ColumnBool attackerCorrect;

  late final _is.ColumnInt defenderSaintId;

  late final _is.ColumnInt defenderQuestionId;

  late final _is.ColumnInt defenderAnswerIndex;

  late final _is.ColumnBool defenderCorrect;

  late final _is.ColumnInt attackerScore;

  late final _is.ColumnInt defenderScore;

  late final _is.ColumnUuid pointTo;

  late final _is.ColumnBool resolved;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    duelId,
    roundNumber,
    category,
    attackerId,
    defenderId,
    attackerSaintId,
    attackerQuestionId,
    attackerAnswerIndex,
    attackerCorrect,
    defenderSaintId,
    defenderQuestionId,
    defenderAnswerIndex,
    defenderCorrect,
    attackerScore,
    defenderScore,
    pointTo,
    resolved,
    createdAt,
  ];
}

class DuelRoundInclude extends _is.IncludeObject {
  DuelRoundInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DuelRound.t;
}

class DuelRoundIncludeList extends _is.IncludeList {
  DuelRoundIncludeList._({
    _is.WhereExpressionBuilder<DuelRoundTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DuelRound.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DuelRound.t;
}

class DuelRoundRepository {
  const DuelRoundRepository._();

  /// Returns a list of [DuelRound]s matching the given query parameters.
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
  Future<List<DuelRound>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelRoundTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelRoundTable>? orderBy,
    _is.OrderByListBuilder<DuelRoundTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DuelRound>(
      where: where?.call(DuelRound.t),
      orderBy: orderBy?.call(DuelRound.t),
      orderByList: orderByList?.call(DuelRound.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DuelRound] matching the given query parameters.
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
  Future<DuelRound?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelRoundTable>? where,
    int? offset,
    _is.OrderByBuilder<DuelRoundTable>? orderBy,
    _is.OrderByListBuilder<DuelRoundTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DuelRound>(
      where: where?.call(DuelRound.t),
      orderBy: orderBy?.call(DuelRound.t),
      orderByList: orderByList?.call(DuelRound.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DuelRound] by its [id] or null if no such row exists.
  Future<DuelRound?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DuelRound>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DuelRound]s in the list and returns the inserted rows.
  ///
  /// The returned [DuelRound]s will have their `id` fields set.
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
  Future<List<DuelRound>> insert(
    _is.DatabaseSession session,
    List<DuelRound> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DuelRound>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DuelRound] and returns the inserted row.
  ///
  /// The returned [DuelRound] will have its `id` field set.
  Future<DuelRound> insertRow(
    _is.DatabaseSession session,
    DuelRound row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DuelRound>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DuelRound]s in the list and returns the resulting rows.
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
  /// The returned [DuelRound]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DuelRound>> upsert(
    _is.DatabaseSession session,
    List<DuelRound> rows, {
    required _is.ColumnSelections<DuelRoundTable> conflictColumns,
    _is.ColumnSelections<DuelRoundTable>? updateColumns,
    _is.WhereExpressionBuilder<DuelRoundTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DuelRound>(
      rows,
      conflictColumns: conflictColumns(DuelRound.t),
      updateColumns: updateColumns?.call(DuelRound.t),
      updateWhere: updateWhere?.call(DuelRound.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DuelRound] and returns the resulting row.
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
  /// The returned [DuelRound] will have its `id` field set.
  Future<DuelRound?> upsertRow(
    _is.DatabaseSession session,
    DuelRound row, {
    required _is.ColumnSelections<DuelRoundTable> conflictColumns,
    _is.ColumnSelections<DuelRoundTable>? updateColumns,
    _is.WhereExpressionBuilder<DuelRoundTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DuelRound>(
      row,
      conflictColumns: conflictColumns(DuelRound.t),
      updateColumns: updateColumns?.call(DuelRound.t),
      updateWhere: updateWhere?.call(DuelRound.t),
      transaction: transaction,
    );
  }

  /// Updates all [DuelRound]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DuelRound>> update(
    _is.DatabaseSession session,
    List<DuelRound> rows, {
    _is.ColumnSelections<DuelRoundTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DuelRound>(
      rows,
      columns: columns?.call(DuelRound.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DuelRound]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DuelRound> updateRow(
    _is.DatabaseSession session,
    DuelRound row, {
    _is.ColumnSelections<DuelRoundTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DuelRound>(
      row,
      columns: columns?.call(DuelRound.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DuelRound] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DuelRound?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DuelRoundUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DuelRound>(
      id,
      columnValues: columnValues(DuelRound.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DuelRound]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DuelRound>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DuelRoundUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DuelRoundTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelRoundTable>? orderBy,
    _is.OrderByListBuilder<DuelRoundTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DuelRound>(
      columnValues: columnValues(DuelRound.t.updateTable),
      where: where(DuelRound.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DuelRound.t),
      orderByList: orderByList?.call(DuelRound.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DuelRound]s in the list and returns the deleted rows.
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
  Future<List<DuelRound>> delete(
    _is.DatabaseSession session,
    List<DuelRound> rows, {
    _is.OrderByBuilder<DuelRoundTable>? orderBy,
    _is.OrderByListBuilder<DuelRoundTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DuelRound>(
      rows,
      orderBy: orderBy?.call(DuelRound.t),
      orderByList: orderByList?.call(DuelRound.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DuelRound].
  Future<DuelRound> deleteRow(
    _is.DatabaseSession session,
    DuelRound row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DuelRound>(
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
  Future<List<DuelRound>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DuelRoundTable> where,
    _is.OrderByBuilder<DuelRoundTable>? orderBy,
    _is.OrderByListBuilder<DuelRoundTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DuelRound>(
      where: where(DuelRound.t),
      orderBy: orderBy?.call(DuelRound.t),
      orderByList: orderByList?.call(DuelRound.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelRoundTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DuelRound>(
      where: where?.call(DuelRound.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DuelRound] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DuelRoundTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DuelRound>(
      where: where(DuelRound.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
