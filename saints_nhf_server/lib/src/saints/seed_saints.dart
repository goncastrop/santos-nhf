import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Inserts example saints when the catalog is empty, so the app can be tried
/// in development. Scores are illustrative, not the ones from the program.
Future<void> seedSaintsIfEmpty(Session session) async {
  final count = await Saint.db.count(session);
  if (count > 0) return;
  await Saint.db.insert(session, _exampleSaints);
  session.log('Seeded ${_exampleSaints.length} example saints.');
}

/// Fills in the life years of the example saints that were seeded before the
/// columns existed, so a development database keeps working without a reset.
/// Only touches example slugs that have no years at all.
Future<void> backfillExampleYears(Session session) async {
  final slugs = {for (final s in _exampleSaints) s.slug: s};
  final stored = await Saint.db.find(
    session,
    where: (t) => t.birthYear.equals(null) & t.deathYear.equals(null),
  );
  final updates = [
    for (final saint in stored)
      if (slugs[saint.slug] case final example?)
        saint.copyWith(
          birthYear: example.birthYear,
          birthApprox: example.birthApprox,
          deathYear: example.deathYear,
          deathApprox: example.deathApprox,
        ),
  ];
  if (updates.isEmpty) return;
  await Saint.db.update(session, updates);
  session.log('Backfilled life years of ${updates.length} example saints.');
}

final _exampleSaints = <Saint>[
  Saint(
    name: 'San Francisco de Asís',
    slug: 'san-francisco-de-asis',
    titles: const [SaintTitle.fundador, SaintTitle.religioso],
    title: 'Fundador de los franciscanos',
    feastMonth: 10,
    feastDay: 4,
    birthYear: 1181,
    birthApprox: true,
    deathYear: 1226,
    bio:
        'Nació en Asís hacia 1181, hijo de un rico comerciante de telas. Tras una '
        'juventud despreocupada y un tiempo como prisionero de guerra, escuchó en '
        'la iglesia de San Damián el llamado a reparar la Iglesia y renunció a '
        'todos sus bienes. Fundó la Orden de los Hermanos Menores, predicó la '
        'pobreza y la alegría del Evangelio, viajó hasta Egipto para hablar con el '
        'sultán y armó el primer pesebre viviente en Greccio. Recibió los estigmas '
        'en el monte Alverna y murió en 1226 cantando.',
    prayer:
        'Señor, haz de mí un instrumento de tu paz: donde haya odio, ponga yo '
        'amor; donde haya ofensa, ponga yo perdón; donde haya discordia, ponga '
        'yo unión; donde haya error, ponga yo verdad; donde haya duda, ponga yo '
        'fe; donde haya desesperación, ponga yo esperanza; donde haya tinieblas, '
        'ponga yo luz; donde haya tristeza, ponga yo alegría.',
    season: 2,
    episode: 3,
    status: SaintStatus.published,
    catequesis: 82,
    escritos: 71,
    oracion: 95,
    patronazgos: 93,
    evangelizacion: 90,
    viajes: 78,
  ),
  Saint(
    name: 'Santa Teresa de Jesús',
    slug: 'santa-teresa-de-jesus',
    titles: const [SaintTitle.doctor, SaintTitle.virgen, SaintTitle.fundador],
    title: 'Doctora de la Iglesia, reformadora del Carmelo',
    feastMonth: 10,
    feastDay: 15,
    birthYear: 1515,
    deathYear: 1582,
    bio:
        'Teresa de Cepeda y Ahumada nació en Ávila en 1515. Entró al Carmelo '
        'joven y, tras años de tibieza y enfermedad, vivió una conversión profunda '
        'que la llevó a reformar la orden y fundar diecisiete conventos de '
        'carmelitas descalzas recorriendo Castilla y Andalucía en carreta. Escribió '
        'el Libro de la Vida, el Camino de Perfección y Las Moradas, obras maestras '
        'de la oración cristiana. Fue la primera mujer declarada Doctora de la '
        'Iglesia.',
    prayer:
        'Nada te turbe, nada te espante, todo se pasa, Dios no se muda; la '
        'paciencia todo lo alcanza. Quien a Dios tiene nada le falta: solo Dios '
        'basta.',
    season: 2,
    episode: 11,
    status: SaintStatus.published,
    catequesis: 80,
    escritos: 97,
    oracion: 99,
    patronazgos: 70,
    evangelizacion: 74,
    viajes: 81,
  ),
  Saint(
    name: 'San Ignacio de Loyola',
    slug: 'san-ignacio-de-loyola',
    titles: const [SaintTitle.presbitero, SaintTitle.fundador],
    title: 'Fundador de la Compañía de Jesús',
    feastMonth: 7,
    feastDay: 31,
    birthYear: 1491,
    deathYear: 1556,
    bio:
        'Íñigo López de Loyola nació en Guipúzcoa en 1491 y fue soldado hasta que '
        'una bala de cañón le destrozó la pierna en Pamplona. Durante la '
        'convalecencia leyó vidas de santos y cambió de bando. En la cueva de '
        'Manresa escribió los Ejercicios Espirituales, estudió en París y allí '
        'reunió a los primeros compañeros con los que fundó la Compañía de Jesús. '
        'Desde Roma gobernó una orden que en pocos años llegó a Asia y América.',
    prayer:
        'Tomad, Señor, y recibid toda mi libertad, mi memoria, mi entendimiento y '
        'toda mi voluntad, todo mi haber y mi poseer. Vos me lo disteis; a Vos, '
        'Señor, lo torno. Todo es vuestro: disponed de ello según vuestra '
        'voluntad. Dadme vuestro amor y gracia, que esta me basta.',
    season: 2,
    episode: 19,
    status: SaintStatus.published,
    catequesis: 88,
    escritos: 85,
    oracion: 93,
    patronazgos: 72,
    evangelizacion: 86,
    viajes: 84,
  ),
  Saint(
    name: 'San Agustín de Hipona',
    slug: 'san-agustin-de-hipona',
    titles: const [SaintTitle.doctor, SaintTitle.obispo],
    title: 'Obispo y Doctor de la Iglesia',
    feastMonth: 8,
    feastDay: 28,
    birthYear: 354,
    deathYear: 430,
    bio:
        'Nació en Tagaste, en el norte de África, en 354. Brillante profesor de '
        'retórica, pasó por el maniqueísmo y el escepticismo mientras su madre, '
        'Santa Mónica, rezaba por él. Se convirtió en Milán escuchando a San '
        'Ambrosio y fue bautizado en 387. Como obispo de Hipona predicó sin '
        'descanso y escribió las Confesiones y La Ciudad de Dios, textos que '
        'marcaron para siempre el pensamiento cristiano.',
    prayer:
        'Tarde te amé, hermosura tan antigua y tan nueva, tarde te amé. Tú '
        'estabas dentro de mí y yo afuera, y por fuera te buscaba. Me llamaste y '
        'clamaste, y rompiste mi sordera. Brillaste y resplandeciste, y curaste mi '
        'ceguera. Me tocaste, y me abrasé en tu paz.',
    season: 3,
    episode: 2,
    status: SaintStatus.published,
    catequesis: 96,
    escritos: 99,
    oracion: 90,
    patronazgos: 75,
    evangelizacion: 83,
    viajes: 62,
  ),
  Saint(
    name: 'Santa Teresa de Lisieux',
    slug: 'santa-teresa-de-lisieux',
    titles: const [SaintTitle.doctor, SaintTitle.virgen, SaintTitle.religioso],
    title: 'Doctora de la Iglesia, patrona de las misiones',
    feastMonth: 10,
    feastDay: 1,
    birthYear: 1873,
    deathYear: 1897,
    bio:
        'Teresa Martin nació en Alençon en 1873 y entró al Carmelo de Lisieux a '
        'los quince años, tras pedírselo al propio Papa León XIII. Nunca salió del '
        'convento, pero descubrió el "caminito" de la confianza y el amor en las '
        'cosas pequeñas, que dejó escrito en Historia de un alma. Murió de '
        'tuberculosis a los veinticuatro años prometiendo pasar su cielo haciendo '
        'el bien en la tierra.',
    prayer:
        'Jesús, quiero amarte como nunca has sido amado. Enséñame a hacer las '
        'cosas pequeñas con un amor grande, y a confiar en Ti como un niño en los '
        'brazos de su padre. Que mi vida sea una rosa deshojada a tus pies.',
    season: 3,
    episode: 6,
    status: SaintStatus.published,
    catequesis: 79,
    escritos: 88,
    oracion: 97,
    patronazgos: 89,
    evangelizacion: 77,
    viajes: 25,
  ),
  Saint(
    name: 'San Francisco Javier',
    slug: 'san-francisco-javier',
    titles: const [SaintTitle.presbitero, SaintTitle.misionero],
    title: 'Misionero en Asia, patrono de las misiones',
    feastMonth: 12,
    feastDay: 3,
    birthYear: 1506,
    deathYear: 1552,
    bio:
        'Navarro nacido en 1506, compartió cuarto en París con Ignacio de Loyola '
        'y fue uno de los primeros jesuitas. Enviado a las Indias, predicó en Goa, '
        'en la costa de la Pesquería, en las Molucas y fue el primer misionero en '
        'Japón. Murió en 1552 en la isla de Sanchón, a la vista de China, adonde '
        'soñaba con entrar. Se calcula que bautizó a decenas de miles de personas.',
    prayer:
        'Señor, dame almas y quédate con lo demás. Que no me detenga la '
        'distancia, ni el idioma, ni el cansancio, cuando se trata de anunciarte a '
        'quien todavía no te conoce.',
    season: 3,
    episode: 14,
    status: SaintStatus.published,
    catequesis: 84,
    escritos: 60,
    oracion: 86,
    patronazgos: 87,
    evangelizacion: 99,
    viajes: 99,
  ),
  Saint(
    name: 'Santa Catalina de Siena',
    slug: 'santa-catalina-de-siena',
    titles: const [SaintTitle.doctor, SaintTitle.virgen],
    title: 'Doctora de la Iglesia, patrona de Italia',
    feastMonth: 4,
    feastDay: 29,
    birthYear: 1347,
    deathYear: 1380,
    bio:
        'Nació en Siena en 1347, la menor de una familia de veinticinco hijos. '
        'Terciaria dominica, cuidó enfermos durante la peste y se volvió consejera '
        'de príncipes y papas: convenció a Gregorio XI de volver de Aviñón a Roma. '
        'Dictó cientos de cartas y el Diálogo de la Divina Providencia sin saber '
        'escribir de niña. Murió en Roma a los treinta y tres años.',
    prayer:
        'Oh Trinidad eterna, mar profundo, cuanto más entro en Ti, más te '
        'encuentro, y cuanto más te encuentro, más te busco. Vísteme de Ti, '
        'Trinidad eterna, para que recorra esta vida con verdadera obediencia y '
        'con la luz de la santísima fe.',
    season: 3,
    episode: 9,
    status: SaintStatus.published,
    catequesis: 85,
    escritos: 92,
    oracion: 96,
    patronazgos: 82,
    evangelizacion: 80,
    viajes: 66,
  ),
  Saint(
    name: 'San Juan Pablo II',
    slug: 'san-juan-pablo-ii',
    titles: const [SaintTitle.papa],
    title: 'Papa peregrino',
    feastMonth: 10,
    feastDay: 22,
    birthYear: 1920,
    deathYear: 2005,
    bio:
        'Karol Wojtyła nació en Wadowice, Polonia, en 1920. Obrero, actor y '
        'seminarista clandestino durante la ocupación nazi, fue obispo de Cracovia '
        'bajo el comunismo y en 1978 se convirtió en el primer Papa no italiano en '
        'más de cuatro siglos. En veintiséis años de pontificado hizo 104 viajes '
        'fuera de Italia, creó las Jornadas Mundiales de la Juventud y publicó '
        'catorce encíclicas. Murió en 2005 y fue canonizado en 2014.',
    prayer:
        '¡No tengan miedo! Abran, más todavía, abran de par en par las puertas a '
        'Cristo. Señor, danos la valentía de San Juan Pablo II para anunciarte '
        'con alegría a todos los pueblos.',
    season: 2,
    episode: 30,
    status: SaintStatus.published,
    catequesis: 98,
    escritos: 94,
    oracion: 92,
    patronazgos: 68,
    evangelizacion: 97,
    viajes: 99,
  ),
  Saint(
    name: 'San Pablo Apóstol',
    slug: 'san-pablo-apostol',
    titles: const [SaintTitle.apostol, SaintTitle.martir],
    title: 'Apóstol de los gentiles',
    feastMonth: 6,
    feastDay: 29,
    birthYear: 5,
    birthApprox: true,
    deathYear: 67,
    deathApprox: true,
    bio:
        'Saulo de Tarso, fariseo y perseguidor de los primeros cristianos, fue '
        'derribado camino a Damasco por una luz y una voz: "Yo soy Jesús, a quien '
        'tú persigues". Convertido, recorrió el Mediterráneo fundando comunidades '
        'en Antioquía, Filipos, Corinto, Éfeso y Roma, y sus cartas son los textos '
        'más antiguos del Nuevo Testamento. Fue martirizado en Roma hacia el año '
        '67.',
    prayer:
        'Señor, que como San Pablo pueda decir: ya no vivo yo, es Cristo quien '
        'vive en mí. Dame su fuego para correr hasta el final la carrera y '
        'conservar la fe.',
    season: 1,
    episode: 2,
    status: SaintStatus.published,
    catequesis: 95,
    escritos: 99,
    oracion: 88,
    patronazgos: 79,
    evangelizacion: 99,
    viajes: 97,
  ),
  Saint(
    name: 'San Juan Diego',
    slug: 'san-juan-diego',
    titles: const [SaintTitle.laico, SaintTitle.confesor],
    title: 'Vidente de Guadalupe',
    feastMonth: 12,
    feastDay: 9,
    birthYear: 1474,
    birthApprox: true,
    deathYear: 1548,
    bio:
        'Cuauhtlatoatzin nació hacia 1474 en el actual México. Ya adulto y '
        'bautizado, en diciembre de 1531 la Virgen se le apareció en el cerro del '
        'Tepeyac y le pidió un templo. Como prueba llevó al obispo rosas fuera de '
        'estación en su tilma, donde quedó impresa la imagen de Guadalupe. Vivió el '
        'resto de su vida junto a la ermita, contando lo sucedido a quien se '
        'acercaba.',
    prayer: null,
    season: 3,
    episode: 20,
    status: SaintStatus.draft,
    catequesis: 60,
    escritos: 10,
    oracion: 85,
    patronazgos: 70,
    evangelizacion: 90,
    viajes: 30,
  ),
];
