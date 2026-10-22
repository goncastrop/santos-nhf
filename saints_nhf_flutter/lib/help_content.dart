/// Las explicaciones de cómo funciona la app: lo que se lee en la guía y en
/// la bienvenida. Editá estos textos a mano.
///
/// Todo lo que se afirma acá tiene que ser verdad en el código: si cambia una
/// regla del juego, cambia también este archivo.
library;

import 'package:flutter/material.dart';

/// Cada capítulo de la guía. Los cinco primeros son las pestañas, en su
/// orden, así la ayuda puede abrirse donde está parado el lector.
enum HelpSection {
  app,
  today,
  saints,
  album,
  play,
  friends,
  holiness,
  faq;

  /// La sección que le corresponde a la pestaña [index] de la barra de abajo.
  static HelpSection ofTab(int index) => switch (index) {
    0 => HelpSection.today,
    1 => HelpSection.saints,
    2 => HelpSection.album,
    3 => HelpSection.play,
    4 => HelpSection.friends,
    _ => HelpSection.app,
  };
}

/// Un capítulo de la guía: una entrada corta y una lista de cosas concretas.
class HelpChapter {
  const HelpChapter({
    required this.section,
    required this.title,
    required this.icon,
    required this.lead,
    this.points = const [],
  });

  final HelpSection section;
  final String title;
  final IconData icon;

  /// El párrafo de arriba, el que contesta "¿y esto qué es?".
  final String lead;

  /// Lo concreto, una idea por renglón.
  final List<String> points;
}

/// Una pregunta de las que nos hacen, con su respuesta.
class Faq {
  const Faq(this.question, this.answer);

  final String question;
  final String answer;
}

const helpChapters = <HelpChapter>[
  HelpChapter(
    section: HelpSection.app,
    title: 'De qué se trata',
    icon: Icons.auto_stories_rounded,
    lead:
        'Es la app de "El santo del día", la sección del streaming católico '
        'No Hacemos Fotocopias. Cada santo del programa tiene su tarjeta, con '
        'una ilustración y seis puntajes, y la idea es juntarlas todas: '
        'conocer a los santos, rezar con ellos y jugar con sus cartas.',
    points: [
      'El catálogo de santos, con su vida y su oración, se ve sin cuenta.',
      'Para coleccionar cartas, jugar y sumar amigos hace falta una cuenta.',
      'No se compra nada: las cartas se consiguen jugando, un día a la vez.',
    ],
  ),
  HelpChapter(
    section: HelpSection.today,
    title: 'Hoy',
    icon: Icons.wb_twilight_rounded,
    lead:
        'La pestaña de todos los días: acá se reclama la carta, se responde '
        'la pregunta diaria y se ve qué cambió en el juego.',
    points: [
      'Una carta por día. El día empieza a la medianoche de Argentina.',
      'Si el santo que la Iglesia celebra hoy todavía te falta, esa es la '
          'carta que te toca. Si no, sale una al azar entre las que te faltan.',
      'Al crear la cuenta se reparten 5 cartas para empezar.',
      'La pregunta del día es sobre un santo de tu álbum y suma racha: '
          'cuenta los días seguidos que respondés bien. No se repite una '
          'pregunta hasta que se te terminen las nuevas.',
      'Si el programa da un código, se canjea acá.',
      'Las notas del parche avisan cuándo se corrigió el puntaje de un santo.',
    ],
  ),
  HelpChapter(
    section: HelpSection.saints,
    title: 'Santos',
    icon: Icons.menu_book_rounded,
    lead:
        'El catálogo completo, tengas o no tengas la carta. Es la parte de la '
        'app que se puede mirar sin cuenta y la que conviene compartir con '
        'alguien que recién llega.',
    points: [
      'Lista con buscador, que se puede ordenar por nombre o por fecha de '
          'fiesta.',
      'Línea de tiempo: cada santo es una barra desde que nació hasta que '
          'murió, con los concilios y los hechos grandes de la Iglesia de '
          'fondo.',
      'Mapa: dónde nació y dónde murió cada uno.',
      'En la ficha están su vida, los santos del catálogo con los que se '
          'conoció, su oración, los libros recomendados y el link al '
          'fragmento del programa.',
      'Los seis puntajes solo se ven en las cartas que ya tenés.',
    ],
  ),
  HelpChapter(
    section: HelpSection.album,
    title: 'Álbum',
    icon: Icons.style_rounded,
    lead:
        'Tu colección y cuánto te falta para completarla. Cada carta que '
        'entra se queda: no se pierde ni se gasta jugando.',
    points: [
      'No hay repetidas: nunca te toca una carta que ya tenés.',
      'El álbum está completo cuando juntaste todos los santos publicados. '
          'Cuando el programa suma un santo nuevo, vuelve a haber para buscar.',
      'Tocando una carta se abre la ficha del santo.',
      'Desde la ficha de una carta tuya se puede compartir la tarjeta como '
          'imagen.',
    ],
  ),
  HelpChapter(
    section: HelpSection.play,
    title: 'Jugar',
    icon: Icons.sports_esports_rounded,
    lead:
        'Los juegos usan las cartas de tu álbum y lo que sabés de cada santo. '
        'Nunca se apuestan cartas: se juega por puntos, no por figuritas.',
    points: [
      'Duelo: armás un mazo de 5 cartas entre las 8 que se reparten al azar.',
      'Por turnos, el que ataca elige una categoría y una carta; el otro ve la '
          'categoría y elige la suya. Una categoría no se repite en la partida.',
      'Los dos responden una pregunta sobre su santo antes de saber quién '
          'ganó la comparación.',
      'El punto es para la carta más alta, si esa persona respondió bien; si '
          'no, se lo lleva la otra si acertó. Si erraron los dos, la ronda '
          'queda sin punto, y si las cartas empatan decide la pregunta. '
          'Gana el primero que llega a 3.',
      'Al cerrarse cada ronda se ve la carta del rival, los dos puntajes y '
          'por qué el punto fue para donde fue.',
      'Se puede jugar contra El Sacristán, la máquina, o contra un amigo. '
          'Contra un amigo cada uno juega cuando puede: nadie espera a nadie.',
      'Adivinar el puntaje: se tapa una tarjeta y hay que decir en qué '
          'categoría es más fuerte.',
      'La Letanía: preguntas sobre los santos de tu álbum, una tras otra, con '
          'tres vidas. Cada tres aciertos seguidos sube el multiplicador, '
          'hasta ×5, y nunca se repite una pregunta. La mejor corrida queda '
          'en el ranking.',
      'Entre las preguntas sale cada tanto una de la línea de tiempo: de '
          'quién fue contemporáneo un santo, con cuatro santos del catálogo '
          'de los que solo uno vivió en su misma época. Nadie la carga: se '
          'arma con los años de nacimiento y muerte. Cuando la respuesta '
          'queda en pantalla, como en la Letanía, se ven los años de cada '
          'uno.',
      'Trivia en vivo: durante el programa, el equipo lanza unas preguntas '
          'sobre el santo del día y te aparece un aviso arriba en la app. '
          'Acertar vale entre 500 y 1000 puntos, más cuanto más rápido. Los '
          'mejores puntajes y algunos sorteados entre los que sumaron se '
          'llevan la carta del santo, o una que les falte si ya la tenían.',
    ],
  ),
  HelpChapter(
    section: HelpSection.friends,
    title: 'Amigos',
    icon: Icons.group_rounded,
    lead: 'Para jugar con gente conocida y ver cómo va su colección.',
    points: [
      'Cada uno tiene un código de 6 caracteres. Se lo pasás a quien quieras '
          'y listo: no hay que aceptar invitaciones.',
      'El código es privado: quien lo tiene te puede sumar.',
      'En el álbum de un amigo ves qué cartas tiene, pero los puntajes solo '
          'en las que vos también tenés.',
      'Los rankings comparan álbum, mejor racha y duelos ganados.',
    ],
  ),
];

/// Las preguntas que nos hicieron, con la respuesta corta.
const faqs = <Faq>[
  Faq(
    '¿De qué se trata la app?',
    'De la sección "El santo del día" del programa No Hacemos Fotocopias. '
        'Cada santo tiene su tarjeta con seis puntajes: se juntan, se leen y '
        'se juega con ellas.',
  ),
  Faq(
    '¿Cómo se consiguen las tarjetas?',
    'De cuatro maneras: las 5 que se reparten al crear la cuenta, una por '
        'día en la pestaña Hoy, los códigos que a veces da el programa y la '
        'trivia en vivo durante el programa. No se compran.',
  ),
  Faq(
    '¿Se pueden repetir?',
    'No. La carta del día siempre sale entre las que te faltan, así que nunca '
        'vas a tener dos veces el mismo santo. Por eso tampoco hay repetidas '
        'para cambiar.',
  ),
  Faq(
    '¿Se pueden cambiar o intercambiar con otra persona?',
    'Por ahora no. Cada álbum se arma solo, y en los duelos no se ponen en '
        'juego las cartas: nadie puede perder una carta que ya tiene.',
  ),
  Faq(
    '¿Qué pasa si un día no entro?',
    'No se acumula: al día siguiente te espera una carta nueva, una sola. Lo '
        'que ya tenés no se pierde nunca. Lo único que se corta es la racha de '
        'la pregunta del día.',
  ),
  Faq(
    '¿Para qué sirven los seis puntajes?',
    'Son los de las tarjetas del programa —catequesis, escritos, oración, '
        'patronazgos, evangelización y viajes— y se usan para los duelos y '
        'para adivinar el puntaje.',
  ),
  Faq(
    '¿Puedo usarla sin cuenta?',
    'Sí, para mirar el catálogo, la línea de tiempo, el mapa, las fichas de '
        'todos los santos y la trivia en vivo. Para coleccionar, jugar, '
        'responder la trivia y tener amigos hace falta una cuenta.',
  ),
  Faq(
    '¿Cuándo es la trivia en vivo?',
    'Durante el programa, cuando el equipo la lanza. Si tenés la app abierta '
        'te aparece un aviso arriba con la cuenta regresiva; si lo cerrás, '
        'queda un punto rojo de "EN VIVO" en la barra para volver.',
  ),
  Faq(
    '¿Puedo borrar mi cuenta?',
    'Sí, desde Perfil → Borrar mi cuenta. Para confirmar hay que escribir '
        'BORRAR. Se pierden el álbum, los récords, los amigos y los duelos, '
        'y no se puede deshacer.',
  ),
  Faq(
    '¿Anda sin internet?',
    'La app guarda en el dispositivo lo último que cargó, así que el álbum, '
        'los santos y sus oraciones se ven igual. Para reclamar la carta del '
        'día, jugar o canjear un código hace falta conexión.',
  ),
  Faq(
    '¿Los puntajes pueden cambiar?',
    'Sí: si el equipo corrige uno, el cambio aparece en las notas del parche, '
        'en la pestaña Hoy.',
  ),
];
