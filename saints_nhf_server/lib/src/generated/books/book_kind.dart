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

/// What a recommended book is, in relation to the saint. Ordered so that the
/// saint's own writings come first: the ficha groups the first three under
/// "escritos del santo" and the rest under "libros sobre él".
enum BookKind implements _is.SerializableModel {
  obra,
  autobiografia,
  compilado,
  biografia,
  estudio,
  novela,
  infantil;

  static BookKind fromJson(String name) {
    switch (name) {
      case 'obra':
        return BookKind.obra;
      case 'autobiografia':
        return BookKind.autobiografia;
      case 'compilado':
        return BookKind.compilado;
      case 'biografia':
        return BookKind.biografia;
      case 'estudio':
        return BookKind.estudio;
      case 'novela':
        return BookKind.novela;
      case 'infantil':
        return BookKind.infantil;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "BookKind"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
