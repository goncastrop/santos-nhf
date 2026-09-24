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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;

/// Per-user game state.
abstract class PlayerProfile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PlayerProfile._({
    this.id,
    required this.authUserId,
    this.authUser,
    this.lastDailyClaimDay,
    bool? starterGranted,
    this.displayName,
    this.friendCode,
    this.quizDay,
    this.quizQuestionId,
    this.quizChosenIndex,
    bool? quizAnswered,
    this.lastCorrectDay,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    this.pendingHand,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  }) : starterGranted = starterGranted ?? false,
       quizAnswered = quizAnswered ?? false,
       streak = streak ?? 0,
       bestStreak = bestStreak ?? 0,
       totalAnswered = totalAnswered ?? 0,
       totalCorrect = totalCorrect ?? 0,
       duelsWon = duelsWon ?? 0,
       duelsPlayed = duelsPlayed ?? 0,
       litanyBest = litanyBest ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory PlayerProfile({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    String? lastDailyClaimDay,
    bool? starterGranted,
    String? displayName,
    String? friendCode,
    String? quizDay,
    int? quizQuestionId,
    int? quizChosenIndex,
    bool? quizAnswered,
    String? lastCorrectDay,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    List<int>? pendingHand,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  }) = _PlayerProfileImpl;

  factory PlayerProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlayerProfile(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      lastDailyClaimDay: jsonSerialization['lastDailyClaimDay'] as String?,
      starterGranted: jsonSerialization['starterGranted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['starterGranted']),
      displayName: jsonSerialization['displayName'] as String?,
      friendCode: jsonSerialization['friendCode'] as String?,
      quizDay: jsonSerialization['quizDay'] as String?,
      quizQuestionId: jsonSerialization['quizQuestionId'] as int?,
      quizChosenIndex: jsonSerialization['quizChosenIndex'] as int?,
      quizAnswered: jsonSerialization['quizAnswered'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['quizAnswered']),
      lastCorrectDay: jsonSerialization['lastCorrectDay'] as String?,
      streak: jsonSerialization['streak'] as int?,
      bestStreak: jsonSerialization['bestStreak'] as int?,
      totalAnswered: jsonSerialization['totalAnswered'] as int?,
      totalCorrect: jsonSerialization['totalCorrect'] as int?,
      pendingHand: jsonSerialization['pendingHand'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<List<int>>(
              jsonSerialization['pendingHand'],
            ),
      duelsWon: jsonSerialization['duelsWon'] as int?,
      duelsPlayed: jsonSerialization['duelsPlayed'] as int?,
      litanyBest: jsonSerialization['litanyBest'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = PlayerProfileTable();

  static const db = PlayerProfileRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  _iacs.AuthUser? authUser;

  /// Calendar day (yyyy-MM-dd, Argentina time) of the last daily claim.
  String? lastDailyClaimDay;

  bool starterGranted;

  /// Public name shown to friends and in rankings.
  String? displayName;

  /// Code friends use to add this player.
  String? friendCode;

  /// Daily quiz: current question and stats.
  String? quizDay;

  int? quizQuestionId;

  int? quizChosenIndex;

  bool quizAnswered;

  /// Day of the last correct daily answer, to continue the streak.
  String? lastCorrectDay;

  int streak;

  int bestStreak;

  int totalAnswered;

  int totalCorrect;

  /// Cards dealt for the next duel deck; the deck must come from here.
  List<int>? pendingHand;

  /// Duel stats.
  int duelsWon;

  int duelsPlayed;

  /// Best score ever reached in La Letanía.
  int litanyBest;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PlayerProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlayerProfile copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? lastDailyClaimDay,
    bool? starterGranted,
    String? displayName,
    String? friendCode,
    String? quizDay,
    int? quizQuestionId,
    int? quizChosenIndex,
    bool? quizAnswered,
    String? lastCorrectDay,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    List<int>? pendingHand,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlayerProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (lastDailyClaimDay != null) 'lastDailyClaimDay': lastDailyClaimDay,
      'starterGranted': starterGranted,
      if (displayName != null) 'displayName': displayName,
      if (friendCode != null) 'friendCode': friendCode,
      if (quizDay != null) 'quizDay': quizDay,
      if (quizQuestionId != null) 'quizQuestionId': quizQuestionId,
      if (quizChosenIndex != null) 'quizChosenIndex': quizChosenIndex,
      'quizAnswered': quizAnswered,
      if (lastCorrectDay != null) 'lastCorrectDay': lastCorrectDay,
      'streak': streak,
      'bestStreak': bestStreak,
      'totalAnswered': totalAnswered,
      'totalCorrect': totalCorrect,
      if (pendingHand != null) 'pendingHand': pendingHand?.toJson(),
      'duelsWon': duelsWon,
      'duelsPlayed': duelsPlayed,
      'litanyBest': litanyBest,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlayerProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (lastDailyClaimDay != null) 'lastDailyClaimDay': lastDailyClaimDay,
      'starterGranted': starterGranted,
      if (displayName != null) 'displayName': displayName,
      if (friendCode != null) 'friendCode': friendCode,
      if (quizDay != null) 'quizDay': quizDay,
      if (quizQuestionId != null) 'quizQuestionId': quizQuestionId,
      if (quizChosenIndex != null) 'quizChosenIndex': quizChosenIndex,
      'quizAnswered': quizAnswered,
      if (lastCorrectDay != null) 'lastCorrectDay': lastCorrectDay,
      'streak': streak,
      'bestStreak': bestStreak,
      'totalAnswered': totalAnswered,
      'totalCorrect': totalCorrect,
      if (pendingHand != null) 'pendingHand': pendingHand?.toJson(),
      'duelsWon': duelsWon,
      'duelsPlayed': duelsPlayed,
      'litanyBest': litanyBest,
      'createdAt': createdAt.toJson(),
    };
  }

  static PlayerProfileInclude include({_iacs.AuthUserInclude? authUser}) {
    return PlayerProfileInclude._(authUser: authUser);
  }

  static PlayerProfileIncludeList includeList({
    _is.WhereExpressionBuilder<PlayerProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlayerProfileTable>? orderBy,
    _is.OrderByListBuilder<PlayerProfileTable>? orderByList,
    PlayerProfileInclude? include,
  }) {
    return PlayerProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlayerProfile.t),
      orderByList: orderByList?.call(PlayerProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlayerProfileImpl extends PlayerProfile {
  _PlayerProfileImpl({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    String? lastDailyClaimDay,
    bool? starterGranted,
    String? displayName,
    String? friendCode,
    String? quizDay,
    int? quizQuestionId,
    int? quizChosenIndex,
    bool? quizAnswered,
    String? lastCorrectDay,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    List<int>? pendingHand,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         lastDailyClaimDay: lastDailyClaimDay,
         starterGranted: starterGranted,
         displayName: displayName,
         friendCode: friendCode,
         quizDay: quizDay,
         quizQuestionId: quizQuestionId,
         quizChosenIndex: quizChosenIndex,
         quizAnswered: quizAnswered,
         lastCorrectDay: lastCorrectDay,
         streak: streak,
         bestStreak: bestStreak,
         totalAnswered: totalAnswered,
         totalCorrect: totalCorrect,
         pendingHand: pendingHand,
         duelsWon: duelsWon,
         duelsPlayed: duelsPlayed,
         litanyBest: litanyBest,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PlayerProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlayerProfile copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? lastDailyClaimDay = _Undefined,
    bool? starterGranted,
    Object? displayName = _Undefined,
    Object? friendCode = _Undefined,
    Object? quizDay = _Undefined,
    Object? quizQuestionId = _Undefined,
    Object? quizChosenIndex = _Undefined,
    bool? quizAnswered,
    Object? lastCorrectDay = _Undefined,
    int? streak,
    int? bestStreak,
    int? totalAnswered,
    int? totalCorrect,
    Object? pendingHand = _Undefined,
    int? duelsWon,
    int? duelsPlayed,
    int? litanyBest,
    DateTime? createdAt,
  }) {
    return PlayerProfile(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      lastDailyClaimDay: lastDailyClaimDay is String?
          ? lastDailyClaimDay
          : this.lastDailyClaimDay,
      starterGranted: starterGranted ?? this.starterGranted,
      displayName: displayName is String? ? displayName : this.displayName,
      friendCode: friendCode is String? ? friendCode : this.friendCode,
      quizDay: quizDay is String? ? quizDay : this.quizDay,
      quizQuestionId: quizQuestionId is int?
          ? quizQuestionId
          : this.quizQuestionId,
      quizChosenIndex: quizChosenIndex is int?
          ? quizChosenIndex
          : this.quizChosenIndex,
      quizAnswered: quizAnswered ?? this.quizAnswered,
      lastCorrectDay: lastCorrectDay is String?
          ? lastCorrectDay
          : this.lastCorrectDay,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      pendingHand: pendingHand is List<int>?
          ? pendingHand
          : this.pendingHand?.map((e0) => e0).toList(),
      duelsWon: duelsWon ?? this.duelsWon,
      duelsPlayed: duelsPlayed ?? this.duelsPlayed,
      litanyBest: litanyBest ?? this.litanyBest,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PlayerProfileUpdateTable extends _is.UpdateTable<PlayerProfileTable> {
  PlayerProfileUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> lastDailyClaimDay(String? value) =>
      _is.ColumnValue(
        table.lastDailyClaimDay,
        value,
      );

  _is.ColumnValue<bool, bool> starterGranted(bool value) => _is.ColumnValue(
    table.starterGranted,
    value,
  );

  _is.ColumnValue<String, String> displayName(String? value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<String, String> friendCode(String? value) => _is.ColumnValue(
    table.friendCode,
    value,
  );

  _is.ColumnValue<String, String> quizDay(String? value) => _is.ColumnValue(
    table.quizDay,
    value,
  );

  _is.ColumnValue<int, int> quizQuestionId(int? value) => _is.ColumnValue(
    table.quizQuestionId,
    value,
  );

  _is.ColumnValue<int, int> quizChosenIndex(int? value) => _is.ColumnValue(
    table.quizChosenIndex,
    value,
  );

  _is.ColumnValue<bool, bool> quizAnswered(bool value) => _is.ColumnValue(
    table.quizAnswered,
    value,
  );

  _is.ColumnValue<String, String> lastCorrectDay(String? value) =>
      _is.ColumnValue(
        table.lastCorrectDay,
        value,
      );

  _is.ColumnValue<int, int> streak(int value) => _is.ColumnValue(
    table.streak,
    value,
  );

  _is.ColumnValue<int, int> bestStreak(int value) => _is.ColumnValue(
    table.bestStreak,
    value,
  );

  _is.ColumnValue<int, int> totalAnswered(int value) => _is.ColumnValue(
    table.totalAnswered,
    value,
  );

  _is.ColumnValue<int, int> totalCorrect(int value) => _is.ColumnValue(
    table.totalCorrect,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> pendingHand(List<int>? value) =>
      _is.ColumnValue(
        table.pendingHand,
        value,
      );

  _is.ColumnValue<int, int> duelsWon(int value) => _is.ColumnValue(
    table.duelsWon,
    value,
  );

  _is.ColumnValue<int, int> duelsPlayed(int value) => _is.ColumnValue(
    table.duelsPlayed,
    value,
  );

  _is.ColumnValue<int, int> litanyBest(int value) => _is.ColumnValue(
    table.litanyBest,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class PlayerProfileTable extends _is.Table<int?> {
  PlayerProfileTable({super.tableRelation})
    : super(tableName: 'player_profile') {
    updateTable = PlayerProfileUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    lastDailyClaimDay = _is.ColumnString(
      'lastDailyClaimDay',
      this,
    );
    starterGranted = _is.ColumnBool(
      'starterGranted',
      this,
      hasDefault: true,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    friendCode = _is.ColumnString(
      'friendCode',
      this,
    );
    quizDay = _is.ColumnString(
      'quizDay',
      this,
    );
    quizQuestionId = _is.ColumnInt(
      'quizQuestionId',
      this,
    );
    quizChosenIndex = _is.ColumnInt(
      'quizChosenIndex',
      this,
    );
    quizAnswered = _is.ColumnBool(
      'quizAnswered',
      this,
      hasDefault: true,
    );
    lastCorrectDay = _is.ColumnString(
      'lastCorrectDay',
      this,
    );
    streak = _is.ColumnInt(
      'streak',
      this,
      hasDefault: true,
    );
    bestStreak = _is.ColumnInt(
      'bestStreak',
      this,
      hasDefault: true,
    );
    totalAnswered = _is.ColumnInt(
      'totalAnswered',
      this,
      hasDefault: true,
    );
    totalCorrect = _is.ColumnInt(
      'totalCorrect',
      this,
      hasDefault: true,
    );
    pendingHand = _is.ColumnSerializable<List<int>>(
      'pendingHand',
      this,
    );
    duelsWon = _is.ColumnInt(
      'duelsWon',
      this,
      hasDefault: true,
    );
    duelsPlayed = _is.ColumnInt(
      'duelsPlayed',
      this,
      hasDefault: true,
    );
    litanyBest = _is.ColumnInt(
      'litanyBest',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final PlayerProfileUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  _iacs.AuthUserTable? _authUser;

  /// Calendar day (yyyy-MM-dd, Argentina time) of the last daily claim.
  late final _is.ColumnString lastDailyClaimDay;

  late final _is.ColumnBool starterGranted;

  /// Public name shown to friends and in rankings.
  late final _is.ColumnString displayName;

  /// Code friends use to add this player.
  late final _is.ColumnString friendCode;

  /// Daily quiz: current question and stats.
  late final _is.ColumnString quizDay;

  late final _is.ColumnInt quizQuestionId;

  late final _is.ColumnInt quizChosenIndex;

  late final _is.ColumnBool quizAnswered;

  /// Day of the last correct daily answer, to continue the streak.
  late final _is.ColumnString lastCorrectDay;

  late final _is.ColumnInt streak;

  late final _is.ColumnInt bestStreak;

  late final _is.ColumnInt totalAnswered;

  late final _is.ColumnInt totalCorrect;

  /// Cards dealt for the next duel deck; the deck must come from here.
  late final _is.ColumnSerializable<List<int>> pendingHand;

  /// Duel stats.
  late final _is.ColumnInt duelsWon;

  late final _is.ColumnInt duelsPlayed;

  /// Best score ever reached in La Letanía.
  late final _is.ColumnInt litanyBest;

  late final _is.ColumnDateTime createdAt;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: PlayerProfile.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    lastDailyClaimDay,
    starterGranted,
    displayName,
    friendCode,
    quizDay,
    quizQuestionId,
    quizChosenIndex,
    quizAnswered,
    lastCorrectDay,
    streak,
    bestStreak,
    totalAnswered,
    totalCorrect,
    pendingHand,
    duelsWon,
    duelsPlayed,
    litanyBest,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class PlayerProfileInclude extends _is.IncludeObject {
  PlayerProfileInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => PlayerProfile.t;
}

class PlayerProfileIncludeList extends _is.IncludeList {
  PlayerProfileIncludeList._({
    _is.WhereExpressionBuilder<PlayerProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PlayerProfile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PlayerProfile.t;
}

class PlayerProfileRepository {
  const PlayerProfileRepository._();

  final attachRow = const PlayerProfileAttachRowRepository._();

  /// Returns a list of [PlayerProfile]s matching the given query parameters.
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
  Future<List<PlayerProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlayerProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlayerProfileTable>? orderBy,
    _is.OrderByListBuilder<PlayerProfileTable>? orderByList,
    _is.Transaction? transaction,
    PlayerProfileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PlayerProfile>(
      where: where?.call(PlayerProfile.t),
      orderBy: orderBy?.call(PlayerProfile.t),
      orderByList: orderByList?.call(PlayerProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PlayerProfile] matching the given query parameters.
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
  Future<PlayerProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlayerProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<PlayerProfileTable>? orderBy,
    _is.OrderByListBuilder<PlayerProfileTable>? orderByList,
    _is.Transaction? transaction,
    PlayerProfileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PlayerProfile>(
      where: where?.call(PlayerProfile.t),
      orderBy: orderBy?.call(PlayerProfile.t),
      orderByList: orderByList?.call(PlayerProfile.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PlayerProfile] by its [id] or null if no such row exists.
  Future<PlayerProfile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    PlayerProfileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PlayerProfile>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PlayerProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [PlayerProfile]s will have their `id` fields set.
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
  Future<List<PlayerProfile>> insert(
    _is.DatabaseSession session,
    List<PlayerProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PlayerProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PlayerProfile] and returns the inserted row.
  ///
  /// The returned [PlayerProfile] will have its `id` field set.
  Future<PlayerProfile> insertRow(
    _is.DatabaseSession session,
    PlayerProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PlayerProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PlayerProfile]s in the list and returns the resulting rows.
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
  /// The returned [PlayerProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlayerProfile>> upsert(
    _is.DatabaseSession session,
    List<PlayerProfile> rows, {
    required _is.ColumnSelections<PlayerProfileTable> conflictColumns,
    _is.ColumnSelections<PlayerProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<PlayerProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PlayerProfile>(
      rows,
      conflictColumns: conflictColumns(PlayerProfile.t),
      updateColumns: updateColumns?.call(PlayerProfile.t),
      updateWhere: updateWhere?.call(PlayerProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PlayerProfile] and returns the resulting row.
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
  /// The returned [PlayerProfile] will have its `id` field set.
  Future<PlayerProfile?> upsertRow(
    _is.DatabaseSession session,
    PlayerProfile row, {
    required _is.ColumnSelections<PlayerProfileTable> conflictColumns,
    _is.ColumnSelections<PlayerProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<PlayerProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PlayerProfile>(
      row,
      conflictColumns: conflictColumns(PlayerProfile.t),
      updateColumns: updateColumns?.call(PlayerProfile.t),
      updateWhere: updateWhere?.call(PlayerProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [PlayerProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlayerProfile>> update(
    _is.DatabaseSession session,
    List<PlayerProfile> rows, {
    _is.ColumnSelections<PlayerProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PlayerProfile>(
      rows,
      columns: columns?.call(PlayerProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PlayerProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PlayerProfile> updateRow(
    _is.DatabaseSession session,
    PlayerProfile row, {
    _is.ColumnSelections<PlayerProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PlayerProfile>(
      row,
      columns: columns?.call(PlayerProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PlayerProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PlayerProfile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PlayerProfileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PlayerProfile>(
      id,
      columnValues: columnValues(PlayerProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PlayerProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlayerProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PlayerProfileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PlayerProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlayerProfileTable>? orderBy,
    _is.OrderByListBuilder<PlayerProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PlayerProfile>(
      columnValues: columnValues(PlayerProfile.t.updateTable),
      where: where(PlayerProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlayerProfile.t),
      orderByList: orderByList?.call(PlayerProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PlayerProfile]s in the list and returns the deleted rows.
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
  Future<List<PlayerProfile>> delete(
    _is.DatabaseSession session,
    List<PlayerProfile> rows, {
    _is.OrderByBuilder<PlayerProfileTable>? orderBy,
    _is.OrderByListBuilder<PlayerProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PlayerProfile>(
      rows,
      orderBy: orderBy?.call(PlayerProfile.t),
      orderByList: orderByList?.call(PlayerProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PlayerProfile].
  Future<PlayerProfile> deleteRow(
    _is.DatabaseSession session,
    PlayerProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PlayerProfile>(
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
  Future<List<PlayerProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlayerProfileTable> where,
    _is.OrderByBuilder<PlayerProfileTable>? orderBy,
    _is.OrderByListBuilder<PlayerProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PlayerProfile>(
      where: where(PlayerProfile.t),
      orderBy: orderBy?.call(PlayerProfile.t),
      orderByList: orderByList?.call(PlayerProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlayerProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PlayerProfile>(
      where: where?.call(PlayerProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PlayerProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlayerProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PlayerProfile>(
      where: where(PlayerProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PlayerProfileAttachRowRepository {
  const PlayerProfileAttachRowRepository._();

  /// Creates a relation between the given [PlayerProfile] and [AuthUser]
  /// by setting the [PlayerProfile]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    PlayerProfile playerProfile,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (playerProfile.id == null) {
      throw ArgumentError.notNull('playerProfile.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $playerProfile = playerProfile.copyWith(authUserId: authUser.id);
    await session.db.updateRow<PlayerProfile>(
      $playerProfile,
      columns: [PlayerProfile.t.authUserId],
      transaction: transaction,
    );
  }
}
