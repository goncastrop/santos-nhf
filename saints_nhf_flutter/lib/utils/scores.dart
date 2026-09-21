import 'package:saints_nhf_client/saints_nhf_client.dart';

/// Labels and lookups for the six shared [ScoreCategory] values.
extension ScoreCategoryX on ScoreCategory {
  String get label => switch (this) {
    ScoreCategory.catequesis => 'Catequesis',
    ScoreCategory.escritos => 'Escritos',
    ScoreCategory.oracion => 'Oración',
    ScoreCategory.patronazgos => 'Patronazgos',
    ScoreCategory.evangelizacion => 'Evangelización',
    ScoreCategory.viajes => 'Viajes',
  };

  String get abbreviation => switch (this) {
    ScoreCategory.catequesis => 'CAT',
    ScoreCategory.escritos => 'ESC',
    ScoreCategory.oracion => 'ORA',
    ScoreCategory.patronazgos => 'PAT',
    ScoreCategory.evangelizacion => 'EVA',
    ScoreCategory.viajes => 'VIA',
  };

  int of(SaintScores scores) => switch (this) {
    ScoreCategory.catequesis => scores.catequesis,
    ScoreCategory.escritos => scores.escritos,
    ScoreCategory.oracion => scores.oracion,
    ScoreCategory.patronazgos => scores.patronazgos,
    ScoreCategory.evangelizacion => scores.evangelizacion,
    ScoreCategory.viajes => scores.viajes,
  };
}

/// Rounded mean of the six scores, shown as the card's overall rating.
int overallOf(SaintScores scores) {
  final total = ScoreCategory.values.fold<int>(
    0,
    (sum, c) => sum + c.of(scores),
  );
  return (total / ScoreCategory.values.length).round();
}

SaintScores scoresOfSaint(Saint saint) => SaintScores(
  catequesis: saint.catequesis,
  escritos: saint.escritos,
  oracion: saint.oracion,
  patronazgos: saint.patronazgos,
  evangelizacion: saint.evangelizacion,
  viajes: saint.viajes,
);

SaintInfo infoOfSaint(Saint saint, {String? illustrationUrl}) => SaintInfo(
  id: saint.id ?? 0,
  name: saint.name,
  slug: saint.slug,
  title: saint.title,
  titles: saint.titles,
  feastMonth: saint.feastMonth,
  feastDay: saint.feastDay,
  birthYear: saint.birthYear,
  birthApprox: saint.birthApprox,
  deathYear: saint.deathYear,
  deathApprox: saint.deathApprox,
  birthPlace: saint.birthPlace,
  birthLat: saint.birthLat,
  birthLng: saint.birthLng,
  deathPlace: saint.deathPlace,
  deathLat: saint.deathLat,
  deathLng: saint.deathLng,
  bio: saint.bio,
  prayer: saint.prayer,
  illustrationUrl: illustrationUrl,
  season: saint.season,
  episode: saint.episode,
  youtubeUrl: saint.youtubeUrl,
);
