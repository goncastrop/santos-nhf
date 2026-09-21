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
import 'package:saints_nhf_client/src/protocol/protocol.dart' as _ipd1p8hh;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../saints/saint_status.dart' as _if2tzgnp;
import '../saints/saint_title.dart' as _itutlhb1;

/// A saint of the "santo del día" section, with the six card scores.
/// Only returned to admins; public clients receive [SaintInfo] and, once the
/// card is in their collection, [SaintScores].
abstract class Saint
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _ipd1p8hh.Protocol().deserialize<List<_itutlhb1.SaintTitle>>(
              jsonSerialization['titles'],
            ),
      feastMonth: jsonSerialization['feastMonth'] as int?,
      feastDay: jsonSerialization['feastDay'] as int?,
      birthYear: jsonSerialization['birthYear'] as int?,
      birthApprox: jsonSerialization['birthApprox'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['birthApprox']),
      deathYear: jsonSerialization['deathYear'] as int?,
      deathApprox: jsonSerialization['deathApprox'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['deathApprox']),
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
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  /// Returns a shallow copy of this [Saint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
