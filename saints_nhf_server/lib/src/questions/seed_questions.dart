import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Inserts example questions for the example saints when the bank is empty.
Future<void> seedQuestionsIfEmpty(Session session) async {
  if (await Question.db.count(session) > 0) return;
  final saints = await Saint.db.find(session);
  final idBySlug = {for (final s in saints) s.slug: s.id!};
  final questions = <Question>[];
  for (final entry in _bySlug.entries) {
    final saintId = idBySlug[entry.key];
    if (saintId == null) continue;
    for (final (prompt, options, correct) in entry.value) {
      questions.add(
        Question(
          saintId: saintId,
          prompt: prompt,
          options: options,
          correctIndex: correct,
        ),
      );
    }
  }
  if (questions.isEmpty) return;
  await Question.db.insert(session, questions);
  session.log('Seeded ${questions.length} example questions.');
}

typedef _Q = (String, List<String>, int);

const Map<String, List<_Q>> _bySlug = {
  'san-francisco-de-asis': [
    (
      '¿En qué ciudad nació San Francisco?',
      ['Asís', 'Roma', 'Florencia', 'Siena'],
      0,
    ),
    (
      '¿Qué armó en Greccio?',
      [
        'Un hospital',
        'El primer pesebre viviente',
        'Una biblioteca',
        'Un puente',
      ],
      1,
    ),
    (
      '¿A quién viajó a ver en Egipto?',
      ['Al emperador', 'Al Papa', 'Al sultán', 'A un rey cruzado'],
      2,
    ),
  ],
  'santa-teresa-de-jesus': [
    (
      '¿Cuántos conventos fundó Santa Teresa?',
      ['Tres', 'Siete', 'Diecisiete', 'Cuarenta'],
      2,
    ),
    (
      '¿Cuál de estas obras escribió?',
      [
        'Las Moradas',
        'La Ciudad de Dios',
        'Los Ejercicios',
        'Historia de un alma',
      ],
      0,
    ),
    (
      '¿En qué ciudad nació?',
      ['Sevilla', 'Ávila', 'Toledo', 'Salamanca'],
      1,
    ),
  ],
  'san-ignacio-de-loyola': [
    (
      '¿Qué le destrozó la pierna en Pamplona?',
      [
        'Una caída del caballo',
        'Una bala de cañón',
        'Una flecha',
        'Una espada',
      ],
      1,
    ),
    (
      '¿Dónde escribió los Ejercicios Espirituales?',
      ['En Roma', 'En París', 'En la cueva de Manresa', 'En Loyola'],
      2,
    ),
    (
      '¿Qué orden fundó?',
      [
        'Los dominicos',
        'Los franciscanos',
        'Los carmelitas',
        'La Compañía de Jesús',
      ],
      3,
    ),
  ],
  'san-agustin-de-hipona': [
    (
      '¿Quién era la madre de San Agustín?',
      ['Santa Mónica', 'Santa Clara', 'Santa Elena', 'Santa Marta'],
      0,
    ),
    (
      '¿Quién lo influyó para convertirse en Milán?',
      ['San Jerónimo', 'San Ambrosio', 'San Benito', 'San Gregorio'],
      1,
    ),
    (
      '¿Cuál de estos libros es suyo?',
      ['Las Moradas', 'Imitación de Cristo', 'Confesiones', 'Suma Teológica'],
      2,
    ),
  ],
  'santa-teresa-de-lisieux': [
    (
      '¿A qué edad entró al Carmelo?',
      ['A los doce', 'A los quince', 'A los dieciocho', 'A los veintiuno'],
      1,
    ),
    (
      '¿Cómo se llama su autobiografía?',
      [
        'Camino de Perfección',
        'Historia de un alma',
        'El caminito',
        'Confesiones',
      ],
      1,
    ),
    (
      '¿A qué Papa le pidió permiso para entrar al convento?',
      ['Pío IX', 'León XIII', 'Pío X', 'Benedicto XV'],
      1,
    ),
  ],
  'san-francisco-javier': [
    (
      '¿Con quién compartió cuarto en París?',
      [
        'Con San Ignacio de Loyola',
        'Con San Pedro Fabro',
        'Con Santo Tomás Moro',
        'Con Erasmo',
      ],
      0,
    ),
    (
      '¿De qué país fue el primer misionero?',
      ['China', 'India', 'Japón', 'Filipinas'],
      2,
    ),
    (
      '¿A la vista de qué país murió?',
      ['Japón', 'China', 'India', 'Portugal'],
      1,
    ),
  ],
  'santa-catalina-de-siena': [
    (
      '¿A qué Papa convenció de volver de Aviñón a Roma?',
      ['Urbano VI', 'Gregorio XI', 'Clemente VII', 'Bonifacio IX'],
      1,
    ),
    (
      '¿A qué orden estaba vinculada como terciaria?',
      ['Franciscana', 'Benedictina', 'Dominica', 'Carmelita'],
      2,
    ),
    (
      '¿A qué edad murió?',
      ['A los 25', 'A los 33', 'A los 47', 'A los 60'],
      1,
    ),
  ],
  'san-juan-pablo-ii': [
    (
      '¿En qué país nació Karol Wojtyła?',
      ['Alemania', 'Polonia', 'Ucrania', 'Austria'],
      1,
    ),
    (
      '¿Cuántos viajes hizo fuera de Italia como Papa?',
      ['Unos 20', 'Unos 50', 'Unos 104', 'Unos 200'],
      2,
    ),
    (
      '¿Qué evento creó para los jóvenes?',
      [
        'Las Jornadas Mundiales de la Juventud',
        'El Sínodo joven',
        'La Pascua Joven',
        'El Jubileo',
      ],
      0,
    ),
  ],
  'san-pablo-apostol': [
    (
      '¿Cómo se llamaba antes de su conversión?',
      ['Simón', 'Saulo', 'Leví', 'Silas'],
      1,
    ),
    (
      '¿Camino a qué ciudad se convirtió?',
      ['Jerusalén', 'Antioquía', 'Damasco', 'Roma'],
      2,
    ),
    (
      '¿Dónde fue martirizado?',
      ['En Éfeso', 'En Corinto', 'En Roma', 'En Atenas'],
      2,
    ),
  ],
  'san-juan-diego': [
    (
      '¿En qué cerro se le apareció la Virgen?',
      ['Tepeyac', 'Popocatépetl', 'Ajusco', 'Chapultepec'],
      0,
    ),
    (
      '¿Qué llevó al obispo en su tilma?',
      ['Pan', 'Rosas', 'Maíz', 'Plumas'],
      1,
    ),
    (
      '¿En qué año ocurrieron las apariciones?',
      ['1492', '1531', '1600', '1810'],
      1,
    ),
  ],
};
