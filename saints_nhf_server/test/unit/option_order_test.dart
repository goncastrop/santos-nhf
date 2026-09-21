import 'package:saints_nhf_server/src/questions/option_order.dart';
import 'package:test/test.dart';

void main() {
  group('OptionOrder', () {
    const options = ['a', 'b', 'c', 'd'];

    test('is a permutation of the options', () {
      for (var i = 0; i < 100; i++) {
        final shown = OptionOrder.of(4, 'seed-$i').apply(options);
        expect(shown..sort(), options);
      }
    });

    test('the same seed always gives the same order', () {
      final first = OptionOrder.of(4, 'quiz:u1:2026-09-19:7').apply(options);
      final again = OptionOrder.of(4, 'quiz:u1:2026-09-19:7').apply(options);
      expect(again, first);
    });

    test('shown and stored indexes are inverses of each other', () {
      for (var i = 0; i < 100; i++) {
        final order = OptionOrder.of(4, 'seed-$i');
        for (var stored = 0; stored < 4; stored++) {
          expect(order.toStored(order.toShown(stored)), stored);
        }
      }
    });

    test('the option shown at a position is the stored one it maps to', () {
      final order = OptionOrder.of(4, 'seed');
      final shown = order.apply(options);
      for (var i = 0; i < 4; i++) {
        expect(shown[i], options[order.toStored(i)]);
      }
    });

    test('a position that does not exist is not an answer', () {
      final order = OptionOrder.of(4, 'seed');
      expect(order.toStored(-1), -1);
      expect(order.toStored(4), -1);
      expect(order.toShown(9), -1);
    });

    test('the right answer lands in every slot across seeds', () {
      final slots = <int>{};
      for (var i = 0; i < 200; i++) {
        slots.add(OptionOrder.of(4, 'seed-$i').toShown(0));
      }
      expect(slots, {0, 1, 2, 3});
    });
  });
}
