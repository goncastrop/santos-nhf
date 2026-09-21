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

abstract class LeaderboardEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LeaderboardEntry._({
    required this.authUserId,
    required this.displayName,
    required this.value,
    required this.isMe,
    required this.isFriend,
  });

  factory LeaderboardEntry({
    required _is.UuidValue authUserId,
    required String displayName,
    required int value,
    required bool isMe,
    required bool isFriend,
  }) = _LeaderboardEntryImpl;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return LeaderboardEntry(
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      value: jsonSerialization['value'] as int,
      isMe: _is.BoolJsonExtension.fromJson(jsonSerialization['isMe']),
      isFriend: _is.BoolJsonExtension.fromJson(jsonSerialization['isFriend']),
    );
  }

  _is.UuidValue authUserId;

  String displayName;

  int value;

  bool isMe;

  bool isFriend;

  /// Returns a shallow copy of this [LeaderboardEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LeaderboardEntry copyWith({
    _is.UuidValue? authUserId,
    String? displayName,
    int? value,
    bool? isMe,
    bool? isFriend,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LeaderboardEntry',
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'value': value,
      'isMe': isMe,
      'isFriend': isFriend,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LeaderboardEntry',
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'value': value,
      'isMe': isMe,
      'isFriend': isFriend,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LeaderboardEntryImpl extends LeaderboardEntry {
  _LeaderboardEntryImpl({
    required _is.UuidValue authUserId,
    required String displayName,
    required int value,
    required bool isMe,
    required bool isFriend,
  }) : super._(
         authUserId: authUserId,
         displayName: displayName,
         value: value,
         isMe: isMe,
         isFriend: isFriend,
       );

  /// Returns a shallow copy of this [LeaderboardEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LeaderboardEntry copyWith({
    _is.UuidValue? authUserId,
    String? displayName,
    int? value,
    bool? isMe,
    bool? isFriend,
  }) {
    return LeaderboardEntry(
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      value: value ?? this.value,
      isMe: isMe ?? this.isMe,
      isFriend: isFriend ?? this.isFriend,
    );
  }
}
