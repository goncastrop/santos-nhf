import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'duel_service.dart';

/// Tells the open streams that a duel changed: the board of that duel, and
/// the duel list of each of its two players, which drives the count of
/// turns waiting in the Play tab.
///
/// Posted only after the move's transaction committed, so a stream that
/// reacts at once already reads the new state. Like the live trivia, the
/// messages stay in this server: production is a single instance.
class DuelEvents {
  static String duelChannel(int duelId) => 'duel-$duelId';
  static String playerChannel(UuidValue playerId) => 'duels-of-$playerId';

  static Future<void> changed(Session session, int duelId) async {
    final duel = await Duel.db.findById(session, duelId);
    if (duel == null) return;
    final signal = DuelSignal(duelId: duelId);
    await session.messages.postMessage(
      duelChannel(duelId),
      signal,
      scope: MessageScope.local,
    );
    for (final player in {duel.challengerId, duel.opponentId}) {
      if (player == DuelService.machineId) continue;
      await session.messages.postMessage(
        playerChannel(player),
        signal,
        scope: MessageScope.local,
      );
    }
  }
}
