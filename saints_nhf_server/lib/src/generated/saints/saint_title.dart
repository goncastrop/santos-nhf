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

/// Liturgical titles a saint is presented with, e.g. "virgen y mártir".
/// Ordered by how distinctive they are: the first one a saint has is the one
/// shown on the card emblem.
enum SaintTitle implements _is.SerializableModel {
  doctor,
  apostol,
  evangelista,
  papa,
  obispo,
  presbitero,
  diacono,
  martir,
  virgen,
  fundador,
  religioso,
  misionero,
  confesor,
  laico;

  static SaintTitle fromJson(String name) {
    switch (name) {
      case 'doctor':
        return SaintTitle.doctor;
      case 'apostol':
        return SaintTitle.apostol;
      case 'evangelista':
        return SaintTitle.evangelista;
      case 'papa':
        return SaintTitle.papa;
      case 'obispo':
        return SaintTitle.obispo;
      case 'presbitero':
        return SaintTitle.presbitero;
      case 'diacono':
        return SaintTitle.diacono;
      case 'martir':
        return SaintTitle.martir;
      case 'virgen':
        return SaintTitle.virgen;
      case 'fundador':
        return SaintTitle.fundador;
      case 'religioso':
        return SaintTitle.religioso;
      case 'misionero':
        return SaintTitle.misionero;
      case 'confesor':
        return SaintTitle.confesor;
      case 'laico':
        return SaintTitle.laico;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SaintTitle"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
