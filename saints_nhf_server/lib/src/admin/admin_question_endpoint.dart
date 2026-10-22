import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../questions/question_service.dart';
import 'admin_scope.dart';

/// Admin management of the question bank.
class AdminQuestionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AppScope.admin};

  Future<List<Question>> listFor(Session session, int saintId) {
    return Question.db.find(
      session,
      where: (t) => t.saintId.equals(saintId),
      orderBy: (t) => t.id,
    );
  }

  /// Number of questions per saint id.
  Future<Map<int, int>> counts(Session session) =>
      QuestionService.counts(session);

  Future<Question> save(Session session, Question question) async {
    QuestionService.validate(question);
    final saint = await Saint.db.findById(session, question.saintId);
    if (saint == null) throw AdminException(message: 'Santo no encontrado.');
    if (question.id != null) {
      await _ensureTyped(session, question.id!);
    }
    final cleaned = question.copyWith(
      prompt: question.prompt.trim(),
      options: question.options.map((o) => o.trim()).toList(),
      // Only the generator writes the generated ones.
      kind: QuestionKind.manual,
      optionSaintIds: null,
    );
    if (cleaned.id == null) return Question.db.insertRow(session, cleaned);
    return Question.db.updateRow(session, cleaned);
  }

  Future<void> delete(Session session, int questionId) async {
    final question = await _ensureTyped(session, questionId);
    if (question == null) return;
    await Question.db.deleteRow(session, question);
  }

  /// The question [questionId], refusing the ones built from the catalog:
  /// the next sync would rewrite an edit and bring a deleted one back.
  static Future<Question?> _ensureTyped(
    Session session,
    int questionId,
  ) async {
    final question = await Question.db.findById(session, questionId);
    if (question != null && question.kind != QuestionKind.manual) {
      throw AdminException(
        message:
            'Esta pregunta se arma sola con los años de los santos. Para '
            'cambiarla, corregí los años en la ficha del santo.',
      );
    }
    return question;
  }
}
