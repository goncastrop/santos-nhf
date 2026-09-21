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
import '../collection/card_source.dart' as _in4697tk;
import '../saints/saint_info.dart' as _i38p9z6b;
import '../saints/saint_scores.dart' as _iwd0qww1;

/// A saint card owned by the current user, with its scores revealed.
abstract class CollectedCard
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CollectedCard._({
    required this.saint,
    required this.scores,
    required this.obtainedAt,
    required this.source,
  });

  factory CollectedCard({
    required _i38p9z6b.SaintInfo saint,
    required _iwd0qww1.SaintScores scores,
    required DateTime obtainedAt,
    required _in4697tk.CardSource source,
  }) = _CollectedCardImpl;

  factory CollectedCard.fromJson(Map<String, dynamic> jsonSerialization) {
    return CollectedCard(
      saint: _ipd1p8hh.Protocol().deserialize<_i38p9z6b.SaintInfo>(
        jsonSerialization['saint'],
      ),
      scores: _ipd1p8hh.Protocol().deserialize<_iwd0qww1.SaintScores>(
        jsonSerialization['scores'],
      ),
      obtainedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['obtainedAt'],
      ),
      source: _in4697tk.CardSource.fromJson(
        (jsonSerialization['source'] as String),
      ),
    );
  }

  _i38p9z6b.SaintInfo saint;

  _iwd0qww1.SaintScores scores;

  DateTime obtainedAt;

  _in4697tk.CardSource source;

  /// Returns a shallow copy of this [CollectedCard]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CollectedCard copyWith({
    _i38p9z6b.SaintInfo? saint,
    _iwd0qww1.SaintScores? scores,
    DateTime? obtainedAt,
    _in4697tk.CardSource? source,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CollectedCard',
      'saint': saint.toJson(),
      'scores': scores.toJson(),
      'obtainedAt': obtainedAt.toJson(),
      'source': source.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CollectedCard',
      'saint': saint.toJsonForProtocol(),
      'scores': scores.toJsonForProtocol(),
      'obtainedAt': obtainedAt.toJson(),
      'source': source.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CollectedCardImpl extends CollectedCard {
  _CollectedCardImpl({
    required _i38p9z6b.SaintInfo saint,
    required _iwd0qww1.SaintScores scores,
    required DateTime obtainedAt,
    required _in4697tk.CardSource source,
  }) : super._(
         saint: saint,
         scores: scores,
         obtainedAt: obtainedAt,
         source: source,
       );

  /// Returns a shallow copy of this [CollectedCard]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CollectedCard copyWith({
    _i38p9z6b.SaintInfo? saint,
    _iwd0qww1.SaintScores? scores,
    DateTime? obtainedAt,
    _in4697tk.CardSource? source,
  }) {
    return CollectedCard(
      saint: saint ?? this.saint.copyWith(),
      scores: scores ?? this.scores.copyWith(),
      obtainedAt: obtainedAt ?? this.obtainedAt,
      source: source ?? this.source,
    );
  }
}
