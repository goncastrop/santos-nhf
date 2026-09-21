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

/// The current user's collection state.
abstract class CollectionOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CollectionOverview._({
    required this.totalPublished,
    required this.cards,
    required this.newStarterCards,
    required this.canClaimToday,
    this.todayCard,
  });

  factory CollectionOverview({
    required int totalPublished,
    required List<_izrixkci.CollectedCard> cards,
    required List<_izrixkci.CollectedCard> newStarterCards,
    required bool canClaimToday,
    _izrixkci.CollectedCard? todayCard,
  }) = _CollectionOverviewImpl;

  factory CollectionOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return CollectionOverview(
      totalPublished: jsonSerialization['totalPublished'] as int,
      cards: _ipd1p8hh.Protocol().deserialize<List<_izrixkci.CollectedCard>>(
        jsonSerialization['cards'],
      ),
      newStarterCards: _ipd1p8hh.Protocol()
          .deserialize<List<_izrixkci.CollectedCard>>(
            jsonSerialization['newStarterCards'],
          ),
      canClaimToday: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['canClaimToday'],
      ),
      todayCard: jsonSerialization['todayCard'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_izrixkci.CollectedCard>(
              jsonSerialization['todayCard'],
            ),
    );
  }

  /// Number of published saints in the catalog.
  int totalPublished;

  /// All cards the user owns, newest first.
  List<_izrixkci.CollectedCard> cards;

  /// Cards granted in this very call as the starter pack (empty afterwards).
  List<_izrixkci.CollectedCard> newStarterCards;

  /// Whether the daily card can still be claimed today.
  bool canClaimToday;

  /// The card claimed today, if any.
  _izrixkci.CollectedCard? todayCard;

  /// Returns a shallow copy of this [CollectionOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CollectionOverview copyWith({
    int? totalPublished,
    List<_izrixkci.CollectedCard>? cards,
    List<_izrixkci.CollectedCard>? newStarterCards,
    bool? canClaimToday,
    _izrixkci.CollectedCard? todayCard,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CollectionOverview',
      'totalPublished': totalPublished,
      'cards': cards.toJson(valueToJson: (v) => v.toJson()),
      'newStarterCards': newStarterCards.toJson(valueToJson: (v) => v.toJson()),
      'canClaimToday': canClaimToday,
      if (todayCard != null) 'todayCard': todayCard?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CollectionOverview',
      'totalPublished': totalPublished,
      'cards': cards.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'newStarterCards': newStarterCards.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'canClaimToday': canClaimToday,
      if (todayCard != null) 'todayCard': todayCard?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CollectionOverviewImpl extends CollectionOverview {
  _CollectionOverviewImpl({
    required int totalPublished,
    required List<_izrixkci.CollectedCard> cards,
    required List<_izrixkci.CollectedCard> newStarterCards,
    required bool canClaimToday,
    _izrixkci.CollectedCard? todayCard,
  }) : super._(
         totalPublished: totalPublished,
         cards: cards,
         newStarterCards: newStarterCards,
         canClaimToday: canClaimToday,
         todayCard: todayCard,
       );

  /// Returns a shallow copy of this [CollectionOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CollectionOverview copyWith({
    int? totalPublished,
    List<_izrixkci.CollectedCard>? cards,
    List<_izrixkci.CollectedCard>? newStarterCards,
    bool? canClaimToday,
    Object? todayCard = _Undefined,
  }) {
    return CollectionOverview(
      totalPublished: totalPublished ?? this.totalPublished,
      cards: cards ?? this.cards.map((e0) => e0.copyWith()).toList(),
      newStarterCards:
          newStarterCards ??
          this.newStarterCards.map((e0) => e0.copyWith()).toList(),
      canClaimToday: canClaimToday ?? this.canClaimToday,
      todayCard: todayCard is _izrixkci.CollectedCard?
          ? todayCard
          : this.todayCard?.copyWith(),
    );
  }
}
