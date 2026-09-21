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

/// The five cards a player brings to a duel.
abstract class DuelDeck
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DuelDeck._({
    this.id,
    required this.duelId,
    required this.playerId,
    required this.saintIds,
    required this.usedSaintIds,
  });

  factory DuelDeck({
    int? id,
    required int duelId,
    required _isc.UuidValue playerId,
    required List<int> saintIds,
    required List<int> usedSaintIds,
  }) = _DuelDeckImpl;

  factory DuelDeck.fromJson(Map<String, dynamic> jsonSerialization) {
    return DuelDeck(
      id: jsonSerialization['id'] as int?,
      duelId: jsonSerialization['duelId'] as int,
      playerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['playerId'],
      ),
      saintIds: _ipd1p8hh.Protocol().deserialize<List<int>>(
        jsonSerialization['saintIds'],
      ),
      usedSaintIds: _ipd1p8hh.Protocol().deserialize<List<int>>(
        jsonSerialization['usedSaintIds'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int duelId;

  _isc.UuidValue playerId;

  List<int> saintIds;

  List<int> usedSaintIds;

  /// Returns a shallow copy of this [DuelDeck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DuelDeck copyWith({
    int? id,
    int? duelId,
    _isc.UuidValue? playerId,
    List<int>? saintIds,
    List<int>? usedSaintIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuelDeck',
      if (id != null) 'id': id,
      'duelId': duelId,
      'playerId': playerId.toJson(),
      'saintIds': saintIds.toJson(),
      'usedSaintIds': usedSaintIds.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DuelDeck',
      if (id != null) 'id': id,
      'duelId': duelId,
      'playerId': playerId.toJson(),
      'saintIds': saintIds.toJson(),
      'usedSaintIds': usedSaintIds.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelDeckImpl extends DuelDeck {
  _DuelDeckImpl({
    int? id,
    required int duelId,
    required _isc.UuidValue playerId,
    required List<int> saintIds,
    required List<int> usedSaintIds,
  }) : super._(
         id: id,
         duelId: duelId,
         playerId: playerId,
         saintIds: saintIds,
         usedSaintIds: usedSaintIds,
       );

  /// Returns a shallow copy of this [DuelDeck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DuelDeck copyWith({
    Object? id = _Undefined,
    int? duelId,
    _isc.UuidValue? playerId,
    List<int>? saintIds,
    List<int>? usedSaintIds,
  }) {
    return DuelDeck(
      id: id is int? ? id : this.id,
      duelId: duelId ?? this.duelId,
      playerId: playerId ?? this.playerId,
      saintIds: saintIds ?? this.saintIds.map((e0) => e0).toList(),
      usedSaintIds: usedSaintIds ?? this.usedSaintIds.map((e0) => e0).toList(),
    );
  }
}
