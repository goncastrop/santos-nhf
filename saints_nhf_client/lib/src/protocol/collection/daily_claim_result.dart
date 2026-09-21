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
import '../collection/collected_card.dart' as _izrixkci;

/// Result of claiming the daily card.
abstract class DailyClaimResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DailyClaimResult._({
    required this.card,
    required this.isFeastDay,
  });

  factory DailyClaimResult({
    required _izrixkci.CollectedCard card,
    required bool isFeastDay,
  }) = _DailyClaimResultImpl;

  factory DailyClaimResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyClaimResult(
      card: _ipd1p8hh.Protocol().deserialize<_izrixkci.CollectedCard>(
        jsonSerialization['card'],
      ),
      isFeastDay: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isFeastDay'],
      ),
    );
  }

  _izrixkci.CollectedCard card;

  /// True when the card is the saint whose feast is today.
  bool isFeastDay;

  /// Returns a shallow copy of this [DailyClaimResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DailyClaimResult copyWith({
    _izrixkci.CollectedCard? card,
    bool? isFeastDay,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyClaimResult',
      'card': card.toJson(),
      'isFeastDay': isFeastDay,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyClaimResult',
      'card': card.toJsonForProtocol(),
      'isFeastDay': isFeastDay,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DailyClaimResultImpl extends DailyClaimResult {
  _DailyClaimResultImpl({
    required _izrixkci.CollectedCard card,
    required bool isFeastDay,
  }) : super._(
         card: card,
         isFeastDay: isFeastDay,
       );

  /// Returns a shallow copy of this [DailyClaimResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DailyClaimResult copyWith({
    _izrixkci.CollectedCard? card,
    bool? isFeastDay,
  }) {
    return DailyClaimResult(
      card: card ?? this.card.copyWith(),
      isFeastDay: isFeastDay ?? this.isFeastDay,
    );
  }
}
