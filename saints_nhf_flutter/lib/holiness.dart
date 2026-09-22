/// Lo que la Iglesia dice sobre la santidad, para que la app no sea solo un
/// juego de figuritas. Editá esta lista a mano.
///
/// Cada tema lleva una explicación nuestra y una cita textual con su
/// referencia y el link al documento oficial. Las citas de acá están
/// copiadas de vatican.va: si se corrige alguna, hay que volver a la fuente.
library;

/// Un concepto sobre la santidad, anclado en un documento de la Iglesia.
class HolinessTopic {
  const HolinessTopic({
    required this.id,
    required this.title,
    required this.body,
    required this.quote,
    required this.source,
    required this.url,
  });

  /// Nombre estable, para no depender del orden de la lista.
  final String id;

  final String title;

  /// La explicación en la voz del programa.
  final String body;

  /// Cita textual, sin comillas: las pone la pantalla.
  final String quote;

  /// De dónde sale, como se escribe al pie de una cita.
  final String source;

  /// El documento en vatican.va, para que cualquiera lo lea entero.
  final String url;
}

const _catecismoIglesia =
    'https://www.vatican.va/archive/catechism_sp/p123a9p3_sp.html';
const _catecismoComunion =
    'https://www.vatican.va/archive/catechism_sp/p123a9p5_sp.html';
const _catecismoSantidad =
    'https://www.vatican.va/archive/catechism_sp/p3s1c3a2_sp.html';
const _gaudeteEtExsultate =
    'https://www.vatican.va/content/francesco/es/apost_exhortations/documents/'
    'papa-francesco_esortazione-ap_20180319_gaudete-et-exsultate.html';

/// Los conceptos, en el orden en que conviene leerlos.
const holinessTopics = <HolinessTopic>[
  HolinessTopic(
    id: 'llamado-universal',
    title: 'La santidad no es para unos pocos',
    body:
        'Los santos de las tarjetas no son una categoría aparte de cristianos. '
        'La Iglesia enseña que el llamado a ser santo es para todos los '
        'bautizados, sin excepción: no es un premio para gente rara, es el '
        'destino normal de un cristiano.',
    quote:
        'Todos los fieles, de cualquier estado o régimen de vida, son llamados '
        'a la plenitud de la vida cristiana y a la perfección de la caridad.',
    source:
        'Catecismo de la Iglesia Católica, 2013, citando al concilio '
        'Vaticano II (Lumen gentium, 40)',
    url: _catecismoSantidad,
  ),
  HolinessTopic(
    id: 'tambien-para-vos',
    title: 'También para vos, donde estás',
    body:
        'No hace falta cambiar de vida ni entrar a un convento para empezar. '
        'El lugar donde cada uno ya está —la casa, el trabajo, la familia, el '
        'estudio— es el lugar donde se juega su santidad.',
    quote:
        'Todos estamos llamados a ser santos viviendo con amor y ofreciendo el '
        'propio testimonio en las ocupaciones de cada día, allí donde cada uno '
        'se encuentra.',
    source: 'Papa Francisco, Gaudete et exsultate, 14',
    url: _gaudeteEtExsultate,
  ),
  HolinessTopic(
    id: 'puerta-de-al-lado',
    title: 'Los santos de la puerta de al lado',
    body:
        'Por cada santo canonizado hay miles que nadie va a canonizar nunca. '
        'Están en el álbum los que la Iglesia propone como ejemplo, pero no '
        'son los únicos: la santidad de todos los días es la que sostiene a '
        'la Iglesia.',
    // Las comillas de adentro van rectas: la pantalla pone las angulares
    // alrededor de toda la cita y dos pares de « » se pisan.
    quote:
        'Esa es muchas veces la santidad "de la puerta de al lado", de '
        'aquellos que viven cerca de nosotros y son un reflejo de la presencia '
        'de Dios.',
    source: 'Papa Francisco, Gaudete et exsultate, 7',
    url: _gaudeteEtExsultate,
  ),
  HolinessTopic(
    id: 'comunion-de-los-santos',
    title: 'La comunión de los santos',
    body:
        'Es un artículo del Credo que se reza casi sin pensar. Quiere decir '
        'que los cristianos de la tierra, los que se están purificando y los '
        'que ya están con Dios no son tres grupos separados, sino un mismo '
        'cuerpo: lo que tiene uno es de todos.',
    quote: 'La comunión de los santos es precisamente la Iglesia.',
    source: 'Catecismo de la Iglesia Católica, 946',
    url: _catecismoComunion,
  ),
  HolinessTopic(
    id: 'interceden',
    title: 'Por qué se les pide a ellos',
    body:
        'No se le reza a un santo como se le reza a Dios: se le pide que rece '
        'con nosotros, como se le pide a un amigo. Estar con Dios no los alejó '
        'de nosotros; los dejó más cerca.',
    quote: 'No dejan de interceder por nosotros ante el Padre.',
    source:
        'Catecismo de la Iglesia Católica, 956, citando al concilio '
        'Vaticano II (Lumen gentium, 49)',
    url: _catecismoComunion,
  ),
  HolinessTopic(
    id: 'por-que-canoniza',
    title: 'Para qué los canoniza la Iglesia',
    body:
        'Canonizar no es repartir medallas. Cuando la Iglesia declara santo a '
        'alguien está diciendo dos cosas: que esa vida se puede imitar y que '
        'esa persona reza por nosotros. Las dos razones por las que vale la '
        'pena conocerlos.',
    quote:
        'La Iglesia reconoce el poder del Espíritu de santidad, que está en '
        'ella, y sostiene la esperanza de los fieles proponiendo a los santos '
        'como modelos e intercesores.',
    source: 'Catecismo de la Iglesia Católica, 828',
    url: _catecismoIglesia,
  ),
];

/// El tema que toca hoy. Es el mismo durante todo el día para todos, y va
/// cambiando: [dayKey] es la clave del día argentino (`yyyy-MM-dd`).
HolinessTopic topicOfTheDay(String dayKey) {
  var sum = 0;
  for (final unit in dayKey.codeUnits) {
    sum = (sum + unit) % 100000;
  }
  return holinessTopics[sum % holinessTopics.length];
}
