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

/// Two saints who met in life, e.g. San Juan Pablo II and Santa Teresa de
/// Calcuta. It goes both ways, so each pair is stored once, with the lower
/// saint id first (see `MeetingService.pair`).
abstract class SaintMeeting
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SaintMeeting._({
    this.id,
    required this.saintAId,
    required this.saintBId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SaintMeeting({
    int? id,
    required int saintAId,
    required int saintBId,
    DateTime? createdAt,
  }) = _SaintMeetingImpl;

  factory SaintMeeting.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaintMeeting(
      id: jsonSerialization['id'] as int?,
      saintAId: jsonSerialization['saintAId'] as int,
      saintBId: jsonSerialization['saintBId'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int saintAId;

  int saintBId;

  DateTime createdAt;

  /// Returns a shallow copy of this [SaintMeeting]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SaintMeeting copyWith({
    int? id,
    int? saintAId,
    int? saintBId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaintMeeting',
      if (id != null) 'id': id,
      'saintAId': saintAId,
      'saintBId': saintBId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaintMeeting',
      if (id != null) 'id': id,
      'saintAId': saintAId,
      'saintBId': saintBId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SaintMeetingImpl extends SaintMeeting {
  _SaintMeetingImpl({
    int? id,
    required int saintAId,
    required int saintBId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         saintAId: saintAId,
         saintBId: saintBId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SaintMeeting]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SaintMeeting copyWith({
    Object? id = _Undefined,
    int? saintAId,
    int? saintBId,
    DateTime? createdAt,
  }) {
    return SaintMeeting(
      id: id is int? ? id : this.id,
      saintAId: saintAId ?? this.saintAId,
      saintBId: saintBId ?? this.saintBId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
