import 'package:saints_nhf_client/saints_nhf_client.dart';

/// A year as it reads on screen: "1226", "5 a.C.", and "c. 1181" when the
/// date is only approximate.
String yearLabel(int year, {bool approx = false}) {
  final absolute = year.abs().toString();
  final era = year < 0 ? '$absolute a.C.' : absolute;
  return approx ? 'c. $era' : era;
}

/// "c. 1181 – 1226", or just one end when the other is unknown. Null when the
/// saint has no years loaded.
String? lifespanLabel(SaintInfo saint) {
  final birth = saint.birthYear;
  final death = saint.deathYear;
  if (birth == null && death == null) return null;
  if (birth != null && death != null) {
    return '${yearLabel(birth, approx: saint.birthApprox)} – '
        '${yearLabel(death, approx: saint.deathApprox)}';
  }
  if (birth != null) {
    return 'n. ${yearLabel(birth, approx: saint.birthApprox)}';
  }
  return '† ${yearLabel(death!, approx: saint.deathApprox)}';
}

/// The century a year belongs to: 1226 is the 13th, -5 is the 1st BC
/// (returned negative).
int centuryOf(int year) =>
    year > 0 ? ((year - 1) ~/ 100) + 1 : -(((-year - 1) ~/ 100) + 1);

/// "s. XIII", or "s. I a.C." for a negative century.
String centuryLabel(int century) {
  final roman = _roman(century.abs());
  return century < 0 ? 's. $roman a.C.' : 's. $roman';
}

/// The span a saint occupies on the timeline, or null when neither year is
/// known. A missing end is filled in with a plausible lifetime so the bar has
/// a length: most of these saints lived into their sixties.
({int from, int to})? lifeSpan(SaintInfo saint) {
  const assumedLifetime = 60;
  final birth = saint.birthYear;
  final death = saint.deathYear;
  if (birth == null && death == null) return null;
  final from = birth ?? death! - assumedLifetime;
  final to = death ?? birth! + assumedLifetime;
  return from <= to ? (from: from, to: to) : (from: to, to: from);
}

/// Whether both ends of the bar are real data. A bar with a guessed end is
/// drawn faded so it does not read as a fact.
bool hasBothYears(SaintInfo saint) =>
    saint.birthYear != null && saint.deathYear != null;

const _romanUnits = [
  (1000, 'M'),
  (900, 'CM'),
  (500, 'D'),
  (400, 'CD'),
  (100, 'C'),
  (90, 'XC'),
  (50, 'L'),
  (40, 'XL'),
  (10, 'X'),
  (9, 'IX'),
  (5, 'V'),
  (4, 'IV'),
  (1, 'I'),
];

String _roman(int value) {
  var rest = value;
  final buffer = StringBuffer();
  for (final (amount, numeral) in _romanUnits) {
    while (rest >= amount) {
      buffer.write(numeral);
      rest -= amount;
    }
  }
  return buffer.toString();
}
