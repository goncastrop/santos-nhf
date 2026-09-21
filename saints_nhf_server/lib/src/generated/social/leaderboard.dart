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
import '../social/leaderboard_entry.dart' as _i3um952z;

/// Global rankings.
abstract class Leaderboard
    implements _is.SerializableModel, _is.ProtocolSerialization {
  Leaderboard._({
    required this.byCards,
    required this.byStreak,
    required this.byDuelsWon,
  });

  factory Leaderboard({
    required List<_i3um952z.LeaderboardEntry> byCards,
    required List<_i3um952z.LeaderboardEntry> byStreak,
    required List<_i3um952z.LeaderboardEntry> byDuelsWon,
  }) = _LeaderboardImpl;

  factory Leaderboard.fromJson(Map<String, dynamic> jsonSerialization) {
    return Leaderboard(
      byCards: _itw3ru38.Protocol()
          .deserialize<List<_i3um952z.LeaderboardEntry>>(
            jsonSerialization['byCards'],
          ),
      byStreak: _itw3ru38.Protocol()
          .deserialize<List<_i3um952z.LeaderboardEntry>>(
            jsonSerialization['byStreak'],
          ),
      byDuelsWon: _itw3ru38.Protocol()
          .deserialize<List<_i3um952z.LeaderboardEntry>>(
            jsonSerialization['byDuelsWon'],
          ),
    );
  }

  List<_i3um952z.LeaderboardEntry> byCards;

  List<_i3um952z.LeaderboardEntry> byStreak;

  List<_i3um952z.LeaderboardEntry> byDuelsWon;

  /// Returns a shallow copy of this [Leaderboard]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Leaderboard copyWith({
    List<_i3um952z.LeaderboardEntry>? byCards,
    List<_i3um952z.LeaderboardEntry>? byStreak,
    List<_i3um952z.LeaderboardEntry>? byDuelsWon,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Leaderboard',
      'byCards': byCards.toJson(valueToJson: (v) => v.toJson()),
      'byStreak': byStreak.toJson(valueToJson: (v) => v.toJson()),
      'byDuelsWon': byDuelsWon.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Leaderboard',
      'byCards': byCards.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'byStreak': byStreak.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'byDuelsWon': byDuelsWon.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LeaderboardImpl extends Leaderboard {
  _LeaderboardImpl({
    required List<_i3um952z.LeaderboardEntry> byCards,
    required List<_i3um952z.LeaderboardEntry> byStreak,
    required List<_i3um952z.LeaderboardEntry> byDuelsWon,
  }) : super._(
         byCards: byCards,
         byStreak: byStreak,
         byDuelsWon: byDuelsWon,
       );

  /// Returns a shallow copy of this [Leaderboard]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Leaderboard copyWith({
    List<_i3um952z.LeaderboardEntry>? byCards,
    List<_i3um952z.LeaderboardEntry>? byStreak,
    List<_i3um952z.LeaderboardEntry>? byDuelsWon,
  }) {
    return Leaderboard(
      byCards: byCards ?? this.byCards.map((e0) => e0.copyWith()).toList(),
      byStreak: byStreak ?? this.byStreak.map((e0) => e0.copyWith()).toList(),
      byDuelsWon:
          byDuelsWon ?? this.byDuelsWon.map((e0) => e0.copyWith()).toList(),
    );
  }
}
