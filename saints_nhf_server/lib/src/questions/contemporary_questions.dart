import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The years a saint lived, as the contemporaries question reads them.
class Lifetime {
  const Lifetime({
    required this.saintId,
    required this.name,
    required this.birth,
    required this.death,
    this.birthApprox = false,
    this.deathApprox = false,
  });

  /// Null when [saint] is missing either year: with only one end there is no
  /// telling who they lived alongside.
  static Lifetime? of(Saint saint) {
    final birth = saint.birthYear;
    final death = saint.deathYear;
    if (saint.id == null || birth == null || death == null || birth > death) {
      return null;
    }
    return Lifetime(
      saintId: saint.id!,
      name: saint.name,
      birth: birth,
      death: death,
      birthApprox: saint.birthApprox,
      deathApprox: saint.deathApprox,
    );
  }

  final int saintId;
  final String name;
  final int birth;
  final int death;
  final bool birthApprox;
  final bool deathApprox;

  static const _margin = ContemporaryQuestions.approxMargin;

  /// The years they surely lived: an approximate end is pulled in.
  int get surelyFrom => birth + (birthApprox ? _margin : 0);
  int get surelyTo => death - (deathApprox ? _margin : 0);

  /// The years they may have lived: an approximate end is pushed out.
  int get possiblyFrom => birth - (birthApprox ? _margin : 0);
  int get possiblyTo => death + (deathApprox ? _margin : 0);
}

/// "¿De quién fue contemporáneo San Francisco de Asís?", with four saints of
/// the catalog of which only one lived at the same time.
///
/// Nobody types these: they come out of the years of birth and death, one per
/// saint that has someone to pair with. They are stored as ordinary rows of
/// `question` (with [QuestionKind.contemporary]), so the daily question, the
/// duel, La Letanía and the live trivia draw them, remember them as seen and
/// grade them like any other, without knowing where they came from. Among
/// the five or so typed questions of a saint, this one comes up every now and
/// then.
///
/// [sync] keeps them in step with the catalog, and runs at startup and after
/// anything that writes saints.
class ContemporaryQuestions {
  /// Years taken off or added at each approximate end, so that a "c. 480" is
  /// never what decides an answer.
  static const approxMargin = 5;

  /// Years both must surely have been alive at once to count as
  /// contemporaries: a saint who died when the other was two does not. For
  /// short lives it is half the shorter one instead, or the two Fátima
  /// children, nine years together, would not be contemporaries.
  static const minOverlap = 10;

  /// Years between one death and the other birth, at the widest reading of
  /// the dates, for a wrong option. Anything closer is arguable and is never
  /// offered, neither as the right answer nor as a wrong one.
  static const minGap = 30;

  /// The wrong options are drawn from this many of the nearest saints that
  /// were not contemporaries: the question is about the timeline, and an
  /// option from another millennium answers it alone.
  static const nearestWrong = 6;

  /// Whether [a] and [b] were surely alive at the same time for long enough
  /// (see [minOverlap]).
  static bool contemporaries(Lifetime a, Lifetime b) {
    final together =
        min(a.surelyTo, b.surelyTo) - max(a.surelyFrom, b.surelyFrom);
    final shorter = min(
      a.surelyTo - a.surelyFrom,
      b.surelyTo - b.surelyFrom,
    );
    return together >= max(1, min(minOverlap, shorter ~/ 2));
  }

  /// Years from the end of one life to the start of the other, at the widest
  /// reading of their dates. Negative when they may have overlapped.
  static int gap(Lifetime a, Lifetime b) =>
      max(b.possiblyFrom - a.possiblyTo, a.possiblyFrom - b.possiblyTo);

  /// Whether [a] and [b] surely did not live at the same time.
  static bool apart(Lifetime a, Lifetime b) => gap(a, b) >= minGap;

  /// The question about [name]. The feminine follows how the name starts,
  /// as the titles on the card do.
  static String promptFor(String name) {
    final n = name.trim().toLowerCase();
    final feminine = n.startsWith('santa ') || n.startsWith('beata ');
    return '¿De quién fue ${feminine ? 'contemporánea' : 'contemporáneo'} '
        '${name.trim()}?';
  }

  /// The question about [subject] out of [catalog], or null when nobody in it
  /// lived at the same time or there are not three who surely did not. The
  /// same catalog always gives the same question.
  static Question? draft(Lifetime subject, Iterable<Lifetime> catalog) {
    final others = catalog.where((o) => o.saintId != subject.saintId).toList()
      ..sort((a, b) => a.saintId.compareTo(b.saintId));

    var right = others.where((o) => contemporaries(subject, o)).toList();
    // Siblings, or an apostle next to the other apostles, give the answer
    // away by the last word of the name. Only when there is nobody else.
    final unrelated = right
        .where((o) => _lastWord(o.name) != _lastWord(subject.name))
        .toList();
    if (unrelated.isNotEmpty) right = unrelated;

    final wrong = others.where((o) => apart(subject, o)).toList()
      ..sort((a, b) {
        final byGap = gap(subject, a).compareTo(gap(subject, b));
        return byGap != 0 ? byGap : a.saintId.compareTo(b.saintId);
      });
    if (right.isEmpty || wrong.length < 3) return null;

    final random = Random(subject.saintId);
    final answer = right[random.nextInt(right.length)];
    final options = (wrong.take(nearestWrong).toList()..shuffle(random))
        .take(3)
        .toList();
    // Each player sees them shuffled anyway; the stored slot is random too so
    // that no screen that shows them in stored order gives the answer away.
    final correctIndex = random.nextInt(4);
    options.insert(correctIndex, answer);
    return Question(
      saintId: subject.saintId,
      prompt: promptFor(subject.name),
      options: [for (final o in options) o.name],
      correctIndex: correctIndex,
      kind: QuestionKind.contemporary,
      optionSaintIds: [for (final o in options) o.saintId],
    );
  }

  /// Whether a stored question still holds against [catalog]: same names,
  /// every saint still in it, the right one still a contemporary and the
  /// wrong ones still apart. One that holds is kept as is, so editing a
  /// saint does not reshuffle every question in the catalog.
  static bool stillTrue(Question question, Map<int, Lifetime> catalog) {
    final subject = catalog[question.saintId];
    final ids = question.optionSaintIds;
    if (subject == null ||
        ids == null ||
        ids.length != 4 ||
        question.options.length != 4 ||
        ids.toSet().length != 4 ||
        ids.contains(subject.saintId) ||
        question.prompt != promptFor(subject.name)) {
      return false;
    }
    for (var i = 0; i < 4; i++) {
      final option = catalog[ids[i]];
      if (option == null || question.options[i] != option.name) return false;
      final holds = i == question.correctIndex
          ? contemporaries(subject, option)
          : apart(subject, option);
      if (!holds) return false;
    }
    return true;
  }

  /// Brings the stored questions in line with the published catalog: one
  /// for every saint that can have it, rewritten in place (same id, so the
  /// players' history stays) when it no longer holds, and deleted when the
  /// saint can no longer have one.
  static Future<ContemporarySync> sync(Session session) async {
    final saints = await Saint.db.find(
      session,
      where: (t) => t.status.equals(SaintStatus.published),
    );
    final catalog = <int, Lifetime>{
      for (final s in saints) s.id!: ?Lifetime.of(s),
    };
    final stored = await Question.db.find(
      session,
      where: (t) => t.kind.equals(QuestionKind.contemporary),
      orderBy: (t) => t.id,
    );

    final current = <int, Question>{};
    final toDelete = <Question>[];
    for (final q in stored) {
      // Two syncs at once can both insert one for a new saint. One is enough.
      if (current.containsKey(q.saintId)) {
        toDelete.add(q);
      } else {
        current[q.saintId] = q;
      }
    }

    final toInsert = <Question>[];
    final toUpdate = <Question>[];
    var kept = 0;
    final saintIds = {...catalog.keys, ...current.keys}.toList()..sort();
    for (final saintId in saintIds) {
      final existing = current[saintId];
      if (existing != null && stillTrue(existing, catalog)) {
        kept++;
        continue;
      }
      final subject = catalog[saintId];
      final fresh = subject == null ? null : draft(subject, catalog.values);
      if (fresh == null) {
        if (existing != null) toDelete.add(existing);
      } else if (existing == null) {
        toInsert.add(fresh);
      } else {
        toUpdate.add(
          existing.copyWith(
            prompt: fresh.prompt,
            options: fresh.options,
            correctIndex: fresh.correctIndex,
            optionSaintIds: fresh.optionSaintIds,
          ),
        );
      }
    }

    if (toDelete.isNotEmpty || toInsert.isNotEmpty || toUpdate.isNotEmpty) {
      await session.db.transaction((tx) async {
        if (toDelete.isNotEmpty) {
          await Question.db.delete(session, toDelete, transaction: tx);
        }
        if (toInsert.isNotEmpty) {
          await Question.db.insert(session, toInsert, transaction: tx);
        }
        for (final q in toUpdate) {
          await Question.db.updateRow(
            session,
            q,
            columns: (t) => [
              t.prompt,
              t.options,
              t.correctIndex,
              t.optionSaintIds,
            ],
            transaction: tx,
          );
        }
      });
    }
    return ContemporarySync(
      created: toInsert.length,
      updated: toUpdate.length,
      deleted: toDelete.length,
      kept: kept,
    );
  }

  /// [sync] for the places where it is a side effect: a failure is logged
  /// and does not undo or fail the save that triggered it. The next sync
  /// (at the latest, the next startup) catches up.
  static Future<void> refresh(Session session) async {
    try {
      final result = await sync(session);
      if (result.changed) {
        session.log(
          'Preguntas de contemporáneos: ${result.created} nuevas, '
          '${result.updated} rehechas, ${result.deleted} borradas, '
          '${result.kept} sin cambios.',
        );
      }
    } catch (e, stackTrace) {
      session.log(
        'No se pudieron actualizar las preguntas de contemporáneos.',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    }
  }

  static String _lastWord(String name) =>
      name.trim().toLowerCase().split(RegExp(r'\s+')).last;
}

/// What a [ContemporaryQuestions.sync] did.
class ContemporarySync {
  const ContemporarySync({
    required this.created,
    required this.updated,
    required this.deleted,
    required this.kept,
  });

  final int created;
  final int updated;
  final int deleted;
  final int kept;

  bool get changed => created + updated + deleted > 0;
}
