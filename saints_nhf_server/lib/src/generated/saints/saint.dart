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
import '../saints/saint_status.dart' as _if2tzgnp;
import '../saints/saint_title.dart' as _itutlhb1;

/// A saint of the "santo del día" section, with the six card scores.
/// Only returned to admins; public clients receive [SaintInfo] and, once the
/// card is in their collection, [SaintScores].
abstract class Saint implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Saint._({
    this.id,
    required this.name,
    required this.slug,
    this.title,
    this.titles,
    this.feastMonth,
    this.feastDay,
    this.birthYear,
    bool? birthApprox,
    this.deathYear,
    bool? deathApprox,
    this.birthPlace,
    this.birthLat,
    this.birthLng,
    this.deathPlace,
    this.deathLat,
    this.deathLng,
    String? bio,
    this.prayer,
    this.illustrationPath,
    this.season,
    this.episode,
    this.youtubeUrl,
    _if2tzgnp.SaintStatus? status,
    int? catequesis,
    int? escritos,
    int? oracion,
    int? patronazgos,
    int? evangelizacion,
    int? viajes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : birthApprox = birthApprox ?? false,
       deathApprox = deathApprox ?? false,
       bio = bio ?? '',
       status = status ?? _if2tzgnp.SaintStatus.draft,
       catequesis = catequesis ?? 50,
       escritos = escritos ?? 50,
       oracion = oracion ?? 50,
       patronazgos = patronazgos ?? 50,
       evangelizacion = evangelizacion ?? 50,
       viajes = viajes ?? 50,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Saint({
    int? id,
    required String name,
    required String slug,
    String? title,
    List<_itutlhb1.SaintTitle>? titles,
    int? feastMonth,
    int? feastDay,
    int? birthYear,
    bool? birthApprox,
    int? deathYear,
    bool? deathApprox,
    String? birthPlace,
    double? birthLat,
    double? birthLng,
    String? deathPlace,
    double? deathLat,
    double? deathLng,
    String? bio,
    String? prayer,
    String? illustrationPath,
    int? season,
    int? episode,
    String? youtubeUrl,
    _if2tzgnp.SaintStatus? status,
    int? catequesis,
    int? escritos,
    int? oracion,
    int? patronazgos,
    int? evangelizacion,
    int? viajes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SaintImpl;

  factory Saint.fromJson(Map<String, dynamic> jsonSerialization) {
    return Saint(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      title: jsonSerialization['title'] as String?,
      titles: jsonSerialization['titles'] == null
          ? null
          : _itw3ru38.Protocol().deserialize<List<_itutlhb1.SaintTitle>>(
              jsonSerialization['titles'],
            ),
      feastMonth: jsonSerialization['feastMonth'] as int?,
      feastDay: jsonSerialization['feastDay'] as int?,
      birthYear: jsonSerialization['birthYear'] as int?,
      birthApprox: jsonSerialization['birthApprox'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['birthApprox']),
      deathYear: jsonSerialization['deathYear'] as int?,
      deathApprox: jsonSerialization['deathApprox'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['deathApprox']),
      birthPlace: jsonSerialization['birthPlace'] as String?,
      birthLat: (jsonSerialization['birthLat'] as num?)?.toDouble(),
      birthLng: (jsonSerialization['birthLng'] as num?)?.toDouble(),
      deathPlace: jsonSerialization['deathPlace'] as String?,
      deathLat: (jsonSerialization['deathLat'] as num?)?.toDouble(),
      deathLng: (jsonSerialization['deathLng'] as num?)?.toDouble(),
      bio: jsonSerialization['bio'] as String?,
      prayer: jsonSerialization['prayer'] as String?,
      illustrationPath: jsonSerialization['illustrationPath'] as String?,
      season: jsonSerialization['season'] as int?,
      episode: jsonSerialization['episode'] as int?,
      youtubeUrl: jsonSerialization['youtubeUrl'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _if2tzgnp.SaintStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      catequesis: jsonSerialization['catequesis'] as int?,
      escritos: jsonSerialization['escritos'] as int?,
      oracion: jsonSerialization['oracion'] as int?,
      patronazgos: jsonSerialization['patronazgos'] as int?,
      evangelizacion: jsonSerialization['evangelizacion'] as int?,
      viajes: jsonSerialization['viajes'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = SaintTable();

  static const db = SaintRepository._();

  @override
  int? id;

  /// Display name, e.g. "San Francisco de Asís".
  String name;

  /// URL-friendly unique identifier, e.g. "san-francisco-de-asis".
  String slug;

  /// Short descriptor shown under the name, e.g. "Fundador de los franciscanos".
  String? title;

  /// Liturgical titles, e.g. virgen y doctora. Null is read as empty.
  List<_itutlhb1.SaintTitle>? titles;

  /// Feast day (liturgical memorial) month 1-12 and day 1-31.
  int? feastMonth;

  int? feastDay;

  /// Years of birth and death, for the timeline. Negative is BC. Many old
  /// dates are only approximate, and the flags make them read "c. 1181".
  int? birthYear;

  bool birthApprox;

  int? deathYear;

  bool deathApprox;

  /// Where they were born and where they died, for the map. The name is kept
  /// apart from the coordinates because many were born in cities or kingdoms
  /// that no longer exist: "Tagaste, Numidia" is the honest label for a point
  /// that today falls in Algeria.
  String? birthPlace;

  double? birthLat;

  double? birthLng;

  String? deathPlace;

  double? deathLat;

  double? deathLng;

  /// Biography in Markdown-ish plain text.
  String bio;

  /// A prayer to or by the saint.
  String? prayer;

  /// Path of the illustration in the public cloud storage.
  String? illustrationPath;

  /// NHF season and episode where the saint was presented.
  int? season;

  int? episode;

  /// Link to the stream fragment (YouTube URL with timestamp).
  String? youtubeUrl;

  _if2tzgnp.SaintStatus status;

  /// The six card scores (0-99).
  int catequesis;

  int escritos;

  int oracion;

  int patronazgos;

  int evangelizacion;

  int viajes;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Saint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Saint copyWith({
    int? id,
    String? name,
    String? slug,
    String? title,
    List<_itutlhb1.SaintTitle>? titles,
    int? feastMonth,
    int? feastDay,
    int? birthYear,
    bool? birthApprox,
    int? deathYear,
    bool? deathApprox,
    String? birthPlace,
    double? birthLat,
    double? birthLng,
    String? deathPlace,
    double? deathLat,
    double? deathLng,
    String? bio,
    String? prayer,
    String? illustrationPath,
    int? season,
    int? episode,
    String? youtubeUrl,
    _if2tzgnp.SaintStatus? status,
    int? catequesis,
    int? escritos,
    int? oracion,
    int? patronazgos,
    int? evangelizacion,
    int? viajes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Saint',
      if (id != null) 'id': id,
      'name': name,
      'slug': slug,
      if (title != null) 'title': title,
      if (titles != null)
        'titles': titles?.toJson(valueToJson: (v) => v.toJson()),
      if (feastMonth != null) 'feastMonth': feastMonth,
      if (feastDay != null) 'feastDay': feastDay,
      if (birthYear != null) 'birthYear': birthYear,
      'birthApprox': birthApprox,
      if (deathYear != null) 'deathYear': deathYear,
      'deathApprox': deathApprox,
      if (birthPlace != null) 'birthPlace': birthPlace,
      if (birthLat != null) 'birthLat': birthLat,
      if (birthLng != null) 'birthLng': birthLng,
      if (deathPlace != null) 'deathPlace': deathPlace,
      if (deathLat != null) 'deathLat': deathLat,
      if (deathLng != null) 'deathLng': deathLng,
      'bio': bio,
      if (prayer != null) 'prayer': prayer,
      if (illustrationPath != null) 'illustrationPath': illustrationPath,
      if (season != null) 'season': season,
      if (episode != null) 'episode': episode,
      if (youtubeUrl != null) 'youtubeUrl': youtubeUrl,
      'status': status.toJson(),
      'catequesis': catequesis,
      'escritos': escritos,
      'oracion': oracion,
      'patronazgos': patronazgos,
      'evangelizacion': evangelizacion,
      'viajes': viajes,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Saint',
      if (id != null) 'id': id,
      'name': name,
      'slug': slug,
      if (title != null) 'title': title,
      if (titles != null)
        'titles': titles?.toJson(valueToJson: (v) => v.toJson()),
      if (feastMonth != null) 'feastMonth': feastMonth,
      if (feastDay != null) 'feastDay': feastDay,
      if (birthYear != null) 'birthYear': birthYear,
      'birthApprox': birthApprox,
      if (deathYear != null) 'deathYear': deathYear,
      'deathApprox': deathApprox,
      if (birthPlace != null) 'birthPlace': birthPlace,
      if (birthLat != null) 'birthLat': birthLat,
      if (birthLng != null) 'birthLng': birthLng,
      if (deathPlace != null) 'deathPlace': deathPlace,
      if (deathLat != null) 'deathLat': deathLat,
      if (deathLng != null) 'deathLng': deathLng,
      'bio': bio,
      if (prayer != null) 'prayer': prayer,
      if (illustrationPath != null) 'illustrationPath': illustrationPath,
      if (season != null) 'season': season,
      if (episode != null) 'episode': episode,
      if (youtubeUrl != null) 'youtubeUrl': youtubeUrl,
      'status': status.toJson(),
      'catequesis': catequesis,
      'escritos': escritos,
      'oracion': oracion,
      'patronazgos': patronazgos,
      'evangelizacion': evangelizacion,
      'viajes': viajes,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static SaintInclude include() {
    return SaintInclude._();
  }

  static SaintIncludeList includeList({
    _is.WhereExpressionBuilder<SaintTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintTable>? orderBy,
    _is.OrderByListBuilder<SaintTable>? orderByList,
    SaintInclude? include,
  }) {
    return SaintIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Saint.t),
      orderByList: orderByList?.call(Saint.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SaintImpl extends Saint {
  _SaintImpl({
    int? id,
    required String name,
    required String slug,
    String? title,
    List<_itutlhb1.SaintTitle>? titles,
    int? feastMonth,
    int? feastDay,
    int? birthYear,
    bool? birthApprox,
    int? deathYear,
    bool? deathApprox,
    String? birthPlace,
    double? birthLat,
    double? birthLng,
    String? deathPlace,
    double? deathLat,
    double? deathLng,
    String? bio,
    String? prayer,
    String? illustrationPath,
    int? season,
    int? episode,
    String? youtubeUrl,
    _if2tzgnp.SaintStatus? status,
    int? catequesis,
    int? escritos,
    int? oracion,
    int? patronazgos,
    int? evangelizacion,
    int? viajes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         slug: slug,
         title: title,
         titles: titles,
         feastMonth: feastMonth,
         feastDay: feastDay,
         birthYear: birthYear,
         birthApprox: birthApprox,
         deathYear: deathYear,
         deathApprox: deathApprox,
         birthPlace: birthPlace,
         birthLat: birthLat,
         birthLng: birthLng,
         deathPlace: deathPlace,
         deathLat: deathLat,
         deathLng: deathLng,
         bio: bio,
         prayer: prayer,
         illustrationPath: illustrationPath,
         season: season,
         episode: episode,
         youtubeUrl: youtubeUrl,
         status: status,
         catequesis: catequesis,
         escritos: escritos,
         oracion: oracion,
         patronazgos: patronazgos,
         evangelizacion: evangelizacion,
         viajes: viajes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Saint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Saint copyWith({
    Object? id = _Undefined,
    String? name,
    String? slug,
    Object? title = _Undefined,
    Object? titles = _Undefined,
    Object? feastMonth = _Undefined,
    Object? feastDay = _Undefined,
    Object? birthYear = _Undefined,
    bool? birthApprox,
    Object? deathYear = _Undefined,
    bool? deathApprox,
    Object? birthPlace = _Undefined,
    Object? birthLat = _Undefined,
    Object? birthLng = _Undefined,
    Object? deathPlace = _Undefined,
    Object? deathLat = _Undefined,
    Object? deathLng = _Undefined,
    String? bio,
    Object? prayer = _Undefined,
    Object? illustrationPath = _Undefined,
    Object? season = _Undefined,
    Object? episode = _Undefined,
    Object? youtubeUrl = _Undefined,
    _if2tzgnp.SaintStatus? status,
    int? catequesis,
    int? escritos,
    int? oracion,
    int? patronazgos,
    int? evangelizacion,
    int? viajes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Saint(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      title: title is String? ? title : this.title,
      titles: titles is List<_itutlhb1.SaintTitle>?
          ? titles
          : this.titles?.map((e0) => e0).toList(),
      feastMonth: feastMonth is int? ? feastMonth : this.feastMonth,
      feastDay: feastDay is int? ? feastDay : this.feastDay,
      birthYear: birthYear is int? ? birthYear : this.birthYear,
      birthApprox: birthApprox ?? this.birthApprox,
      deathYear: deathYear is int? ? deathYear : this.deathYear,
      deathApprox: deathApprox ?? this.deathApprox,
      birthPlace: birthPlace is String? ? birthPlace : this.birthPlace,
      birthLat: birthLat is double? ? birthLat : this.birthLat,
      birthLng: birthLng is double? ? birthLng : this.birthLng,
      deathPlace: deathPlace is String? ? deathPlace : this.deathPlace,
      deathLat: deathLat is double? ? deathLat : this.deathLat,
      deathLng: deathLng is double? ? deathLng : this.deathLng,
      bio: bio ?? this.bio,
      prayer: prayer is String? ? prayer : this.prayer,
      illustrationPath: illustrationPath is String?
          ? illustrationPath
          : this.illustrationPath,
      season: season is int? ? season : this.season,
      episode: episode is int? ? episode : this.episode,
      youtubeUrl: youtubeUrl is String? ? youtubeUrl : this.youtubeUrl,
      status: status ?? this.status,
      catequesis: catequesis ?? this.catequesis,
      escritos: escritos ?? this.escritos,
      oracion: oracion ?? this.oracion,
      patronazgos: patronazgos ?? this.patronazgos,
      evangelizacion: evangelizacion ?? this.evangelizacion,
      viajes: viajes ?? this.viajes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SaintUpdateTable extends _is.UpdateTable<SaintTable> {
  SaintUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> slug(String value) => _is.ColumnValue(
    table.slug,
    value,
  );

  _is.ColumnValue<String, String> title(String? value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<List<_itutlhb1.SaintTitle>, List<_itutlhb1.SaintTitle>>
  titles(List<_itutlhb1.SaintTitle>? value) => _is.ColumnValue(
    table.titles,
    value,
  );

  _is.ColumnValue<int, int> feastMonth(int? value) => _is.ColumnValue(
    table.feastMonth,
    value,
  );

  _is.ColumnValue<int, int> feastDay(int? value) => _is.ColumnValue(
    table.feastDay,
    value,
  );

  _is.ColumnValue<int, int> birthYear(int? value) => _is.ColumnValue(
    table.birthYear,
    value,
  );

  _is.ColumnValue<bool, bool> birthApprox(bool value) => _is.ColumnValue(
    table.birthApprox,
    value,
  );

  _is.ColumnValue<int, int> deathYear(int? value) => _is.ColumnValue(
    table.deathYear,
    value,
  );

  _is.ColumnValue<bool, bool> deathApprox(bool value) => _is.ColumnValue(
    table.deathApprox,
    value,
  );

  _is.ColumnValue<String, String> birthPlace(String? value) => _is.ColumnValue(
    table.birthPlace,
    value,
  );

  _is.ColumnValue<double, double> birthLat(double? value) => _is.ColumnValue(
    table.birthLat,
    value,
  );

  _is.ColumnValue<double, double> birthLng(double? value) => _is.ColumnValue(
    table.birthLng,
    value,
  );

  _is.ColumnValue<String, String> deathPlace(String? value) => _is.ColumnValue(
    table.deathPlace,
    value,
  );

  _is.ColumnValue<double, double> deathLat(double? value) => _is.ColumnValue(
    table.deathLat,
    value,
  );

  _is.ColumnValue<double, double> deathLng(double? value) => _is.ColumnValue(
    table.deathLng,
    value,
  );

  _is.ColumnValue<String, String> bio(String value) => _is.ColumnValue(
    table.bio,
    value,
  );

  _is.ColumnValue<String, String> prayer(String? value) => _is.ColumnValue(
    table.prayer,
    value,
  );

  _is.ColumnValue<String, String> illustrationPath(String? value) =>
      _is.ColumnValue(
        table.illustrationPath,
        value,
      );

  _is.ColumnValue<int, int> season(int? value) => _is.ColumnValue(
    table.season,
    value,
  );

  _is.ColumnValue<int, int> episode(int? value) => _is.ColumnValue(
    table.episode,
    value,
  );

  _is.ColumnValue<String, String> youtubeUrl(String? value) => _is.ColumnValue(
    table.youtubeUrl,
    value,
  );

  _is.ColumnValue<_if2tzgnp.SaintStatus, _if2tzgnp.SaintStatus> status(
    _if2tzgnp.SaintStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> catequesis(int value) => _is.ColumnValue(
    table.catequesis,
    value,
  );

  _is.ColumnValue<int, int> escritos(int value) => _is.ColumnValue(
    table.escritos,
    value,
  );

  _is.ColumnValue<int, int> oracion(int value) => _is.ColumnValue(
    table.oracion,
    value,
  );

  _is.ColumnValue<int, int> patronazgos(int value) => _is.ColumnValue(
    table.patronazgos,
    value,
  );

  _is.ColumnValue<int, int> evangelizacion(int value) => _is.ColumnValue(
    table.evangelizacion,
    value,
  );

  _is.ColumnValue<int, int> viajes(int value) => _is.ColumnValue(
    table.viajes,
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
}

class SaintTable extends _is.Table<int?> {
  SaintTable({super.tableRelation}) : super(tableName: 'saint') {
    updateTable = SaintUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    slug = _is.ColumnString(
      'slug',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    titles = _is.ColumnSerializable<List<_itutlhb1.SaintTitle>>(
      'titles',
      this,
    );
    feastMonth = _is.ColumnInt(
      'feastMonth',
      this,
    );
    feastDay = _is.ColumnInt(
      'feastDay',
      this,
    );
    birthYear = _is.ColumnInt(
      'birthYear',
      this,
    );
    birthApprox = _is.ColumnBool(
      'birthApprox',
      this,
      hasDefault: true,
    );
    deathYear = _is.ColumnInt(
      'deathYear',
      this,
    );
    deathApprox = _is.ColumnBool(
      'deathApprox',
      this,
      hasDefault: true,
    );
    birthPlace = _is.ColumnString(
      'birthPlace',
      this,
    );
    birthLat = _is.ColumnDouble(
      'birthLat',
      this,
    );
    birthLng = _is.ColumnDouble(
      'birthLng',
      this,
    );
    deathPlace = _is.ColumnString(
      'deathPlace',
      this,
    );
    deathLat = _is.ColumnDouble(
      'deathLat',
      this,
    );
    deathLng = _is.ColumnDouble(
      'deathLng',
      this,
    );
    bio = _is.ColumnString(
      'bio',
      this,
      hasDefault: true,
    );
    prayer = _is.ColumnString(
      'prayer',
      this,
    );
    illustrationPath = _is.ColumnString(
      'illustrationPath',
      this,
    );
    season = _is.ColumnInt(
      'season',
      this,
    );
    episode = _is.ColumnInt(
      'episode',
      this,
    );
    youtubeUrl = _is.ColumnString(
      'youtubeUrl',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    catequesis = _is.ColumnInt(
      'catequesis',
      this,
      hasDefault: true,
    );
    escritos = _is.ColumnInt(
      'escritos',
      this,
      hasDefault: true,
    );
    oracion = _is.ColumnInt(
      'oracion',
      this,
      hasDefault: true,
    );
    patronazgos = _is.ColumnInt(
      'patronazgos',
      this,
      hasDefault: true,
    );
    evangelizacion = _is.ColumnInt(
      'evangelizacion',
      this,
      hasDefault: true,
    );
    viajes = _is.ColumnInt(
      'viajes',
      this,
      hasDefault: true,
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
  }

  late final SaintUpdateTable updateTable;

  /// Display name, e.g. "San Francisco de Asís".
  late final _is.ColumnString name;

  /// URL-friendly unique identifier, e.g. "san-francisco-de-asis".
  late final _is.ColumnString slug;

  /// Short descriptor shown under the name, e.g. "Fundador de los franciscanos".
  late final _is.ColumnString title;

  /// Liturgical titles, e.g. virgen y doctora. Null is read as empty.
  late final _is.ColumnSerializable<List<_itutlhb1.SaintTitle>> titles;

  /// Feast day (liturgical memorial) month 1-12 and day 1-31.
  late final _is.ColumnInt feastMonth;

  late final _is.ColumnInt feastDay;

  /// Years of birth and death, for the timeline. Negative is BC. Many old
  /// dates are only approximate, and the flags make them read "c. 1181".
  late final _is.ColumnInt birthYear;

  late final _is.ColumnBool birthApprox;

  late final _is.ColumnInt deathYear;

  late final _is.ColumnBool deathApprox;

  /// Where they were born and where they died, for the map. The name is kept
  /// apart from the coordinates because many were born in cities or kingdoms
  /// that no longer exist: "Tagaste, Numidia" is the honest label for a point
  /// that today falls in Algeria.
  late final _is.ColumnString birthPlace;

  late final _is.ColumnDouble birthLat;

  late final _is.ColumnDouble birthLng;

  late final _is.ColumnString deathPlace;

  late final _is.ColumnDouble deathLat;

  late final _is.ColumnDouble deathLng;

  /// Biography in Markdown-ish plain text.
  late final _is.ColumnString bio;

  /// A prayer to or by the saint.
  late final _is.ColumnString prayer;

  /// Path of the illustration in the public cloud storage.
  late final _is.ColumnString illustrationPath;

  /// NHF season and episode where the saint was presented.
  late final _is.ColumnInt season;

  late final _is.ColumnInt episode;

  /// Link to the stream fragment (YouTube URL with timestamp).
  late final _is.ColumnString youtubeUrl;

  late final _is.ColumnEnum<_if2tzgnp.SaintStatus> status;

  /// The six card scores (0-99).
  late final _is.ColumnInt catequesis;

  late final _is.ColumnInt escritos;

  late final _is.ColumnInt oracion;

  late final _is.ColumnInt patronazgos;

  late final _is.ColumnInt evangelizacion;

  late final _is.ColumnInt viajes;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    slug,
    title,
    titles,
    feastMonth,
    feastDay,
    birthYear,
    birthApprox,
    deathYear,
    deathApprox,
    birthPlace,
    birthLat,
    birthLng,
    deathPlace,
    deathLat,
    deathLng,
    bio,
    prayer,
    illustrationPath,
    season,
    episode,
    youtubeUrl,
    status,
    catequesis,
    escritos,
    oracion,
    patronazgos,
    evangelizacion,
    viajes,
    createdAt,
    updatedAt,
  ];
}

class SaintInclude extends _is.IncludeObject {
  SaintInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Saint.t;
}

class SaintIncludeList extends _is.IncludeList {
  SaintIncludeList._({
    _is.WhereExpressionBuilder<SaintTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Saint.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Saint.t;
}

class SaintRepository {
  const SaintRepository._();

  /// Returns a list of [Saint]s matching the given query parameters.
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
  Future<List<Saint>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintTable>? orderBy,
    _is.OrderByListBuilder<SaintTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Saint>(
      where: where?.call(Saint.t),
      orderBy: orderBy?.call(Saint.t),
      orderByList: orderByList?.call(Saint.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Saint] matching the given query parameters.
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
  Future<Saint?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintTable>? where,
    int? offset,
    _is.OrderByBuilder<SaintTable>? orderBy,
    _is.OrderByListBuilder<SaintTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Saint>(
      where: where?.call(Saint.t),
      orderBy: orderBy?.call(Saint.t),
      orderByList: orderByList?.call(Saint.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Saint] by its [id] or null if no such row exists.
  Future<Saint?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Saint>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Saint]s in the list and returns the inserted rows.
  ///
  /// The returned [Saint]s will have their `id` fields set.
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
  Future<List<Saint>> insert(
    _is.DatabaseSession session,
    List<Saint> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Saint>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Saint] and returns the inserted row.
  ///
  /// The returned [Saint] will have its `id` field set.
  Future<Saint> insertRow(
    _is.DatabaseSession session,
    Saint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Saint>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Saint]s in the list and returns the resulting rows.
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
  /// The returned [Saint]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Saint>> upsert(
    _is.DatabaseSession session,
    List<Saint> rows, {
    required _is.ColumnSelections<SaintTable> conflictColumns,
    _is.ColumnSelections<SaintTable>? updateColumns,
    _is.WhereExpressionBuilder<SaintTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Saint>(
      rows,
      conflictColumns: conflictColumns(Saint.t),
      updateColumns: updateColumns?.call(Saint.t),
      updateWhere: updateWhere?.call(Saint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Saint] and returns the resulting row.
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
  /// The returned [Saint] will have its `id` field set.
  Future<Saint?> upsertRow(
    _is.DatabaseSession session,
    Saint row, {
    required _is.ColumnSelections<SaintTable> conflictColumns,
    _is.ColumnSelections<SaintTable>? updateColumns,
    _is.WhereExpressionBuilder<SaintTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Saint>(
      row,
      conflictColumns: conflictColumns(Saint.t),
      updateColumns: updateColumns?.call(Saint.t),
      updateWhere: updateWhere?.call(Saint.t),
      transaction: transaction,
    );
  }

  /// Updates all [Saint]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Saint>> update(
    _is.DatabaseSession session,
    List<Saint> rows, {
    _is.ColumnSelections<SaintTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Saint>(
      rows,
      columns: columns?.call(Saint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Saint]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Saint> updateRow(
    _is.DatabaseSession session,
    Saint row, {
    _is.ColumnSelections<SaintTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Saint>(
      row,
      columns: columns?.call(Saint.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Saint] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Saint?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SaintUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Saint>(
      id,
      columnValues: columnValues(Saint.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Saint]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Saint>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SaintUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SaintTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SaintTable>? orderBy,
    _is.OrderByListBuilder<SaintTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Saint>(
      columnValues: columnValues(Saint.t.updateTable),
      where: where(Saint.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Saint.t),
      orderByList: orderByList?.call(Saint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Saint]s in the list and returns the deleted rows.
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
  Future<List<Saint>> delete(
    _is.DatabaseSession session,
    List<Saint> rows, {
    _is.OrderByBuilder<SaintTable>? orderBy,
    _is.OrderByListBuilder<SaintTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Saint>(
      rows,
      orderBy: orderBy?.call(Saint.t),
      orderByList: orderByList?.call(Saint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Saint].
  Future<Saint> deleteRow(
    _is.DatabaseSession session,
    Saint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Saint>(
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
  Future<List<Saint>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SaintTable> where,
    _is.OrderByBuilder<SaintTable>? orderBy,
    _is.OrderByListBuilder<SaintTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Saint>(
      where: where(Saint.t),
      orderBy: orderBy?.call(Saint.t),
      orderByList: orderByList?.call(Saint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SaintTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Saint>(
      where: where?.call(Saint.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Saint] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SaintTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Saint>(
      where: where(Saint.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
