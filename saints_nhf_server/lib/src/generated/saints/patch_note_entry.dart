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
import 'package:saints_nhf_server/src/generated/protocol.dart' as _itw3ru38;
import 'package:serverpod/serverpod.dart' as _is;
import '../saints/saint_info.dart' as _i38p9z6b;
import '../saints/score_change.dart' as _iy6qi8fm;

/// A published score change, shown to players as "notas del parche".
abstract class PatchNoteEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PatchNoteEntry._({
    required this.saint,
    this.note,
    required this.changedAt,
    required this.changes,
  });

  factory PatchNoteEntry({
    required _i38p9z6b.SaintInfo saint,
    String? note,
    required DateTime changedAt,
    required List<_iy6qi8fm.ScoreChange> changes,
  }) = _PatchNoteEntryImpl;

  factory PatchNoteEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatchNoteEntry(
      saint: _itw3ru38.Protocol().deserialize<_i38p9z6b.SaintInfo>(
        jsonSerialization['saint'],
      ),
      note: jsonSerialization['note'] as String?,
      changedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['changedAt'],
      ),
      changes: _itw3ru38.Protocol().deserialize<List<_iy6qi8fm.ScoreChange>>(
        jsonSerialization['changes'],
      ),
    );
  }

  _i38p9z6b.SaintInfo saint;

  String? note;

  DateTime changedAt;

  List<_iy6qi8fm.ScoreChange> changes;

  /// Returns a shallow copy of this [PatchNoteEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PatchNoteEntry copyWith({
    _i38p9z6b.SaintInfo? saint,
    String? note,
    DateTime? changedAt,
    List<_iy6qi8fm.ScoreChange>? changes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatchNoteEntry',
      'saint': saint.toJson(),
      if (note != null) 'note': note,
      'changedAt': changedAt.toJson(),
      'changes': changes.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PatchNoteEntry',
      'saint': saint.toJsonForProtocol(),
      if (note != null) 'note': note,
      'changedAt': changedAt.toJson(),
      'changes': changes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PatchNoteEntryImpl extends PatchNoteEntry {
  _PatchNoteEntryImpl({
    required _i38p9z6b.SaintInfo saint,
    String? note,
    required DateTime changedAt,
    required List<_iy6qi8fm.ScoreChange> changes,
  }) : super._(
         saint: saint,
         note: note,
         changedAt: changedAt,
         changes: changes,
       );

  /// Returns a shallow copy of this [PatchNoteEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PatchNoteEntry copyWith({
    _i38p9z6b.SaintInfo? saint,
    Object? note = _Undefined,
    DateTime? changedAt,
    List<_iy6qi8fm.ScoreChange>? changes,
  }) {
    return PatchNoteEntry(
      saint: saint ?? this.saint.copyWith(),
      note: note is String? ? note : this.note,
      changedAt: changedAt ?? this.changedAt,
      changes: changes ?? this.changes.map((e0) => e0.copyWith()).toList(),
    );
  }
}
