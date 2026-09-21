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

/// Result of a CSV import (or of its preview when not applied).
abstract class ImportReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportReport._({
    required this.applied,
    required this.created,
    required this.updated,
    required this.unchanged,
    required this.changes,
    required this.errors,
  });

  factory ImportReport({
    required bool applied,
    required int created,
    required int updated,
    required int unchanged,
    required List<String> changes,
    required List<String> errors,
  }) = _ImportReportImpl;

  factory ImportReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportReport(
      applied: _isc.BoolJsonExtension.fromJson(jsonSerialization['applied']),
      created: jsonSerialization['created'] as int,
      updated: jsonSerialization['updated'] as int,
      unchanged: jsonSerialization['unchanged'] as int,
      changes: _ipd1p8hh.Protocol().deserialize<List<String>>(
        jsonSerialization['changes'],
      ),
      errors: _ipd1p8hh.Protocol().deserialize<List<String>>(
        jsonSerialization['errors'],
      ),
    );
  }

  bool applied;

  int created;

  int updated;

  int unchanged;

  /// Human-readable list of what changed, one line per row.
  List<String> changes;

  /// Rows that could not be imported, with the line number.
  List<String> errors;

  /// Returns a shallow copy of this [ImportReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportReport copyWith({
    bool? applied,
    int? created,
    int? updated,
    int? unchanged,
    List<String>? changes,
    List<String>? errors,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportReport',
      'applied': applied,
      'created': created,
      'updated': updated,
      'unchanged': unchanged,
      'changes': changes.toJson(),
      'errors': errors.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportReport',
      'applied': applied,
      'created': created,
      'updated': updated,
      'unchanged': unchanged,
      'changes': changes.toJson(),
      'errors': errors.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ImportReportImpl extends ImportReport {
  _ImportReportImpl({
    required bool applied,
    required int created,
    required int updated,
    required int unchanged,
    required List<String> changes,
    required List<String> errors,
  }) : super._(
         applied: applied,
         created: created,
         updated: updated,
         unchanged: unchanged,
         changes: changes,
         errors: errors,
       );

  /// Returns a shallow copy of this [ImportReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportReport copyWith({
    bool? applied,
    int? created,
    int? updated,
    int? unchanged,
    List<String>? changes,
    List<String>? errors,
  }) {
    return ImportReport(
      applied: applied ?? this.applied,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      unchanged: unchanged ?? this.unchanged,
      changes: changes ?? this.changes.map((e0) => e0).toList(),
      errors: errors ?? this.errors.map((e0) => e0).toList(),
    );
  }
}
