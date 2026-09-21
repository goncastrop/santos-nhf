import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Inserts example recommended reading when the table is empty, so the
/// section can be tried in development. Titles and authors are real; the
/// selection is not the program's.
Future<void> seedBooksIfEmpty(Session session) async {
  final count = await SaintBook.db.count(session);
  if (count > 0) return;
  final saints = await Saint.db.find(session);
  final idBySlug = {for (final s in saints) s.slug: s.id!};
  final books = <SaintBook>[];
  for (final entry in _exampleBooks.entries) {
    final saintId = idBySlug[entry.key];
    if (saintId == null) continue;
    var position = 0;
    for (final (title, author, kind, year) in entry.value) {
      books.add(
        SaintBook(
          saintId: saintId,
          title: title,
          author: author,
          kind: kind,
          year: year,
          position: position++,
        ),
      );
    }
  }
  if (books.isEmpty) return;
  await SaintBook.db.insert(session, books);
  session.log('Seeded ${books.length} example books.');
}

typedef _Book = (String title, String? author, BookKind kind, int? year);

const _exampleBooks = <String, List<_Book>>{
  'san-francisco-de-asis': [
    ('Florecillas de San Francisco', null, BookKind.compilado, 1390),
    ('Cántico de las criaturas', null, BookKind.obra, 1224),
    ('Vida de San Francisco', 'Tomás de Celano', BookKind.biografia, 1229),
    ('San Francisco de Asís', 'G. K. Chesterton', BookKind.estudio, 1923),
  ],
  'santa-teresa-de-jesus': [
    ('Libro de la vida', null, BookKind.autobiografia, 1565),
    ('Camino de perfección', null, BookKind.obra, 1566),
    ('Las moradas del castillo interior', null, BookKind.obra, 1577),
    ('Teresa de Ávila', 'Marcelle Auclair', BookKind.biografia, 1950),
  ],
  'san-ignacio-de-loyola': [
    ('Ejercicios espirituales', null, BookKind.obra, 1548),
    ('Autobiografía', null, BookKind.autobiografia, 1555),
    (
      'Ignacio de Loyola, solo y a pie',
      'José Ignacio Tellechea',
      BookKind.biografia,
      1986,
    ),
  ],
  'san-agustin-de-hipona': [
    ('Confesiones', null, BookKind.autobiografia, 400),
    ('La ciudad de Dios', null, BookKind.obra, 426),
    ('Vida de San Agustín', 'Posidio de Calama', BookKind.biografia, 437),
    ('Agustín de Hipona', 'Peter Brown', BookKind.estudio, 1967),
  ],
  'santa-teresa-de-lisieux': [
    ('Historia de un alma', null, BookKind.autobiografia, 1898),
    ('Cartas', null, BookKind.compilado, 1948),
    ('Teresita de Lisieux', 'Ida Friederike Görres', BookKind.biografia, 1944),
  ],
  'san-francisco-javier': [
    ('Cartas y escritos', null, BookKind.compilado, 1552),
    (
      'Francisco Javier, su vida y su tiempo',
      'Georg Schurhammer',
      BookKind.biografia,
      1955,
    ),
  ],
  'santa-catalina-de-siena': [
    ('El diálogo', null, BookKind.obra, 1378),
    ('Cartas', null, BookKind.compilado, 1380),
    (
      'Vida de Santa Catalina de Siena',
      'Raimundo de Capua',
      BookKind.biografia,
      1395,
    ),
  ],
  'san-juan-pablo-ii': [
    ('Cruzando el umbral de la esperanza', null, BookKind.obra, 1994),
    ('Don y misterio', null, BookKind.autobiografia, 1996),
    ('Testigo de esperanza', 'George Weigel', BookKind.biografia, 1999),
  ],
  'san-pablo-apostol': [
    ('Cartas de San Pablo', null, BookKind.compilado, 60),
    ('Pablo de Tarso', 'Joseph Holzner', BookKind.biografia, 1937),
  ],
  'san-juan-diego': [
    ('Nican Mopohua', 'Antonio Valeriano', BookKind.biografia, 1556),
  ],
};
