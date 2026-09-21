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

/// Snapshot of a saint before an admin change, so edits can be reviewed and undone.
abstract class SaintRevision
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SaintRevision._({
    this.id,
    required this.saintId,
    required this.snapshotJson,
    this.note,
    this.changedByEmail,
    this.changedByAuthUserId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SaintRevision({
    int? id,
    required int saintId,
    required String snapshotJson,
    String? note,
    String? changedByEmail,
    _isc.UuidValue? changedByAuthUserId,
    DateTime? createdAt,
  }) = _SaintRevisionImpl;

  factory SaintRevision.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaintRevision(
      id: jsonSerialization['id'] as int?,
      saintId: jsonSerialization['saintId'] as int,
      snapshotJson: jsonSerialization['snapshotJson'] as String,
      note: jsonSerialization['note'] as String?,
      changedByEmail: jsonSerialization['changedByEmail'] as String?,
      changedByAuthUserId: jsonSerialization['changedByAuthUserId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['changedByAuthUserId'],
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

  int saintId;

  /// JSON encoding of the [Saint] as it was before the change.
  String snapshotJson;

  /// Admin note describing the change that replaced this snapshot.
  String? note;

  String? changedByEmail;

  _isc.UuidValue? changedByAuthUserId;

  DateTime createdAt;

  /// Returns a shallow copy of this [SaintRevision]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SaintRevision copyWith({
    int? id,
    int? saintId,
    String? snapshotJson,
    String? note,
    String? changedByEmail,
    _isc.UuidValue? changedByAuthUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaintRevision',
      if (id != null) 'id': id,
      'saintId': saintId,
      'snapshotJson': snapshotJson,
      if (note != null) 'note': note,
      if (changedByEmail != null) 'changedByEmail': changedByEmail,
      if (changedByAuthUserId != null)
        'changedByAuthUserId': changedByAuthUserId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaintRevision',
      if (id != null) 'id': id,
      'saintId': saintId,
      'snapshotJson': snapshotJson,
      if (note != null) 'note': note,
      if (changedByEmail != null) 'changedByEmail': changedByEmail,
      if (changedByAuthUserId != null)
        'changedByAuthUserId': changedByAuthUserId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SaintRevisionImpl extends SaintRevision {
  _SaintRevisionImpl({
    int? id,
    required int saintId,
    required String snapshotJson,
    String? note,
    String? changedByEmail,
    _isc.UuidValue? changedByAuthUserId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         saintId: saintId,
         snapshotJson: snapshotJson,
         note: note,
         changedByEmail: changedByEmail,
         changedByAuthUserId: changedByAuthUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SaintRevision]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SaintRevision copyWith({
    Object? id = _Undefined,
    int? saintId,
    String? snapshotJson,
    Object? note = _Undefined,
    Object? changedByEmail = _Undefined,
    Object? changedByAuthUserId = _Undefined,
    DateTime? createdAt,
  }) {
    return SaintRevision(
      id: id is int? ? id : this.id,
      saintId: saintId ?? this.saintId,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      note: note is String? ? note : this.note,
      changedByEmail: changedByEmail is String?
          ? changedByEmail
          : this.changedByEmail,
      changedByAuthUserId: changedByAuthUserId is _isc.UuidValue?
          ? changedByAuthUserId
          : this.changedByAuthUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
