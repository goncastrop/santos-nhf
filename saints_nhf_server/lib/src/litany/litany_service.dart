import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../questions/question_service.dart';
import '../saints/saint_mapper.dart';
import '../social/profile_service.dart';

/// La Letanía: a solo run of questions about the saints in your album that
/// lasts as long as your lives do.
///
/// One question at a time. A right answer scores and lengthens the streak,
/// which raises the multiplier; a wrong one costs a life and resets the
/// streak. Three wrong answers end the run and the score is kept as the
/// player's record.
class LitanyService {
  static const lives = 3;

  /// Points a right answer is worth before the multiplier.
  static const basePoints = 10;

  /// Correct answers in a row needed for each step of the multiplier.
  static const streakPerStep = 3;

  /// Ceiling of the multiplier, so a long run does not run away.
  static const maxMultiplier = 5;

  /// What the next right answer pays at [streak].
  static int multiplierFor(int streak) {
    final step = 1 + streak ~/ streakPerStep;
    return step > maxMultiplier ? maxMultiplier : step;
  }

  /// The run in progress, or an empty view when there is none.
  static Future<LitanyView> state(Session session, UuidValue me) async {
    final run = await _openRun(session, me);
    final profile = await ProfileService.ensure(session, me);
    if (run == null) {
      return LitanyView(
        lives: lives,
        score: 0,
        streak: 0,
        nextPoints: basePoints,
        multiplier: 1,
        answered: 0,
        correct: 0,
        finished: false,
        maxLives: lives,
        maxMultiplier: maxMultiplier,
        bestScore: profile.litanyBest,
        newRecord: false,
        unavailableReason: await _blockedReason(session, me),
      );
    }
    return _view(session, run, profile);
  }

  /// Starts a run, or returns the one already going on. Coming back to a run
  /// in progress must never wipe its score.
  static Future<LitanyView> start(Session session, UuidValue me) async {
    return session.db.transaction((tx) async {
      final existing = await _openRun(session, me, transaction: tx);
      if (existing != null) {
        final profile = await ProfileService.ensure(
          session,
          me,
          transaction: tx,
        );
        return _view(session, existing, profile, transaction: tx);
      }
      final reason = await _blockedReason(session, me, transaction: tx);
      if (reason != null) throw LitanyException(message: reason);

      var run = await LitanyRun.db.insertRow(
        session,
        LitanyRun(authUserId: me, lives: lives, askedQuestionIds: const []),
        transaction: tx,
      );
      run = await _draw(session, me, run, transaction: tx);
      final profile = await ProfileService.ensure(session, me, transaction: tx);
      return _view(session, run, profile, transaction: tx);
    });
  }

  /// Grades [chosenIndex] against the question on the table. The result stays
  /// on screen until [next] is called, so the player gets to see it.
  static Future<LitanyView> answer(
    Session session,
    UuidValue me,
    int chosenIndex,
  ) async {
    return session.db.transaction((tx) async {
      final run = await _openRun(session, me, transaction: tx);
      if (run == null) {
        throw LitanyException(message: 'No tenés una letanía en curso.');
      }
      if (run.questionId == null) {
        throw LitanyException(message: 'No hay pregunta para responder.');
      }
      if (run.chosenIndex != null) {
        throw LitanyException(message: 'Ya respondiste esta pregunta.');
      }
      final question = await Question.db.findById(
        session,
        run.questionId!,
        transaction: tx,
      );
      if (question == null) {
        throw LitanyException(message: 'La pregunta ya no existe.');
      }
      // The player sees the options shuffled, so what arrives is a position on
      // their screen. Answers are graded in the question's own order.
      final storedIndex = QuestionService.orderFor(
        question,
        _seed(run, question),
      ).toStored(chosenIndex);
      final right = question.correctIndex == storedIndex;
      final streak = right ? run.streak + 1 : 0;
      final gained = right ? basePoints * multiplierFor(run.streak) : 0;
      final livesLeft = right ? run.lives : run.lives - 1;

      var updated = run.copyWith(
        chosenIndex: storedIndex,
        score: run.score + gained,
        streak: streak,
        bestStreak: streak > run.bestStreak ? streak : run.bestStreak,
        answered: run.answered + 1,
        correct: run.correct + (right ? 1 : 0),
        lives: livesLeft,
      );
      updated = await LitanyRun.db.updateRow(
        session,
        updated,
        transaction: tx,
      );
      if (livesLeft <= 0) {
        updated = await _finish(session, me, updated, transaction: tx);
      }
      final profile = await ProfileService.ensure(session, me, transaction: tx);
      return _view(session, updated, profile, transaction: tx);
    });
  }

  /// Puts the next question on the table.
  static Future<LitanyView> next(Session session, UuidValue me) async {
    return session.db.transaction((tx) async {
      final run = await _openRun(session, me, transaction: tx);
      if (run == null) {
        throw LitanyException(message: 'No tenés una letanía en curso.');
      }
      if (run.chosenIndex == null) {
        throw LitanyException(message: 'Primero respondé la pregunta.');
      }
      final drawn = await _draw(session, me, run, transaction: tx);
      final profile = await ProfileService.ensure(session, me, transaction: tx);
      return _view(session, drawn, profile, transaction: tx);
    });
  }

  /// Ends the run on purpose, keeping the score earned so far.
  static Future<LitanyView> giveUp(Session session, UuidValue me) async {
    return session.db.transaction((tx) async {
      final run = await _openRun(session, me, transaction: tx);
      if (run == null) {
        throw LitanyException(message: 'No tenés una letanía en curso.');
      }
      final done = await _finish(session, me, run, transaction: tx);
      final profile = await ProfileService.ensure(session, me, transaction: tx);
      return _view(session, done, profile, transaction: tx);
    });
  }

  static Future<LitanyRun?> _openRun(
    Session session,
    UuidValue me, {
    Transaction? transaction,
  }) {
    return LitanyRun.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(me) & t.finished.equals(false),
      orderBy: (t) => t.id.desc(),
      transaction: transaction,
    );
  }

  /// Draws a question the player has not been asked, in this run or before.
  static Future<LitanyRun> _draw(
    Session session,
    UuidValue me,
    LitanyRun run, {
    Transaction? transaction,
  }) async {
    final saintIds = await _saintIdsOf(session, me, transaction: transaction);
    final asked = run.askedQuestionIds ?? const <int>[];
    final question = await QuestionService.pickForPlayer(
      session,
      me,
      saintIds,
      exclude: asked.toSet(),
      transaction: transaction,
    );
    if (question == null) {
      // Nothing left to ask: close the run rather than leave it stuck.
      return _finish(session, me, run, transaction: transaction);
    }
    await QuestionService.markSeen(
      session,
      me,
      question.id!,
      transaction: transaction,
    );
    return LitanyRun.db.updateRow(
      session,
      run.copyWith(
        questionId: question.id,
        chosenIndex: null,
        askedQuestionIds: [...asked, question.id!],
      ),
      transaction: transaction,
    );
  }

  static Future<LitanyRun> _finish(
    Session session,
    UuidValue me,
    LitanyRun run, {
    Transaction? transaction,
  }) async {
    final profile = await ProfileService.ensure(
      session,
      me,
      transaction: transaction,
    );
    final record = run.score > profile.litanyBest;
    if (record) {
      await PlayerProfile.db.updateRow(
        session,
        profile.copyWith(litanyBest: run.score),
        // Only the record: writing the whole row would revert whatever another
        // endpoint wrote in the meantime.
        columns: (t) => [t.litanyBest],
        transaction: transaction,
      );
    }
    return LitanyRun.db.updateRow(
      session,
      run.copyWith(
        finished: true,
        wasRecord: record,
        finishedAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  }

  static Future<Set<int>> _saintIdsOf(
    Session session,
    UuidValue me, {
    Transaction? transaction,
  }) async {
    // The ids only, not the mapped cards: this runs on every draw and the
    // illustration URLs would be built for nothing.
    final cards = await UserSaintCard.db.find(
      session,
      where: (t) =>
          t.authUserId.equals(me) &
          t.saint.status.equals(SaintStatus.published),
      transaction: transaction,
    );
    return {for (final c in cards) c.saintId};
  }

  /// Why a run cannot start, or null when it can.
  static Future<String?> _blockedReason(
    Session session,
    UuidValue me, {
    Transaction? transaction,
  }) async {
    final saintIds = await _saintIdsOf(session, me, transaction: transaction);
    if (saintIds.isEmpty) {
      return 'Necesitás cartas en tu álbum para rezar la letanía.';
    }
    final withQuestions = await QuestionService.withQuestions(
      session,
      saintIds,
      transaction: transaction,
    );
    if (withQuestions.isEmpty) {
      return 'Todavía no hay preguntas sobre los santos de tu colección. '
          'Volvé mañana.';
    }
    return null;
  }

  /// Ties the shuffle to this question inside this run, so the options keep
  /// their order while it is on screen.
  static String _seed(LitanyRun run, Question question) =>
      'litany:${run.id}:${question.id}';

  static Future<LitanyView> _view(
    Session session,
    LitanyRun run,
    PlayerProfile profile, {
    Transaction? transaction,
  }) async {
    Question? question;
    Saint? saint;
    if (run.questionId != null) {
      question = await Question.db.findById(
        session,
        run.questionId!,
        transaction: transaction,
      );
      if (question != null) {
        saint = await Saint.db.findById(
          session,
          question.saintId,
          transaction: transaction,
        );
      }
    }
    final order = question == null
        ? null
        : QuestionService.orderFor(question, _seed(run, question));
    final graded = run.chosenIndex != null && question != null;
    return LitanyView(
      runId: run.finished ? null : run.id,
      lives: run.lives < 0 ? 0 : run.lives,
      score: run.score,
      streak: run.streak,
      nextPoints: basePoints * multiplierFor(run.streak),
      multiplier: multiplierFor(run.streak),
      answered: run.answered,
      correct: run.correct,
      // The question travels while its result is on screen too: the app needs
      // the options to show which one was right. What makes it unanswerable is
      // [correctIndex] being set, not the question being withheld.
      question: question == null
          ? null
          : QuestionService.toQuiz(question, order!),
      saint: saint == null ? null : await SaintMapper.toInfo(session, saint),
      lastWasCorrect: graded ? question.correctIndex == run.chosenIndex : null,
      // The streak already moved, so the multiplier that paid for this answer
      // is the one for the streak before it.
      lastGain: !graded
          ? null
          : question.correctIndex == run.chosenIndex
          ? basePoints * multiplierFor(run.streak - 1)
          : 0,
      correctIndex: graded ? order!.toShown(question.correctIndex) : null,
      chosenIndex: graded ? order!.toShown(run.chosenIndex!) : null,
      finished: run.finished,
      maxLives: lives,
      maxMultiplier: maxMultiplier,
      // The profile is read after [_finish] has written the record, so this is
      // the stored best even on the view that ends a run.
      bestScore: profile.litanyBest,
      newRecord: run.finished && run.wasRecord,
      unavailableReason: null,
    );
  }
}
