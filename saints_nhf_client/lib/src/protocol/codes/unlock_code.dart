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

/// A code handed out during the stream that unlocks a card.
abstract class UnlockCode
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UnlockCode._({
    this.id,
    required this.code,
    this.saintId,
    this.maxUses,
    int? uses,
    this.expiresAt,
    bool? active,
    this.note,
    DateTime? createdAt,
  }) : uses = uses ?? 0,
       active = active ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory UnlockCode({
    int? id,
    required String code,
    int? saintId,
    int? maxUses,
    int? uses,
    DateTime? expiresAt,
    bool? active,
    String? note,
    DateTime? createdAt,
  }) = _UnlockCodeImpl;

  factory UnlockCode.fromJson(Map<String, dynamic> jsonSerialization) {
    return UnlockCode(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      saintId: jsonSerialization['saintId'] as int?,
      maxUses: jsonSerialization['maxUses'] as int?,
      uses: jsonSerialization['uses'] as int?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      active: jsonSerialization['active'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
      note: jsonSerialization['note'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  /// Null grants a random card the player is missing.
  int? saintId;

  /// Null means unlimited.
  int? maxUses;

  int uses;

  DateTime? expiresAt;

  bool active;

  String? note;

  DateTime createdAt;

  /// Returns a shallow copy of this [UnlockCode]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UnlockCode copyWith({
    int? id,
    String? code,
    int? saintId,
    int? maxUses,
    int? uses,
    DateTime? expiresAt,
    bool? active,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UnlockCode',
      if (id != null) 'id': id,
      'code': code,
      if (saintId != null) 'saintId': saintId,
      if (maxUses != null) 'maxUses': maxUses,
      'uses': uses,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'active': active,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UnlockCode',
      if (id != null) 'id': id,
      'code': code,
      if (saintId != null) 'saintId': saintId,
      if (maxUses != null) 'maxUses': maxUses,
      'uses': uses,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'active': active,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UnlockCodeImpl extends UnlockCode {
  _UnlockCodeImpl({
    int? id,
    required String code,
    int? saintId,
    int? maxUses,
    int? uses,
    DateTime? expiresAt,
    bool? active,
    String? note,
    DateTime? createdAt,
  }) : super._(
         id: id,
         code: code,
         saintId: saintId,
         maxUses: maxUses,
         uses: uses,
         expiresAt: expiresAt,
         active: active,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UnlockCode]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UnlockCode copyWith({
    Object? id = _Undefined,
    String? code,
    Object? saintId = _Undefined,
    Object? maxUses = _Undefined,
    int? uses,
    Object? expiresAt = _Undefined,
    bool? active,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return UnlockCode(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      saintId: saintId is int? ? saintId : this.saintId,
      maxUses: maxUses is int? ? maxUses : this.maxUses,
      uses: uses ?? this.uses,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      active: active ?? this.active,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
