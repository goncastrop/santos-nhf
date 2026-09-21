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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// What the caller has to do next in a duel.
enum DuelPhase implements _isc.SerializableModel {
  chooseDeck,
  waitingOpponentDeck,
  attack,
  defend,
  answer,
  waitingOpponent,
  finished,
  declined;

  static DuelPhase fromJson(String name) {
    switch (name) {
      case 'chooseDeck':
        return DuelPhase.chooseDeck;
      case 'waitingOpponentDeck':
        return DuelPhase.waitingOpponentDeck;
      case 'attack':
        return DuelPhase.attack;
      case 'defend':
        return DuelPhase.defend;
      case 'answer':
        return DuelPhase.answer;
      case 'waitingOpponent':
        return DuelPhase.waitingOpponent;
      case 'finished':
        return DuelPhase.finished;
      case 'declined':
        return DuelPhase.declined;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "DuelPhase"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
