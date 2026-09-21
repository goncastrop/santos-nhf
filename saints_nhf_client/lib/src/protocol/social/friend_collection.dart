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
import '../saints/saint_info.dart' as _i38p9z6b;
import '../social/friend_summary.dart' as _ilr04398;

/// A friend's collection: saints only, scores stay hidden unless the caller
/// also owns the card (the client resolves that).
abstract class FriendCollection
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FriendCollection._({
    required this.friend,
    required this.saints,
  });

  factory FriendCollection({
    required _ilr04398.FriendSummary friend,
    required List<_i38p9z6b.SaintInfo> saints,
  }) = _FriendCollectionImpl;

  factory FriendCollection.fromJson(Map<String, dynamic> jsonSerialization) {
    return FriendCollection(
      friend: _ipd1p8hh.Protocol().deserialize<_ilr04398.FriendSummary>(
        jsonSerialization['friend'],
      ),
      saints: _ipd1p8hh.Protocol().deserialize<List<_i38p9z6b.SaintInfo>>(
        jsonSerialization['saints'],
      ),
    );
  }

  _ilr04398.FriendSummary friend;

  List<_i38p9z6b.SaintInfo> saints;

  /// Returns a shallow copy of this [FriendCollection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FriendCollection copyWith({
    _ilr04398.FriendSummary? friend,
    List<_i38p9z6b.SaintInfo>? saints,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FriendCollection',
      'friend': friend.toJson(),
      'saints': saints.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FriendCollection',
      'friend': friend.toJsonForProtocol(),
      'saints': saints.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _FriendCollectionImpl extends FriendCollection {
  _FriendCollectionImpl({
    required _ilr04398.FriendSummary friend,
    required List<_i38p9z6b.SaintInfo> saints,
  }) : super._(
         friend: friend,
         saints: saints,
       );

  /// Returns a shallow copy of this [FriendCollection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FriendCollection copyWith({
    _ilr04398.FriendSummary? friend,
    List<_i38p9z6b.SaintInfo>? saints,
  }) {
    return FriendCollection(
      friend: friend ?? this.friend.copyWith(),
      saints: saints ?? this.saints.map((e0) => e0.copyWith()).toList(),
    );
  }
}
