# Santos NHF — Flutter & Serverpod project

App de la sección "El santo del día" del streaming católico **No Hacemos Fotocopias**.
Los usuarios coleccionan las tarjetas estilo FIFA de los santos (una por día, más un mazo
inicial de 5), leen su biografía y oración, y saltan al fragmento del programa en YouTube.
El roadmap completo, con las fases de juego individual y social, está en `ROADMAP.md`.

## Cómo está armada

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

**Servidor (`saints_nhf_server/lib/src/`)**

- `saints/`: modelo `Saint` (tabla `saint`, con los 6 puntajes como columnas, estado
  `draft`/`published`, fecha de fiesta, años de nacimiento y muerte, temporada/capítulo,
  `youtubeUrl`, `illustrationPath` en el storage público), `SaintRevision` (snapshot JSON
  previo a cada edición admin), DTOs públicos `SaintInfo` (sin puntajes) y `SaintScores`,
  `SaintEndpoint` (catálogo público, sin login), `SaintMapper` y `seed_saints.dart` (10 santos
  de ejemplo que se insertan en desarrollo si la tabla está vacía; sus puntajes son inventados,
  y `backfillExampleYears` les completa los años si la base de desarrollo es anterior a esas
  columnas).
- `collection/`: `PlayerProfile` (por usuario: mazo inicial otorgado y día del último
  reclamo), `UserSaintCard` (cartas por usuario), `CollectionService` (reglas: mazo inicial
  de 5, una carta por día en calendario argentino UTC-3, prioriza el santo cuya fiesta es
  hoy, sin duplicados) y `CollectionEndpoint` (requiere login).
- `admin/`: `AdminSaintEndpoint` (CRUD con revisiones, restauración y subida de
  ilustración; requiere scope `admin`), `AdminAccessEndpoint` (consultar/solicitar acceso:
  se otorga si el email está en `adminEmails` de `config/passwords.yaml`) y
  `AdminUsersEndpoint` (dar/quitar admin por email).
- `questions/`: banco de preguntas (`Question`, 4 opciones), `QuestionService`, y el quiz
  diario (`QuizService`, `QuizEndpoint`): una pregunta por día sobre un santo de tu
  colección, con racha guardada en `PlayerProfile`. `QuestionSeen` (tabla `question_seen`,
  par jugador + pregunta) recuerda qué preguntas ya le tocaron a cada uno:
  `QuestionService.pickForPlayer` elige siempre entre las que nunca vio y solo cuando se
  agota el pozo vuelve a las vistas hace más tiempo, al azar dentro de la mitad más vieja.
  El Sacristán no se registra ahí (no tiene usuario) y sigue usando `randomFor`. En el duelo
  además se excluyen las preguntas ya jugadas en ese mismo duelo (`_usedQuestionIds`).
- `duel/`: motor del duelo (`DuelService`) con tablas `duel`, `duel_deck` y `duel_round`,
  `DuelEndpoint`, y la máquina "El Sacristán" (id fijo `11111111-1111-4111-8111-111111111111`,
  juega dentro de la misma transacción tras cada jugada humana). Reglas en `ROADMAP.md`.
- `live/`: la trivia en vivo estilo Kahoot (`LiveGame`, `LiveAnswer`, `LiveService`,
  `LiveEndpoint` público y `AdminLiveEndpoint`). Las preguntas se abren y cierran con
  `LiveFutureCall` (por eso `futureCall.scanInterval` es de 1 segundo en la config) y el stream
  `live.watch` manda la vista entera en cada cambio. Las vistas salen de una sola foto en
  memoria por cambio y los avisos van por `session.messages` con alcance local: anda porque
  producción es un solo servidor; con dos haría falta Redis. Reglas en `ROADMAP.md`.
- `duel/duel_events.dart`: cada jugada avisa por el canal del duelo y por el de cada jugador,
  y los streams `duel.watch` y `duel.watchMine` mandan el tablero y la lista actualizados.
  Los tests de streams que reaccionan a otra llamada en curso van en un grupo con
  `rollbackDatabase: RollbackDatabase.disabled` (ver `duel_stream_test.dart`): el proxy de
  rollback no permite dos consultas a la vez.
- `litany/`: "La Letanía", el juego individual (`LitanyRun` en la tabla `litany_run`,
  `LitanyService`, `LitanyEndpoint`, DTO `LitanyView`). Una corrida de preguntas sobre los
  santos del álbum con 3 vidas: acertar suma `basePoints` por el multiplicador, que sube un
  paso cada `streakPerStep` aciertos seguidos hasta `maxMultiplier`; errar cuesta una vida y
  corta la racha. Hay como máximo una corrida sin terminar por jugador, así que volver a la
  pantalla la retoma en lugar de perder el puntaje. `askedQuestionIds` evita repetir dentro de
  la corrida incluso cuando el pozo global ya se agotó. Al terminar, el puntaje queda en
  `PlayerProfile.litanyBest` y entra en `Leaderboard.byLitany`. Las reglas (`maxLives`,
  `maxMultiplier`) viajan en el DTO para que la app no tenga su propia copia de los números.
- `social/`: `ProfileService` (nombre público y código de amigo), `FriendsEndpoint`
  (amistad inmediata por código, tabla `friendship` con el par ordenado) y
  `LeaderboardEndpoint` (rankings con SQL crudo para contar cartas).
- `books/`: libros recomendados de cada santo (`SaintBook` en la tabla `saint_book`, con
  `BookKind` como categoría única), `BookService` (orden de lectura: primero lo que escribió el
  santo —`obra`, `autobiografia`, `compilado`—, después lo que se escribió sobre él, y dentro de
  cada grupo por `position`) y `seed_books.dart`. Viajan en `SaintDetail`, no en `SaintInfo`: el
  catálogo se pide entero y en cada duelo, así que la lista de lectura solo baja al abrir la
  ficha. Por lo mismo no está en el snapshot offline. Se administran con `AdminBookEndpoint`.
- `codes/`: códigos de desbloqueo (`UnlockCode`, `UnlockRedemption`), canje en
  `CollectionService.redeem` y `AdminCodesEndpoint`.
- `admin/csv_catalog.dart` + `AdminCatalogEndpoint`: export/import CSV de santos, preguntas y
  libros (paquete `csv`, cabeceras en español, upsert por `slug` / `id`, vista previa
  con `apply: false`). `saints/saint_revisions.dart` guarda revisiones y lo usan tanto el
  editor como la importación.
- `saints/saint_title.spy.yaml`: enum `SaintTitle` con los títulos litúrgicos (doctor, mártir,
  virgen…), guardado en `Saint.titles` y expuesto en `SaintInfo`. El enum está ordenado de más a
  menos distintivo: el primero que tiene un santo es el que sale como medalla en la tarjeta. El
  femenino se deduce de si el nombre empieza con "Santa"/"Beata" (`utils/titles.dart` en la app).
- `saints/saint_endpoint.dart#recentChanges`: notas del parche a partir de las revisiones.
- `questions/option_order.dart`: las opciones se guardan en el orden en que las cargó el admin,
  pero cada jugador las ve barajadas con una permutación estable derivada de una semilla
  (usuario + día + pregunta en la pregunta del día; ronda + jugador + pregunta en el duelo).
  Los índices de respuesta se guardan siempre en el orden original: la traducción pasa solo al
  entrar (`toQuiz`) y al salir (`toStored`).
- `util/argentina_day.dart`: el "día" del juego es el día calendario en Argentina.

Los puntajes solo viajan al cliente dentro de `CollectedCard` (santo ya coleccionado) o
por los endpoints admin. El catálogo público nunca los incluye.

**App Flutter (`saints_nhf_flutter/lib/`)**

- `theme.dart`: paleta "capilla nocturna" (tinta, dorado, pergamino) con Cinzel para
  títulos y Nunito Sans para texto.
- `state/app_state.dart`: `AppState` (ChangeNotifier con catálogo, colección y acceso
  admin) expuesto con `AppStateScope`; se lee con `AppState.of(context)`. `signedIn` decide
  el modo: sin cuenta solo se carga el catálogo, y `widgets/account_gate.dart` tapa las
  pestañas que necesitan cuenta con una invitación a ingresar (`SignInScreen.open`). Carga primero el
  snapshot local (`state/local_cache.dart`, `shared_preferences`, modelo compartido
  `LocalSnapshot`) y después la red; si la red falla con datos en pantalla, `offline = true`
  y `home_shell` muestra el aviso. Las ilustraciones usan `cached_network_image`.
- Al agregar un plugin de Flutter nuevo, la app web no lo registra hasta que `serverpod start`
  relanza el proceso de Flutter (un `hot_restart` no alcanza): si un plugin falla en silencio,
  esperar el relanzamiento o usar `spawn_flutter_app`. Hoy los plugins son `share_plus`
  (compartir la tarjeta), `file_selector` y `file_saver` (CSV), `image_picker`,
  `url_launcher`, `shared_preferences` y `cached_network_image`.
- `widgets/saint_card.dart`: la tarjeta se dibuja en Flutter a partir de la ilustración y
  los puntajes (`SaintCard`), con dorso (`SaintCardBack`) y animación de giro (`FlipCard`).
  Con `scores == null` se muestra bloqueada en gris.
- `widgets/share_card.dart`: la tarjeta como imagen para redes. `ShareCardImage` es el lienzo
  fijo de 1080 × 1350 (`shareImageSize`), `captureShareCard` lo dibuja en el overlay fuera de
  la pantalla y saca el PNG con `RepaintBoundary.toImage` (fuera del overlay no se pinta y no
  hay foto), y `ShareCardButton` lo pasa a `share_plus`. El botón sale en la ficha solo para
  las cartas que ya tenés.
- `utils/world.dart` + `assets/world.json`: los contornos del mundo (Natural Earth, dominio
  público) y la proyección Web Mercator. El mapa no usa ningún servicio de teselas: se dibuja
  con un `CustomPainter`, así que anda sin conexión y no hay clave ni cuota. El `LEEME.md` del
  asset explica cómo se generó y con qué tolerancia se simplificó.
- `utils/books.dart` y `utils/years.dart`: etiquetas de las categorías de libro y su agrupación,
  y el formato de los años ("c. 1181 – 1226", "s. XIII", siglos y tramos para la línea de tiempo).
- `screens/`: `sign_in_screen` (SignInWidget de Serverpod, traducido con
  `SignInLocalizationProvider`; sus formularios tienen alto fijo, por eso los títulos son
  cortos y los requisitos de contraseña usan etiquetas breves), `home_shell` (tabs Hoy /
  Santos / Álbum / Jugar / Amigos, con contador de turnos pendientes), `today_screen`
  (carta del día, mazo inicial, pregunta del día, canje de código, notas del parche),
  `explore_screen` (la pestaña Santos, con el selector Lista / Línea de tiempo / Mapa),
  `catalog_screen` (buscador y orden por nombre o por fecha de fiesta), `timeline_screen` (tiempo en horizontal, una barra por vida, filas apiladas
  para los contemporáneos, regla de siglos arriba, riel de concilios y hechos de la Iglesia
  entre la regla y las barras —cada uno baja como línea tenue por detrás, tocarlo abre una
  hoja, y un botón al lado del zoom apaga todo el fondo—, minimapa con la densidad por siglo y la
  ventana visible para saltar, y zoom de tres pasos; cada barra muestra cara / nombre / años
  según su propio ancho en píxeles, que es su duración, así que el detalle es por santo y no
  global), `map_screen` (dónde nació y dónde murió cada uno, con interruptor entre las dos
  puntas y un hilo hasta la otra; `InteractiveViewer` para el zoom más botones propios, y tanto
  el trazo de la costa como los marcadores dividen por la escala para no engordar; los
  marcadores que se pisan se agrupan por celda de pantalla, y el grupo que ningún zoom
  separaría abre una lista en vez de acercar),
  `saint_detail_screen`, `album_screen`, `profile_screen` (cerrar
  sesión, acceso admin), `screens/play/` (hub, selector de mazo, tablero del duelo que
  sigue `duel.watch` en duelos entre amigos, con un sondeo cada 30 s de respaldo, adivinar el
  puntaje, `litany_screen` con La Letanía), `screens/live/` (la trivia en vivo, ver
  `state/live_state.dart`), `screens/friends/`
  (código, amigos, desafiar, rankings, álbum de un amigo) y `screens/admin/` (santos,
  edición, historial, preguntas, libros, códigos, admins).
- `utils/scores.dart`: extensión sobre el enum compartido `ScoreCategory` (label,
  abreviatura, valor). Las pantallas admin cargan siempre el santo fresco por id antes de editar.
- `state/app_state.dart` vigila el cambio de día argentino (`watchDayChange` con un Timer hasta la
  medianoche y `checkDayChange` al volver del segundo plano) y recarga: la carta del día y la
  pregunta diaria son por día. `today_screen` además olvida la carta reclamada ayer.
- `widgets/common.dart`: además de los ladrillos compartidos (`Eyebrow`, `Ornament`, `InfoChip`,
  `ErrorView`, `showMessage`), `openLink` abre un link afuera de la app y, si el navegador lo
  bloquea por popup, lo copia al portapapeles.
- `widgets/waiting_view.dart`: pantalla de espera con un santo para leer, usada al crear un duelo.
- `widgets/card_reveal.dart`: animación de carta nueva (`CardReveal`), usada en Hoy y en el
  mazo inicial. `credits.dart`: datos de la pantalla de créditos, para editar a mano.
- `help_content.dart` y `holiness.dart`: el contenido de la ayuda, también para editar a mano.
  El primero tiene un capítulo por pestaña (`HelpChapter`, con `HelpSection.ofTab` para abrir la
  guía donde estaba el lector) y las preguntas frecuentes; el segundo, los conceptos sobre la
  santidad (`HolinessTopic`) con su cita textual, la referencia y el link a vatican.va, más
  `topicOfTheDay` para el que se muestra en Hoy. Lo que afirman tiene que ser verdad en el
  código: si cambia una regla del juego, cambian estos archivos.
- `screens/guide_screen.dart` (la guía "Cómo funciona", con los capítulos plegables) y
  `screens/welcome_screen.dart` (la bienvenida de la primera vez, que `home_shell` muestra una
  sola vez según la marca de `LocalCache.welcomeSeen`). Las dos se abren también desde Perfil, y
  la guía desde el signo de pregunta de la barra de arriba. `widgets/holiness_card.dart` es la
  cita del día en la pestaña Hoy.
- `church_events.dart`: los concilios ecuménicos y los hechos grandes de la Iglesia
  (`ChurchEvent`, lista `churchEvents`), también para editar a mano. La línea de tiempo los
  dibuja de fondo; `churchEventsBetween` deja solo los que caen dentro de los años que cubren
  los santos del catálogo, porque el eje es de ellos y no se estira por un hito.
- `screens/admin/admin_catalog_screen.dart`: import/export CSV con `file_selector` y
  `file_saver` (en macOS de escritorio `file_selector` necesita entitlements de acceso a archivos).

**Importar CSV sin pasar por la app**: `dart run bin/import_csv.dart [--apply] <archivos>`
corre el mismo importador que el panel admin contra la base de desarrollo. El nombre de cada
archivo decide qué es (santos, preguntas, libros) y el orden se acomoda solo, porque las
preguntas y los libros necesitan que los santos existan. Sin `--apply` solo muestra la vista
previa; conviene aplicar primero los santos y después mirar la vista previa de los otros dos.

**Catálogo lleno en desarrollo**: `dart run bin/seed_demo_saints.dart` agrega 68 santos de
prueba (nombres y años reales, biografía y puntajes inventados, slug `demo-` y título corto
"Santo de prueba") para ver la línea de tiempo con el catálogo lleno; `--remove` los borra y la
cascada se lleva sus cartas, preguntas y libros. Quedan publicados, así que también entran en la
carta del día y en los duelos mientras estén cargados.

**Tests**: `saints_nhf_server/test/integration/` con `withServerpod`. El helper
`auth_test_helper.dart` inicializa `AuthServices` y crea usuarios reales de auth, porque
`player_profile` tiene FK a la tabla de usuarios.

**Ingreso con Google**: preparado pero apagado hasta tener credenciales. `server.dart` agrega
`GoogleIdpConfigFromPasswords()` solo si existe `googleClientSecret` en passwords.yaml;
`client.dart` inicializa Google solo si se compila con `GOOGLE_WEB_CLIENT_ID`. Pasos completos
en `ROADMAP.md`, sección "Cuentas e ingreso".

**Despliegue (DonWeb)**: en migración desde Serverpod Cloud hacia un Cloud Server de DonWeb.
Toda la infra vive en `deploy/` (`docker-compose.yml` con Caddy + Postgres 16 + el servidor,
`Caddyfile`, `env.example`, `provision.sh`) y el runbook completo —pasos manuales, DNS, Brevo,
migración de datos, operación y rollback— está en `deploy/README.md`: **leerlo antes de tocar
cualquier cosa de producción**. El deploy lo hace `.github/workflows/deploy.yml` en cada push a
`main` que pase los tests: compila la app web, publica la imagen en GHCR taggeada con el SHA y
hace `pull` + `up -d` por SSH. Los secretos van por variables de entorno
(`SERVERPOD_PASSWORD_<clave>`, `SERVERPOD_DATABASE_PASSWORD`, `SERVERPOD_SERVICE_SECRET`) desde
`/srv/santos-nhf/.env`, nunca en la imagen: `.dockerignore` excluye `config/passwords.yaml`, que
el Dockerfile copiaría junto al resto de `config/`. `santos.nhf.com.ar` sirve la app y
`api.santos.nhf.com.ar` la API; Insights (8081) no se publica. Las ilustraciones quedan en
`DatabaseCloudStorage`, al que `ServerpodCloudProvider` cae solo fuera de Serverpod Cloud; si
crecen, el camino es `serverpod_cloud_storage_s3_compat`.

Mientras dure la convivencia, `.scloudignore` excluye `config/passwords.yaml` y todos los
`config/*.yaml`, así que `config/production.yaml` —que ahora apunta al dominio propio— no llega a
Serverpod Cloud. Ahí los secretos se definen con `scloud password set <nombre> <valor>` y los
ajustes con `scloud variable set <VAR> <valor>`, y ambos requieren `scloud deploy` para tomar
efecto. Los peppers de auth de Serverpod Cloud no se pueden recuperar, así que el corte obliga a
todos los usuarios existentes a usar "olvidé mi contraseña"; los datos viajan intactos.

**Cuentas**: los códigos de verificación y de recuperación los manda
`src/email/verification_emails.dart` (`appEmailIdpConfig`) por SMTP con el paquete `mailer`,
configurado con las claves `smtpHost`, `smtpPort`, `smtpUsername`, `smtpPassword` y
`smtpFromAddress` (Brevo en producción, pero no hay nada atado al proveedor). Si falta alguna, el
código se escribe en el log en vez de enviarse —eso es lo normal en desarrollo
(`tail_server_logs`, líneas "Registration code" / "Password reset code")— y en producción queda
además un log de error nombrando las que faltan. El envío es best-effort y nunca lanza: si lo
hiciera, una caída del relay rompería el registro y en el reset revelaría si una cuenta existe.
Para probar el envío real en local, poner esas claves bajo `development:` en `passwords.yaml`.
Para restablecer una contraseña a mano: `dart run bin/set_password.dart <email> <contraseña>` en
el paquete del servidor (arranca Serverpod en rol `maintenance` sobre la base de desarrollo).
Los nombres públicos por defecto son aleatorios ("Peregrino 412") y nunca derivan del código de
amigo, que debe permanecer privado.

**Subida de ilustraciones**: los bytes van al endpoint `adminSaint.uploadIllustration` y el
servidor los guarda con `session.storage.storeFile`. No se usa subida directa al bucket con URL
firmada: en Serverpod Cloud el storage es un bucket de objetos en otro dominio y el navegador
bloquea ese PUT por CORS, sin dejar rastro en los logs del servidor. Pasar por el servidor también
unifica el camino entre el storage de base de datos (local) y el de la nube. Límite de 6 MB en
`AdminSaintEndpoint.maxIllustrationBytes` y en la pantalla de edición: los bytes viajan en base64,
que agrega un tercio, y el `maxRequestSize` es de 10 MB. Cada archivo se guarda con
`Cache-Control: public, max-age=31536000, immutable` (`illustrationCacheControl`), que el endpoint
público reenvía desde el metadata; el reemplazo de una imagen se nota porque `SaintMapper` le
agrega `?v=<updatedAt>` a la URL, así que no hay que purgar ninguna caché.

**Páginas legales**: la política de privacidad y los términos se escriben en `docs/legal/*.md` y
`python3 tools/legal_a_html.py` genera `saints_nhf_server/web/pages/{privacidad,terminos}.html`,
que el servidor sirve en `/privacidad` y `/terminos` (antes de la ruta de la app de Flutter). Lo
que afirman tiene que ser verdad en el código, igual que la ayuda: si cambia qué datos se guardan
o con quién se comparten, cambian estos textos. La app las abre desde Perfil y desde la casilla de
aceptación del registro (`privacyUrl` y `termsUrl` en `credits.dart`).

**Optimizar ilustraciones**: `tools/optimizar_ilustraciones.sh <carpeta>` pasa un lote a WebP con
transparencia, limita el lado mayor a 1200 px (alcanza para la tarjeta compartible de 1080 × 1350)
y saca los metadatos. Con la colección original: 109 MB a 10 MB. Necesita ImageMagick.

**Imágenes en desarrollo**: las ilustraciones se sirven desde el endpoint
`serverpod_cloud_storage` del puerto 8080. En Serverpod 4.0.0 ese endpoint se perdía tras cada hot
reload del servidor ("Endpoint not found", 404) y las tarjetas mostraban el monograma; 4.0.1 lo
vuelve a registrar y ya no hace falta `hot_restart` para eso.

**Versiones**: todos los paquetes `serverpod*` de los tres pubspecs están fijados a la misma
versión exacta (hoy 4.0.3) y se suben juntos. El CLI que corre `serverpod start` lo instala App
Studio con `dart install` en `~/Library/Application Support/Dart/install/bin/serverpod` (hoy 4.0.3).
Esa carpeta no está en el PATH de la terminal: para usarlo a mano, llamarlo con la ruta completa. El CLI tiene que ser de la misma versión que los paquetes: aunque solo sugiere actualizar
y no exige que coincidan, el código que genera puede usar parámetros que el paquete viejo no tiene.
Al subir uno, subir el otro, y también el `VERSION` de `.github/workflows/tests.yml`. Lo mismo con
Flutter: el `flutter-version` de los cuatro workflows y la imagen `dart:` del
`saints_nhf_server/Dockerfile` siguen a la versión de fvm.

**Toolchain**: App Studio ya no trae un SDK propio y usa el del sistema. Flutter y Dart son los de
fvm: la versión global (`~/fvm/default`, hoy 3.47.6 con Dart 3.13.5) está en el PATH, así que
`dart` y `flutter` sirven directo para `analyze`, `format` y `test`. App Studio pide Flutter 3.47.0
o más nuevo del canal stable. Para cambiar de versión, usar `fvm install <versión> --setup` y
`fvm global <versión>`, nunca `flutter upgrade` dentro de una carpeta de `~/fvm/versions`, porque
cambia esa versión en el lugar y rompe los proyectos que la tienen fijada en su `.fvmrc`.

## Flujo de trabajo

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `saints_nhf_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited
  by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for
  destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and
  manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `saints_nhf_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.
