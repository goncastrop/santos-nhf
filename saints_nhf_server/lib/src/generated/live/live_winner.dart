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

/// A prize winner of a live game. Server only: the user id never leaves it;
/// players see [LiveWinnerView].
abstract class LiveWinner
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LiveWinner._({
    required this.authUserId,
    required this.name,
    required this.points,
    this.saintId,
  });

  factory LiveWinner({
    required _is.UuidValue authUserId,
    required String name,
    required int points,
    int? saintId,
  }) = _LiveWinnerImpl;

  factory LiveWinner.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveWinner(
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      name: jsonSerialization['name'] as String,
      points: jsonSerialization['points'] as int,
      saintId: jsonSerialization['saintId'] as int?,
    );
  }

  _is.UuidValue authUserId;

  String name;

  int points;

  /// Card granted, or null when the player already had the whole album.
  int? saintId;

  /// Returns a shallow copy of this [LiveWinner]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveWinner copyWith({
    _is.UuidValue? authUserId,
    String? name,
    int? points,
    int? saintId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveWinner',
      'authUserId': authUserId.toJson(),
      'name': name,
      'points': points,
      if (saintId != null) 'saintId': saintId,
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

class _Undefined {}

class _LiveWinnerImpl extends LiveWinner {
  _LiveWinnerImpl({
    required _is.UuidValue authUserId,
    required String name,
    required int points,
    int? saintId,
  }) : super._(
         authUserId: authUserId,
         name: name,
         points: points,
         saintId: saintId,
       );

  /// Returns a shallow copy of this [LiveWinner]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveWinner copyWith({
    _is.UuidValue? authUserId,
    String? name,
    int? points,
    Object? saintId = _Undefined,
  }) {
    return LiveWinner(
      authUserId: authUserId ?? this.authUserId,
      name: name ?? this.name,
      points: points ?? this.points,
      saintId: saintId is int? ? saintId : this.saintId,
    );
  }
}
