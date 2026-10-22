import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:saints_nhf_server/src/meetings/meeting_service.dart';
import 'package:test/test.dart';

Saint _saint(
  int id,
  String name, {
  int? birth,
  int? death,
  bool birthApprox = false,
  bool deathApprox = false,
}) => Saint(
  id: id,
  name: name,
  slug: 's$id',
  birthYear: birth,
  deathYear: death,
  birthApprox: birthApprox,
  deathApprox: deathApprox,
);

void main() {
  group('MeetingService.pair', () {
    test('stores the lower id first, whatever the order given', () {
      expect(MeetingService.pair(7, 3), (3, 7));
      expect(MeetingService.pair(3, 7), (3, 7));
    });
  });

  group('MeetingService.whyNot', () {
    final juanPablo = _saint(1, 'San Juan Pablo II', birth: 1920, death: 2005);
    final teresa = _saint(
      2,
      'Santa Teresa de Calcuta',
      birth: 1910,
      death: 1997,
    );
    final francisco = _saint(
      3,
      'San Francisco de Asís',
      birth: 1181,
      death: 1226,
      birthApprox: true,
    );

    test('lets through two saints who lived at the same time', () {
      expect(MeetingService.whyNot(juanPablo, teresa), isNull);
    });

    test('rejects two saints who never shared a year', () {
      expect(
        MeetingService.whyNot(juanPablo, francisco),
        contains('no vivieron en la misma época'),
      );
    });

    test('rejects a saint with themself', () {
      expect(MeetingService.whyNot(teresa, teresa), isNotNull);
    });

    test('gives the benefit of the doubt to a saint missing a year', () {
      final unknown = _saint(4, 'San Sin Fechas', birth: 1500);
      expect(MeetingService.whyNot(unknown, juanPablo), isNull);
    });

    test('reads a "c." end with the same margin as the contemporaries', () {
      // Died exactly 3 years before the other was born, but the death is
      // only approximate: it may have overlapped.
      final early = _saint(5, 'San Antiguo', birth: 400, death: 450);
      final approx = _saint(
        6,
        'San Aproximado',
        birth: 350,
        death: 397,
        deathApprox: true,
      );
      expect(MeetingService.whyNot(early, approx), isNull);
      final exact = _saint(7, 'San Exacto', birth: 350, death: 397);
      expect(MeetingService.whyNot(early, exact), isNotNull);
    });
  });

  group('MeetingService.byBirth', () {
    test('orders oldest first and leaves saints without a year last', () {
      final sorted = MeetingService.byBirth([
        _saint(1, 'San Sin Año'),
        _saint(2, 'San Juan Pablo II', birth: 1920),
        _saint(3, 'Santa Teresa de Calcuta', birth: 1910),
      ]);
      expect(sorted.map((s) => s.id), [3, 2, 1]);
    });
  });
}
