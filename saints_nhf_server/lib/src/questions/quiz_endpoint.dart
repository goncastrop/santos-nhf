import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'quiz_service.dart';

/// The daily question and its streak.
class QuizEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<DailyQuiz> today(Session session) {
    return QuizService.today(session, session.authenticated!.authUserId);
  }

  Future<DailyQuiz> answer(Session session, int questionId, int chosenIndex) {
    return QuizService.answer(
      session,
      session.authenticated!.authUserId,
      questionId,
      chosenIndex,
    );
  }
}
