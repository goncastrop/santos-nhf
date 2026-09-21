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

/// Whether the current user has admin access.
abstract class AdminAccess
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminAccess._({
    required this.isAdmin,
    this.email,
  });

  factory AdminAccess({
    required bool isAdmin,
    String? email,
  }) = _AdminAccessImpl;

  factory AdminAccess.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAccess(
      isAdmin: _is.BoolJsonExtension.fromJson(jsonSerialization['isAdmin']),
      email: jsonSerialization['email'] as String?,
    );
  }

  bool isAdmin;

  String? email;

  /// Returns a shallow copy of this [AdminAccess]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminAccess copyWith({
    bool? isAdmin,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAccess',
      'isAdmin': isAdmin,
      if (email != null) 'email': email,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAccess',
      'isAdmin': isAdmin,
      if (email != null) 'email': email,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAccessImpl extends AdminAccess {
  _AdminAccessImpl({
    required bool isAdmin,
    String? email,
  }) : super._(
         isAdmin: isAdmin,
         email: email,
       );

  /// Returns a shallow copy of this [AdminAccess]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminAccess copyWith({
    bool? isAdmin,
    Object? email = _Undefined,
  }) {
    return AdminAccess(
      isAdmin: isAdmin ?? this.isAdmin,
      email: email is String? ? email : this.email,
    );
  }
}
