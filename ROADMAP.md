# Santos NHF — Roadmap

App de la sección "El santo del día" del streaming católico **No Hacemos Fotocopias (NHF)**.
Cada santo tiene una tarjeta estilo FIFA con una ilustración y seis puntajes:
**catequesis, escritos, oración, patronazgos, evangelización y viajes**.
La app sirve para aprender de los santos, rezar con ellos y jugar con sus tarjetas.

## Principios de diseño

- **El santo es contenido público, la tarjeta es la capa de juego.** Biografía, oración,
  fecha de fiesta, ilustración y link al programa están disponibles para todos.
  Los seis puntajes solo se ven cuando la tarjeta forma parte de tu colección.
- **La ilustración se guarda separada de la tarjeta.** La app dibuja la tarjeta
  (marco, nombre, puntajes) a partir de la ilustración, así los cambios de puntaje
  se reflejan al instante y la ilustración se reutiliza en toda la app.
- **Contenido editable como un juego vivo.** Todo se puede corregir y ajustar desde
  un panel de administración. Cada cambio deja una revisión anterior, lo que permite
  deshacer y publicar "notas del parche" cuando cambian los puntajes.
- **Alineado con la liturgia.** La carta del día es la del santo cuya fiesta es hoy
  cuando existe en el catálogo; si no, una aleatoria entre las que faltan. Sin duplicados:
  el objetivo es completar el álbum.
- **Todo lo social es asincrónico.** Nada requiere que dos personas estén conectadas
  al mismo tiempo. La única excepción es la trivia en vivo, atada al programa: quien no
  la ve en el momento se pierde esa carta y nada más, igual que un código que se dice al aire.

## Juego en vivo y tiempo real

### Trivia en vivo

Una partida estilo Kahoot durante "El santo del día". El admin la anuncia y en todas las
pestañas aparece un cartel con cuenta regresiva; quien toca "Sumarme" espera en una pantalla
propia. Después van de 3 a 5 preguntas sobre el santo, de 20 segundos cada una: acertar vale
entre 1000 y 500 puntos según lo rápido que llegó la respuesta, medido con el reloj del
servidor. Entre pregunta y pregunta se ve la correcta, el recuento, tu resultado y el top 5;
la siguiente la abre el admin con "Siguiente", con 3 segundos de preparación. Al final, podio,
premios y la animación de carta nueva para quien ganó. Sin cuenta se ve todo, pero en lugar
de las opciones aparece "Ingresá para participar". La ✕ del cartel lo esconde por esa
partida y deja un punto rojo de "EN VIVO" en la barra de arriba.

Servidor (`lib/src/live/`), hecho:
- [x] Modelos `LiveGame` (fase, preguntas, pregunta actual, horarios, premios y resultados) y
  `LiveAnswer` (una por jugador y pregunta, con puntos y milisegundos), con su migración.
  `CardSource.live` para las cartas que salen de acá.
- [x] `LiveService`: anunciar (una partida a la vez), abrir y cerrar preguntas, avanzar,
  cancelar, contestar y terminar (ranking, ganadores y cartas en una sola transacción).
  Cada paso bloquea la fila de la partida y es idempotente, así el botón del admin y la
  future call no pisan el mismo paso.
- [x] `LiveFutureCall` abre cada pregunta al terminar su cuenta regresiva y la cierra a los
  20 segundos; sobrevive a un reinicio. Las future calls se revisan cada segundo
  (`futureCall.scanInterval` en la config), no cada 5.
- [x] `LiveEndpoint.watch()`: stream con la vista entera en cada cambio, alimentado por
  `session.messages`. Las vistas salen de una sola foto en memoria por cambio, así cien
  espectadores cuestan una ronda de consultas. Las respuestas y los espectadores que entran y
  salen se avisan como mucho una vez por segundo. Funciona porque hay un solo servidor; con
  dos haría falta Redis.
- [x] `AdminLiveEndpoint`: anunciar, avanzar (un solo botón que hace lo que toca) y cancelar.
- [x] 14 tests de integración, incluido el stream.

App:
- [x] Cartel global en `home_shell` y punto rojo en la barra, escuchando el stream mientras
  la app está en primer plano. Se reinicia al ingresar o salir de la cuenta, para que el
  stream sepa quién mira.
- [x] Pantallas de la partida: espera con cuenta regresiva, pregunta con reloj, revelación
  con barras y tu resultado ("¡Bien! +842 · vas 12.º de 128"), podio con premios y
  `CardReveal` si ganaste. El reloj se corrige con `serverTime`.
- [x] Reconexión del stream si se corta, con espera creciente hasta 30 segundos.
- [x] Pantalla admin "En vivo" (Perfil → Trivia en vivo): santo (por defecto el de la fiesta de hoy), preguntas y su
  orden, cuenta regresiva, cantidad de premios rápidos y por sorteo; después, el botón
  "Siguiente" y "Cancelar".
- [x] Los WebSockets pasan por Caddy en producción: el stream conecta en ~150 ms.
- [x] Partida completa en local: un visitante sin cuenta en el navegador y un admin que juega
  desde un script. Cartel, espera, preguntas que se abren y cierran solas, revelación, podio y
  carta entregada.
- [x] Partida completa en producción, con el panel admin y dos jugadores.

Reglas de los premios: ganan los primeros N en acertar, por la hora en que el servidor
recibió la respuesta, más 2 por sorteo entre los demás que acertaron (las dos cantidades se
eligen al lanzar la ronda). Si aciertan N + 2 o menos, ganan todos. Quien ya tiene la carta se
lleva una al azar entre las que le faltan; con el álbum completo figura entre los ganadores sin
carta. Al cierre se muestran las dos listas por separado. Mirar no requiere cuenta; contestar sí.

### Duelos en tiempo real


- [x] `DuelEndpoint.watch(duelId)`: el tablero en vivo. Cada jugada avisa por el canal del
  duelo y por el de cada jugador (`DuelEvents`), desde el endpoint, después de que la
  transacción confirmó.
- [x] `DuelEndpoint.watchMine()`: la lista de duelos en vivo, que mueve el contador de turnos
  de la pestaña Jugar. `AppState` la escucha mientras la app está abierta.
- [x] `duel_screen` se suscribe y el sondeo queda cada 30 s como respaldo por si el stream se
  cae. Los ecos de las jugadas propias no borran una elección a medio hacer.

### Pendientes

- [ ] Recorrer en `santos.nhf.com.ar` el flujo completo: crear cuenta, mazo inicial, carta
  del día, pregunta del día, Letanía, duelo contra el Sacristán, duelo entre amigos.
- [ ] Vencimiento de duelos abandonados y mail del santo del día (con opt-in).
- No se puede traducir desde la app lo que quedó en inglés en el ingreso: en
  `serverpod_auth_idp_flutter` 4.0.4 (igual que en 4.0.3) el formulario de ingreso arma el
  campo de contraseña sin pasarle `EmailSignInTexts.passwordLabel` (sale "Password") y "Didn't
  receive? Send a new code" es una constante del botón de reenviar. Está anotado en
  `docs/serverpod-feedback.md`, junto con el resto de lo que encontramos de Serverpod.

## Fase 1 — Catálogo, colección y administración

- [x] Modelo de datos: santos con puntajes, estado (borrador/publicado), ilustración,
  fecha de fiesta, temporada/capítulo y link al fragmento del streaming.
- [x] Historial de revisiones por santo, con nota del cambio y autor.
- [x] Colección por usuario: mazo inicial de 5 cartas al registrarse y una carta por día
  (prioriza el santo del día litúrgico). Un día = día calendario en Argentina (UTC-3).
- [x] Catálogo público con búsqueda: ficha con ilustración, biografía, oración y botón
  para ver el fragmento en YouTube. Tarjeta bloqueada si todavía no la tenés.
- [x] Álbum de la colección con progreso.
- [x] Panel de administración dentro de la app (rol `admin`): alta y edición de santos,
  puntajes, estado, subida de ilustración, historial de revisiones y restauración.
- [x] Acceso admin inicial: lista de emails en `config/passwords.yaml`
  (`adminEmails`, separados por coma). Después, un admin puede dar acceso a otros por email.
- [x] Datos de ejemplo en modo desarrollo (santos ficticios en puntajes, para probar la app).
- [ ] Carga inicial de los 53 santos reales del programa (nombres desde la planilla,
  puntajes e ilustraciones desde las tarjetas, links a los fragmentos, borradores de
  biografía y oración a revisar por el equipo).

## Fase 2 — Juego individual

- [x] Pregunta del día: un multiple choice sobre un santo de tu colección, con racha
  (la racha cuenta días consecutivos con respuesta correcta).
- [x] Banco de preguntas por santo, editable desde el panel admin (botón "Preguntas" en
  la ficha de cada santo). Un santo necesita al menos una pregunta para entrar en un mazo.
- [ ] Borradores de preguntas generados a partir de la transcripción del fragmento
  (pendiente de tener los links reales).
- [x] "Adivinar el puntaje": tarjeta con puntajes tapados, hay que adivinar la categoría
  más alta. Juego local con las cartas del álbum.
- [x] Duelo contra la máquina ("El Sacristán"), con la misma mecánica que entre amigos.
  La máquina elige la categoría donde su mejor carta es más fuerte y responde bien el
  60 % de las veces.
- [x] Notas del parche en la pestaña Hoy: cambios de puntaje recientes. Los valores
  exactos solo se muestran si tenés la carta; si no, solo si subió o bajó.

## Fase 3 — Social

- [x] Amigos por código de invitación (6 caracteres, sumar es inmediato). Nombre público
  editable. Ver el álbum de un amigo: los puntajes solo se ven en las cartas que también tenés.
- [x] Duelo asincrónico entre amigos:
  - Cada jugador arma un mazo de 5 cartas de su colección; los puntajes del rival están ocultos.
  - Turnos alternados: el atacante elige categoría (no se repiten en la partida) y carta;
    el defensor ve la categoría y elige su carta.
  - Cada jugador responde una pregunta sobre su santo **en el mismo momento en que elige
    la carta**, antes de saber si ganó la comparación. Así cada ronda son solo dos pasos.
  - El de la carta más alta suma el punto si respondió bien; si no, lo suma el rival si
    respondió bien. Gana el primero en llegar a 3 o el que más puntos tenga al terminar.
- [ ] Notificaciones push cuando es tu turno (requiere configurar Firebase). Con la app
  abierta ya no hacen falta: el contador de turnos y el tablero se actualizan en vivo.
- [x] Rankings globales de álbum, mejor racha y duelos ganados, con marca de amigos.
- [x] Códigos de desbloqueo: se crean desde el panel admin (carta fija o al azar, usos
  máximos, vencimiento) y se canjean desde la pestaña Hoy. Un canje por persona por código.

## Mantenimiento del contenido

- [x] **Importar y exportar CSV** desde el panel admin (Perfil → Importar y exportar):
  un archivo de santos, otro de preguntas y otro de libros, pensados para editarse en Google
  Sheets o Excel. Los santos se identifican por `slug`, las preguntas por `id` (o por santo +
  texto de la pregunta si el id está vacío) y los libros por `id` (o por santo + título).
  Las filas nuevas se crean, las existentes se actualizan, nada se borra. Antes de aplicar
  se muestra una vista previa con los cambios y los errores por línea; con errores no se
  importa nada. Cada santo modificado deja una revisión con la
  nota "Importación CSV". La ilustración no viaja en el CSV: se sube desde la app.
- [x] Créditos del programa, el canal de YouTube y el ilustrador en Perfil → Créditos.
  Los datos se editan en `saints_nhf_flutter/lib/credits.dart`.
- [x] Animación al obtener una carta nueva (carta del día, código y mazo inicial): la carta
  se eleva con un halo dorado, gira, estalla en chispas, la cruza un destello y se asienta.
- [x] **Compartir la tarjeta como imagen.** En la ficha de un santo que ya tenés, el botón
  "Compartir la tarjeta" arma un PNG de 1080 × 1350 (4:5, la proporción que las redes muestran
  entera) con la misma tarjeta que dibuja la app, agrandada, sobre el fondo de capilla, con
  "El santo del día" arriba y el nombre del programa abajo. El lienzo es de tamaño fijo y no
  de la pantalla: la imagen que sale de un teléfono chico es igual a la que sale de una tablet.
  Se dibuja fuera de la pantalla en el overlay —un `Offstage` no pinta y no habría nada que
  fotografiar—, se espera a que la ilustración termine su fundido y se saca la foto con
  `RepaintBoundary.toImage`. Después va al menú de compartir del sistema (`share_plus`).

  En la web casi ninguna computadora puede compartir archivos —la Web Share API no está, o
  `canShare` dice que no—, así que ahí bajamos la imagen con `file_saver` y lo decimos:
  "te descargamos la imagen; desde el celular el botón abre el menú para compartir". No se usa
  el plan B del plugin, que mete la imagen entera dentro de la URL de un ancla: con una tarjeta
  de 1080 × 1350 eso es un megabyte o más de URL, y algunos navegadores lo rechazan tirando un
  error (era el cartel rojo que aparecía al compartir desde el navegador). Solo para las
  cartas que están en tu álbum: la tarjeta con sus puntajes es lo que hay para mostrar.

## Cuentas e ingreso

- [x] **Catálogo público.** La pestaña Santos y las fichas se ven sin cuenta. Hoy, Álbum,
  Jugar y Amigos muestran una invitación a crear cuenta o ingresar. Los visitantes entran
  directo al catálogo; al ingresar se carga todo lo demás.
- [x] Pantalla de ingreso traducida (títulos cortos para que el formulario de Serverpod, de
  alto fijo, no desborde). El botón "Didn't receive? Send a new code" está fijo en la
  librería y no se puede traducir sin un formulario propio.
- [x] **Ingreso con Google**, en la web. `auth/google_idp_endpoint.dart` une la cuenta de Google
  con la cuenta por email que ya tenga ese mismo email verificado (`GoogleAccountLinking`): sin
  eso, Serverpod crea un usuario nuevo y vacío. El servidor activa el proveedor si
  `googleClientSecret` tiene algo (en producción, `GOOGLE_CLIENT_SECRET_JSON` en el `.env`), y la
  app web se compila con el client id y la redirección en `deploy.yml`. El JSON tiene que traer
  `redirect_uris`; Google Cloud las tiene que tener registradas:
  `https://santos.nhf.com.ar/auth/callback` y `http://localhost:8082/auth/callback`. En desarrollo
  el botón solo aparece compilando con `--dart-define=GOOGLE_WEB_CLIENT_ID=…` y sirviendo la app
  desde el 8082: la ventana de Google vuelve a `/auth/callback` del servidor web, que no es el
  origen de la app del 9998. Faltan iOS y Android (clientes OAuth propios y `Info.plist`). En la
  pantalla de consentimiento: logo `docs/logo-google-oauth-120.png`, página principal
  `https://santos.nhf.com.ar/acerca`, política `/privacidad` y términos `/terminos`.
- [ ] **Primer administrador en producción.** La imagen no incluye `config/passwords.yaml`, así
  que la lista `adminEmails` va como `ADMIN_EMAILS` en `/srv/santos-nhf/.env` del servidor.
  Luego se crea la cuenta en la app con ese email y se usa Perfil → Solicitar acceso. Desde ahí,
  ese admin puede dar acceso a otros por email sin volver a desplegar.
- [x] **Subida de ilustraciones en producción.** El navegador no puede subir directo al bucket de
  la nube: está en otro dominio y el PUT queda bloqueado por CORS, sin error visible en el servidor.
  Ahora la imagen se manda al servidor y él la guarda en el storage. Máximo 6 MB.
- [x] **Límite de subida en producción.** `config/production.yaml` viaja dentro de la imagen del
  servidor, así que el `maxRequestSize` de 10 MB aplica en producción. Caddy deja pasar hasta
  12 MB para que el que rechace sea el servidor, con su mensaje, y no el proxy con un 413.
- [x] **Envío de emails.** `src/email/verification_emails.dart` manda los códigos por SMTP con el
  paquete `mailer` (Brevo, plan gratuito de 300 envíos por día). Sin las claves `smtp*` el código
  se escribe en el log, que es el camino de desarrollo. Falta autenticar el dominio en Brevo
  (DKIM, SPF, DMARC): ver `deploy/README.md`.
- [ ] **Migración a DonWeb.** Infra en `deploy/`, runbook y pendientes en `deploy/README.md`. El
  corte obliga a todos los usuarios a usar "olvidé mi contraseña", porque los peppers de auth de
  Serverpod Cloud no se pueden recuperar; los datos viajan intactos en el dump.

## Sin conexión

- [x] La app guarda en el dispositivo una foto de los datos (catálogo, colección, perfil,
  pregunta del día y notas del parche) cada vez que carga bien, usando el modelo compartido
  `LocalSnapshot`. Sin red, abre con esa foto y muestra un aviso "Sin conexión" con la fecha
  de los datos y un botón para reintentar. Las ilustraciones se cachean en disco.
- Funciona sin red: ver el álbum, el catálogo, las fichas con biografía y oración, y el juego
  de adivinar el puntaje. Necesita red: carta del día, códigos, pregunta del día, duelos,
  amigos, rankings y el panel admin.
- Decisión: no se usó la base de datos SQLite del cliente de Serverpod porque en web (nuestro
  entorno de prueba) requiere binarios WebAssembly y un worker externos, y está en beta. El
  snapshot en `shared_preferences` cubre el caso de lectura; si algún día hace falta encolar
  acciones offline, la base cliente es el siguiente paso.

## Presentación de los santos

- [x] **Títulos litúrgicos** por santo (doctor, mártir, virgen, papa, fundador y demás), idea del
  ilustrador. Se eligen con chips en el panel admin, viajan en la columna `titulos_liturgicos` del
  CSV separados por punto y coma, y se muestran como medalla en la tarjeta y como chips en la ficha.
  El color sigue la liturgia: rojo para mártires, blanco para vírgenes, dorado para el resto.
  El femenino se deduce del nombre, así Santa Catalina aparece como "Doctora de la Iglesia".
- [x] **Libros recomendados** por santo. Cada libro tiene una categoría única (`BookKind`:
  obra, autobiografía, compilado, biografía, estudio, novela histórica, infantil), autor, año,
  editorial, un link opcional y una nota de por qué leerlo. La ficha los agrupa en dos:
  "Escritos de él/ella" (las tres primeras categorías) y "Libros sobre él/ella". Se cargan desde
  el panel admin (botón "Libros" en la ficha, con flechas para ordenar dentro de cada grupo) o
  por el CSV `libros`. Se eligió categoría única y no tags: con 3 a 10 libros por santo los tags
  no aportan y traen el costo de mantener el vocabulario.
- [x] **Años de nacimiento y muerte** (`birthYear`/`deathYear`, negativos para antes de Cristo,
  con `birthApprox`/`deathApprox` para que se lean "c. 1181"). Viajan en `SaintInfo`, así que
  están en el catálogo y en el snapshot offline. Se muestran como chip en la ficha.
- [x] **Línea de tiempo.** La pestaña Santos tiene arriba un selector Lista / Línea de tiempo.
  El tiempo corre **en horizontal** y se scrollea de izquierda a derecha: cada santo es una barra
  desde su nacimiento hasta su muerte, y las vidas que se superponen se apilan en filas, así los
  contemporáneos quedan uno debajo del otro en la misma franja vertical. Es horizontal porque
  entonces **el largo de la barra es la vida**, y una vida larga tiene lugar para escribir a lo
  largo la cara, el nombre y los años; además los contemporáneos se apilan contra el alto de la
  pantalla, que en un teléfono da el doble que el ancho. Cada barra dice lo que le entra según su
  propio largo: primero la cara, después el nombre, después los años. Cuando la barra se sale
  de la pantalla por la izquierda, la cara y el nombre se corren para adentro y se quedan a la
  vista, como los encabezados pegajosos de una tabla; frenan antes de caerse por la otra punta.
  Lo que se muestra se decide contra el lugar que queda después de correrse, no contra el ancho
  total, que si no una vida larga prometía los años y después desbordaba. Arriba, una regla de
  siglos con sus líneas bajando detrás de las barras; y más arriba, un **minimapa** de toda la
  historia:
  un histograma con cuántos santos vivieron en cada siglo, los siglos en números romanos (se
  dibujan los que entran sin tocarse) y un recuadro que marca la ventana de tiempo que se está
  viendo abajo, que la sigue al scrollear. Tocando o arrastrando el minimapa se salta a cualquier
  época, que queda centrada. Zoom de tres pasos (siglos / décadas / años) conservando el año
  del centro de la pantalla. Las cartas que ya tenés salen doradas y las que no, apagadas. Un
  santo con un solo año conocido se dibuja con una vida supuesta de 60 años y el borde tenue,
  para que no se lea como un dato. Hay tests que miden el apilado, qué dice cada barra según su
  largo, que ningún largo de vida desborde su barra en ninguno de los tres zooms, y que tocar el
  minimapa lleve el gráfico al siglo correcto.
- [x] **Concilios y hechos grandes de la Iglesia** de fondo en la línea de tiempo. Entre la
  regla de siglos y las barras corre un riel con los 21 concilios ecuménicos y una docena de
  hitos (Pentecostés, el edicto de Milán, los dos cismas, Guadalupe, la Reforma, Fátima), y
  cada uno baja como una línea tenue detrás de los santos: leer una franja vertical dice qué
  estaba viviendo la Iglesia mientras ese santo vivía. Los que duraron años —Trento, el cisma
  de Occidente— son una barra de punta a punta y pintan su franja. Los concilios van llenos y
  los demás huecos, que es toda la diferencia que necesita un fondo. Tocar uno abre una hoja
  con qué fue y por qué importa. Los nombres que entran se eligen por espacio, y los hitos
  marcados como principales se quedan con el lugar cuando no entran todos. Un botón al lado
  del zoom prende y apaga todo el fondo, para poder quedarse solo con las vidas; como el zoom,
  la elección vale para esa visita y no se guarda.

  El contenido vive en `saints_nhf_flutter/lib/church_events.dart` y se edita a mano, como los
  créditos: son treinta y tres datos que no cambian, iguales para todos y sin puntaje ni
  colección atrás, así que no justifican tabla, migración, panel admin ni CSV. Si alguna vez
  el equipo los quiere editar desde la app, la lista pasa a una tabla sin tocar el dibujo.
  Un hito fuera de los años que cubren los santos del catálogo no se dibuja: el eje es de
  ellos y no se estira por un concilio.
- [x] **Mapa de los santos.** Tercer segmento de la pestaña Santos, con un interruptor
  Nació / Murió. Cada santo tiene `birthPlace`/`birthLat`/`birthLng` y sus equivalentes de
  muerte: el nombre del lugar se guarda aparte de las coordenadas porque muchos nacieron en
  ciudades o reinos que ya no existen, y "Tagaste, Numidia" es la etiqueta honesta de un punto
  que hoy cae en Argelia. El nombre también sale como chip en la ficha.

  **No usa ningún servicio de mapas.** El contorno del mundo viaja dentro de la app
  (`assets/world.json`, 263 KB, de Natural Earth, que es dominio público) y lo dibuja un
  `CustomPainter` en proyección Web Mercator. Así el mapa funciona sin conexión como el resto
  del catálogo, no hay clave ni cuota, y queda en el estilo de la app en vez de un mapa de
  calles. Se descartaron las teselas de OpenStreetMap porque su política prohíbe expresamente
  el uso offline y traerlas por adelantado; cualquier otro proveedor pide una API key.
  Geocodificar tampoco: las coordenadas son dato del CSV, cargado una vez a mano.

  Los marcadores compensan el zoom para no agrandarse, y son un punto de lejos y una cara de
  cerca. Los que se pisan se juntan en un marcador con la cuenta: tocarlo acerca el mapa, salvo
  cuando el zoom no los va a separar nunca porque son de la misma ciudad —Mónica y Agustín en
  Tagaste—, y entonces abre una hoja con la lista. Desde el punto que se está mirando sale un
  hilo tenue hasta la otra punta de la vida, así se ve de dónde salió y dónde terminó cada uno
  sin tener que cambiar de modo. Hay botones de +, − y "ver todo el mundo", porque con mouse no
  hay forma obvia de hacer zoom.

## Explicar la app, y por qué los santos

- [x] **Bienvenida la primera vez.** Al abrir la app por primera vez en un dispositivo, cuatro
  pantallas que contestan lo que nos preguntan antes de que lo pregunten: qué es esto, cómo se
  consiguen las cartas, qué se hace con ellas, y por qué los santos. Se puede saltear, y se
  vuelve a ver desde Perfil. Se marca como vista al mostrarla, no al terminarla: el que la
  saltea tampoco quiere verla de nuevo. La marca vive en el dispositivo
  (`shared_preferences`), aparte de la foto de los datos, así cerrar sesión no la reinicia.
- [x] **Guía "Cómo funciona".** Un signo de pregunta en la barra de arriba, en todas las
  pestañas. Abre la guía **en la sección de la pestaña donde estaba el lector**: el que
  pregunta desde Jugar quiere leer sobre Jugar, no el índice entero. Un capítulo por pestaña,
  uno de "Por qué los santos" y las preguntas frecuentes; todos plegables. Las preguntas son
  las que nos hicieron de verdad —cómo se consiguen, si se repiten, si se cambian, qué pasa si
  un día no entro— y las respuestas dicen lo que el código hace hoy: no hay repetidas porque la
  carta del día sale siempre entre las que faltan, no hay intercambio, y en los duelos no se
  ponen en juego las cartas.
- [x] **Conceptos sobre la santidad, con la fuente oficial.** Seis temas —el llamado universal,
  "también para vos", los santos de la puerta de al lado, la comunión de los santos, por qué se
  les pide a ellos y para qué los canoniza la Iglesia—, cada uno explicado en la voz del
  programa y anclado en una cita corta del Catecismo, de Lumen gentium (a través del Catecismo)
  o de Gaudete et exsultate, con la referencia y el link al documento en vatican.va. Las citas
  están copiadas de vatican.va, no de memoria. Además, la pestaña Hoy muestra el tema del día,
  que rota solo con el día y es el mismo para todos, y lleva a la guía.
  El contenido vive en `saints_nhf_flutter/lib/holiness.dart` y `lib/help_content.dart`, para
  editar a mano como los créditos.

## Reglas del duelo, tal como quedaron implementadas

- La app reparte 8 cartas al azar del álbum (con preguntas cargadas) y el jugador elige 5.
  Así no se juega siempre con los mismos santos. El reparto se guarda en el servidor y el
  mazo se valida contra él.
- Mazos de 5 cartas, se gana a 3 puntos o al terminar las 5 rondas (puede haber empate).
- El primer atacante se sortea; después alternan.
- Empate de puntaje en la comparación (incluida la misma carta de los dos lados): el punto
  es para quien respondió bien, solo si fue uno de los dos. Si ambos aciertan o ambos
  fallan, la ronda queda sin punto y las dos cartas se consumen.
- La carta del rival y su puntaje en la categoría se revelan al cerrar la ronda.

## Ideas para más adelante

- Que los libros de la ficha se puedan filtrar por categoría cuando un santo tenga muchos.
- Sección de oraciones generales y oración del día.
- Ediciones especiales de tarjetas.
