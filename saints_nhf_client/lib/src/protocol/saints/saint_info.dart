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
import '../saints/saint_title.dart' as _itutlhb1;

/// Public information about a saint: everything except the card scores.
abstract class SaintInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SaintInfo._({
    required this.id,
    required this.name,
    required this.slug,
    this.title,
    this.titles,
    this.feastMonth,
    this.feastDay,
    this.birthYear,
    required this.birthApprox,
    this.deathYear,
    required this.deathApprox,
    this.birthPlace,
    this.birthLat,
    this.birthLng,
    this.deathPlace,
    this.deathLat,
    this.deathLng,
    required this.bio,
    this.prayer,
    this.illustrationUrl,
    this.season,
    this.episode,
    this.youtubeUrl,
  });

  factory SaintInfo({
    required int id,
    required String name,
    required String slug,
    String? title,
    List<_itutlhb1.SaintTitle>? titles,
    int? feastMonth,
    int? feastDay,
    int? birthYear,
    required bool birthApprox,
    int? deathYear,
    required bool deathApprox,
    String? birthPlace,
    double? birthLat,
    double? birthLng,
    String? deathPlace,
    double? deathLat,
    double? deathLng,
    required String bio,
    String? prayer,
    String? illustrationUrl,
    int? season,
    int? episode,
    String? youtubeUrl,
  }) = _SaintInfoImpl;

  factory SaintInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaintInfo(
      id: jsonSerialization['id'] as int,
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
      birthApprox: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['birthApprox'],
      ),
      deathYear: jsonSerialization['deathYear'] as int?,
      deathApprox: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['deathApprox'],
      ),
      birthPlace: jsonSerialization['birthPlace'] as String?,
      birthLat: (jsonSerialization['birthLat'] as num?)?.toDouble(),
      birthLng: (jsonSerialization['birthLng'] as num?)?.toDouble(),
      deathPlace: jsonSerialization['deathPlace'] as String?,
      deathLat: (jsonSerialization['deathLat'] as num?)?.toDouble(),
      deathLng: (jsonSerialization['deathLng'] as num?)?.toDouble(),
      bio: jsonSerialization['bio'] as String,
      prayer: jsonSerialization['prayer'] as String?,
      illustrationUrl: jsonSerialization['illustrationUrl'] as String?,
      season: jsonSerialization['season'] as int?,
      episode: jsonSerialization['episode'] as int?,
      youtubeUrl: jsonSerialization['youtubeUrl'] as String?,
    );
  }

  int id;

  String name;

  String slug;

  String? title;

  List<_itutlhb1.SaintTitle>? titles;

  int? feastMonth;

  int? feastDay;

  int? birthYear;

  bool birthApprox;

  int? deathYear;

  bool deathApprox;

  String? birthPlace;

  double? birthLat;

  double? birthLng;

  String? deathPlace;

  double? deathLat;

  double? deathLng;

  String bio;

  String? prayer;

  String? illustrationUrl;

  int? season;

  int? episode;

  String? youtubeUrl;

  /// Returns a shallow copy of this [SaintInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SaintInfo copyWith({
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
    String? illustrationUrl,
    int? season,
    int? episode,
    String? youtubeUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaintInfo',
      'id': id,
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
      if (illustrationUrl != null) 'illustrationUrl': illustrationUrl,
      if (season != null) 'season': season,
      if (episode != null) 'episode': episode,
      if (youtubeUrl != null) 'youtubeUrl': youtubeUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaintInfo',
      'id': id,
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
      if (illustrationUrl != null) 'illustrationUrl': illustrationUrl,
      if (season != null) 'season': season,
      if (episode != null) 'episode': episode,
      if (youtubeUrl != null) 'youtubeUrl': youtubeUrl,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SaintInfoImpl extends SaintInfo {
  _SaintInfoImpl({
    required int id,
    required String name,
    required String slug,
    String? title,
    List<_itutlhb1.SaintTitle>? titles,
    int? feastMonth,
    int? feastDay,
    int? birthYear,
    required bool birthApprox,
    int? deathYear,
    required bool deathApprox,
    String? birthPlace,
    double? birthLat,
    double? birthLng,
    String? deathPlace,
    double? deathLat,
    double? deathLng,
    required String bio,
    String? prayer,
    String? illustrationUrl,
    int? season,
    int? episode,
    String? youtubeUrl,
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
         illustrationUrl: illustrationUrl,
         season: season,
         episode: episode,
         youtubeUrl: youtubeUrl,
       );

  /// Returns a shallow copy of this [SaintInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SaintInfo copyWith({
    int? id,
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
    Object? illustrationUrl = _Undefined,
    Object? season = _Undefined,
    Object? episode = _Undefined,
    Object? youtubeUrl = _Undefined,
  }) {
    return SaintInfo(
      id: id ?? this.id,
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
      illustrationUrl: illustrationUrl is String?
          ? illustrationUrl
          : this.illustrationUrl,
      season: season is int? ? season : this.season,
      episode: episode is int? ? episode : this.episode,
      youtubeUrl: youtubeUrl is String? ? youtubeUrl : this.youtubeUrl,
    );
  }
}
