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

/// A user with admin access.
abstract class AdminUser
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminUser._({
    required this.authUserId,
    this.email,
  });

  factory AdminUser({
    required _isc.UuidValue authUserId,
    String? email,
  }) = _AdminUserImpl;

  factory AdminUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUser(
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      email: jsonSerialization['email'] as String?,
    );
  }

  _isc.UuidValue authUserId;

  String? email;

  /// Returns a shallow copy of this [AdminUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminUser copyWith({
    _isc.UuidValue? authUserId,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUser',
      'authUserId': authUserId.toJson(),
      if (email != null) 'email': email,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUser',
      'authUserId': authUserId.toJson(),
      if (email != null) 'email': email,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUserImpl extends AdminUser {
  _AdminUserImpl({
    required _isc.UuidValue authUserId,
    String? email,
  }) : super._(
         authUserId: authUserId,
         email: email,
       );

  /// Returns a shallow copy of this [AdminUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminUser copyWith({
    _isc.UuidValue? authUserId,
    Object? email = _Undefined,
  }) {
    return AdminUser(
      authUserId: authUserId ?? this.authUserId,
      email: email is String? ? email : this.email,
    );
  }
}
