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
import 'package:saints_nhf_client/src/protocol/protocol.dart' as _ipd1p8hh;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../collection/card_source.dart' as _in4697tk;
import '../saints/saint.dart' as _iz4se2fa;

/// A saint card in a user's collection.
abstract class UserSaintCard
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserSaintCard._({
    this.id,
    required this.authUserId,
    required this.saintId,
    this.saint,
    required this.source,
    DateTime? obtainedAt,
  }) : obtainedAt = obtainedAt ?? DateTime.now();

  factory UserSaintCard({
    int? id,
    required _isc.UuidValue authUserId,
    required int saintId,
    _iz4se2fa.Saint? saint,
    required _in4697tk.CardSource source,
    DateTime? obtainedAt,
  }) = _UserSaintCardImpl;

  factory UserSaintCard.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSaintCard(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      saintId: jsonSerialization['saintId'] as int,
      saint: jsonSerialization['saint'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_iz4se2fa.Saint>(
              jsonSerialization['saint'],
            ),
      source: _in4697tk.CardSource.fromJson(
        (jsonSerialization['source'] as String),
      ),
      obtainedAt: jsonSerialization['obtainedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['obtainedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  int saintId;

  _iz4se2fa.Saint? saint;

  _in4697tk.CardSource source;

  DateTime obtainedAt;

  /// Returns a shallow copy of this [UserSaintCard]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserSaintCard copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? saintId,
    _iz4se2fa.Saint? saint,
    _in4697tk.CardSource? source,
    DateTime? obtainedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSaintCard',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'saintId': saintId,
      if (saint != null) 'saint': saint?.toJson(),
      'source': source.toJson(),
      'obtainedAt': obtainedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserSaintCard',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'saintId': saintId,
      if (saint != null) 'saint': saint?.toJsonForProtocol(),
      'source': source.toJson(),
      'obtainedAt': obtainedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserSaintCardImpl extends UserSaintCard {
  _UserSaintCardImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required int saintId,
    _iz4se2fa.Saint? saint,
    required _in4697tk.CardSource source,
    DateTime? obtainedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         saintId: saintId,
         saint: saint,
         source: source,
         obtainedAt: obtainedAt,
       );

  /// Returns a shallow copy of this [UserSaintCard]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserSaintCard copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    int? saintId,
    Object? saint = _Undefined,
    _in4697tk.CardSource? source,
    DateTime? obtainedAt,
  }) {
    return UserSaintCard(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      saintId: saintId ?? this.saintId,
      saint: saint is _iz4se2fa.Saint? ? saint : this.saint?.copyWith(),
      source: source ?? this.source,
      obtainedAt: obtainedAt ?? this.obtainedAt,
    );
  }
}
