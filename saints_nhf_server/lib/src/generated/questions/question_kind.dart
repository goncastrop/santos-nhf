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

/// Where a question comes from.
enum QuestionKind implements _is.SerializableModel {
  /// Typed by an admin, from the panel or a CSV.
  manual,

  /// "¿De quién fue contemporáneo…?", built from the years of the catalog by
  /// `ContemporaryQuestions` and rebuilt when those years change. Never
  /// edited by hand.
  contemporary;

  static QuestionKind fromJson(String name) {
    switch (name) {
      case 'manual':
        return QuestionKind.manual;
      case 'contemporary':
        return QuestionKind.contemporary;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "QuestionKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
