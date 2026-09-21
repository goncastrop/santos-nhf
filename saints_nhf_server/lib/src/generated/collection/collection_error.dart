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
import '../collection/collection_error_code.dart' as _iaoro63m;

/// Thrown by the collection endpoint when a claim is not possible.
abstract class CollectionException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  CollectionException._({
    required this.message,
    required this.code,
  });

  factory CollectionException({
    required String message,
    required _iaoro63m.CollectionErrorCode code,
  }) = _CollectionExceptionImpl;

  factory CollectionException.fromJson(Map<String, dynamic> jsonSerialization) {
    return CollectionException(
      message: jsonSerialization['message'] as String,
      code: _iaoro63m.CollectionErrorCode.fromJson(
        (jsonSerialization['code'] as String),
      ),
    );
  }

  String message;

  _iaoro63m.CollectionErrorCode code;

  /// Returns a shallow copy of this [CollectionException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CollectionException copyWith({
    String? message,
    _iaoro63m.CollectionErrorCode? code,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CollectionException',
      'message': message,
      'code': code.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CollectionException',
      'message': message,
      'code': code.toJson(),
    };
  }

  @override
  String toString() {
    return 'CollectionException(message: $message, code: $code)';
  }
}

class _CollectionExceptionImpl extends CollectionException {
  _CollectionExceptionImpl({
    required String message,
    required _iaoro63m.CollectionErrorCode code,
  }) : super._(
         message: message,
         code: code,
       );

  /// Returns a shallow copy of this [CollectionException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CollectionException copyWith({
    String? message,
    _iaoro63m.CollectionErrorCode? code,
  }) {
    return CollectionException(
      message: message ?? this.message,
      code: code ?? this.code,
    );
  }
}
