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
import 'package:saints_nhf_server/src/generated/protocol.dart' as _itw3ru38;
import 'package:serverpod/serverpod.dart' as _is;
import '../live/live_winner.dart' as _iryjiuzv;

/// Who won the prizes of a finished live game. Kept inside the game row.
abstract class LiveResults
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LiveResults._({
    required this.fast,
    required this.raffle,
  });

  factory LiveResults({
    required List<_iryjiuzv.LiveWinner> fast,
    required List<_iryjiuzv.LiveWinner> raffle,
  }) = _LiveResultsImpl;

  factory LiveResults.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveResults(
      fast: _itw3ru38.Protocol().deserialize<List<_iryjiuzv.LiveWinner>>(
        jsonSerialization['fast'],
      ),
      raffle: _itw3ru38.Protocol().deserialize<List<_iryjiuzv.LiveWinner>>(
        jsonSerialization['raffle'],
      ),
    );
  }

  List<_iryjiuzv.LiveWinner> fast;

  List<_iryjiuzv.LiveWinner> raffle;

  /// Returns a shallow copy of this [LiveResults]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveResults copyWith({
    List<_iryjiuzv.LiveWinner>? fast,
    List<_iryjiuzv.LiveWinner>? raffle,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveResults',
      'fast': fast.toJson(valueToJson: (v) => v.toJson()),
      'raffle': raffle.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LiveResultsImpl extends LiveResults {
  _LiveResultsImpl({
    required List<_iryjiuzv.LiveWinner> fast,
    required List<_iryjiuzv.LiveWinner> raffle,
  }) : super._(
         fast: fast,
         raffle: raffle,
       );

  /// Returns a shallow copy of this [LiveResults]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveResults copyWith({
    List<_iryjiuzv.LiveWinner>? fast,
    List<_iryjiuzv.LiveWinner>? raffle,
  }) {
    return LiveResults(
      fast: fast ?? this.fast.map((e0) => e0.copyWith()).toList(),
      raffle: raffle ?? this.raffle.map((e0) => e0.copyWith()).toList(),
    );
  }
}
