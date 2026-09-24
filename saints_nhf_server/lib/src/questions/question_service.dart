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

  /// A question about one of [saintIds] that [me] has not been asked yet, or
  /// null when those saints have no questions at all.
  ///
  /// A plain random draw over the whole bank kept bringing the same questions
  /// back — with a handful per saint the birthday problem is brutal, and the
  /// player reads it as "always the same ones". So unseen questions come
  /// first, and only when every one has come up does it start over with the
  /// ones seen longest ago.
  ///
  /// [exclude] drops questions that cannot be used right now (already played
  /// in this duel), and is ignored when it would leave nothing to ask.
  static Future<Question?> pickForPlayer(
    Session session,
    UuidValue me,
    Set<int> saintIds, {
    Set<int> exclude = const {},
    Transaction? transaction,
  }) async {
    if (saintIds.isEmpty) return null;
    final all = await Question.db.find(
      session,
      where: (t) => t.saintId.inSet(saintIds),
      transaction: transaction,
    );
    var pool = all.where((q) => !exclude.contains(q.id)).toList();
    if (pool.isEmpty) pool = all;
    if (pool.isEmpty) return null;

    final seenRows = await QuestionSeen.db.find(
      session,
      where: (t) =>
          t.authUserId.equals(me) &
          t.questionId.inSet({for (final q in pool) q.id!}),
      transaction: transaction,
    );
    final seenAt = {for (final r in seenRows) r.questionId: r.seenAt};
    final unseen = pool.where((q) => !seenAt.containsKey(q.id)).toList();
    if (unseen.isNotEmpty) return unseen[_random.nextInt(unseen.length)];

    // Second lap: the oldest half, at random inside it, so the order of the
    // first lap does not repeat either.
    pool.sort((a, b) => seenAt[a.id]!.compareTo(seenAt[b.id]!));
    final oldest = pool.take(max(1, pool.length ~/ 2)).toList();
    return oldest[_random.nextInt(oldest.length)];
  }

  /// Records that [me] was asked [questionId]. Call it when the question is
  /// handed to the player, not when they answer: an abandoned duel round still
  /// showed it.
  static Future<void> markSeen(
    Session session,
    UuidValue me,
    int questionId, {
    Transaction? transaction,
  }) async {
    final existing = await QuestionSeen.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(me) & t.questionId.equals(questionId),
      transaction: transaction,
    );
    if (existing == null) {
      await QuestionSeen.db.insertRow(
        session,
        QuestionSeen(authUserId: me, questionId: questionId),
        transaction: transaction,
      );
    } else {
      await QuestionSeen.db.updateRow(
        session,
        existing.copyWith(seenAt: DateTime.now().toUtc()),
        columns: (t) => [t.seenAt],
        transaction: transaction,
      );
    }
  }

  /// A random question about [saintId], or null when there is none. Used for
  /// the machine opponent, which has no history of its own.
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
