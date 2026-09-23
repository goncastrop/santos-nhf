import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../saints/saint_mapper.dart';
import '../social/profile_service.dart';
import '../util/argentina_day.dart';
import 'question_service.dart';

/// The daily question: one per day about a saint in the player's collection.
class QuizService {
  static final _random = Random();

  static Future<DailyQuiz> today(Session session, UuidValue me) async {
    return session.db.transaction((tx) async {
      var profile = await ProfileService.ensure(session, me, transaction: tx);
      final today = todayKey();
      final yesterday = dayKey(
        nowInArgentina().subtract(const Duration(days: 1)),
      );

      // A streak survives only if yesterday (or today) was answered right.
      if (profile.streak > 0 &&
          profile.lastCorrectDay != today &&
          profile.lastCorrectDay != yesterday) {
        profile = await PlayerProfile.db.updateRow(
          session,
          profile.copyWith(streak: 0),
          columns: (t) => [t.streak],
          transaction: tx,
        );
      }

      if (profile.quizDay != today) {
        final question = await _pickForPlayer(session, me, transaction: tx);
        profile = await PlayerProfile.db.updateRow(
          session,
          profile.copyWith(
            quizDay: today,
            quizQuestionId: question?.id,
            quizAnswered: false,
            quizChosenIndex: null,
          ),
          // Solo las columnas del quiz: escribir la fila entera revertía lo que
          // otro endpoint hubiera escrito mientras tanto, y así se perdió más
          // de una vez la marca del mazo inicial.
          columns: (t) => [
            t.quizDay,
            t.quizQuestionId,
            t.quizAnswered,
            t.quizChosenIndex,
          ],
          transaction: tx,
        );
      }
      return _state(session, profile, transaction: tx);
    });
  }

  static Future<DailyQuiz> answer(
    Session session,
    UuidValue me,
    int questionId,
    int chosenIndex,
  ) async {
    return session.db.transaction((tx) async {
      var profile = await ProfileService.ensure(session, me, transaction: tx);
      final today = todayKey();
      if (profile.quizDay != today || profile.quizQuestionId != questionId) {
        throw QuizException(
          message: 'Esa no es la pregunta de hoy. Volvé a cargar.',
        );
      }
      if (profile.quizAnswered) {
        throw QuizException(message: 'Ya respondiste la pregunta de hoy.');
      }
      final question = await Question.db.findById(
        session,
        questionId,
        transaction: tx,
      );
      if (question == null) {
        throw QuizException(message: 'La pregunta ya no existe.');
      }
      final storedIndex = QuestionService.orderFor(
        question,
        _seed(profile, question),
      ).toStored(chosenIndex);
      final correct = question.correctIndex == storedIndex;
      final yesterday = dayKey(
        nowInArgentina().subtract(const Duration(days: 1)),
      );
      final streak = correct
          ? (profile.lastCorrectDay == yesterday ? profile.streak + 1 : 1)
          : 0;
      profile = await PlayerProfile.db.updateRow(
        session,
        profile.copyWith(
          quizAnswered: true,
          quizChosenIndex: storedIndex,
          streak: streak,
          bestStreak: max(profile.bestStreak, streak),
          totalAnswered: profile.totalAnswered + 1,
          totalCorrect: profile.totalCorrect + (correct ? 1 : 0),
          lastCorrectDay: correct ? today : profile.lastCorrectDay,
        ),
        columns: (t) => [
          t.quizAnswered,
          t.quizChosenIndex,
          t.streak,
          t.bestStreak,
          t.totalAnswered,
          t.totalCorrect,
          t.lastCorrectDay,
        ],
        transaction: tx,
      );
      return _state(session, profile, transaction: tx);
    });
  }

  /// A random question about one of the player's published cards.
  static Future<Question?> _pickForPlayer(
    Session session,
    UuidValue me, {
    Transaction? transaction,
  }) async {
    final cards = await UserSaintCard.db.find(
      session,
      where: (t) =>
          t.authUserId.equals(me) &
          t.saint.status.equals(SaintStatus.published),
      transaction: transaction,
    );
    final saintIds = cards.map((c) => c.saintId).toSet();
    if (saintIds.isEmpty) return null;
    final questions = await Question.db.find(
      session,
      where: (t) => t.saintId.inSet(saintIds),
      transaction: transaction,
    );
    if (questions.isEmpty) return null;
    return questions[_random.nextInt(questions.length)];
  }

  /// Ties the shuffle to this player's question for this day, so the options
  /// keep the same order while the question is open and differ between
  /// players.
  static String _seed(PlayerProfile profile, Question question) =>
      'quiz:${profile.authUserId}:${profile.quizDay}:${question.id}';

  static Future<DailyQuiz> _state(
    Session session,
    PlayerProfile profile, {
    Transaction? transaction,
  }) async {
    Question? question;
    Saint? saint;
    if (profile.quizQuestionId != null) {
      question = await Question.db.findById(
        session,
        profile.quizQuestionId!,
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
    final saintInfo = saint == null
        ? null
        : await SaintMapper.toInfo(session, saint);
    // The answer indexes are stored in the order the admin typed the options;
    // the player saw them shuffled, so report the positions they clicked on.
    final order = question == null
        ? null
        : QuestionService.orderFor(question, _seed(profile, question));
    return DailyQuiz(
      question: question == null || profile.quizAnswered
          ? null
          : QuestionService.toQuiz(question, order!),
      saint: saintInfo,
      answeredToday: profile.quizAnswered,
      wasCorrect: profile.quizAnswered && question != null
          ? question.correctIndex == profile.quizChosenIndex
          : null,
      correctIndex: profile.quizAnswered && question != null
          ? order!.toShown(question.correctIndex)
          : null,
      chosenIndex: profile.quizAnswered && profile.quizChosenIndex != null
          ? order?.toShown(profile.quizChosenIndex!)
          : null,
      streak: profile.streak,
      bestStreak: profile.bestStreak,
      totalAnswered: profile.totalAnswered,
      totalCorrect: profile.totalCorrect,
      unavailableReason: question == null && !profile.quizAnswered
          ? 'Todavía no hay preguntas sobre los santos de tu colección. '
                'Volvé mañana.'
          : null,
    );
  }
}
