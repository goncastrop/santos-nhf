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

/// The six card scores of a saint (0-99).
abstract class SaintScores
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SaintScores._({
    required this.catequesis,
    required this.escritos,
    required this.oracion,
    required this.patronazgos,
    required this.evangelizacion,
    required this.viajes,
  });

  factory SaintScores({
    required int catequesis,
    required int escritos,
    required int oracion,
    required int patronazgos,
    required int evangelizacion,
    required int viajes,
  }) = _SaintScoresImpl;

  factory SaintScores.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaintScores(
      catequesis: jsonSerialization['catequesis'] as int,
      escritos: jsonSerialization['escritos'] as int,
      oracion: jsonSerialization['oracion'] as int,
      patronazgos: jsonSerialization['patronazgos'] as int,
      evangelizacion: jsonSerialization['evangelizacion'] as int,
      viajes: jsonSerialization['viajes'] as int,
    );
  }

  int catequesis;

  int escritos;

  int oracion;

  int patronazgos;

  int evangelizacion;

  int viajes;

  /// Returns a shallow copy of this [SaintScores]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SaintScores copyWith({
    int? catequesis,
    int? escritos,
    int? oracion,
    int? patronazgos,
    int? evangelizacion,
    int? viajes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaintScores',
      'catequesis': catequesis,
      'escritos': escritos,
      'oracion': oracion,
      'patronazgos': patronazgos,
      'evangelizacion': evangelizacion,
      'viajes': viajes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaintScores',
      'catequesis': catequesis,
      'escritos': escritos,
      'oracion': oracion,
      'patronazgos': patronazgos,
      'evangelizacion': evangelizacion,
      'viajes': viajes,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SaintScoresImpl extends SaintScores {
  _SaintScoresImpl({
    required int catequesis,
    required int escritos,
    required int oracion,
    required int patronazgos,
    required int evangelizacion,
    required int viajes,
  }) : super._(
         catequesis: catequesis,
         escritos: escritos,
         oracion: oracion,
         patronazgos: patronazgos,
         evangelizacion: evangelizacion,
         viajes: viajes,
       );

  /// Returns a shallow copy of this [SaintScores]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SaintScores copyWith({
    int? catequesis,
    int? escritos,
    int? oracion,
    int? patronazgos,
    int? evangelizacion,
    int? viajes,
  }) {
    return SaintScores(
      catequesis: catequesis ?? this.catequesis,
      escritos: escritos ?? this.escritos,
      oracion: oracion ?? this.oracion,
      patronazgos: patronazgos ?? this.patronazgos,
      evangelizacion: evangelizacion ?? this.evangelizacion,
      viajes: viajes ?? this.viajes,
    );
  }
}
