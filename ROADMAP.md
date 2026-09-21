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
  al mismo tiempo.

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
- [ ] Notificaciones push cuando es tu turno (requiere configurar Firebase; por ahora la
  pestaña Jugar muestra un contador de turnos pendientes y la pantalla del duelo consulta
  cada 8 segundos mientras espera).
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

## Cuentas e ingreso

- [x] **Catálogo público.** La pestaña Santos y las fichas se ven sin cuenta. Hoy, Álbum,
  Jugar y Amigos muestran una invitación a crear cuenta o ingresar. Los visitantes entran
  directo al catálogo; al ingresar se carga todo lo demás.
- [x] Pantalla de ingreso traducida (títulos cortos para que el formulario de Serverpod, de
  alto fijo, no desborde). El botón "Didn't receive? Send a new code" está fijo en la
  librería y no se puede traducir sin un formulario propio.
- [ ] **Ingreso con Google.** El código está preparado y se activa con credenciales:
  1. En Google Cloud Console, habilitar Google Auth Platform y crear tres clientes OAuth:
     Web (da client id y secret; orígenes `http://localhost:8082` y la URL de producción;
     redirect `http://localhost:8082/auth/callback` y la de producción), iOS (bundle id) y
     Android (package name y SHA-1 de `./gradlew signingReport`).
  2. Pegar el JSON del cliente web en `config/passwords.yaml` bajo `googleClientSecret`
     (sección `development` y luego `production`). El servidor activa el proveedor solo si
     esa clave existe.
  3. Crear `saints_nhf_server/lib/src/auth/google_idp_endpoint.dart` con
     `class GoogleIdpEndpoint extends GoogleIdpBaseEndpoint {}` (import
     `package:serverpod_auth_idp_server/providers/google.dart`). El widget de ingreso muestra
     el botón de Google en cuanto existe ese endpoint.
  4. Compilar la app con `--dart-define=GOOGLE_WEB_CLIENT_ID=<id del cliente web>` (y en
     producción `GOOGLE_REDIRECT_URI`). En iOS, agregar `GIDClientID`, `GIDServerClientID` y el
     URL scheme en `Info.plist`.
  Las tablas de Google ya están en las migraciones.
- [ ] **Primer administrador en producción.** El despliegue no sube `config/passwords.yaml`,
  así que la lista `adminEmails` hay que definirla en el servidor:
  `scloud password set adminEmails "<emails separados por coma>"` y después `scloud deploy`.
  Luego se crea la cuenta en la app con ese email y se usa Perfil → Solicitar acceso. Desde ahí,
  ese admin puede dar acceso a otros por email sin volver a desplegar.
- [x] **Subida de ilustraciones en producción.** El navegador no puede subir directo al bucket de
  la nube: está en otro dominio y el PUT queda bloqueado por CORS, sin error visible en el servidor.
  Ahora la imagen se manda al servidor y él la guarda en el storage. Máximo 6 MB.
- [ ] **Límite de subida en producción.** También por `.scloudignore`, `config/production.yaml`
  no se sube: el `maxRequestSize` de 10 MB solo aplica local. En la nube hace falta
  `scloud variable set SERVERPOD_MAX_REQUEST_SIZE 10485760` y redesplegar, o las ilustraciones
  de más de 512 kB fallarán.
- [ ] **Envío de emails.** En desarrollo los códigos se imprimen en la consola del servidor.
  En producción hace falta un servicio de email: si se despliega en Serverpod Cloud, la
  configuración actual (`ServerpodCloudEmailIdpConfig`) usa su servicio sin cambios; si no,
  reemplazarla por `EmailIdpConfigFromPasswords` con un callback que envíe el código por un
  proveedor (Resend, SendGrid, Postmark, SMTP propio).

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
- Compartir la tarjeta como imagen en redes.
- Ediciones especiales de tarjetas.
