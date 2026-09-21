// Development tool: loads a crowd of extra saints so the timeline can be
// tried with a full catalog, and takes them out again.
//
//   dart run bin/seed_demo_saints.dart            carga
//   dart run bin/seed_demo_saints.dart --remove   borra
//
// Every saint it creates has a slug starting with `demo-` and the short title
// "Santo de prueba", so they are easy to tell apart from real content. The
// years are real; the biographies and the scores are not.
import 'dart:io';

import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:saints_nhf_server/src/generated/serverpod.dart';

const _prefix = 'demo-';

/// (nombre, nacimiento, aprox, muerte, aprox, títulos)
typedef _Demo = (String, int, bool, int, bool, List<SaintTitle>);

const _demoSaints = <_Demo>[
  // Antigüedad
  (
    'San Pedro Apóstol',
    1,
    true,
    64,
    true,
    [SaintTitle.apostol, SaintTitle.martir],
  ),
  (
    'San Juan Evangelista',
    6,
    true,
    100,
    true,
    [SaintTitle.apostol, SaintTitle.evangelista],
  ),
  ('San Esteban', 5, true, 34, true, [SaintTitle.diacono, SaintTitle.martir]),
  (
    'San Policarpo de Esmirna',
    69,
    false,
    155,
    false,
    [SaintTitle.obispo, SaintTitle.martir],
  ),
  ('San Justino', 100, true, 165, false, [SaintTitle.martir, SaintTitle.laico]),
  (
    'San Ireneo de Lyon',
    130,
    true,
    202,
    true,
    [SaintTitle.doctor, SaintTitle.obispo],
  ),
  (
    'Santa Cecilia',
    200,
    true,
    230,
    true,
    [SaintTitle.martir, SaintTitle.virgen],
  ),
  (
    'San Lorenzo',
    225,
    true,
    258,
    false,
    [SaintTitle.diacono, SaintTitle.martir],
  ),
  ('San Jorge', 275, true, 303, false, [SaintTitle.martir]),
  ('San Nicolás de Bari', 270, true, 343, false, [SaintTitle.obispo]),
  (
    'Santa Inés de Roma',
    291,
    true,
    304,
    true,
    [SaintTitle.martir, SaintTitle.virgen],
  ),
  (
    'San Atanasio',
    296,
    true,
    373,
    false,
    [SaintTitle.doctor, SaintTitle.obispo],
  ),
  (
    'San Martín de Tours',
    316,
    true,
    397,
    false,
    [SaintTitle.obispo, SaintTitle.misionero],
  ),
  ('Santa Mónica', 332, false, 387, false, [SaintTitle.laico]),
  (
    'San Ambrosio de Milán',
    339,
    true,
    397,
    false,
    [SaintTitle.doctor, SaintTitle.obispo],
  ),
  (
    'San Jerónimo',
    347,
    true,
    420,
    false,
    [SaintTitle.doctor, SaintTitle.presbitero],
  ),
  (
    'San Juan Crisóstomo',
    349,
    true,
    407,
    false,
    [SaintTitle.doctor, SaintTitle.obispo],
  ),
  (
    'San Patricio',
    385,
    true,
    461,
    true,
    [SaintTitle.obispo, SaintTitle.misionero],
  ),
  (
    'San Benito de Nursia',
    480,
    true,
    547,
    true,
    [SaintTitle.fundador, SaintTitle.religioso],
  ),
  (
    'Santa Escolástica',
    480,
    true,
    543,
    true,
    [SaintTitle.virgen, SaintTitle.religioso],
  ),
  (
    'San Gregorio Magno',
    540,
    true,
    604,
    false,
    [SaintTitle.doctor, SaintTitle.papa],
  ),
  (
    'San Isidoro de Sevilla',
    560,
    true,
    636,
    false,
    [SaintTitle.doctor, SaintTitle.obispo],
  ),
  // Edad Media
  (
    'San Bernardo de Claraval',
    1090,
    false,
    1153,
    false,
    [SaintTitle.doctor, SaintTitle.religioso],
  ),
  (
    'Santa Hildegarda de Bingen',
    1098,
    false,
    1179,
    false,
    [SaintTitle.doctor, SaintTitle.religioso],
  ),
  (
    'Santo Domingo de Guzmán',
    1170,
    false,
    1221,
    false,
    [SaintTitle.presbitero, SaintTitle.fundador],
  ),
  (
    'Santa Clara de Asís',
    1194,
    false,
    1253,
    false,
    [SaintTitle.virgen, SaintTitle.fundador],
  ),
  (
    'San Antonio de Padua',
    1195,
    false,
    1231,
    false,
    [SaintTitle.doctor, SaintTitle.presbitero],
  ),
  (
    'Santa Isabel de Hungría',
    1207,
    false,
    1231,
    false,
    [SaintTitle.laico, SaintTitle.religioso],
  ),
  (
    'San Buenaventura',
    1221,
    false,
    1274,
    false,
    [SaintTitle.doctor, SaintTitle.obispo],
  ),
  (
    'Santo Tomás de Aquino',
    1225,
    false,
    1274,
    false,
    [SaintTitle.doctor, SaintTitle.presbitero],
  ),
  (
    'Santa Brígida de Suecia',
    1303,
    false,
    1373,
    false,
    [SaintTitle.religioso, SaintTitle.fundador],
  ),
  (
    'San Vicente Ferrer',
    1350,
    false,
    1419,
    false,
    [SaintTitle.presbitero, SaintTitle.misionero],
  ),
  (
    'San Juan de Capistrano',
    1386,
    false,
    1456,
    false,
    [SaintTitle.presbitero, SaintTitle.misionero],
  ),
  (
    'Santa Juana de Arco',
    1412,
    true,
    1431,
    false,
    [SaintTitle.virgen, SaintTitle.laico],
  ),
  // Siglo XVI, el racimo
  (
    'Santo Tomás Moro',
    1478,
    false,
    1535,
    false,
    [SaintTitle.martir, SaintTitle.laico],
  ),
  (
    'San Juan de Dios',
    1495,
    false,
    1550,
    false,
    [SaintTitle.fundador, SaintTitle.religioso],
  ),
  (
    'San Juan de Ávila',
    1499,
    false,
    1569,
    false,
    [SaintTitle.doctor, SaintTitle.presbitero],
  ),
  (
    'San Pedro de Alcántara',
    1499,
    false,
    1562,
    false,
    [SaintTitle.presbitero, SaintTitle.religioso],
  ),
  ('San Pío V', 1504, false, 1572, false, [SaintTitle.papa]),
  (
    'San Francisco de Borja',
    1510,
    false,
    1572,
    false,
    [SaintTitle.presbitero, SaintTitle.religioso],
  ),
  (
    'San Felipe Neri',
    1515,
    false,
    1595,
    false,
    [SaintTitle.presbitero, SaintTitle.fundador],
  ),
  ('San Carlos Borromeo', 1538, false, 1584, false, [SaintTitle.obispo]),
  (
    'San Juan de la Cruz',
    1542,
    false,
    1591,
    false,
    [SaintTitle.doctor, SaintTitle.presbitero],
  ),
  (
    'San Roberto Belarmino',
    1542,
    false,
    1621,
    false,
    [SaintTitle.doctor, SaintTitle.obispo],
  ),
  (
    'San Francisco de Sales',
    1567,
    false,
    1622,
    false,
    [SaintTitle.doctor, SaintTitle.obispo],
  ),
  ('San Luis Gonzaga', 1568, false, 1591, false, [SaintTitle.religioso]),
  (
    'Santa Juana Francisca de Chantal',
    1572,
    false,
    1641,
    false,
    [SaintTitle.religioso, SaintTitle.fundador],
  ),
  ('San Martín de Porres', 1579, false, 1639, false, [SaintTitle.religioso]),
  (
    'San Vicente de Paúl',
    1581,
    false,
    1660,
    false,
    [SaintTitle.presbitero, SaintTitle.fundador],
  ),
  (
    'Santa Rosa de Lima',
    1586,
    false,
    1617,
    false,
    [SaintTitle.virgen, SaintTitle.religioso],
  ),
  // Siglos XVII y XVIII
  (
    'San Juan Bautista de La Salle',
    1651,
    false,
    1719,
    false,
    [SaintTitle.presbitero, SaintTitle.fundador],
  ),
  (
    'San Luis María Grignion de Montfort',
    1673,
    false,
    1716,
    false,
    [SaintTitle.presbitero, SaintTitle.misionero],
  ),
  (
    'San Alfonso María de Ligorio',
    1696,
    false,
    1787,
    false,
    [SaintTitle.doctor, SaintTitle.obispo],
  ),
  // Siglos XIX y XX, el otro racimo
  ('San Juan María Vianney', 1786, false, 1859, false, [SaintTitle.presbitero]),
  (
    'San Juan Bosco',
    1815,
    false,
    1888,
    false,
    [SaintTitle.presbitero, SaintTitle.fundador],
  ),
  (
    'Santa Bernardita Soubirous',
    1844,
    false,
    1879,
    false,
    [SaintTitle.virgen, SaintTitle.religioso],
  ),
  ('San Juan XXIII', 1881, false, 1963, false, [SaintTitle.papa]),
  (
    'San Pío de Pietrelcina',
    1887,
    false,
    1968,
    false,
    [SaintTitle.presbitero, SaintTitle.religioso],
  ),
  (
    'Santa Edith Stein',
    1891,
    false,
    1942,
    false,
    [SaintTitle.martir, SaintTitle.religioso],
  ),
  (
    'Santa Laura Vicuña',
    1891,
    false,
    1904,
    false,
    [SaintTitle.virgen, SaintTitle.laico],
  ),
  (
    'San Maximiliano Kolbe',
    1894,
    false,
    1941,
    false,
    [SaintTitle.martir, SaintTitle.presbitero],
  ),
  (
    'Santa Teresa de los Andes',
    1900,
    false,
    1920,
    false,
    [SaintTitle.virgen, SaintTitle.religioso],
  ),
  (
    'San Josemaría Escrivá',
    1902,
    false,
    1975,
    false,
    [SaintTitle.presbitero, SaintTitle.fundador],
  ),
  (
    'Santa Faustina Kowalska',
    1905,
    false,
    1938,
    false,
    [SaintTitle.virgen, SaintTitle.religioso],
  ),
  (
    'Santa Teresa de Calcuta',
    1910,
    false,
    1997,
    false,
    [SaintTitle.religioso, SaintTitle.fundador],
  ),
  (
    'San Óscar Romero',
    1917,
    false,
    1980,
    false,
    [SaintTitle.martir, SaintTitle.obispo],
  ),
  ('Santa Gianna Beretta Molla', 1922, false, 1962, false, [SaintTitle.laico]),
  ('Beato Carlo Acutis', 1991, false, 2006, false, [SaintTitle.laico]),
];

String _slugify(String input) {
  const from = 'áàäâãéèëêíìïîóòöôõúùüûñç';
  const to = 'aaaaaeeeeiiiiooooouuuunc';
  var s = input.toLowerCase();
  for (var i = 0; i < from.length; i++) {
    s = s.replaceAll(from[i], to[i]);
  }
  s = s.replaceAll(RegExp('[^a-z0-9]+'), '-');
  return s.replaceAll(RegExp(r'^-+|-+$'), '');
}

Future<void> main(List<String> args) async {
  final remove = args.contains('--remove');
  final pod = Serverpod(['--mode', 'development', '--role', 'maintenance']);
  await pod.start();
  final session = await pod.createSession();
  try {
    final existing = await Saint.db.find(
      session,
      where: (t) => t.slug.like('$_prefix%'),
    );

    if (remove) {
      if (existing.isEmpty) {
        stdout.writeln('No hay santos de prueba para borrar.');
      } else {
        await Saint.db.delete(session, existing);
        stdout.writeln('Borrados ${existing.length} santos de prueba.');
        stdout.writeln(
          'Las cartas, preguntas y libros que colgaban de ellos se borran en '
          'cascada.',
        );
      }
      return;
    }

    final have = existing.map((s) => s.slug).toSet();
    final now = DateTime.now().toUtc();
    final toInsert = <Saint>[];
    for (var i = 0; i < _demoSaints.length; i++) {
      final (name, birth, birthApprox, death, deathApprox, titles) =
          _demoSaints[i];
      final slug = '$_prefix${_slugify(name)}';
      if (have.contains(slug)) continue;
      // Deterministic but varied, so the cards do not all look the same.
      int score(int seed) => 40 + (name.length * seed + i * 17) % 60;
      toInsert.add(
        Saint(
          name: name,
          slug: slug,
          title: 'Santo de prueba',
          titles: titles,
          // A feast day spread through the year, so the daily card still has
          // something to pick on most days.
          feastMonth: (i % 12) + 1,
          feastDay: (i % 28) + 1,
          birthYear: birth,
          birthApprox: birthApprox,
          deathYear: death,
          deathApprox: deathApprox,
          bio:
              'Santo de prueba cargado con bin/seed_demo_saints.dart para '
              'probar la línea de tiempo con el catálogo lleno. Los años son '
              'reales; esta biografía y los puntajes no.',
          status: SaintStatus.published,
          catequesis: score(3),
          escritos: score(5),
          oracion: score(7),
          patronazgos: score(11),
          evangelizacion: score(13),
          viajes: score(17),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    if (toInsert.isEmpty) {
      stdout.writeln('Ya estaban cargados los ${existing.length} de prueba.');
    } else {
      await Saint.db.insert(session, toInsert);
      final total = await Saint.db.count(session);
      stdout.writeln('Cargados ${toInsert.length} santos de prueba.');
      stdout.writeln('El catálogo queda con $total santos.');
      stdout.writeln(
        'Para sacarlos: dart run bin/seed_demo_saints.dart --remove',
      );
    }
  } finally {
    await session.close();
  }
  await pod.shutdown(exitProcess: true);
}
