/// The order in which one player sees the options of a question.
///
/// Options are stored in the order the admin typed them, so the right one
/// tends to sit in the same slot and can be guessed without reading. Each
/// player gets their own shuffle instead, derived from a seed so that it does
/// not move around between reloads of the same question.
class OptionOrder {
  const OptionOrder._(this._stored);

  /// For each shown position, the stored index of the option that goes there.
  final List<int> _stored;

  /// The order for [length] options under [seed]. The same seed always gives
  /// the same order, on any run of the server.
  factory OptionOrder.of(int length, String seed) {
    final order = [for (var i = 0; i < length; i++) i];
    // Fisher-Yates with a small generator of our own: `Random(seed)` is not
    // promised to keep its sequence across Dart versions, and a reordering
    // mid-duel would move the options under the player's finger.
    var state = _hash(seed);
    for (var i = length - 1; i > 0; i--) {
      state = (state * 1103515245 + 12345) & 0x7fffffff;
      final j = state % (i + 1);
      final swap = order[i];
      order[i] = order[j];
      order[j] = swap;
    }
    return OptionOrder._(order);
  }

  /// [options] as the player sees them.
  List<String> apply(List<String> options) => [
    for (final i in _stored) options[i],
  ];

  /// The stored index of the option shown at [shownIndex], or -1 when the
  /// client sends a position that does not exist.
  int toStored(int shownIndex) =>
      shownIndex >= 0 && shownIndex < _stored.length ? _stored[shownIndex] : -1;

  /// Where the option stored at [storedIndex] is shown, or -1 when there is
  /// no such option.
  int toShown(int storedIndex) => _stored.indexOf(storedIndex);

  /// FNV-1a, so the order never depends on `String.hashCode`, which is free
  /// to change between runs.
  static int _hash(String seed) {
    var h = 0x811c9dc5;
    for (final unit in seed.codeUnits) {
      h = ((h ^ unit) * 0x01000193) & 0xffffffff;
    }
    return h;
  }
}
