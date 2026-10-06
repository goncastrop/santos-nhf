import 'dart:async';
import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../collection/collection_service.dart';
import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../questions/option_order.dart';
import '../saints/saint_mapper.dart';
import '../social/profile_service.dart';

/// Rules and state of the live trivia played during the show.
///
/// Every change to a game posts a [LiveSignal] on [channel], and each open
/// [watch] stream answers it by sending its viewer a fresh [LiveView]. The
/// views are cut from one shared snapshot of the game per change, so a
/// hundred viewers cost one round of queries and not a hundred.
///
/// The snapshot, the throttle and the count of viewers live in memory, and the
/// signals go out with [MessageScope.local]: this holds because production is
/// a single server. A second instance would need Redis and a shared count.
class LiveService {
  static const channel = 'live';

  static const maxQuestions = 10;
  static const minQuestionSeconds = 10;
  static const maxQuestionSeconds = 60;
  static const maxCountdownSeconds = 600;

  /// A right answer is worth [maxPoints] when it comes at once and drops
  /// linearly to [minPoints] at the last moment.
  static const maxPoints = 1000;
  static const minPoints = 500;

  /// Pause between questions, so nobody is caught reading the last result.
  static const getReady = Duration(seconds: 3);

  /// An answer sent right at the end still counts if it arrives this late:
  /// the question closed on the player's screen at the same time it did here.
  static const lateGrace = Duration(milliseconds: 300);

  /// How long the podium stays on the stream before going back to idle.
  static const resultsShownFor = Duration(minutes: 10);

  /// How many rows of the ranking the views carry.
  static const leaderboardSize = 5;

  static final _random = Random.secure();

  static const _active = [
    LivePhase.countdown,
    LivePhase.question,
    LivePhase.reveal,
  ];

  // ------------------------------------------------------------------ admin

  /// Announces a game: the lobby opens now and the first question opens when
  /// the countdown runs out.
  static Future<LiveGame> announce(
    Session session,
    UuidValue adminId, {
    required int saintId,
    required List<int> questionIds,
    required int countdownSeconds,
    required int questionSeconds,
    required int fastPrizes,
    required int rafflePrizes,
  }) async {
    if (questionIds.isEmpty || questionIds.length > maxQuestions) {
      throw LiveException(
        message: 'Elegí entre 1 y $maxQuestions preguntas.',
      );
    }
    if (questionIds.toSet().length != questionIds.length) {
      throw LiveException(message: 'Hay una pregunta repetida.');
    }
    if (countdownSeconds < 0 || countdownSeconds > maxCountdownSeconds) {
      throw LiveException(
        message: 'La cuenta regresiva va de 0 a $maxCountdownSeconds segundos.',
      );
    }
    if (questionSeconds < minQuestionSeconds ||
        questionSeconds > maxQuestionSeconds) {
      throw LiveException(
        message:
            'Cada pregunta dura entre $minQuestionSeconds y '
            '$maxQuestionSeconds segundos.',
      );
    }
    if (fastPrizes < 0 || rafflePrizes < 0) {
      throw LiveException(message: 'Los premios no pueden ser negativos.');
    }
    final saint = await Saint.db.findById(session, saintId);
    if (saint == null) throw LiveException(message: 'Santo no encontrado.');
    final questions = await Question.db.find(
      session,
      where: (t) => t.id.inSet(questionIds.toSet()),
    );
    if (questions.length != questionIds.length) {
      throw LiveException(message: 'Alguna pregunta ya no existe.');
    }

    final game = await session.db.transaction((tx) async {
      final running = await LiveGame.db.findFirstRow(
        session,
        where: (t) => t.phase.inSet(_active.toSet()),
        transaction: tx,
      );
      if (running != null) {
        throw LiveException(
          message: 'Ya hay una trivia en curso. Terminala o cancelala antes.',
        );
      }
      final now = _now();
      return LiveGame.db.insertRow(
        session,
        LiveGame(
          saintId: saintId,
          questionIds: questionIds,
          phase: LivePhase.countdown,
          currentIndex: 0,
          countdownTo: now.add(Duration(seconds: countdownSeconds)),
          questionSeconds: questionSeconds,
          fastPrizes: fastPrizes,
          rafflePrizes: rafflePrizes,
          createdBy: adminId,
        ),
        transaction: tx,
      );
    });
    await _scheduleOpen(session, game);
    await _post(session);
    return game;
  }

  /// The admin's one button: skips the countdown, closes the open question
  /// early, moves from a reveal to the next question, or ends the game after
  /// the last one.
  static Future<void> advance(Session session, int gameId) async {
    final game = await _game(session, gameId);
    switch (game.phase) {
      case LivePhase.countdown:
        await openQuestion(session, gameId, game.currentIndex);
      case LivePhase.question:
        await closeQuestion(session, gameId, game.currentIndex);
      case LivePhase.reveal:
        if (game.currentIndex + 1 < game.questionIds.length) {
          await _toNextQuestion(session, gameId, game.currentIndex);
        } else {
          await finish(session, gameId);
        }
      case LivePhase.finished:
      case LivePhase.cancelled:
      case LivePhase.idle:
        throw LiveException(message: 'Esa trivia ya terminó.');
    }
  }

  static Future<void> cancel(Session session, int gameId) async {
    final changed = await _transition(session, gameId, (game) {
      if (!_active.contains(game.phase)) return null;
      return game.copyWith(
        phase: LivePhase.cancelled,
        finishedAt: _now(),
      );
    });
    if (changed == null) {
      throw LiveException(message: 'Esa trivia ya terminó.');
    }
    await session.serverpod.futureCalls.cancel(_callId(gameId));
    await _post(session);
  }

  // -------------------------------------------------------------- the clock

  /// Opens question [index] if the game is still waiting for it. Run by the
  /// future call when the countdown ends, or by the admin to skip it.
  static Future<void> openQuestion(
    Session session,
    int gameId,
    int index,
  ) async {
    final opened = await _transition(session, gameId, (game) {
      if (game.phase != LivePhase.countdown || game.currentIndex != index) {
        return null;
      }
      final now = _now();
      return game.copyWith(
        phase: LivePhase.question,
        countdownTo: null,
        openedAt: now,
        closesAt: now.add(Duration(seconds: game.questionSeconds)),
      );
    });
    if (opened == null) return;
    // Replaces the pending open, if the admin skipped the countdown.
    await session.serverpod.futureCalls.cancel(_callId(gameId));
    await session.serverpod.futureCalls
        .callAtTime(opened.closesAt!, identifier: _callId(gameId))
        .live
        .closeQuestion(gameId, index);
    await _post(session);
  }

  /// Closes question [index] if it is still open.
  static Future<void> closeQuestion(
    Session session,
    int gameId,
    int index,
  ) async {
    final closed = await _transition(session, gameId, (game) {
      if (game.phase != LivePhase.question || game.currentIndex != index) {
        return null;
      }
      return game.copyWith(phase: LivePhase.reveal);
    });
    if (closed == null) return;
    await session.serverpod.futureCalls.cancel(_callId(gameId));
    await _post(session);
  }

  static Future<void> _toNextQuestion(
    Session session,
    int gameId,
    int index,
  ) async {
    final next = await _transition(session, gameId, (game) {
      if (game.phase != LivePhase.reveal || game.currentIndex != index) {
        return null;
      }
      return game.copyWith(
        phase: LivePhase.countdown,
        currentIndex: index + 1,
        countdownTo: _now().add(getReady),
        openedAt: null,
        closesAt: null,
      );
    });
    if (next == null) return;
    await _scheduleOpen(session, next);
    await _post(session);
  }

  /// Ends the game after the last reveal: ranks the players, picks the
  /// winners and grants their cards, all in one transaction, so a retry
  /// either finds it done or does it whole.
  static Future<void> finish(Session session, int gameId) async {
    final done = await session.db.transaction((tx) async {
      final game = await _lockedGame(session, gameId, tx);
      if (game.phase != LivePhase.reveal ||
          game.currentIndex != game.questionIds.length - 1) {
        return false;
      }
      final answers = await LiveAnswer.db.find(
        session,
        where: (t) => t.gameId.equals(gameId),
        transaction: tx,
      );
      final standings = _standings(answers);
      final scorers = standings.where((s) => s.points > 0).toList();
      final fast = scorers.take(game.fastPrizes).toList();
      final rest = scorers.skip(fast.length).toList()..shuffle(_random);
      final raffle = rest.take(game.rafflePrizes).toList();

      final profiles = await PlayerProfile.db.find(
        session,
        where: (t) => t.authUserId.inSet(
          {...fast, ...raffle}.map((s) => s.authUserId).toSet(),
        ),
        transaction: tx,
      );
      final names = {
        for (final p in profiles) p.authUserId: ProfileService.nameOf(p),
      };

      Future<LiveWinner> award(_Standing s) async {
        final saint = await _prizeFor(session, s.authUserId, game, tx);
        if (saint != null) {
          await UserSaintCard.db.insertRow(
            session,
            UserSaintCard(
              authUserId: s.authUserId,
              saintId: saint.id!,
              source: CardSource.live,
            ),
            transaction: tx,
          );
        }
        return LiveWinner(
          authUserId: s.authUserId,
          name: names[s.authUserId] ?? ProfileService.nameOf(null),
          points: s.points,
          saintId: saint?.id,
        );
      }

      final results = LiveResults(
        fast: [for (final s in fast) await award(s)],
        raffle: [for (final s in raffle) await award(s)],
      );
      await LiveGame.db.updateRow(
        session,
        game.copyWith(
          phase: LivePhase.finished,
          results: results,
          finishedAt: _now(),
        ),
        transaction: tx,
      );
      return true;
    });
    if (done) await _post(session);
  }

  /// The card a winner gets: the saint of the game, or any one they are
  /// missing when they already have it, or nothing with the album complete.
  static Future<Saint?> _prizeFor(
    Session session,
    UuidValue authUserId,
    LiveGame game,
    Transaction tx,
  ) async {
    final missing = await CollectionService.missingSaints(
      session,
      authUserId,
      transaction: tx,
    );
    if (missing.isEmpty) return null;
    return missing.where((s) => s.id == game.saintId).firstOrNull ??
        missing[_random.nextInt(missing.length)];
  }

  // ---------------------------------------------------------------- players

  /// Records [userId]'s answer to question [questionIndex]. The option comes
  /// in the order shown. Returns the player's standing.
  static Future<LiveMe> answer(
    Session session,
    UuidValue userId,
    int gameId,
    int questionIndex,
    int shownIndex,
  ) async {
    final now = _now();
    final game = await _game(session, gameId);
    if (game.phase != LivePhase.question ||
        game.currentIndex != questionIndex ||
        game.openedAt == null ||
        now.isAfter(game.closesAt!.add(lateGrace))) {
      throw LiveException(message: 'Esa pregunta ya cerró.');
    }
    final question = await Question.db.findById(
      session,
      game.questionIds[questionIndex],
    );
    if (question == null) {
      throw LiveException(message: 'La pregunta ya no existe.');
    }
    final order = _order(gameId, questionIndex, question.options.length);
    final stored = order.toStored(shownIndex);
    if (stored < 0) throw LiveException(message: 'Opción inválida.');

    final total = game.closesAt!.difference(game.openedAt!);
    final elapsed = now.difference(game.openedAt!);
    final correct = stored == question.correctIndex;
    final points = correct ? _points(elapsed, total) : 0;

    final existing = await LiveAnswer.db.findFirstRow(
      session,
      where: (t) =>
          t.gameId.equals(gameId) &
          t.questionIndex.equals(questionIndex) &
          t.authUserId.equals(userId),
    );
    if (existing != null) {
      throw LiveException(message: 'Ya respondiste esta pregunta.');
    }
    try {
      await LiveAnswer.db.insertRow(
        session,
        LiveAnswer(
          gameId: gameId,
          questionIndex: questionIndex,
          authUserId: userId,
          chosenIndex: stored,
          correct: correct,
          points: points,
          elapsedMs: elapsed.inMilliseconds.clamp(0, total.inMilliseconds),
        ),
      );
    } on DatabaseQueryException {
      // Two taps racing past the check above: the unique index keeps one.
      throw LiveException(message: 'Ya respondiste esta pregunta.');
    }
    _markChanged();
    _postSoon();

    // The open question does not count in the ranking until it closes, so a
    // snapshot from before this answer still gives the right totals.
    final snapshot = await _snapshot(session, allowStale: true);
    final me = snapshot.meFor(userId);
    return me.copyWith(answered: true, chosenIndex: shownIndex);
  }

  /// Points for a right answer that took [elapsed] out of [total].
  static int _points(Duration elapsed, Duration total) {
    if (total <= Duration.zero) return maxPoints;
    final fraction = (elapsed.inMilliseconds / total.inMilliseconds).clamp(
      0.0,
      1.0,
    );
    return (maxPoints - (maxPoints - minPoints) * fraction).round();
  }

  // ------------------------------------------------------------------ views

  /// The game as [userId] sees it; null for viewers without an account.
  static Future<LiveView> view(Session session, UuidValue? userId) async {
    final snapshot = await _snapshot(session);
    return snapshot.viewFor(userId, watching: _watching);
  }

  /// Sends a view now and another one after every change, until the viewer
  /// goes away.
  static Stream<LiveView> watch(Session session, UuidValue? userId) async* {
    _watching++;
    _postSoonIfActive();
    try {
      final signals = session.messages.createStream<LiveSignal>(channel);
      yield await view(session, userId);
      await for (final _ in signals) {
        yield await view(session, userId);
      }
    } finally {
      _watching--;
      _postSoonIfActive();
    }
  }

  // ----------------------------------------------------- signals and cache

  static int _version = 0;
  static int _watching = 0;
  static Timer? _pending;
  static _Snapshot? _cached;
  static Future<_Snapshot>? _building;
  static int _buildingVersion = -1;

  static void _markChanged() => _version++;

  /// Makes the next view read the database again. Only tests need it: they
  /// roll the data back behind the service's back, and every real change goes
  /// through here and already does this.
  static void forgetSnapshot() => _markChanged();

  /// Tells every stream that the game changed.
  static Future<void> _post(Session session) async {
    _markChanged();
    _pending?.cancel();
    _pending = null;
    await session.messages.postMessage(
      channel,
      LiveSignal(version: _version),
      scope: MessageScope.local,
    );
  }

  /// Like [_post], but at most once a second: answers and viewers coming
  /// and going arrive in bursts, and the screens only need the count.
  static void _postSoon() {
    if (_pending != null) return;
    _pending = Timer(const Duration(seconds: 1), () async {
      _pending = null;
      final session = await Serverpod.instance.createSession(
        enableLogging: false,
      );
      try {
        await _post(session);
      } finally {
        await session.close();
      }
    });
  }

  static void _postSoonIfActive() {
    final phase = _cached?.game?.phase;
    if (phase != null && _active.contains(phase)) _postSoon();
  }

  /// The shared snapshot of the current game, rebuilt once per change. With
  /// [allowStale], any snapshot already built will do.
  static Future<_Snapshot> _snapshot(
    Session session, {
    bool allowStale = false,
  }) async {
    final cached = _cached;
    if (cached != null && (allowStale || cached.version == _version)) {
      return cached;
    }
    if (_building != null && _buildingVersion == _version) return _building!;
    final version = _version;
    _buildingVersion = version;
    final building = _build(session, version);
    _building = building;
    try {
      final snapshot = await building;
      if (_cached == null || _cached!.version <= version) _cached = snapshot;
      return snapshot;
    } finally {
      if (identical(_building, building)) _building = null;
    }
  }

  static Future<_Snapshot> _build(Session session, int version) async {
    final latest = await LiveGame.db.findFirstRow(
      session,
      orderBy: (t) => t.id.desc(),
    );
    final now = _now();
    final shown =
        latest != null &&
        (_active.contains(latest.phase) ||
            (latest.finishedAt != null &&
                now.difference(latest.finishedAt!) < resultsShownFor));
    if (!shown) return _Snapshot.idle(version);

    final game = latest;
    final saint = await Saint.db.findById(session, game.saintId);
    final questions = await Question.db.find(
      session,
      where: (t) => t.id.inSet(game.questionIds.toSet()),
    );
    final byId = {for (final q in questions) q.id!: q};
    final answers = await LiveAnswer.db.find(
      session,
      where: (t) => t.gameId.equals(game.id!),
    );
    final players = answers.map((a) => a.authUserId).toSet();
    final profiles = players.isEmpty
        ? const <PlayerProfile>[]
        : await PlayerProfile.db.find(
            session,
            where: (t) => t.authUserId.inSet(players),
          );
    final prizeIds = {
      ...?game.results?.fast.map((w) => w.saintId),
      ...?game.results?.raffle.map((w) => w.saintId),
    }.whereType<int>().toSet();
    final prizeSaints = prizeIds.isEmpty
        ? const <Saint>[]
        : await Saint.db.find(session, where: (t) => t.id.inSet(prizeIds));
    return _Snapshot(
      version: version,
      game: game,
      saint: saint == null ? null : await SaintMapper.toInfo(session, saint),
      questions: [for (final id in game.questionIds) byId[id]],
      answers: answers,
      names: {
        for (final p in profiles) p.authUserId: ProfileService.nameOf(p),
      },
      saintNames: {for (final s in prizeSaints) s.id!: s.name},
    );
  }

  // ---------------------------------------------------------------- helpers

  static DateTime _now() => DateTime.now().toUtc();

  /// One identifier per game for its pending future call, so moving on
  /// cancels whatever was scheduled for the step before.
  static String _callId(int gameId) => 'live-game-$gameId';

  /// The options are shuffled once per question and shown in that order to
  /// everyone, so the host can talk about "the B".
  static OptionOrder _order(int gameId, int index, int length) =>
      OptionOrder.of(length, 'live:$gameId:$index');

  static Future<void> _scheduleOpen(Session session, LiveGame game) async {
    await session.serverpod.futureCalls.cancel(_callId(game.id!));
    await session.serverpod.futureCalls
        .callAtTime(game.countdownTo!, identifier: _callId(game.id!))
        .live
        .openQuestion(game.id!, game.currentIndex);
  }

  static Future<LiveGame> _game(Session session, int gameId) async {
    final game = await LiveGame.db.findById(session, gameId);
    if (game == null) throw LiveException(message: 'Trivia no encontrada.');
    return game;
  }

  static Future<LiveGame> _lockedGame(
    Session session,
    int gameId,
    Transaction tx,
  ) async {
    await LiveGame.db.lockRows(
      session,
      where: (t) => t.id.equals(gameId),
      lockMode: LockMode.forUpdate,
      transaction: tx,
    );
    final game = await LiveGame.db.findById(session, gameId, transaction: tx);
    if (game == null) throw LiveException(message: 'Trivia no encontrada.');
    return game;
  }

  /// Applies [change] to the game with its row locked, so the future call and
  /// the admin's button cannot both move the same step. [change] returns null
  /// when the game is no longer where the caller expected it.
  static Future<LiveGame?> _transition(
    Session session,
    int gameId,
    LiveGame? Function(LiveGame game) change,
  ) {
    return session.db.transaction((tx) async {
      final game = await _lockedGame(session, gameId, tx);
      final next = change(game);
      if (next == null) return null;
      return LiveGame.db.updateRow(session, next, transaction: tx);
    });
  }

  /// Players ordered by points, and on a tie by the time their right answers
  /// took in total: the faster one goes first.
  static List<_Standing> _standings(Iterable<LiveAnswer> answers) {
    final byUser = <UuidValue, _Standing>{};
    for (final a in answers) {
      final s = byUser.putIfAbsent(a.authUserId, () => _Standing(a.authUserId));
      s.points += a.points;
      if (a.correct) s.elapsedMs += a.elapsedMs;
    }
    return byUser.values.toList()..sort((a, b) {
      final byPoints = b.points.compareTo(a.points);
      return byPoints != 0 ? byPoints : a.elapsedMs.compareTo(b.elapsedMs);
    });
  }
}

class _Standing {
  _Standing(this.authUserId);

  final UuidValue authUserId;
  int points = 0;
  int elapsedMs = 0;
}

/// Everything about the current game that the views need, read once per
/// change and shared by every viewer.
class _Snapshot {
  _Snapshot({
    required this.version,
    required this.game,
    required this.saint,
    required this.questions,
    required this.answers,
    required this.names,
    required this.saintNames,
  }) {
    final game = this.game;
    if (game == null) return;
    // While a question is open its answers stay out of the ranking: points
    // jumping would tell everyone who got it right before the reveal.
    final hidden = game.phase == LivePhase.question ? game.currentIndex : -1;
    standings = LiveService._standings(
      answers.where((a) => a.questionIndex != hidden),
    );
    for (var i = 0; i < standings.length; i++) {
      _rank[standings[i].authUserId] = i + 1;
    }
    for (final a in answers) {
      if (a.questionIndex == game.currentIndex) _current[a.authUserId] = a;
    }
  }

  _Snapshot.idle(this.version)
    : game = null,
      saint = null,
      questions = const [],
      answers = const [],
      names = const {},
      saintNames = const {};

  final int version;
  final LiveGame? game;
  final SaintInfo? saint;
  final List<Question?> questions;
  final List<LiveAnswer> answers;
  final Map<UuidValue, String> names;
  final Map<int, String> saintNames;

  List<_Standing> standings = const [];
  final _rank = <UuidValue, int>{};
  final _current = <UuidValue, LiveAnswer>{};

  LiveView viewFor(UuidValue? userId, {required int watching}) {
    final now = LiveService._now();
    final game = this.game;
    if (game == null) {
      return LiveView(
        phase: LivePhase.idle,
        serverTime: now,
        watching: watching,
      );
    }
    final phase = game.phase;
    final index = game.currentIndex;
    final asking = phase == LivePhase.question || phase == LivePhase.reveal;
    final question = asking ? questions[index] : null;
    final order = question == null
        ? null
        : LiveService._order(game.id!, index, question.options.length);
    final showRanking =
        phase == LivePhase.reveal || phase == LivePhase.finished;

    List<int>? tally;
    if (phase == LivePhase.reveal && question != null) {
      tally = List.filled(question.options.length, 0);
      for (final a in _current.values) {
        final shown = order!.toShown(a.chosenIndex);
        if (shown >= 0) tally[shown]++;
      }
    }

    return LiveView(
      phase: phase,
      serverTime: now,
      gameId: game.id,
      saint: saint,
      questionNumber: index + 1,
      questionCount: game.questionIds.length,
      countdownTo: phase == LivePhase.countdown ? game.countdownTo : null,
      questionSeconds: game.questionSeconds,
      fastPrizes: game.fastPrizes,
      rafflePrizes: game.rafflePrizes,
      question: question == null
          ? null
          : QuizQuestion(
              id: question.id!,
              saintId: question.saintId,
              prompt: question.prompt,
              options: order!.apply(question.options),
            ),
      closesAt: phase == LivePhase.question ? game.closesAt : null,
      answeredCount: asking ? _current.length : null,
      correctIndex: phase == LivePhase.reveal && question != null
          ? order!.toShown(question.correctIndex)
          : null,
      tally: tally,
      leaderboard: showRanking
          ? [
              // Only those who scored: a top of zeros reads as nonsense.
              for (final s
                  in standings
                      .where((s) => s.points > 0)
                      .take(LiveService.leaderboardSize))
                LiveRankEntry(
                  rank: _rank[s.authUserId]!,
                  name: names[s.authUserId] ?? 'Peregrino',
                  points: s.points,
                  isMe: s.authUserId == userId,
                ),
            ]
          : null,
      fastWinners: _winners(game.results?.fast, userId),
      raffleWinners: _winners(game.results?.raffle, userId),
      watching: watching,
      me: userId == null ? null : meFor(userId, order: order),
    );
  }

  LiveMe meFor(UuidValue userId, {OptionOrder? order}) {
    final game = this.game;
    final rank = _rank[userId];
    final standing = rank == null ? null : standings[rank - 1];
    final current = _current[userId];
    final revealed = game?.phase == LivePhase.reveal;
    final won = [
      ...?game?.results?.fast,
      ...?game?.results?.raffle,
    ].where((w) => w.authUserId == userId).firstOrNull;
    return LiveMe(
      answered: current != null,
      chosenIndex: current == null ? null : order?.toShown(current.chosenIndex),
      correct: revealed && current != null ? current.correct : null,
      lastPoints: revealed && current != null ? current.points : null,
      totalPoints: standing?.points ?? 0,
      rank: rank,
      players: standings.length,
      wonSaintId: won?.saintId,
    );
  }

  List<LiveWinnerView>? _winners(List<LiveWinner>? winners, UuidValue? me) {
    if (winners == null) return null;
    return [
      for (final w in winners)
        LiveWinnerView(
          name: w.name,
          points: w.points,
          saintName: w.saintId == null ? null : saintNames[w.saintId],
          isMe: w.authUserId == me,
        ),
    ];
  }
}
