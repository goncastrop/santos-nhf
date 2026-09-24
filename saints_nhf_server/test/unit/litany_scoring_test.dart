import 'package:saints_nhf_server/src/litany/litany_service.dart';
import 'package:test/test.dart';

void main() {
  group('LitanyService.multiplierFor', () {
    test('starts at one and steps up every streakPerStep answers', () {
      expect(LitanyService.multiplierFor(0), 1);
      expect(LitanyService.multiplierFor(LitanyService.streakPerStep - 1), 1);
      expect(LitanyService.multiplierFor(LitanyService.streakPerStep), 2);
      expect(LitanyService.multiplierFor(LitanyService.streakPerStep * 2), 3);
    });

    test('never goes past the ceiling', () {
      expect(
        LitanyService.multiplierFor(LitanyService.streakPerStep * 100),
        LitanyService.maxMultiplier,
      );
    });

    test('grows without ever going backwards', () {
      var previous = 0;
      for (var streak = 0; streak < 60; streak++) {
        final current = LitanyService.multiplierFor(streak);
        expect(current, greaterThanOrEqualTo(previous));
        previous = current;
      }
    });
  });
}
