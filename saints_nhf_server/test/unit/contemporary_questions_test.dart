import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:saints_nhf_server/src/questions/contemporary_questions.dart';
import 'package:test/test.dart';

Lifetime _life(
  int id,
  String name,
  int birth,
  int death, {
  bool birthApprox = false,
  bool deathApprox = false,
}) => Lifetime(
  saintId: id,
  name: name,
  birth: birth,
  death: death,
  birthApprox: birthApprox,
  deathApprox: deathApprox,
);

/// A catalog spread over the centuries, with a pair of contemporaries for
/// Francis.
final _catalog = [
  _life(1, 'San Francisco de Asís', 1181, 1226, birthApprox: true),
  _life(2, 'Santo Domingo de Guzmán', 1170, 1221),
  _life(3, 'San Antonio de Padua', 1195, 1231, birthApprox: true),
  _life(4, 'San Agustín de Hipona', 354, 430),
  _life(5, 'Santa Teresa de Jesús', 1515, 1582),
  _life(6, 'Santa Catalina de Siena', 1347, 1380),
  _life(7, 'San Juan Bosco', 1815, 1888),
  _life(8, 'Santo Tomás de Aquino', 1225, 1274),
];

Map<int, Lifetime> get _byId => {for (final l in _catalog) l.saintId: l};

void main() {
  group('ContemporaryQuestions.draft', () {
    test('offers exactly one contemporary and three surely apart', () {
      final q = ContemporaryQuestions.draft(_catalog.first, _catalog)!;
      final ids = q.optionSaintIds!;
      expect(q.options, hasLength(4));
      expect(ids.toSet(), hasLength(4));
      expect(ids, isNot(contains(1)));
      for (var i = 0; i < 4; i++) {
        final option = _byId[ids[i]]!;
        expect(q.options[i], option.name);
        if (i == q.correctIndex) {
          expect(
            ContemporaryQuestions.contemporaries(_catalog.first, option),
            isTrue,
          );
        } else {
          expect(ContemporaryQuestions.apart(_catalog.first, option), isTrue);
        }
      }
      expect(q.kind, QuestionKind.contemporary);
      expect(q.saintId, 1);
    });

    test('never offers one who is close but not clearly a contemporary', () {
      // Thomas was a baby when Francis died: neither answer is honest.
      final q = ContemporaryQuestions.draft(_catalog.first, _catalog)!;
      expect(q.optionSaintIds, isNot(contains(8)));
    });

    test('the same catalog always gives the same question', () {
      final a = ContemporaryQuestions.draft(_catalog.first, _catalog)!;
      final b = ContemporaryQuestions.draft(
        _catalog.first,
        _catalog.reversed,
      )!;
      expect(b.options, a.options);
      expect(b.correctIndex, a.correctIndex);
    });

    test('is null for a saint alone in their time', () {
      expect(ContemporaryQuestions.draft(_byId[4]!, _catalog), isNull);
    });

    test('is null when there are not three saints surely apart', () {
      final small = [_catalog[0], _catalog[1], _catalog[3], _catalog[4]];
      expect(ContemporaryQuestions.draft(_catalog.first, small), isNull);
    });

    test('takes the wrong options from the nearest non-contemporaries', () {
      // Fifteen saints spread far into the future, one per century: the
      // wrong options have to come from the closest ones.
      final far = [
        for (var i = 0; i < 15; i++)
          _life(100 + i, 'San Lejano $i', 1300 + i * 100, 1350 + i * 100),
      ];
      final catalog = [_catalog[0], _catalog[1], ...far];
      final q = ContemporaryQuestions.draft(_catalog.first, catalog)!;
      final wrong = [
        for (var i = 0; i < 4; i++)
          if (i != q.correctIndex) q.optionSaintIds![i],
      ];
      final nearest = {
        for (var i = 0; i < ContemporaryQuestions.nearestWrong; i++) 100 + i,
      };
      expect(wrong.every(nearest.contains), isTrue);
    });

    test('prefers a contemporary whose name does not give the answer away', () {
      final catalog = [
        _life(1, 'San Francisco Marto', 1908, 1919),
        _life(2, 'Santa Jacinta Marto', 1910, 1920),
        _life(3, 'San Alberto Hurtado', 1901, 1952),
        _life(4, 'San Agustín de Hipona', 354, 430),
        _life(5, 'Santa Teresa de Jesús', 1515, 1582),
        _life(6, 'Santa Catalina de Siena', 1347, 1380),
      ];
      final q = ContemporaryQuestions.draft(catalog.first, catalog)!;
      expect(q.optionSaintIds![q.correctIndex], 3);
    });

    test('falls back to the namesake when there is nobody else', () {
      final catalog = [
        _life(1, 'San Pedro Apóstol', 1, 64, birthApprox: true),
        _life(2, 'San Pablo Apóstol', 5, 67, birthApprox: true),
        _life(4, 'San Agustín de Hipona', 354, 430),
        _life(5, 'Santa Teresa de Jesús', 1515, 1582),
        _life(6, 'Santa Catalina de Siena', 1347, 1380),
      ];
      final q = ContemporaryQuestions.draft(catalog.first, catalog)!;
      expect(q.optionSaintIds![q.correctIndex], 2);
    });
  });

  group('ContemporaryQuestions dates', () {
    test('an approximate end narrows who surely overlapped', () {
      final a = _life(1, 'A', 1000, 1050);
      expect(
        ContemporaryQuestions.contemporaries(a, _life(2, 'B', 1040, 1100)),
        isTrue,
      );
      // c. 1040 may be 1045: five years together is not enough.
      expect(
        ContemporaryQuestions.contemporaries(
          a,
          _life(2, 'B', 1040, 1100, birthApprox: true),
        ),
        isFalse,
      );
    });

    test('an approximate end widens who may have overlapped', () {
      final a = _life(1, 'A', 1000, 1050);
      expect(ContemporaryQuestions.apart(a, _life(2, 'B', 1080, 1120)), isTrue);
      expect(
        ContemporaryQuestions.apart(
          a,
          _life(2, 'B', 1080, 1120, birthApprox: true),
        ),
        isFalse,
      );
    });

    test('works across the turn of the era', () {
      final baptist = _life(
        1,
        'San Juan Bautista',
        -5,
        30,
        birthApprox: true,
        deathApprox: true,
      );
      final peter = _life(
        2,
        'San Pedro Apóstol',
        1,
        64,
        birthApprox: true,
        deathApprox: true,
      );
      expect(ContemporaryQuestions.contemporaries(baptist, peter), isTrue);
    });
  });

  group('ContemporaryQuestions.promptFor', () {
    test('follows the gender of the name', () {
      expect(
        ContemporaryQuestions.promptFor('San Francisco de Asís'),
        '¿De quién fue contemporáneo San Francisco de Asís?',
      );
      expect(
        ContemporaryQuestions.promptFor('Santa Teresa de Jesús'),
        '¿De quién fue contemporánea Santa Teresa de Jesús?',
      );
      expect(
        ContemporaryQuestions.promptFor('Beata Chiara Luce Badano'),
        '¿De quién fue contemporánea Beata Chiara Luce Badano?',
      );
      expect(
        ContemporaryQuestions.promptFor('Santo Domingo de Guzmán'),
        '¿De quién fue contemporáneo Santo Domingo de Guzmán?',
      );
    });
  });

  group('ContemporaryQuestions.stillTrue', () {
    test('holds for a fresh draft', () {
      final q = ContemporaryQuestions.draft(_catalog.first, _catalog)!;
      expect(ContemporaryQuestions.stillTrue(q, _byId), isTrue);
    });

    test('breaks when an option is renamed', () {
      final q = ContemporaryQuestions.draft(_catalog.first, _catalog)!;
      final renamed = Map.of(_byId);
      final id = q.optionSaintIds!.first;
      final o = renamed[id]!;
      renamed[id] = _life(id, '${o.name} (corregido)', o.birth, o.death);
      expect(ContemporaryQuestions.stillTrue(q, renamed), isFalse);
    });

    test('breaks when a wrong option turns out to be a contemporary', () {
      final q = ContemporaryQuestions.draft(_catalog.first, _catalog)!;
      final moved = Map.of(_byId);
      final wrongIndex = (q.correctIndex + 1) % 4;
      final id = q.optionSaintIds![wrongIndex];
      moved[id] = _life(id, moved[id]!.name, 1180, 1240);
      expect(ContemporaryQuestions.stillTrue(q, moved), isFalse);
    });

    test('breaks when an option leaves the catalog', () {
      final q = ContemporaryQuestions.draft(_catalog.first, _catalog)!;
      final fewer = Map.of(_byId)..remove(q.optionSaintIds!.last);
      expect(ContemporaryQuestions.stillTrue(q, fewer), isFalse);
    });

    test('holds when an unrelated saint joins the catalog', () {
      final q = ContemporaryQuestions.draft(_catalog.first, _catalog)!;
      final more = Map.of(_byId)..[50] = _life(50, 'San Pío X', 1835, 1914);
      expect(ContemporaryQuestions.stillTrue(q, more), isTrue);
    });
  });
}
