import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'option_order.dart';

/// Access to the question bank.
class QuestionService {
  static final _random = Random();

  /// The order in which the player behind [seed] sees the options of [q].
  static OptionOrder orderFor(Question q, String seed) =>
      OptionOrder.of(q.options.length, seed);

  /// [q] as the player sees it: no correct answer, and the options shuffled
  /// by [order] so that the right one is not always in the same slot.
  static QuizQuestion toQuiz(Question q, OptionOrder order) => QuizQuestion(
    id: q.id!,
    saintId: q.saintId,
    prompt: q.prompt,
    options: order.apply(q.options),
  );

  /// A random question about [saintId], or null when there is none.
  static Future<Question?> randomFor(
    Session session,
    int saintId, {
    Set<int> exclude = const {},
    Transaction? transaction,
  }) async {
    final all = await Question.db.find(
      session,
      where: (t) => t.saintId.equals(saintId),
      transaction: transaction,
    );
    var pool = all.where((q) => !exclude.contains(q.id)).toList();
    if (pool.isEmpty) pool = all;
    if (pool.isEmpty) return null;
    return pool[_random.nextInt(pool.length)];
  }

  /// Which of [saintIds] have at least one question.
  static Future<Set<int>> withQuestions(
    Session session,
    Iterable<int> saintIds, {
    Transaction? transaction,
  }) async {
    final ids = saintIds.toSet();
    if (ids.isEmpty) return {};
    final questions = await Question.db.find(
      session,
      where: (t) => t.saintId.inSet(ids),
      transaction: transaction,
    );
    return questions.map((q) => q.saintId).toSet();
  }

  /// Number of questions per saint, for the admin list.
  static Future<Map<int, int>> counts(Session session) async {
    final questions = await Question.db.find(session);
    final counts = <int, int>{};
    for (final q in questions) {
      counts[q.saintId] = (counts[q.saintId] ?? 0) + 1;
    }
    return counts;
  }

  static void validate(Question q) {
    if (q.prompt.trim().isEmpty) {
      throw AdminException(message: 'La pregunta no puede estar vacía.');
    }
    if (q.options.length != 4 || q.options.any((o) => o.trim().isEmpty)) {
      throw AdminException(message: 'Cargá exactamente cuatro opciones.');
    }
    if (q.correctIndex < 0 || q.correctIndex > 3) {
      throw AdminException(message: 'Marcá cuál es la opción correcta.');
    }
  }
}
