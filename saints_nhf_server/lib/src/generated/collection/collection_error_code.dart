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

enum CollectionErrorCode implements _is.SerializableModel {
  alreadyClaimedToday,
  noCardsLeft,
  saintNotFound,
  invalidCode,
  codeAlreadyUsed,
  codeExhausted,
  codeExpired;

  static CollectionErrorCode fromJson(String name) {
    switch (name) {
      case 'alreadyClaimedToday':
        return CollectionErrorCode.alreadyClaimedToday;
      case 'noCardsLeft':
        return CollectionErrorCode.noCardsLeft;
      case 'saintNotFound':
        return CollectionErrorCode.saintNotFound;
      case 'invalidCode':
        return CollectionErrorCode.invalidCode;
      case 'codeAlreadyUsed':
        return CollectionErrorCode.codeAlreadyUsed;
      case 'codeExhausted':
        return CollectionErrorCode.codeExhausted;
      case 'codeExpired':
        return CollectionErrorCode.codeExpired;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "CollectionErrorCode"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
