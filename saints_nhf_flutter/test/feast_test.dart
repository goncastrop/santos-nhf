import 'package:flutter_test/flutter_test.dart';
import 'package:saints_nhf_flutter/utils/feast.dart';

void main() {
  group('Given the app has to follow the Argentina calendar day', () {
    test('when asking for today then the key is the Argentina date, which is '
        'three hours behind UTC', () {
      final utc = DateTime.now().toUtc();
      final argentina = utc.subtract(const Duration(hours: 3));
      final expected =
          '${argentina.year}-'
          '${argentina.month.toString().padLeft(2, '0')}-'
          '${argentina.day.toString().padLeft(2, '0')}';
      expect(todayKey(), expected);
    });

    test('when asking for the next midnight then it is the start of tomorrow '
        'and always in the future', () {
      final now = nowInArgentina();
      final next = nextArgentinaMidnight();

      expect(next.isAfter(now), isTrue);
      expect(next.hour, 0);
      expect(next.minute, 0);
      expect(next.second, 0);
      expect(next.difference(now).inHours, lessThanOrEqualTo(24));
      // It is the day right after the one the key names.
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      expect(next, tomorrow);
    });
  });
}
