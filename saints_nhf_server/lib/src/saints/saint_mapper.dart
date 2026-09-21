import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Converts stored [Saint] rows into the public and card representations.
class SaintMapper {
  static const storageId = 'public';

  /// Public info of a saint, resolving the illustration URL.
  static Future<SaintInfo> toInfo(Session session, Saint saint) async {
    return SaintInfo(
      id: saint.id!,
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
      illustrationUrl: _versioned(
        await illustrationUrl(session, saint.illustrationPath),
        saint,
      ),
      season: saint.season,
      episode: saint.episode,
      youtubeUrl: saint.youtubeUrl,
    );
  }

  /// Public info of many saints, resolving illustration URLs in one call.
  static Future<List<SaintInfo>> toInfos(
    Session session,
    List<Saint> saints,
  ) async {
    final paths = saints.map((s) => s.illustrationPath).nonNulls.toList();
    final urls = paths.isEmpty
        ? <Uri?>[]
        : await session.storage.publicDownloadUrls(
            storageId: storageId,
            paths: paths,
          );
    final urlByPath = <String, String?>{
      for (var i = 0; i < paths.length; i++) paths[i]: urls[i]?.toString(),
    };
    return [
      for (final saint in saints)
        SaintInfo(
          id: saint.id!,
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
          illustrationUrl: saint.illustrationPath == null
              ? null
              : _versioned(urlByPath[saint.illustrationPath], saint),
          season: saint.season,
          episode: saint.episode,
          youtubeUrl: saint.youtubeUrl,
        ),
    ];
  }

  static SaintScores toScores(Saint saint) => SaintScores(
    catequesis: saint.catequesis,
    escritos: saint.escritos,
    oracion: saint.oracion,
    patronazgos: saint.patronazgos,
    evangelizacion: saint.evangelizacion,
    viajes: saint.viajes,
  );

  /// Appends the saint's update time so clients refetch a replaced image.
  static String? _versioned(String? url, Saint saint) {
    if (url == null) return null;
    final v = saint.updatedAt.millisecondsSinceEpoch;
    return url.contains('?') ? '$url&v=$v' : '$url?v=$v';
  }

  static Future<String?> illustrationUrl(Session session, String? path) async {
    if (path == null) return null;
    final url = await session.storage.publicDownloadUrl(
      storageId: storageId,
      path: path,
    );
    return url.toString();
  }
}
