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

/// Posted when a duel changes, so the open streams of both players send a
/// fresh view instead of waiting for the next poll.
abstract class DuelSignal
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DuelSignal._({required this.duelId});

  factory DuelSignal({required int duelId}) = _DuelSignalImpl;

  factory DuelSignal.fromJson(Map<String, dynamic> jsonSerialization) {
    return DuelSignal(duelId: jsonSerialization['duelId'] as int);
  }

  int duelId;

  /// Returns a shallow copy of this [DuelSignal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DuelSignal copyWith({int? duelId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuelSignal',
      'duelId': duelId,
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

class _DuelSignalImpl extends DuelSignal {
  _DuelSignalImpl({required int duelId}) : super._(duelId: duelId);

  /// Returns a shallow copy of this [DuelSignal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DuelSignal copyWith({int? duelId}) {
    return DuelSignal(duelId: duelId ?? this.duelId);
  }
}
