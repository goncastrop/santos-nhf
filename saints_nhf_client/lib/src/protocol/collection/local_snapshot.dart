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
import '../collection/collection_overview.dart' as _ihn5g4it;
import '../questions/daily_quiz.dart' as _i21uyarw;
import '../saints/patch_note_entry.dart' as _imkvschn;
import '../saints/saint_info.dart' as _i38p9z6b;
import '../social/my_profile.dart' as _icojo0ez;

/// Everything the app needs to open without network. Stored on the device
/// by the Flutter app after each successful load; never sent to the server.
abstract class LocalSnapshot
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LocalSnapshot._({
    required this.catalog,
    this.overview,
    this.profile,
    this.quiz,
    required this.patchNotes,
    required this.savedAt,
  });

  factory LocalSnapshot({
    required List<_i38p9z6b.SaintInfo> catalog,
    _ihn5g4it.CollectionOverview? overview,
    _icojo0ez.MyProfile? profile,
    _i21uyarw.DailyQuiz? quiz,
    required List<_imkvschn.PatchNoteEntry> patchNotes,
    required DateTime savedAt,
  }) = _LocalSnapshotImpl;

  factory LocalSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return LocalSnapshot(
      catalog: _ipd1p8hh.Protocol().deserialize<List<_i38p9z6b.SaintInfo>>(
        jsonSerialization['catalog'],
      ),
      overview: jsonSerialization['overview'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_ihn5g4it.CollectionOverview>(
              jsonSerialization['overview'],
            ),
      profile: jsonSerialization['profile'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_icojo0ez.MyProfile>(
              jsonSerialization['profile'],
            ),
      quiz: jsonSerialization['quiz'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_i21uyarw.DailyQuiz>(
              jsonSerialization['quiz'],
            ),
      patchNotes: _ipd1p8hh.Protocol()
          .deserialize<List<_imkvschn.PatchNoteEntry>>(
            jsonSerialization['patchNotes'],
          ),
      savedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['savedAt'],
      ),
    );
  }

  List<_i38p9z6b.SaintInfo> catalog;

  _ihn5g4it.CollectionOverview? overview;

  _icojo0ez.MyProfile? profile;

  _i21uyarw.DailyQuiz? quiz;

  List<_imkvschn.PatchNoteEntry> patchNotes;

  DateTime savedAt;

  /// Returns a shallow copy of this [LocalSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LocalSnapshot copyWith({
    List<_i38p9z6b.SaintInfo>? catalog,
    _ihn5g4it.CollectionOverview? overview,
    _icojo0ez.MyProfile? profile,
    _i21uyarw.DailyQuiz? quiz,
    List<_imkvschn.PatchNoteEntry>? patchNotes,
    DateTime? savedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LocalSnapshot',
      'catalog': catalog.toJson(valueToJson: (v) => v.toJson()),
      if (overview != null) 'overview': overview?.toJson(),
      if (profile != null) 'profile': profile?.toJson(),
      if (quiz != null) 'quiz': quiz?.toJson(),
      'patchNotes': patchNotes.toJson(valueToJson: (v) => v.toJson()),
      'savedAt': savedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LocalSnapshot',
      'catalog': catalog.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (overview != null) 'overview': overview?.toJsonForProtocol(),
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
      if (quiz != null) 'quiz': quiz?.toJsonForProtocol(),
      'patchNotes': patchNotes.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'savedAt': savedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LocalSnapshotImpl extends LocalSnapshot {
  _LocalSnapshotImpl({
    required List<_i38p9z6b.SaintInfo> catalog,
    _ihn5g4it.CollectionOverview? overview,
    _icojo0ez.MyProfile? profile,
    _i21uyarw.DailyQuiz? quiz,
    required List<_imkvschn.PatchNoteEntry> patchNotes,
    required DateTime savedAt,
  }) : super._(
         catalog: catalog,
         overview: overview,
         profile: profile,
         quiz: quiz,
         patchNotes: patchNotes,
         savedAt: savedAt,
       );

  /// Returns a shallow copy of this [LocalSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LocalSnapshot copyWith({
    List<_i38p9z6b.SaintInfo>? catalog,
    Object? overview = _Undefined,
    Object? profile = _Undefined,
    Object? quiz = _Undefined,
    List<_imkvschn.PatchNoteEntry>? patchNotes,
    DateTime? savedAt,
  }) {
    return LocalSnapshot(
      catalog: catalog ?? this.catalog.map((e0) => e0.copyWith()).toList(),
      overview: overview is _ihn5g4it.CollectionOverview?
          ? overview
          : this.overview?.copyWith(),
      profile: profile is _icojo0ez.MyProfile?
          ? profile
          : this.profile?.copyWith(),
      quiz: quiz is _i21uyarw.DailyQuiz? ? quiz : this.quiz?.copyWith(),
      patchNotes:
          patchNotes ?? this.patchNotes.map((e0) => e0.copyWith()).toList(),
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
