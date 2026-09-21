import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../collection/collection_service.dart';
import '../generated/protocol.dart';
import '../questions/question_service.dart';
import '../saints/saint_mapper.dart';
import '../saints/score_category_x.dart';
import '../social/profile_service.dart';

/// Rules of the card duel.
///
/// Two players bring five cards each. Rounds alternate the attacker, who picks
/// a category (never repeated in the duel) and a card; the defender sees the
/// category and picks a card. Each player answers a question about their own
/// saint when they play it. The higher card in the category wins the
/// comparison; its owner scores if they answered right, otherwise the other
/// player scores if *they* answered right. First to [pointsToWin], or best
/// score after all cards are played.
class DuelService {
  static const pointsToWin = 3;
  static const deckSize = 5;

  /// Cards dealt to a player to build a deck from.
  static const handSize = 8;

  /// The built-in opponent.
  static final machineId = UuidValue.fromString(
    '11111111-1111-4111-8111-111111111111',
  );
  static const machineName = 'El Sacristán';

  /// How often the machine answers its questions right.
  static double machineAccuracy = 0.6;

  /// Replaceable so tests can make the machine deterministic.
  static Random random = Random();

  // ---------------------------------------------------------------- creation

  static Future<DuelView> createVsMachine(
    Session session,
    UuidValue me,
    List<int> deckIds,
  ) async {
    return session.db.transaction((tx) async {
      await _validateDeck(session, me, deckIds, transaction: tx);
      final machineDeck = await _machineDeck(session, transaction: tx);
      var duel = await Duel.db.insertRow(
        session,
        Duel(
          challengerId: me,
          opponentId: machineId,
          isVsMachine: true,
          status: DuelStatus.active,
        ),
        transaction: tx,
      );
      await DuelDeck.db.insert(session, [
        DuelDeck(
          duelId: duel.id!,
          playerId: me,
          saintIds: deckIds,
          usedSaintIds: [],
        ),
        DuelDeck(
          duelId: duel.id!,
          playerId: machineId,
          saintIds: machineDeck,
          usedSaintIds: [],
        ),
      ], transaction: tx);
      duel = await _start(session, duel, transaction: tx);
      duel = await _machinePlays(session, duel, transaction: tx);
      return _view(session, duel, me, transaction: tx);
    });
  }

  static Future<DuelView> challenge(
    Session session,
    UuidValue me,
    UuidValue opponentId,
    List<int> deckIds,
  ) async {
    return session.db.transaction((tx) async {
      if (opponentId == me) {
        throw DuelException(message: 'No podés desafiarte a vos mismo.');
      }
      if (!await _areFriends(session, me, opponentId, transaction: tx)) {
        throw DuelException(message: 'Solo podés desafiar a tus amigos.');
      }
      await _validateDeck(session, me, deckIds, transaction: tx);
      final duel = await Duel.db.insertRow(
        session,
        Duel(
          challengerId: me,
          opponentId: opponentId,
          status: DuelStatus.pendingDeck,
          turnOf: opponentId,
        ),
        transaction: tx,
      );
      await DuelDeck.db.insertRow(
        session,
        DuelDeck(
          duelId: duel.id!,
          playerId: me,
          saintIds: deckIds,
          usedSaintIds: [],
        ),
        transaction: tx,
      );
      return _view(session, duel, me, transaction: tx);
    });
  }

  static Future<DuelView> accept(
    Session session,
    UuidValue me,
    int duelId,
    List<int> deckIds,
  ) async {
    return session.db.transaction((tx) async {
      var duel = await _load(session, duelId, me, transaction: tx);
      if (duel.status != DuelStatus.pendingDeck || duel.opponentId != me) {
        throw DuelException(message: 'Este duelo no está esperando tu mazo.');
      }
      await _validateDeck(session, me, deckIds, transaction: tx);
      await DuelDeck.db.insertRow(
        session,
        DuelDeck(
          duelId: duel.id!,
          playerId: me,
          saintIds: deckIds,
          usedSaintIds: [],
        ),
        transaction: tx,
      );
      duel = await _start(session, duel, transaction: tx);
      return _view(session, duel, me, transaction: tx);
    });
  }

  static Future<void> decline(Session session, UuidValue me, int duelId) async {
    final duel = await _load(session, duelId, me);
    if (duel.status != DuelStatus.pendingDeck) {
      throw DuelException(message: 'Este duelo ya empezó.');
    }
    await Duel.db.updateRow(
      session,
      duel.copyWith(
        status: DuelStatus.declined,
        turnOf: null,
        updatedAt: DateTime.now().toUtc(),
        finishedAt: DateTime.now().toUtc(),
      ),
    );
  }

  // ------------------------------------------------------------------- moves

  static Future<DuelView> attack(
    Session session,
    UuidValue me,
    int duelId,
    ScoreCategory category,
    int saintId,
  ) async {
    return session.db.transaction((tx) async {
      var duel = await _load(session, duelId, me, transaction: tx);
      _requireTurn(duel, me);
      if (duel.attackerId != me) {
        throw DuelException(message: 'En esta ronda te toca defender.');
      }
      final round = await _currentRound(session, duel, transaction: tx);
      if (round != null) {
        throw DuelException(message: 'Ya elegiste tu carta en esta ronda.');
      }
      final used = await _usedCategories(session, duel.id!, transaction: tx);
      if (used.contains(category)) {
        throw DuelException(
          message: '${labelOf(category)} ya se jugó en este duelo.',
        );
      }
      final deck = await _deckOf(session, duel.id!, me, transaction: tx);
      _requireInDeck(deck, saintId);
      final question = await QuestionService.randomFor(
        session,
        saintId,
        transaction: tx,
      );
      if (question == null) {
        throw DuelException(message: 'Ese santo no tiene preguntas cargadas.');
      }
      await DuelRound.db.insertRow(
        session,
        DuelRound(
          duelId: duel.id!,
          roundNumber: duel.roundNumber,
          category: category,
          attackerId: me,
          defenderId: _otherOf(duel, me),
          attackerSaintId: saintId,
          attackerQuestionId: question.id,
        ),
        transaction: tx,
      );
      duel = await _touch(session, duel, transaction: tx);
      return _view(session, duel, me, transaction: tx);
    });
  }

  static Future<DuelView> defend(
    Session session,
    UuidValue me,
    int duelId,
    int saintId,
  ) async {
    return session.db.transaction((tx) async {
      var duel = await _load(session, duelId, me, transaction: tx);
      _requireTurn(duel, me);
      final round = await _currentRound(session, duel, transaction: tx);
      if (round == null || round.defenderId != me) {
        throw DuelException(message: 'En esta ronda te toca atacar.');
      }
      if (round.attackerAnswerIndex == null) {
        throw DuelException(message: 'El rival todavía no terminó su jugada.');
      }
      if (round.defenderSaintId != null) {
        throw DuelException(message: 'Ya elegiste tu carta en esta ronda.');
      }
      final deck = await _deckOf(session, duel.id!, me, transaction: tx);
      _requireInDeck(deck, saintId);
      final question = await QuestionService.randomFor(
        session,
        saintId,
        transaction: tx,
      );
      if (question == null) {
        throw DuelException(message: 'Ese santo no tiene preguntas cargadas.');
      }
      await DuelRound.db.updateRow(
        session,
        round.copyWith(
          defenderSaintId: saintId,
          defenderQuestionId: question.id,
        ),
        transaction: tx,
      );
      duel = await _touch(session, duel, transaction: tx);
      return _view(session, duel, me, transaction: tx);
    });
  }

  static Future<DuelView> answer(
    Session session,
    UuidValue me,
    int duelId,
    int chosenIndex,
  ) async {
    return session.db.transaction((tx) async {
      var duel = await _load(session, duelId, me, transaction: tx);
      _requireTurn(duel, me);
      var round = await _currentRound(session, duel, transaction: tx);
      if (round == null) {
        throw DuelException(message: 'Primero elegí categoría y carta.');
      }
      final isAttacker = round.attackerId == me;
      final questionId = isAttacker
          ? round.attackerQuestionId
          : round.defenderQuestionId;
      final alreadyAnswered = isAttacker
          ? round.attackerAnswerIndex != null
          : round.defenderAnswerIndex != null;
      if (questionId == null) {
        throw DuelException(message: 'Primero elegí tu carta.');
      }
      if (alreadyAnswered) {
        throw DuelException(message: 'Ya respondiste en esta ronda.');
      }
      final question = await Question.db.findById(
        session,
        questionId,
        transaction: tx,
      );
      // The player sees the options shuffled, so [chosenIndex] is a position
      // on their screen; answers are stored in the question's own order.
      final storedIndex = question == null
          ? -1
          : QuestionService.orderFor(
              question,
              _questionSeed(round, me, questionId),
            ).toStored(chosenIndex);
      final correct = question != null && question.correctIndex == storedIndex;
      round = await DuelRound.db.updateRow(
        session,
        isAttacker
            ? round.copyWith(
                attackerAnswerIndex: storedIndex,
                attackerCorrect: correct,
              )
            : round.copyWith(
                defenderAnswerIndex: storedIndex,
                defenderCorrect: correct,
              ),
        transaction: tx,
      );
      if (isAttacker) {
        duel = await Duel.db.updateRow(
          session,
          duel.copyWith(
            turnOf: round.defenderId,
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: tx,
        );
      } else {
        duel = await _resolve(session, duel, round, transaction: tx);
      }
      duel = await _machinePlays(session, duel, transaction: tx);
      return _view(session, duel, me, transaction: tx);
    });
  }

  // ----------------------------------------------------------------- queries

  static Future<DuelView> view(
    Session session,
    UuidValue me,
    int duelId,
  ) async {
    final duel = await _load(session, duelId, me);
    return _view(session, duel, me);
  }

  static Future<List<DuelSummary>> list(Session session, UuidValue me) async {
    final duels = await Duel.db.find(
      session,
      where: (t) => t.challengerId.equals(me) | t.opponentId.equals(me),
      orderBy: (t) => t.updatedAt.desc(),
      limit: 50,
    );
    final others = duels.map((d) => _otherOf(d, me)).toSet()..remove(machineId);
    final profiles = others.isEmpty
        ? <PlayerProfile>[]
        : await PlayerProfile.db.find(
            session,
            where: (t) => t.authUserId.inSet(others),
          );
    final nameById = {
      for (final p in profiles) p.authUserId: ProfileService.nameOf(p),
    };
    return [
      for (final d in duels)
        DuelSummary(
          duelId: d.id!,
          status: d.status,
          isVsMachine: d.isVsMachine,
          opponentName: d.isVsMachine
              ? machineName
              : nameById[_otherOf(d, me)] ?? 'Peregrino',
          myScore: _scoreOf(d, me),
          opponentScore: _scoreOf(d, _otherOf(d, me)),
          isMyTurn: d.turnOf == me,
          winnerIsMe: d.status == DuelStatus.finished && d.winnerId != null
              ? d.winnerId == me
              : null,
          updatedAt: d.updatedAt,
        ),
    ];
  }

  /// Owned published saints that have at least one question.
  static Future<List<int>> eligibleSaintIds(
    Session session,
    UuidValue me,
  ) async {
    final cards = await UserSaintCard.db.find(
      session,
      where: (t) =>
          t.authUserId.equals(me) &
          t.saint.status.equals(SaintStatus.published),
    );
    final withQuestions = await QuestionService.withQuestions(
      session,
      cards.map((c) => c.saintId),
    );
    return withQuestions.toList()..sort();
  }

  // --------------------------------------------------------------- internals

  static Future<Duel> _start(
    Session session,
    Duel duel, {
    required Transaction transaction,
  }) {
    final first = random.nextBool() ? duel.challengerId : duel.opponentId;
    return Duel.db.updateRow(
      session,
      duel.copyWith(
        status: DuelStatus.active,
        roundNumber: 1,
        attackerId: first,
        turnOf: first,
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  }

  static Future<Duel> _resolve(
    Session session,
    Duel duel,
    DuelRound round, {
    required Transaction transaction,
  }) async {
    final saints = await Saint.db.find(
      session,
      where: (t) =>
          t.id.inSet(<int>{round.attackerSaintId, round.defenderSaintId!}),
      transaction: transaction,
    );
    final byId = {for (final s in saints) s.id!: s};
    final a = scoreOf(byId[round.attackerSaintId]!, round.category);
    final d = scoreOf(byId[round.defenderSaintId]!, round.category);
    final attackerCorrect = round.attackerCorrect ?? false;
    final defenderCorrect = round.defenderCorrect ?? false;

    UuidValue? pointTo;
    if (a > d) {
      pointTo = attackerCorrect
          ? round.attackerId
          : defenderCorrect
          ? round.defenderId
          : null;
    } else if (d > a) {
      pointTo = defenderCorrect
          ? round.defenderId
          : attackerCorrect
          ? round.attackerId
          : null;
    } else if (attackerCorrect != defenderCorrect) {
      pointTo = attackerCorrect ? round.attackerId : round.defenderId;
    }

    await DuelRound.db.updateRow(
      session,
      round.copyWith(
        attackerScore: a,
        defenderScore: d,
        pointTo: pointTo,
        resolved: true,
      ),
      transaction: transaction,
    );

    // Mark both cards as used.
    for (final (player, saintId) in [
      (round.attackerId, round.attackerSaintId),
      (round.defenderId, round.defenderSaintId!),
    ]) {
      final deck = await _deckOf(
        session,
        duel.id!,
        player,
        transaction: transaction,
      );
      await DuelDeck.db.updateRow(
        session,
        deck.copyWith(usedSaintIds: [...deck.usedSaintIds, saintId]),
        transaction: transaction,
      );
    }

    var challengerScore = duel.challengerScore;
    var opponentScore = duel.opponentScore;
    if (pointTo == duel.challengerId) challengerScore++;
    if (pointTo == duel.opponentId) opponentScore++;

    final now = DateTime.now().toUtc();
    final over =
        challengerScore >= pointsToWin ||
        opponentScore >= pointsToWin ||
        duel.roundNumber >= deckSize;
    if (over) {
      final winner = challengerScore == opponentScore
          ? null
          : challengerScore > opponentScore
          ? duel.challengerId
          : duel.opponentId;
      final finished = await Duel.db.updateRow(
        session,
        duel.copyWith(
          challengerScore: challengerScore,
          opponentScore: opponentScore,
          status: DuelStatus.finished,
          winnerId: winner,
          turnOf: null,
          updatedAt: now,
          finishedAt: now,
        ),
        transaction: transaction,
      );
      await _recordStats(session, finished, transaction: transaction);
      return finished;
    }
    final nextAttacker = round.defenderId;
    return Duel.db.updateRow(
      session,
      duel.copyWith(
        challengerScore: challengerScore,
        opponentScore: opponentScore,
        roundNumber: duel.roundNumber + 1,
        attackerId: nextAttacker,
        turnOf: nextAttacker,
        updatedAt: now,
      ),
      transaction: transaction,
    );
  }

  static Future<void> _recordStats(
    Session session,
    Duel duel, {
    required Transaction transaction,
  }) async {
    for (final player in [duel.challengerId, duel.opponentId]) {
      if (player == machineId) continue;
      final profile = await ProfileService.ensure(
        session,
        player,
        transaction: transaction,
      );
      await PlayerProfile.db.updateRow(
        session,
        profile.copyWith(
          duelsPlayed: profile.duelsPlayed + 1,
          duelsWon: profile.duelsWon + (duel.winnerId == player ? 1 : 0),
        ),
        transaction: transaction,
      );
    }
  }

  /// Lets the machine act for as long as it is its turn.
  static Future<Duel> _machinePlays(
    Session session,
    Duel duel, {
    required Transaction transaction,
  }) async {
    var current = duel;
    var guard = 0;
    while (current.isVsMachine &&
        current.status == DuelStatus.active &&
        current.turnOf == machineId &&
        guard++ < 12) {
      final round = await _currentRound(
        session,
        current,
        transaction: transaction,
      );
      final deck = await _deckOf(
        session,
        current.id!,
        machineId,
        transaction: transaction,
      );
      final remaining = deck.saintIds.where(
        (id) => !deck.usedSaintIds.contains(id),
      );
      final saints = await Saint.db.find(
        session,
        where: (t) => t.id.inSet(remaining.toSet()),
        transaction: transaction,
      );
      if (round == null) {
        // Attack: the category where the machine's best card is strongest.
        final used = await _usedCategories(
          session,
          current.id!,
          transaction: transaction,
        );
        ScoreCategory? bestCategory;
        Saint? bestSaint;
        var bestScore = -1;
        for (final c in ScoreCategory.values.where((c) => !used.contains(c))) {
          for (final s in saints) {
            if (scoreOf(s, c) > bestScore) {
              bestScore = scoreOf(s, c);
              bestCategory = c;
              bestSaint = s;
            }
          }
        }
        final question = await QuestionService.randomFor(
          session,
          bestSaint!.id!,
          transaction: transaction,
        );
        final (index, correct) = _machineAnswer(question);
        await DuelRound.db.insertRow(
          session,
          DuelRound(
            duelId: current.id!,
            roundNumber: current.roundNumber,
            category: bestCategory!,
            attackerId: machineId,
            defenderId: _otherOf(current, machineId),
            attackerSaintId: bestSaint.id!,
            attackerQuestionId: question?.id,
            attackerAnswerIndex: index,
            attackerCorrect: correct,
          ),
          transaction: transaction,
        );
        current = await Duel.db.updateRow(
          session,
          current.copyWith(
            turnOf: _otherOf(current, machineId),
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );
      } else {
        // Defend with the strongest remaining card in the category.
        Saint? best;
        for (final s in saints) {
          if (best == null ||
              scoreOf(s, round.category) > scoreOf(best, round.category)) {
            best = s;
          }
        }
        final question = await QuestionService.randomFor(
          session,
          best!.id!,
          transaction: transaction,
        );
        final (index, correct) = _machineAnswer(question);
        final played = await DuelRound.db.updateRow(
          session,
          round.copyWith(
            defenderSaintId: best.id,
            defenderQuestionId: question?.id,
            defenderAnswerIndex: index,
            defenderCorrect: correct,
          ),
          transaction: transaction,
        );
        current = await _resolve(
          session,
          current,
          played,
          transaction: transaction,
        );
      }
    }
    return current;
  }

  static (int, bool) _machineAnswer(Question? question) {
    if (question == null) return (0, false);
    final correct = random.nextDouble() < machineAccuracy;
    if (correct) return (question.correctIndex, true);
    final wrong = [0, 1, 2, 3]..remove(question.correctIndex);
    return (wrong[random.nextInt(wrong.length)], false);
  }

  static Future<List<int>> _machineDeck(
    Session session, {
    required Transaction transaction,
  }) async {
    final published = await Saint.db.find(
      session,
      where: (t) => t.status.equals(SaintStatus.published),
      transaction: transaction,
    );
    final eligible = await QuestionService.withQuestions(
      session,
      published.map((s) => s.id!),
      transaction: transaction,
    );
    final pool = eligible.toList()..shuffle(random);
    if (pool.length < deckSize) {
      throw DuelException(
        message: 'Todavía no hay suficientes santos con preguntas para jugar.',
      );
    }
    return pool.take(deckSize).toList();
  }

  static Future<void> _validateDeck(
    Session session,
    UuidValue me,
    List<int> deckIds, {
    required Transaction transaction,
  }) async {
    if (deckIds.length != deckSize || deckIds.toSet().length != deckSize) {
      throw DuelException(
        message: 'Elegí exactamente $deckSize cartas distintas.',
      );
    }
    final owned = await UserSaintCard.db.find(
      session,
      where: (t) =>
          t.authUserId.equals(me) &
          t.saintId.inSet(deckIds.toSet()) &
          t.saint.status.equals(SaintStatus.published),
      transaction: transaction,
    );
    if (owned.length != deckSize) {
      throw DuelException(message: 'Solo podés jugar con cartas de tu álbum.');
    }
    final withQuestions = await QuestionService.withQuestions(
      session,
      deckIds,
      transaction: transaction,
    );
    if (withQuestions.length != deckSize) {
      throw DuelException(
        message: 'Alguna de esas cartas todavía no tiene preguntas.',
      );
    }
    // The deck must come from the hand the app dealt, so players cannot
    // always field their strongest cards.
    final profile = await ProfileService.ensure(
      session,
      me,
      transaction: transaction,
    );
    final hand = profile.pendingHand ?? const <int>[];
    if (!deckIds.every(hand.contains)) {
      throw DuelException(
        message:
            'Esas cartas no son las que te repartió la app. '
            'Volvé a abrir el mazo.',
      );
    }
    await PlayerProfile.db.updateRow(
      session,
      profile.copyWith(pendingHand: null),
      transaction: transaction,
    );
  }

  /// Deals [handSize] random eligible cards from the player's album and
  /// remembers them; the next deck must be picked from this hand.
  static Future<List<int>> dealHand(Session session, UuidValue me) async {
    final eligible = await eligibleSaintIds(session, me);
    if (eligible.length < deckSize) {
      throw DuelException(
        message:
            'Necesitás al menos $deckSize cartas con preguntas para jugar.',
      );
    }
    final hand = (List.of(eligible)..shuffle(random)).take(handSize).toList()
      ..sort();
    final profile = await ProfileService.ensure(session, me);
    await PlayerProfile.db.updateRow(
      session,
      profile.copyWith(pendingHand: hand),
    );
    return hand;
  }

  static Future<Duel> _load(
    Session session,
    int duelId,
    UuidValue me, {
    Transaction? transaction,
  }) async {
    final duel = await Duel.db.findById(
      session,
      duelId,
      transaction: transaction,
    );
    if (duel == null || (duel.challengerId != me && duel.opponentId != me)) {
      throw DuelException(message: 'Duelo no encontrado.');
    }
    return duel;
  }

  static void _requireTurn(Duel duel, UuidValue me) {
    if (duel.status != DuelStatus.active) {
      throw DuelException(message: 'Este duelo no está en juego.');
    }
    if (duel.turnOf != me) {
      throw DuelException(message: 'No es tu turno.');
    }
  }

  static void _requireInDeck(DuelDeck deck, int saintId) {
    if (!deck.saintIds.contains(saintId) ||
        deck.usedSaintIds.contains(saintId)) {
      throw DuelException(message: 'Esa carta no está disponible en tu mazo.');
    }
  }

  static Future<DuelRound?> _currentRound(
    Session session,
    Duel duel, {
    Transaction? transaction,
  }) {
    return DuelRound.db.findFirstRow(
      session,
      where: (t) =>
          t.duelId.equals(duel.id!) & t.roundNumber.equals(duel.roundNumber),
      transaction: transaction,
    );
  }

  static Future<Set<ScoreCategory>> _usedCategories(
    Session session,
    int duelId, {
    Transaction? transaction,
  }) async {
    final rounds = await DuelRound.db.find(
      session,
      where: (t) => t.duelId.equals(duelId),
      transaction: transaction,
    );
    return rounds.map((r) => r.category).toSet();
  }

  static Future<DuelDeck> _deckOf(
    Session session,
    int duelId,
    UuidValue player, {
    Transaction? transaction,
  }) async {
    final deck = await DuelDeck.db.findFirstRow(
      session,
      where: (t) => t.duelId.equals(duelId) & t.playerId.equals(player),
      transaction: transaction,
    );
    if (deck == null) {
      throw DuelException(message: 'Falta un mazo en el duelo.');
    }
    return deck;
  }

  static Future<bool> _areFriends(
    Session session,
    UuidValue a,
    UuidValue b, {
    Transaction? transaction,
  }) async {
    final (lo, hi) = sortedPair(a, b);
    final f = await Friendship.db.findFirstRow(
      session,
      where: (t) => t.playerA.equals(lo) & t.playerB.equals(hi),
      transaction: transaction,
    );
    return f != null;
  }

  static (UuidValue, UuidValue) sortedPair(UuidValue a, UuidValue b) =>
      a.uuid.compareTo(b.uuid) <= 0 ? (a, b) : (b, a);

  static UuidValue _otherOf(Duel duel, UuidValue me) =>
      duel.challengerId == me ? duel.opponentId : duel.challengerId;

  static int _scoreOf(Duel duel, UuidValue player) =>
      duel.challengerId == player ? duel.challengerScore : duel.opponentScore;

  static Future<DuelView> _view(
    Session session,
    Duel duel,
    UuidValue me, {
    Transaction? transaction,
  }) async {
    final other = _otherOf(duel, me);
    final decks = await DuelDeck.db.find(
      session,
      where: (t) => t.duelId.equals(duel.id!),
      transaction: transaction,
    );
    final myDeck = decks.where((d) => d.playerId == me).firstOrNull;
    final theirDeck = decks.where((d) => d.playerId == other).firstOrNull;
    final rounds = await DuelRound.db.find(
      session,
      where: (t) => t.duelId.equals(duel.id!),
      orderBy: (t) => t.roundNumber,
      transaction: transaction,
    );
    final current = rounds
        .where((r) => r.roundNumber == duel.roundNumber && !r.resolved)
        .firstOrNull;

    // Phase.
    DuelPhase phase;
    QuizQuestion? pendingQuestion;
    int? pendingSaintId;
    switch (duel.status) {
      case DuelStatus.declined:
        phase = DuelPhase.declined;
      case DuelStatus.finished:
        phase = DuelPhase.finished;
      case DuelStatus.pendingDeck:
        phase = myDeck == null
            ? DuelPhase.chooseDeck
            : DuelPhase.waitingOpponentDeck;
      case DuelStatus.active:
        if (duel.turnOf != me) {
          phase = DuelPhase.waitingOpponent;
        } else if (current == null) {
          phase = DuelPhase.attack;
        } else if (current.attackerId == me) {
          phase = DuelPhase.answer;
          pendingQuestion = await _quiz(
            session,
            current,
            me,
            current.attackerQuestionId,
            transaction: transaction,
          );
          pendingSaintId = current.attackerSaintId;
        } else if (current.defenderSaintId == null) {
          phase = DuelPhase.defend;
        } else {
          phase = DuelPhase.answer;
          pendingQuestion = await _quiz(
            session,
            current,
            me,
            current.defenderQuestionId,
            transaction: transaction,
          );
          pendingSaintId = current.defenderSaintId;
        }
    }

    // Saints referenced anywhere in the view.
    final saintIds = <int>{
      ...?myDeck?.saintIds,
      for (final r in rounds) ...[
        r.attackerSaintId,
        if (r.defenderSaintId != null) r.defenderSaintId!,
      ],
      ?pendingSaintId,
    };
    final saints = saintIds.isEmpty
        ? <Saint>[]
        : await Saint.db.find(
            session,
            where: (t) => t.id.inSet(saintIds),
            transaction: transaction,
          );
    final saintById = {for (final s in saints) s.id!: s};
    final infos = await SaintMapper.toInfos(session, saints);
    final infoById = {for (final i in infos) i.id: i};

    final remaining = myDeck == null
        ? <int>{}
        : myDeck.saintIds
              .where((id) => !myDeck.usedSaintIds.contains(id))
              .toSet();
    final myCards = await CollectionService.cardsOf(
      session,
      me,
      saintIds: remaining,
      transaction: transaction,
    );

    final roundViews = <DuelRoundView>[];
    for (final r in rounds) {
      final attackerIsMe = r.attackerId == me;
      final mySaintId = attackerIsMe ? r.attackerSaintId : r.defenderSaintId;
      final theirSaintId = attackerIsMe ? r.defenderSaintId : r.attackerSaintId;
      final myCorrect = attackerIsMe ? r.attackerCorrect : r.defenderCorrect;
      final theirCorrect = attackerIsMe ? r.defenderCorrect : r.attackerCorrect;
      final mySaint = mySaintId == null ? null : saintById[mySaintId];
      final theirSaint = theirSaintId == null ? null : saintById[theirSaintId];
      roundViews.add(
        DuelRoundView(
          roundNumber: r.roundNumber,
          category: r.category,
          attackerIsMe: attackerIsMe,
          resolved: r.resolved,
          mySaint: mySaintId == null ? null : infoById[mySaintId],
          myScore: mySaint == null ? null : scoreOf(mySaint, r.category),
          myCorrect: myCorrect,
          opponentSaint: r.resolved && theirSaintId != null
              ? infoById[theirSaintId]
              : null,
          opponentScore: r.resolved && theirSaint != null
              ? scoreOf(theirSaint, r.category)
              : null,
          opponentCorrect: r.resolved ? theirCorrect : null,
          pointToMe: r.pointTo == null ? null : r.pointTo == me,
        ),
      );
    }

    final opponentName = duel.isVsMachine
        ? machineName
        : ProfileService.nameOf(
            await ProfileService.byUserId(
              session,
              other,
              transaction: transaction,
            ),
          );

    return DuelView(
      duelId: duel.id!,
      status: duel.status,
      isVsMachine: duel.isVsMachine,
      phase: phase,
      roundNumber: duel.roundNumber,
      myScore: _scoreOf(duel, me),
      opponentScore: _scoreOf(duel, other),
      opponentName: opponentName,
      opponentId: other,
      myDeck: myCards,
      opponentCardsLeft: theirDeck == null
          ? deckSize
          : theirDeck.saintIds.length - theirDeck.usedSaintIds.length,
      usedCategories: rounds.map((r) => r.category).toList(),
      currentCategory: current?.category,
      attackerIsMe: duel.attackerId == me,
      pendingQuestion: pendingQuestion,
      pendingSaint: pendingSaintId == null ? null : infoById[pendingSaintId],
      rounds: roundViews,
      winnerIsMe: duel.status == DuelStatus.finished && duel.winnerId != null
          ? duel.winnerId == me
          : null,
      pointsToWin: pointsToWin,
      updatedAt: duel.updatedAt,
    );
  }

  static Future<QuizQuestion?> _quiz(
    Session session,
    DuelRound round,
    UuidValue me,
    int? questionId, {
    Transaction? transaction,
  }) async {
    if (questionId == null) return null;
    final q = await Question.db.findById(
      session,
      questionId,
      transaction: transaction,
    );
    if (q == null) return null;
    return QuestionService.toQuiz(
      q,
      QuestionService.orderFor(q, _questionSeed(round, me, questionId)),
    );
  }

  /// Ties the shuffle to one player's question in one round, so the options
  /// keep the same order while the round is open — the board is polled every
  /// few seconds — and the two players do not see the same layout.
  static String _questionSeed(DuelRound round, UuidValue me, int questionId) =>
      'duel:${round.id}:$me:$questionId';

  static Future<Duel> _touch(
    Session session,
    Duel duel, {
    required Transaction transaction,
  }) {
    return Duel.db.updateRow(
      session,
      duel.copyWith(updatedAt: DateTime.now().toUtc()),
      transaction: transaction,
    );
  }
}
