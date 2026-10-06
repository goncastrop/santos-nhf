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

/// A row of the live ranking.
abstract class LiveRankEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LiveRankEntry._({
    required this.rank,
    required this.name,
    required this.points,
    required this.isMe,
  });

  factory LiveRankEntry({
    required int rank,
    required String name,
    required int points,
    required bool isMe,
  }) = _LiveRankEntryImpl;

  factory LiveRankEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveRankEntry(
      rank: jsonSerialization['rank'] as int,
      name: jsonSerialization['name'] as String,
      points: jsonSerialization['points'] as int,
      isMe: _is.BoolJsonExtension.fromJson(jsonSerialization['isMe']),
    );
  }

  int rank;

  String name;

  int points;

  bool isMe;

  /// Returns a shallow copy of this [LiveRankEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveRankEntry copyWith({
    int? rank,
    String? name,
    int? points,
    bool? isMe,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveRankEntry',
      'rank': rank,
      'name': name,
      'points': points,
      'isMe': isMe,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LiveRankEntry',
      'rank': rank,
      'name': name,
      'points': points,
      'isMe': isMe,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LiveRankEntryImpl extends LiveRankEntry {
  _LiveRankEntryImpl({
    required int rank,
    required String name,
    required int points,
    required bool isMe,
  }) : super._(
         rank: rank,
         name: name,
         points: points,
         isMe: isMe,
       );

  /// Returns a shallow copy of this [LiveRankEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveRankEntry copyWith({
    int? rank,
    String? name,
    int? points,
    bool? isMe,
  }) {
    return LiveRankEntry(
      rank: rank ?? this.rank,
      name: name ?? this.name,
      points: points ?? this.points,
      isMe: isMe ?? this.isMe,
    );
  }
}
