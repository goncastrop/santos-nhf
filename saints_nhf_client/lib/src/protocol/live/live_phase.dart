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

/// Where a live game stands, as everyone watching sees it.
enum LivePhase implements _isc.SerializableModel {
  /// No game going on.
  idle,

  /// Waiting for the next question to open: the lobby before the first one,
  /// and the short "get ready" before each of the others.
  countdown,

  /// A question is open and answers count.
  question,

  /// The question closed: the right answer, the tally and the partial
  /// ranking stay on screen until the admin moves on.
  reveal,

  /// Podium and prizes. Shown for a while after the end, then idle again.
  finished,

  /// Called off by the admin.
  cancelled;

  static LivePhase fromJson(String name) {
    switch (name) {
      case 'idle':
        return LivePhase.idle;
      case 'countdown':
        return LivePhase.countdown;
      case 'question':
        return LivePhase.question;
      case 'reveal':
        return LivePhase.reveal;
      case 'finished':
        return LivePhase.finished;
      case 'cancelled':
        return LivePhase.cancelled;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "LivePhase"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
