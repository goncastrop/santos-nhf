import 'package:saints_nhf_client/saints_nhf_client.dart';

import 'titles.dart';

/// Heading of the saints someone met in life: "Con qué otros santos se
/// conoció", in singular when it was only one ("Con qué otra santa se
/// conoció") and in feminine when they were all women.
String metHeading(List<SaintInfo> saints) {
  if (saints.length == 1) {
    final noun = _nounOf(saints.single.name);
    final other = isFeminineName(saints.single.name) ? 'otra' : 'otro';
    return 'Con qué $other $noun se conoció';
  }
  return saints.every((s) => isFeminineName(s.name))
      ? 'Con qué otras santas se conoció'
      : 'Con qué otros santos se conoció';
}

/// "santa", "beata", "beato" or "santo", by how the catalog writes the name.
String _nounOf(String name) {
  final n = name.trim().toLowerCase();
  for (final noun in ['santa', 'beata', 'beato']) {
    if (n.startsWith('$noun ')) return noun;
  }
  return 'santo';
}
