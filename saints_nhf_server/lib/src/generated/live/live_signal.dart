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

/// Posted on the live channel whenever the game changes, so every open
/// stream sends its viewer a fresh [LiveView].
abstract class LiveSignal
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LiveSignal._({required this.version});

  factory LiveSignal({required int version}) = _LiveSignalImpl;

  factory LiveSignal.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveSignal(version: jsonSerialization['version'] as int);
  }

  int version;

  /// Returns a shallow copy of this [LiveSignal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveSignal copyWith({int? version});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveSignal',
      'version': version,
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

class _LiveSignalImpl extends LiveSignal {
  _LiveSignalImpl({required int version}) : super._(version: version);

  /// Returns a shallow copy of this [LiveSignal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveSignal copyWith({int? version}) {
    return LiveSignal(version: version ?? this.version);
  }
}
