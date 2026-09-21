import '../generated/protocol.dart';

/// Reads a category score from a saint.
int scoreOf(Saint saint, ScoreCategory category) => switch (category) {
  ScoreCategory.catequesis => saint.catequesis,
  ScoreCategory.escritos => saint.escritos,
  ScoreCategory.oracion => saint.oracion,
  ScoreCategory.patronazgos => saint.patronazgos,
  ScoreCategory.evangelizacion => saint.evangelizacion,
  ScoreCategory.viajes => saint.viajes,
};

/// Spanish label of a category.
String labelOf(ScoreCategory category) => switch (category) {
  ScoreCategory.catequesis => 'Catequesis',
  ScoreCategory.escritos => 'Escritos',
  ScoreCategory.oracion => 'Oración',
  ScoreCategory.patronazgos => 'Patronazgos',
  ScoreCategory.evangelizacion => 'Evangelización',
  ScoreCategory.viajes => 'Viajes',
};
