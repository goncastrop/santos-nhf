import 'package:csv/csv.dart';
import 'package:serverpod/serverpod.dart';

import '../books/book_service.dart';
import '../generated/protocol.dart';
import '../meetings/meeting_service.dart';
import '../questions/contemporary_questions.dart';
import '../saints/saint_revisions.dart';
import '../saints/score_category_x.dart';

/// Export and import of the saints catalog, the question bank and the
/// recommended reading as CSV, so the team can maintain the content in a
/// spreadsheet.
///
/// Saints are matched by `slug`; questions by `id`, or by saint + prompt when
/// the id is empty; books by `id`, or by saint + title; meetings by the pair of
/// slugs, in either order. Rows never delete anything. The questions built
/// from the years ([QuestionKind.contemporary]) are neither exported nor
/// imported: they come from the saints file.
class CsvCatalog {
  static const saintHeaders = [
    'slug',
    'nombre',
    'titulo',
    'titulos_liturgicos',
    'fiesta_mes',
    'fiesta_dia',
    'nacimiento',
    'nacimiento_aprox',
    'muerte',
    'muerte_aprox',
    'nacimiento_lugar',
    'nacimiento_lat',
    'nacimiento_lng',
    'muerte_lugar',
    'muerte_lat',
    'muerte_lng',
    'temporada',
    'capitulo',
    'youtube_url',
    'estado',
    'catequesis',
    'escritos',
    'oracion',
    'patronazgos',
    'evangelizacion',
    'viajes',
    'biografia',
    'oracion_texto',
  ];

  static const bookHeaders = [
    'id',
    'santo_slug',
    'titulo',
    'autor',
    'tipo',
    'anio',
    'editorial',
    'link',
    'nota',
  ];

  static const questionHeaders = [
    'id',
    'santo_slug',
    'pregunta',
    'opcion_a',
    'opcion_b',
    'opcion_c',
    'opcion_d',
    'correcta',
  ];

  /// One row per pair of saints who met. The order of the two does not
  /// matter.
  static const meetingHeaders = ['santo_slug', 'otro_santo_slug'];

  static const _converter = ListToCsvConverter(eol: '\n');
  static const _parser = CsvToListConverter(
    eol: '\n',
    shouldParseNumbers: false,
    allowInvalid: false,
  );

  // ---------------------------------------------------------------- export

  static Future<String> exportSaints(Session session) async {
    final saints = await Saint.db.find(session, orderBy: (t) => t.name);
    return _converter.convert([
      saintHeaders,
      for (final s in saints)
        [
          s.slug,
          s.name,
          s.title ?? '',
          (s.titles ?? const []).map((t) => t.name).join('; '),
          s.feastMonth?.toString() ?? '',
          s.feastDay?.toString() ?? '',
          s.birthYear?.toString() ?? '',
          _yesNo(s.birthApprox),
          s.deathYear?.toString() ?? '',
          _yesNo(s.deathApprox),
          s.birthPlace ?? '',
          _coord(s.birthLat),
          _coord(s.birthLng),
          s.deathPlace ?? '',
          _coord(s.deathLat),
          _coord(s.deathLng),
          s.season?.toString() ?? '',
          s.episode?.toString() ?? '',
          s.youtubeUrl ?? '',
          s.status == SaintStatus.published ? 'publicado' : 'borrador',
          for (final c in ScoreCategory.values) scoreOf(s, c).toString(),
          s.bio,
          s.prayer ?? '',
        ],
    ]);
  }

  static Future<String> exportQuestions(Session session) async {
    final saints = await Saint.db.find(session);
    final slugById = {for (final s in saints) s.id!: s.slug};
    final questions = await Question.db.find(
      session,
      where: (t) => t.kind.equals(QuestionKind.manual),
      orderBy: (t) => t.id,
    );
    const letters = ['A', 'B', 'C', 'D'];
    return _converter.convert([
      questionHeaders,
      for (final q in questions)
        [
          q.id.toString(),
          slugById[q.saintId] ?? '',
          q.prompt,
          for (var i = 0; i < 4; i++) i < q.options.length ? q.options[i] : '',
          letters[q.correctIndex.clamp(0, 3)],
        ],
    ]);
  }

  static Future<String> exportBooks(Session session) async {
    final saints = await Saint.db.find(session);
    final slugById = {for (final s in saints) s.id!: s.slug};
    final books = await SaintBook.db.find(session);
    return _converter.convert([
      bookHeaders,
      for (final b in BookService.sorted(books))
        [
          b.id.toString(),
          slugById[b.saintId] ?? '',
          b.title,
          b.author ?? '',
          b.kind.name,
          b.year?.toString() ?? '',
          b.publisher ?? '',
          b.url ?? '',
          b.note ?? '',
        ],
    ]);
  }

  /// Each pair once, the one born first on the left, in the order of the
  /// timeline.
  static Future<String> exportMeetings(Session session) async {
    final saints = await Saint.db.find(session);
    final byId = {for (final s in saints) s.id!: s};
    final pairs = <(Saint, Saint)>[];
    for (final m in await SaintMeeting.db.find(session)) {
      final a = byId[m.saintAId];
      final b = byId[m.saintBId];
      if (a == null || b == null) continue;
      final ordered = MeetingService.byBirth([a, b]);
      pairs.add((ordered[0], ordered[1]));
    }
    final order = {
      for (final (i, s) in MeetingService.byBirth(saints).indexed) s.id!: i,
    };
    pairs.sort((x, y) {
      final first = order[x.$1.id]!.compareTo(order[y.$1.id]!);
      return first != 0 ? first : order[x.$2.id]!.compareTo(order[y.$2.id]!);
    });
    return _converter.convert([
      meetingHeaders,
      for (final (a, b) in pairs) [a.slug, b.slug],
    ]);
  }

  // ---------------------------------------------------------------- import

  static Future<ImportReport> importSaints(
    Session session,
    String csv, {
    required bool apply,
  }) async {
    final rows = _rows(csv, saintHeaders, required: {'slug', 'nombre'});
    final existing = await Saint.db.find(session);
    final bySlug = {for (final s in existing) s.slug: s};

    final errors = <String>[];
    final changes = <String>[];
    final toInsert = <Saint>[];
    final toUpdate = <(Saint previous, Saint next)>[];
    var unchanged = 0;
    final seen = <String>{};

    for (final (line, row) in rows) {
      try {
        var slug = row['slug']!.trim();
        final name = row['nombre']!.trim();
        if (slug.isEmpty) slug = slugify(name);
        if (name.isEmpty) throw 'falta el nombre';
        if (!isValidSlug(slug)) throw 'slug inválido "$slug"';
        if (!seen.add(slug)) {
          throw 'el slug "$slug" está repetido en el archivo';
        }

        final previous = bySlug[slug];
        final base = previous ?? Saint(name: name, slug: slug);
        final next = base.copyWith(
          name: name,
          slug: slug,
          title: _text(row['titulo']),
          titles: _titles(row['titulos_liturgicos'], previous?.titles),
          feastMonth: _int(row['fiesta_mes'], 'fiesta_mes', 1, 12),
          feastDay: _int(row['fiesta_dia'], 'fiesta_dia', 1, 31),
          birthYear: _int(row['nacimiento'], 'nacimiento', -1000, 2400),
          birthApprox: _bool(
            row['nacimiento_aprox'],
            'nacimiento_aprox',
            base.birthApprox,
          ),
          deathYear: _int(row['muerte'], 'muerte', -1000, 2400),
          deathApprox: _bool(
            row['muerte_aprox'],
            'muerte_aprox',
            base.deathApprox,
          ),
          birthPlace: _text(row['nacimiento_lugar']),
          birthLat: _coordinate(row['nacimiento_lat'], 'nacimiento_lat', 90),
          birthLng: _coordinate(row['nacimiento_lng'], 'nacimiento_lng', 180),
          deathPlace: _text(row['muerte_lugar']),
          deathLat: _coordinate(row['muerte_lat'], 'muerte_lat', 90),
          deathLng: _coordinate(row['muerte_lng'], 'muerte_lng', 180),
          season: _int(row['temporada'], 'temporada', 1, 999),
          episode: _int(row['capitulo'], 'capitulo', 1, 9999),
          youtubeUrl: _text(row['youtube_url']),
          status: _status(row['estado'], previous?.status),
          catequesis: _score(row['catequesis'], 'catequesis', base.catequesis),
          escritos: _score(row['escritos'], 'escritos', base.escritos),
          oracion: _score(row['oracion'], 'oracion', base.oracion),
          patronazgos: _score(
            row['patronazgos'],
            'patronazgos',
            base.patronazgos,
          ),
          evangelizacion: _score(
            row['evangelizacion'],
            'evangelizacion',
            base.evangelizacion,
          ),
          viajes: _score(row['viajes'], 'viajes', base.viajes),
          bio: (row['biografia'] ?? base.bio).trim(),
          prayer: _text(row['oracion_texto']),
        );
        if ((next.feastMonth == null) != (next.feastDay == null)) {
          throw 'completá fiesta_mes y fiesta_dia, o ninguno';
        }
        if (next.birthYear != null &&
            next.deathYear != null &&
            next.birthYear! > next.deathYear!) {
          throw 'el año de nacimiento es posterior al de muerte';
        }
        // Una coordenada sola no ubica nada en el mapa.
        if ((next.birthLat == null) != (next.birthLng == null)) {
          throw 'completá nacimiento_lat y nacimiento_lng, o ninguno';
        }
        if ((next.deathLat == null) != (next.deathLng == null)) {
          throw 'completá muerte_lat y muerte_lng, o ninguno';
        }
        if (next.status == SaintStatus.published && next.bio.isEmpty) {
          throw 'un santo publicado necesita biografía';
        }
        if (previous == null) {
          toInsert.add(next);
          changes.add('Nuevo: $name');
        } else {
          final diff = _saintDiff(previous, next);
          if (diff.isEmpty) {
            unchanged++;
          } else {
            toUpdate.add((previous, next));
            changes.add('$name: ${diff.join(', ')}');
          }
        }
      } catch (e) {
        errors.add('Línea $line: $e');
      }
    }

    if (apply && errors.isEmpty) {
      final now = DateTime.now().toUtc();
      await session.db.transaction((tx) async {
        if (toInsert.isNotEmpty) {
          await Saint.db.insert(
            session,
            [
              for (final s in toInsert)
                s.copyWith(createdAt: now, updatedAt: now),
            ],
            transaction: tx,
          );
        }
        for (final (previous, next) in toUpdate) {
          await recordRevision(
            session,
            previous,
            'Importación CSV',
            transaction: tx,
          );
          await Saint.db.updateRow(
            session,
            next.copyWith(
              illustrationPath: previous.illustrationPath,
              createdAt: previous.createdAt,
              updatedAt: now,
            ),
            transaction: tx,
          );
        }
      });
      await ContemporaryQuestions.refresh(session);
    }
    return ImportReport(
      applied: apply && errors.isEmpty,
      created: toInsert.length,
      updated: toUpdate.length,
      unchanged: unchanged,
      changes: changes,
      errors: errors,
    );
  }

  static Future<ImportReport> importQuestions(
    Session session,
    String csv, {
    required bool apply,
  }) async {
    final rows = _rows(
      csv,
      questionHeaders,
      required: {
        'santo_slug',
        'pregunta',
        'opcion_a',
        'opcion_b',
        'opcion_c',
        'opcion_d',
        'correcta',
      },
    );
    final saints = await Saint.db.find(session);
    final saintBySlug = {for (final s in saints) s.slug: s};
    final questions = await Question.db.find(session);
    final byId = {for (final q in questions) q.id!: q};
    final byKey = {
      for (final q in questions)
        if (q.kind == QuestionKind.manual)
          '${q.saintId}|${q.prompt.trim().toLowerCase()}': q,
    };

    final errors = <String>[];
    final changes = <String>[];
    final toInsert = <Question>[];
    final toUpdate = <Question>[];
    var unchanged = 0;

    for (final (line, row) in rows) {
      try {
        final slug = row['santo_slug']!.trim();
        final saint = saintBySlug[slug];
        if (saint == null) throw 'no existe un santo con slug "$slug"';
        final prompt = row['pregunta']!.trim();
        if (prompt.isEmpty) throw 'falta la pregunta';
        final options = [
          for (final k in ['opcion_a', 'opcion_b', 'opcion_c', 'opcion_d'])
            row[k]!.trim(),
        ];
        if (options.any((o) => o.isEmpty)) throw 'faltan opciones';
        final correct = _correctIndex(row['correcta']!);

        final idText = (row['id'] ?? '').trim();
        Question? previous;
        if (idText.isNotEmpty) {
          final id = int.tryParse(idText);
          previous = id == null ? null : byId[id];
          if (previous == null) throw 'no existe la pregunta con id $idText';
          if (previous.kind != QuestionKind.manual) {
            throw 'la pregunta $idText se arma sola con los años de los '
                'santos y no se importa';
          }
          if (previous.saintId != saint.id) {
            throw 'la pregunta $idText pertenece a otro santo';
          }
        } else {
          previous = byKey['${saint.id}|${prompt.toLowerCase()}'];
        }
        final next =
            (previous ??
                    Question(
                      saintId: saint.id!,
                      prompt: prompt,
                      options: options,
                      correctIndex: correct,
                    ))
                .copyWith(
                  prompt: prompt,
                  options: options,
                  correctIndex: correct,
                );
        if (previous == null) {
          toInsert.add(next);
          changes.add('Nueva pregunta para ${saint.name}: "$prompt"');
        } else if (previous.prompt == next.prompt &&
            _sameList(previous.options, next.options) &&
            previous.correctIndex == next.correctIndex) {
          unchanged++;
        } else {
          toUpdate.add(next);
          changes.add('Pregunta ${previous.id} de ${saint.name} actualizada');
        }
      } catch (e) {
        errors.add('Línea $line: $e');
      }
    }

    if (apply && errors.isEmpty) {
      await session.db.transaction((tx) async {
        if (toInsert.isNotEmpty) {
          await Question.db.insert(session, toInsert, transaction: tx);
        }
        for (final q in toUpdate) {
          await Question.db.updateRow(session, q, transaction: tx);
        }
      });
    }
    return ImportReport(
      applied: apply && errors.isEmpty,
      created: toInsert.length,
      updated: toUpdate.length,
      unchanged: unchanged,
      changes: changes,
      errors: errors,
    );
  }

  static Future<ImportReport> importBooks(
    Session session,
    String csv, {
    required bool apply,
  }) async {
    final rows = _rows(
      csv,
      bookHeaders,
      required: {'santo_slug', 'titulo', 'tipo'},
    );
    final saints = await Saint.db.find(session);
    final saintBySlug = {for (final s in saints) s.slug: s};
    final books = await SaintBook.db.find(session);
    final byId = {for (final b in books) b.id!: b};
    final byKey = {
      for (final b in books) '${b.saintId}|${b.title.trim().toLowerCase()}': b,
    };
    // Rows without a position keep reading in the order of the file.
    final nextPosition = <int, int>{};
    for (final b in books) {
      final saintId = b.saintId;
      nextPosition[saintId] = (nextPosition[saintId] ?? -1) > b.position
          ? nextPosition[saintId]!
          : b.position + 1;
    }

    final errors = <String>[];
    final changes = <String>[];
    final toInsert = <SaintBook>[];
    final toUpdate = <SaintBook>[];
    var unchanged = 0;

    for (final (line, row) in rows) {
      try {
        final slug = row['santo_slug']!.trim();
        final saint = saintBySlug[slug];
        if (saint == null) throw 'no existe un santo con slug "$slug"';
        final title = row['titulo']!.trim();
        if (title.isEmpty) throw 'falta el título del libro';
        final kind = _bookKind(row['tipo']!);

        final idText = (row['id'] ?? '').trim();
        SaintBook? previous;
        if (idText.isNotEmpty) {
          final id = int.tryParse(idText);
          previous = id == null ? null : byId[id];
          if (previous == null) throw 'no existe el libro con id $idText';
          if (previous.saintId != saint.id) {
            throw 'el libro $idText pertenece a otro santo';
          }
        } else {
          previous = byKey['${saint.id}|${title.toLowerCase()}'];
        }

        final base =
            previous ??
            SaintBook(
              saintId: saint.id!,
              title: title,
              kind: kind,
              position: nextPosition.update(
                saint.id!,
                (p) => p + 1,
                ifAbsent: () => 0,
              ),
            );
        final next = BookService.clean(
          base.copyWith(
            title: title,
            kind: kind,
            author: _text(row['autor']),
            year: _int(row['anio'], 'anio', -1000, 2400),
            publisher: _text(row['editorial']),
            url: _text(row['link']),
            note: _text(row['nota']),
          ),
        );
        BookService.validate(next);

        if (previous == null) {
          toInsert.add(next);
          changes.add('Nuevo libro de ${saint.name}: "$title"');
        } else if (_sameBook(previous, next)) {
          unchanged++;
        } else {
          toUpdate.add(next);
          changes.add('Libro "${next.title}" de ${saint.name} actualizado');
        }
      } catch (e) {
        errors.add('Línea $line: $e');
      }
    }

    if (apply && errors.isEmpty) {
      await session.db.transaction((tx) async {
        if (toInsert.isNotEmpty) {
          await SaintBook.db.insert(session, toInsert, transaction: tx);
        }
        for (final b in toUpdate) {
          await SaintBook.db.updateRow(session, b, transaction: tx);
        }
      });
    }
    return ImportReport(
      applied: apply && errors.isEmpty,
      created: toInsert.length,
      updated: toUpdate.length,
      unchanged: unchanged,
      changes: changes,
      errors: errors,
    );
  }

  /// Adds the pairs that are not recorded yet. Like the other files, it never
  /// deletes: a pair is removed from the panel.
  static Future<ImportReport> importMeetings(
    Session session,
    String csv, {
    required bool apply,
  }) async {
    final rows = _rows(
      csv,
      meetingHeaders,
      required: {'santo_slug', 'otro_santo_slug'},
    );
    final saints = await Saint.db.find(session);
    final bySlug = {for (final s in saints) s.slug: s};
    final existing = {
      for (final m in await SaintMeeting.db.find(session))
        (m.saintAId, m.saintBId),
    };

    final errors = <String>[];
    final changes = <String>[];
    final toInsert = <SaintMeeting>[];
    final inFile = <(int, int)>{};
    var unchanged = 0;

    for (final (line, row) in rows) {
      try {
        Saint saintOf(String column) {
          final slug = row[column]!.trim();
          if (slug.isEmpty) throw 'falta $column';
          final saint = bySlug[slug];
          if (saint == null) throw 'no existe un santo con slug "$slug"';
          return saint;
        }

        final saint = saintOf('santo_slug');
        final other = saintOf('otro_santo_slug');
        final reason = MeetingService.whyNot(saint, other);
        if (reason != null) throw reason;
        final key = MeetingService.pair(saint.id!, other.id!);
        if (!inFile.add(key)) {
          throw '${saint.name} y ${other.name} ya están en otra línea';
        }
        if (existing.contains(key)) {
          unchanged++;
        } else {
          toInsert.add(SaintMeeting(saintAId: key.$1, saintBId: key.$2));
          changes.add('${saint.name} y ${other.name} se conocieron');
        }
      } catch (e) {
        errors.add('Línea $line: $e');
      }
    }

    if (apply && errors.isEmpty && toInsert.isNotEmpty) {
      await session.db.transaction((tx) async {
        await SaintMeeting.db.insert(session, toInsert, transaction: tx);
      });
    }
    return ImportReport(
      applied: apply && errors.isEmpty,
      created: toInsert.length,
      updated: 0,
      unchanged: unchanged,
      changes: changes,
      errors: errors,
    );
  }

  // --------------------------------------------------------------- helpers

  /// Parses the CSV into rows keyed by header. Header names are matched
  /// case-insensitively and may appear in any order; unknown columns are
  /// ignored.
  static List<(int line, Map<String, String?> row)> _rows(
    String csv,
    List<String> known, {
    required Set<String> required,
  }) {
    final text = csv.replaceFirst('\uFEFF', '').replaceAll('\r\n', '\n').trim();
    final table = _parser.convert(text);
    if (table.isEmpty) throw AdminException(message: 'El archivo está vacío.');
    final headers = table.first
        .map((h) => h.toString().trim().toLowerCase().replaceAll(' ', '_'))
        .toList();
    final missing = required.where((r) => !headers.contains(r)).toList();
    if (missing.isNotEmpty) {
      throw AdminException(
        message:
            'Faltan columnas: ${missing.join(', ')}. '
            'Columnas esperadas: ${known.join(', ')}.',
      );
    }
    final rows = <(int, Map<String, String?>)>[];
    for (var i = 1; i < table.length; i++) {
      final values = table[i];
      if (values.every((v) => v.toString().trim().isEmpty)) continue;
      final row = <String, String?>{};
      for (var c = 0; c < headers.length; c++) {
        row[headers[c]] = c < values.length ? values[c].toString() : '';
      }
      rows.add((i + 1, row));
    }
    return rows;
  }

  static String? _text(String? v) {
    final t = v?.trim() ?? '';
    return t.isEmpty ? null : t;
  }

  static int? _int(String? v, String field, int min, int max) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    final n = int.tryParse(t);
    if (n == null || n < min || n > max) {
      throw '$field debe ser un número entre $min y $max';
    }
    return n;
  }

  /// Reads a yes/no cell. Keeps [fallback] when the column is missing, so an
  /// older file does not clear the flag.
  static bool _bool(String? v, String field, bool fallback) {
    if (v == null) return fallback;
    final t = v.trim().toLowerCase();
    if (t.isEmpty) return false;
    if (['si', 'sí', 'x', 'true', '1'].contains(t)) return true;
    if (['no', 'false', '0'].contains(t)) return false;
    throw '$field debe ser "si" o "no"';
  }

  static String _yesNo(bool value) => value ? 'si' : 'no';

  static String _coord(double? value) =>
      value == null ? '' : value.toStringAsFixed(4);

  /// Reads a latitude or longitude, bounded by [limit].
  static double? _coordinate(String? v, String field, num limit) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    final n = double.tryParse(t);
    if (n == null || n < -limit || n > limit) {
      throw '$field debe ser un número entre -$limit y $limit';
    }
    return n;
  }

  static int _score(String? v, String field, int fallback) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return fallback;
    final n = int.tryParse(t);
    if (n == null || n < 0 || n > 99) throw '$field debe estar entre 0 y 99';
    return n;
  }

  /// Parses the liturgical titles column. Accepts them separated by a
  /// semicolon, a comma or a slash, in any case, and keeps the previous
  /// value when the cell is missing from the file.
  static List<SaintTitle>? _titles(String? v, List<SaintTitle>? fallback) {
    if (v == null) return fallback;
    final text = v.trim();
    if (text.isEmpty) return const [];
    final names = text
        .split(RegExp(r'[;,/]'))
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty);
    final result = <SaintTitle>[];
    for (final name in names) {
      final match = SaintTitle.values
          .where((t) => t.name.toLowerCase() == name)
          .firstOrNull;
      if (match == null) {
        final options = SaintTitle.values.map((t) => t.name).join(', ');
        throw 'título litúrgico desconocido "$name". Opciones: $options';
      }
      if (!result.contains(match)) result.add(match);
    }
    return result;
  }

  static BookKind _bookKind(String v) {
    final t = v.trim().toLowerCase();
    final match = BookKind.values
        .where((k) => k.name.toLowerCase() == t)
        .firstOrNull;
    if (match == null) {
      final options = BookKind.values.map((k) => k.name).join(', ');
      throw 'tipo de libro desconocido "$v". Opciones: $options';
    }
    return match;
  }

  static bool _sameBook(SaintBook a, SaintBook b) =>
      a.title == b.title &&
      a.kind == b.kind &&
      a.author == b.author &&
      a.year == b.year &&
      a.publisher == b.publisher &&
      a.url == b.url &&
      a.note == b.note;

  static SaintStatus _status(String? v, SaintStatus? fallback) {
    final t = (v ?? '').trim().toLowerCase();
    if (t.isEmpty) return fallback ?? SaintStatus.draft;
    if (t.startsWith('publi')) return SaintStatus.published;
    if (t.startsWith('borr') || t.startsWith('draft')) return SaintStatus.draft;
    throw 'estado debe ser "publicado" o "borrador"';
  }

  static int _correctIndex(String v) {
    final t = v.trim().toUpperCase();
    const letters = {
      'A': 0,
      'B': 1,
      'C': 2,
      'D': 3,
      '1': 0,
      '2': 1,
      '3': 2,
      '4': 3,
    };
    final i = letters[t];
    if (i == null) throw 'correcta debe ser A, B, C o D';
    return i;
  }

  static List<String> _saintDiff(Saint a, Saint b) {
    final out = <String>[];
    void f(String label, Object? x, Object? y) {
      if (x != y) out.add(label);
    }

    f('nombre', a.name, b.name);
    f('título', a.title, b.title);
    f(
      'títulos litúrgicos',
      (a.titles ?? const []).map((t) => t.name).join(','),
      (b.titles ?? const []).map((t) => t.name).join(','),
    );
    f(
      'fiesta',
      '${a.feastMonth}/${a.feastDay}',
      '${b.feastMonth}/${b.feastDay}',
    );
    f('lugar de nacimiento', a.birthPlace, b.birthPlace);
    f('lugar de muerte', a.deathPlace, b.deathPlace);
    f(
      'coordenadas',
      '${a.birthLat},${a.birthLng},${a.deathLat},${a.deathLng}',
      '${b.birthLat},${b.birthLng},${b.deathLat},${b.deathLng}',
    );
    f(
      'nacimiento',
      '${a.birthYear}${a.birthApprox}',
      '${b.birthYear}${b.birthApprox}',
    );
    f(
      'muerte',
      '${a.deathYear}${a.deathApprox}',
      '${b.deathYear}${b.deathApprox}',
    );
    f('temporada', a.season, b.season);
    f('capítulo', a.episode, b.episode);
    f('link', a.youtubeUrl, b.youtubeUrl);
    f('estado', a.status, b.status);
    for (final c in ScoreCategory.values) {
      f(labelOf(c).toLowerCase(), scoreOf(a, c), scoreOf(b, c));
    }
    f('biografía', a.bio, b.bio);
    f('oración', a.prayer, b.prayer);
    return out;
  }

  static bool _sameList(List<String> a, List<String> b) =>
      a.length == b.length &&
      [for (var i = 0; i < a.length; i++) a[i] == b[i]].every((x) => x);

  static bool isValidSlug(String slug) {
    if (slug.isEmpty) return false;
    const allowed = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return slug
        .split('-')
        .every(
          (p) => p.isNotEmpty && p.split('').every(allowed.contains),
        );
  }

  static String slugify(String input) {
    const from = 'áàäâãéèëêíìïîóòöôõúùüûñç';
    const to = 'aaaaaeeeeiiiiooooouuuunc';
    var s = input.toLowerCase();
    for (var i = 0; i < from.length; i++) {
      s = s.replaceAll(from[i], to[i]);
    }
    final buffer = StringBuffer();
    var lastDash = true;
    for (final ch in s.split('')) {
      final ok = 'abcdefghijklmnopqrstuvwxyz0123456789'.contains(ch);
      if (ok) {
        buffer.write(ch);
        lastDash = false;
      } else if (!lastDash) {
        buffer.write('-');
        lastDash = true;
      }
    }
    var result = buffer.toString();
    if (result.endsWith('-')) result = result.substring(0, result.length - 1);
    return result;
  }
}
