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

enum DuelStatus implements _is.SerializableModel {
  /// Waiting for the opponent to accept and pick a deck.
  pendingDeck,
  active,
  finished,
  declined;

  static DuelStatus fromJson(String name) {
    switch (name) {
      case 'pendingDeck':
        return DuelStatus.pendingDeck;
      case 'active':
        return DuelStatus.active;
      case 'finished':
        return DuelStatus.finished;
      case 'declined':
        return DuelStatus.declined;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DuelStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
