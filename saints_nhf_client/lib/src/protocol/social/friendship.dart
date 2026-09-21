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

/// Two players who added each other. Stored once, with the lower uuid first.
abstract class Friendship
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Friendship._({
    this.id,
    required this.playerA,
    required this.playerB,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Friendship({
    int? id,
    required _isc.UuidValue playerA,
    required _isc.UuidValue playerB,
    DateTime? createdAt,
  }) = _FriendshipImpl;

  factory Friendship.fromJson(Map<String, dynamic> jsonSerialization) {
    return Friendship(
      id: jsonSerialization['id'] as int?,
      playerA: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['playerA'],
      ),
      playerB: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['playerB'],
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

  _isc.UuidValue playerA;

  _isc.UuidValue playerB;

  DateTime createdAt;

  /// Returns a shallow copy of this [Friendship]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Friendship copyWith({
    int? id,
    _isc.UuidValue? playerA,
    _isc.UuidValue? playerB,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Friendship',
      if (id != null) 'id': id,
      'playerA': playerA.toJson(),
      'playerB': playerB.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Friendship',
      if (id != null) 'id': id,
      'playerA': playerA.toJson(),
      'playerB': playerB.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FriendshipImpl extends Friendship {
  _FriendshipImpl({
    int? id,
    required _isc.UuidValue playerA,
    required _isc.UuidValue playerB,
    DateTime? createdAt,
  }) : super._(
         id: id,
         playerA: playerA,
         playerB: playerB,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Friendship]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Friendship copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? playerA,
    _isc.UuidValue? playerB,
    DateTime? createdAt,
  }) {
    return Friendship(
      id: id is int? ? id : this.id,
      playerA: playerA ?? this.playerA,
      playerB: playerB ?? this.playerB,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
