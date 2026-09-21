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

/// Who redeemed which code, so each player redeems a code once.
abstract class UnlockRedemption
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UnlockRedemption._({
    this.id,
    required this.codeId,
    required this.authUserId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UnlockRedemption({
    int? id,
    required int codeId,
    required _isc.UuidValue authUserId,
    DateTime? createdAt,
  }) = _UnlockRedemptionImpl;

  factory UnlockRedemption.fromJson(Map<String, dynamic> jsonSerialization) {
    return UnlockRedemption(
      id: jsonSerialization['id'] as int?,
      codeId: jsonSerialization['codeId'] as int,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int codeId;

  _isc.UuidValue authUserId;

  DateTime createdAt;

  /// Returns a shallow copy of this [UnlockRedemption]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UnlockRedemption copyWith({
    int? id,
    int? codeId,
    _isc.UuidValue? authUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UnlockRedemption',
      if (id != null) 'id': id,
      'codeId': codeId,
      'authUserId': authUserId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UnlockRedemption',
      if (id != null) 'id': id,
      'codeId': codeId,
      'authUserId': authUserId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UnlockRedemptionImpl extends UnlockRedemption {
  _UnlockRedemptionImpl({
    int? id,
    required int codeId,
    required _isc.UuidValue authUserId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         codeId: codeId,
         authUserId: authUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UnlockRedemption]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UnlockRedemption copyWith({
    Object? id = _Undefined,
    int? codeId,
    _isc.UuidValue? authUserId,
    DateTime? createdAt,
  }) {
    return UnlockRedemption(
      id: id is int? ? id : this.id,
      codeId: codeId ?? this.codeId,
      authUserId: authUserId ?? this.authUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
