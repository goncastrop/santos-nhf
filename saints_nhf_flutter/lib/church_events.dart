/// Los concilios y los hechos grandes de la Iglesia, el fondo contra el que
/// la línea de tiempo ubica a los santos. Editá esta lista a mano; no hace
/// falta nada más. Un hecho fuera de los años que cubren los santos del
/// catálogo simplemente no se dibuja.
library;

import 'utils/years.dart';

/// Qué clase de hito es. Los concilios se dibujan llenos y el resto hueco,
/// que es toda la diferencia que necesita el fondo.
enum ChurchEventKind {
  concilio('Concilio ecuménico'),
  hecho('Hecho de la Iglesia');

  const ChurchEventKind(this.label);

  final String label;
}

/// Un hito de la historia de la Iglesia, en un año o a lo largo de varios.
class ChurchEvent {
  const ChurchEvent({
    required this.name,
    required this.year,
    required this.note,
    this.endYear,
    this.short,
    this.kind = ChurchEventKind.hecho,
    this.approx = false,
    this.major = false,
  });

  /// Nombre completo, el del panel que se abre al tocarlo.
  final String name;

  /// Año en que empieza. Negativo para a.C.
  final int year;

  /// Año en que termina, cuando duró más de uno.
  final int? endYear;

  /// Nombre corto para la etiqueta de la regla, donde el espacio es poco.
  /// Sin él se usa [name].
  final String? short;

  /// Una o dos frases: qué pasó y por qué importa.
  final String note;

  final ChurchEventKind kind;

  /// El año es tradicional o aproximado, y se escribe "c. 33".
  final bool approx;

  /// Los que no pueden faltar. Cuando las etiquetas no entran todas, estos
  /// se quedan con el lugar y los demás ceden.
  final bool major;

  /// Lo que se escribe en la regla.
  String get label => short ?? name;

  /// Último año que ocupa, para saber si entra en la ventana de tiempo.
  int get lastYear => endYear ?? year;

  /// "1545 – 1563", "c. 33".
  String get yearsLabel {
    final start = yearLabel(year, approx: approx);
    return endYear == null ? start : '$start – ${yearLabel(endYear!)}';
  }
}

/// Los hitos que caen dentro de los años que ya cubren los santos. El eje de
/// la línea de tiempo es de ellos: un concilio de afuera no lo estira.
List<ChurchEvent> churchEventsBetween(int from, int to) => [
  for (final event in churchEvents)
    if (event.lastYear >= from && event.year <= to) event,
];

/// Los 21 concilios ecuménicos y una docena de hechos que cambiaron a la
/// Iglesia, en orden. Las fechas de los primeros siglos son las que se dan
/// por tradición, y van marcadas como aproximadas.
const churchEvents = <ChurchEvent>[
  ChurchEvent(
    name: 'Pentecostés',
    year: 33,
    approx: true,
    major: true,
    note:
        'El Espíritu Santo baja sobre los apóstoles y la Iglesia sale a la '
        'calle. El primer día de todo lo que sigue.',
  ),
  ChurchEvent(
    name: 'Martirio de Pedro y Pablo en Roma',
    short: 'Pedro y Pablo',
    year: 67,
    approx: true,
    note:
        'Las dos columnas mueren en Roma bajo Nerón, con pocos años de '
        'diferencia.',
  ),
  ChurchEvent(
    name: 'Edicto de Milán',
    year: 313,
    major: true,
    note:
        'Constantino y Licinio dan libertad de culto. Termina la era de '
        'las persecuciones y empieza la Iglesia a cielo abierto.',
  ),
  ChurchEvent(
    name: 'Concilio de Nicea I',
    short: 'Nicea I',
    year: 325,
    kind: ChurchEventKind.concilio,
    major: true,
    note:
        'Contra Arrio: el Hijo es de la misma sustancia del Padre. De acá '
        'sale el Credo que todavía se reza.',
  ),
  ChurchEvent(
    name: 'Concilio de Constantinopla I',
    short: 'Constantinopla I',
    year: 381,
    kind: ChurchEventKind.concilio,
    note: 'Completa el Credo con la divinidad del Espíritu Santo.',
  ),
  ChurchEvent(
    name: 'Concilio de Éfeso',
    short: 'Éfeso',
    year: 431,
    kind: ChurchEventKind.concilio,
    major: true,
    note:
        'María es Madre de Dios, Theotokos, porque su Hijo es una sola '
        'persona.',
  ),
  ChurchEvent(
    name: 'Concilio de Calcedonia',
    short: 'Calcedonia',
    year: 451,
    kind: ChurchEventKind.concilio,
    major: true,
    note:
        'Cristo es verdadero Dios y verdadero hombre: dos naturalezas en '
        'una persona, sin confusión y sin separación.',
  ),
  ChurchEvent(
    name: 'Concilio de Constantinopla II',
    short: 'Constantinopla II',
    year: 553,
    kind: ChurchEventKind.concilio,
    note: 'Vuelve sobre las discusiones que dejó Calcedonia.',
  ),
  ChurchEvent(
    name: 'Concilio de Constantinopla III',
    short: 'Constantinopla III',
    year: 680,
    endYear: 681,
    kind: ChurchEventKind.concilio,
    note:
        'Cristo tiene también voluntad humana: quiso con una voluntad de '
        'hombre lo que quiso como Dios.',
  ),
  ChurchEvent(
    name: 'Concilio de Nicea II',
    short: 'Nicea II',
    year: 787,
    kind: ChurchEventKind.concilio,
    note:
        'Contra los iconoclastas: las imágenes se veneran porque el Hijo '
        'de Dios se hizo visible.',
  ),
  ChurchEvent(
    name: 'Concilio de Constantinopla IV',
    short: 'Constantinopla IV',
    year: 869,
    endYear: 870,
    kind: ChurchEventKind.concilio,
    note: 'El último concilio de la Iglesia todavía unida.',
  ),
  ChurchEvent(
    name: 'Gran Cisma de Oriente',
    short: 'Cisma de Oriente',
    year: 1054,
    major: true,
    note:
        'Roma y Constantinopla se excomulgan. Oriente y Occidente siguen '
        'caminos separados.',
  ),
  ChurchEvent(
    name: 'Concilio de Letrán I',
    short: 'Letrán I',
    year: 1123,
    kind: ChurchEventKind.concilio,
    note:
        'El primero celebrado en Occidente: cierra la disputa por quién '
        'nombra a los obispos.',
  ),
  ChurchEvent(
    name: 'Concilio de Letrán II',
    short: 'Letrán II',
    year: 1139,
    kind: ChurchEventKind.concilio,
    note: 'Ordena la disciplina del clero después de un cisma.',
  ),
  ChurchEvent(
    name: 'Concilio de Letrán III',
    short: 'Letrán III',
    year: 1179,
    kind: ChurchEventKind.concilio,
    note: 'Fija que al Papa lo eligen los cardenales por dos tercios.',
  ),
  ChurchEvent(
    name: 'Concilio de Letrán IV',
    short: 'Letrán IV',
    year: 1215,
    kind: ChurchEventKind.concilio,
    major: true,
    note:
        'El gran concilio medieval: la confesión y la comunión al menos '
        'una vez al año, y la palabra "transubstanciación".',
  ),
  ChurchEvent(
    name: 'Concilio de Lyon I',
    short: 'Lyon I',
    year: 1245,
    kind: ChurchEventKind.concilio,
    note: 'Convocado en plena pelea con el emperador Federico II.',
  ),
  ChurchEvent(
    name: 'Concilio de Lyon II',
    short: 'Lyon II',
    year: 1274,
    kind: ChurchEventKind.concilio,
    note: 'Intenta reunir a Oriente con Occidente; la unión no dura.',
  ),
  ChurchEvent(
    name: 'Concilio de Vienne',
    short: 'Vienne',
    year: 1311,
    endYear: 1312,
    kind: ChurchEventKind.concilio,
    note: 'Suprime a los templarios, con el papado ya instalado en Aviñón.',
  ),
  ChurchEvent(
    name: 'Cisma de Occidente',
    year: 1378,
    endYear: 1417,
    major: true,
    note:
        'Cuarenta años con dos papas, y por un tiempo tres. Lo cierra el '
        'concilio de Constanza.',
  ),
  ChurchEvent(
    name: 'Concilio de Constanza',
    short: 'Constanza',
    year: 1414,
    endYear: 1418,
    kind: ChurchEventKind.concilio,
    note: 'Termina con el cisma y deja un solo Papa.',
  ),
  ChurchEvent(
    name: 'Concilio de Basilea, Ferrara y Florencia',
    short: 'Florencia',
    year: 1431,
    endYear: 1445,
    kind: ChurchEventKind.concilio,
    note: 'Otro intento de unión con los orientales, firmado en Florencia.',
  ),
  ChurchEvent(
    name: 'Caída de Constantinopla',
    year: 1453,
    note: 'La ciudad cae en manos otomanas y con ella el imperio de Oriente.',
  ),
  ChurchEvent(
    name: 'Comienza la evangelización de América',
    short: 'América',
    year: 1492,
    major: true,
    note: 'La Iglesia cruza el Atlántico y en un siglo cambia de continente.',
  ),
  ChurchEvent(
    name: 'Concilio de Letrán V',
    short: 'Letrán V',
    year: 1512,
    endYear: 1517,
    kind: ChurchEventKind.concilio,
    note:
        'Pide una reforma que llega tarde: termina el mismo año de las 95 '
        'tesis.',
  ),
  ChurchEvent(
    name: 'Reforma protestante',
    short: 'Reforma',
    year: 1517,
    major: true,
    note: 'Lutero publica las 95 tesis y Occidente se parte en dos.',
  ),
  ChurchEvent(
    name: 'Apariciones de Guadalupe',
    short: 'Guadalupe',
    year: 1531,
    major: true,
    note:
        'La Virgen se le aparece a Juan Diego en el Tepeyac y América se '
        'hace católica de otra manera.',
  ),
  ChurchEvent(
    name: 'Concilio de Trento',
    short: 'Trento',
    year: 1545,
    endYear: 1563,
    kind: ChurchEventKind.concilio,
    major: true,
    note:
        'Dieciocho años de concilio que responden a la Reforma y ordenan '
        'la Iglesia durante los cuatro siglos siguientes.',
  ),
  ChurchEvent(
    name: 'Apariciones de Lourdes',
    short: 'Lourdes',
    year: 1858,
    note:
        'La Virgen se le aparece a Bernardita Soubirous: "Yo soy la '
        'Inmaculada Concepción".',
  ),
  ChurchEvent(
    name: 'Concilio Vaticano I',
    short: 'Vaticano I',
    year: 1869,
    endYear: 1870,
    kind: ChurchEventKind.concilio,
    note:
        'Define la infalibilidad del Papa cuando enseña ex cathedra. Lo '
        'interrumpe la toma de Roma.',
  ),
  ChurchEvent(
    name: 'Rerum novarum',
    year: 1891,
    note:
        'León XIII escribe sobre el trabajo y los obreros: el comienzo de '
        'la doctrina social de la Iglesia.',
  ),
  ChurchEvent(
    name: 'Apariciones de Fátima',
    short: 'Fátima',
    year: 1917,
    note:
        'La Virgen se les aparece a tres pastorcitos en Portugal, en el '
        'año de la revolución rusa.',
  ),
  ChurchEvent(
    name: 'Concilio Vaticano II',
    short: 'Vaticano II',
    year: 1962,
    endYear: 1965,
    kind: ChurchEventKind.concilio,
    major: true,
    note:
        'La Iglesia se mira a sí misma y se abre al mundo moderno. El '
        'concilio que todavía estamos recibiendo.',
  ),
];
