# Infraestructura y despliegue

Cómo corre Santos NHF en producción, qué hay que hacer a mano una sola vez y en
qué orden. Los archivos de esta carpeta son la infraestructura entera: no hay
consola de nadie donde esté la verdad.

- `docker-compose.yml` — el stack. Vive en `/srv/santos-nhf/` del servidor.
- `Caddyfile` — TLS y reverse proxy. Vive al lado del compose.
- `env.example` — plantilla de los secretos. El `.env` real solo existe en el
  servidor y nunca en el repo.
- `provision.sh` — preparación del servidor, idempotente.

El despliegue lo hace `.github/workflows/deploy.yml` en cada push a `main` que
pase los tests. La configuración del servidor está en
`saints_nhf_server/config/production.yaml`.

## Por qué esta forma

Veníamos de Serverpod Cloud y nos fuimos por dos razones: USD 20 al mes por un
servidor en Europa cuando los usuarios están en Argentina, y la cuota de acceso
al bucket agotada. DonWeb resuelve servidor, base y mails, pero **no tiene
object storage ni PostgreSQL administrado**, así que las tres cosas van en el
mismo Cloud Server con Docker Compose.

Las ilustraciones quedan en el storage en base de datos de Serverpod
(`DatabaseCloudStorage`, al que `ServerpodCloudProvider` cae solo cuando no
corre en Serverpod Cloud). Después de optimizarlas la colección entera pesa
10 MB, así que un bucket era desproporcionado. Si algún día crece, el camino es
`serverpod_cloud_storage_s3_compat` apuntado a MinIO en el mismo servidor o a
Cloudflare R2, sin escribir un provider propio.

OpenTofu no se usa: DonWeb no publica API ni provider, así que no habría
recursos que administrar. Todo el estado interesante está dentro del servidor, y
eso se versiona con el compose y el script de provisión.

## Arquitectura

```
                     santos.nhf.com.ar ──┐
                 api.santos.nhf.com.ar ──┤
                                         ▼
                              ┌──────────────────┐
                              │ Caddy  :80 :443  │  único con puertos al mundo
                              └────────┬─────────┘
                       :8082 (web app) │ :8080 (API)
                              ┌────────▼─────────┐
                              │ server           │  imagen de GHCR
                              └────────┬─────────┘
                                       │ :5432 red interna
                              ┌────────▼─────────┐
                              │ postgres 16      │  volumen postgres_data
                              └──────────────────┘
```

Insights (8081) no se publica. Para usarlo:
`ssh -p <puerto> -L 8081:localhost:8081 <usuario>@<ip>`.

`migrate` es un contenedor de un solo uso que corre con rol `maintenance` y
`--apply-migrations` antes de que arranque `server`. Si una migración falla sale
con código 1 y el servidor no levanta, así que nunca queda la app corriendo
contra un esquema a medias.

## El servidor

| | |
| --- | --- |
| Dónde están IP, hostname y puerto de SSH | en el panel de DonWeb. Deliberadamente no se escriben acá: publicar el puerto exacto donde escucha SSH le ahorra trabajo a un escáner, y el puerto no estándar deja de aportar nada |
| Sistema | Ubuntu 26.04 LTS (`resolute`), kernel 7.0 |
| Recursos | 2 vCPU, 1635 MB de RAM usables, 26 GB de disco |
| Acceso | clave `~/.ssh/santos_nhf_ed25519` (administración) y `~/.ssh/santos_nhf_ci_ed25519` (GitHub Actions) |

Las dos claves son dedicadas a este host y se revocan por separado borrando su
línea de `authorized_keys`: perder la de CI no deja a nadie afuera, y revocar la
de administración no rompe el deploy. En DonWeb el SSH no escucha en el 22.

Ojo que algunas redes wifi filtran puertos SSH no estándar: si `ssh` se queda
colgado sin error, probar desde otra red antes de buscar el problema en el
servidor.

## Dimensionamiento

2 vCPU / 2 GB de RAM / **20 GB** NVMe, con la transferencia de 1 TB que ya
viene. El espacio del sistema operativo lo regala DonWeb aparte, así que esos
20 GB son todos para nuestros datos.

Ojo con una particularidad del configurador: las opciones de RAM dependen de la
cantidad de vCPU elegida. Si con 2 vCPU la memoria mínima que ofrece es 4 GB,
tomar 4; la restricción es de ellos.

Presupuesto de memoria, sumando lo que consume cada pieza:

| Qué | Cuánto |
| --- | --- |
| Postgres 16 | ~300–500 MB (128 MB de `shared_buffers` + 5–10 MB por conexión, y Serverpod abre 10 como máximo) |
| Servidor Dart compilado AOT | ~100 MB en reposo, 200–300 MB con carga |
| Caddy | 30–60 MB |
| Sistema operativo y daemon de Docker | 300–400 MB |

Total ~1,2 GB, así que 2 GB deja alrededor de 40% de aire y le queda page cache
a Postgres para tener la base entera en memoria. Los 2 vCPU no son de más: el
tráfico de esta app es un pico concentrado a la mañana, cuando todos abren a
buscar la carta del día, y ahí conviene que los handshakes TLS, Postgres y el
servidor no compitan por un solo core.

`provision.sh` agrega un swapfile de 2 GB con `vm.swappiness=10`, porque las
imágenes de Ubuntu del cloud vienen sin swap: sin él, un pico inesperado termina
en el OOM killer matando Postgres sin aviso; con él, termina en unos segundos
lentos. A diferencia del disco, CPU y RAM se pueden **bajar** además de subir, y
la diferencia se acredita por los días restantes, así que empezar justo no ata a
nada.

Si alguna vez se compila la imagen en el servidor en lugar de en CI, hacen falta
2–4 GB libres solo para el `dart build cli`. El workflow lo hace en GitHub
Actions justamente para no pagar eso acá.

Presupuesto de disco, con lo que ocupa cada cosa:

| Qué | Cuánto |
| --- | --- |
| Imágenes de Docker | 992 MB medidos con postgres y caddy bajados (la de Postgres pesa casi todo: trae PostGIS y pgvector), más ~250 MB de la del servidor, y hasta ~2 GB con una semana de deploys viejos |
| Swapfile | 2 GB fijos |
| Base de datos, ilustraciones incluidas | decenas de MB hoy; menos de 1 GB con órdenes de magnitud más de usuarios |
| 14 backups diarios comprimidos | ~0,3 GB |
| Logs de contenedores | ~0,15 GB como techo duro (10 MB × 3 archivos × 4 contenedores) |

Medido en el servidor real después de provisionar: 6,4 GB usados de 26 GB, con
20 GB libres, contando sistema operativo, Docker, las dos imágenes públicas y el
swap. El número real sale de `docker system df` y
`du -sh /srv/santos-nhf/backups`. Lo que mantiene esto
acotado no es el tamaño del disco sino dos cosas que ya están configuradas: la
rotación de logs del daemon que pone `provision.sh` (sin ella los logs crecen
sin límite hasta llenar el disco) y el `docker image prune` del workflow de
deploy, que borra imágenes de más de 7 días. Si se deploya muchas veces por día,
bajar ese umbral.

La razón para arrancar en 20 y no en 40 es que el almacenamiento **se puede
ampliar pero no reducir**: si sobra, el dinero no vuelve. Ampliar se fracciona
por día y toma un reinicio de 3 a 5 minutos, así que el costo de quedarse corto
es bajo. Y si algún día las ilustraciones crecen mucho, antes de agrandar el
disco conviene sacarlas de la base a un Volumen Cloud o a un bucket S3 con
`serverpod_cloud_storage_s3_compat`.

El Cloud Server incluye backup semanal automático, 2 snapshots y certificados de
Let's Encrypt. Los snapshots **no son backup**: se borran a los 28 días y son
del servidor entero. El backup de la base lo hace el cron que instala
`provision.sh`.

## Puesta en marcha, paso a paso

El orden importa: los mails tienen que andar antes de mover el DNS (ver
"Contraseñas de los usuarios").

### 1. Dominio y DNS

`nhf.com.ar` está registrado en DonWeb pero **delegado a Cloudflare**
(`itzel.ns.cloudflare.com`, `margo.ns.cloudflare.com`), así que todos los
registros se administran ahí, no en el panel de DonWeb.

| Nombre | Tipo | Valor | Para qué |
| --- | --- | --- | --- |
| `santos` | A | IP del servidor, **DNS only** | la app |
| `api.santos` | A | IP del servidor, **DNS only** | la API |
| `@` | TXT | `brevo-code:…` | verificación de dominio en Brevo |
| `brevo1._domainkey` | CNAME | `b1.nhf-com-ar.dkim.brevo.com` | DKIM |
| `brevo2._domainkey` | CNAME | `b2.nhf-com-ar.dkim.brevo.com` | DKIM |
| `_dmarc` | TXT | `v=DMARC1; p=none; rua=mailto:rua@dmarc.brevo.com` | DMARC |
| `@` | TXT | `v=spf1 include:spf.brevo.com ~all` | SPF |

Los dos A tienen que estar en **DNS only** (nube gris): el proxy de Cloudflare
devolvería sus propias IPs y Caddy no podría resolver el desafío HTTP-01 contra
el origen. Si más adelante se quiere el CDN de Cloudflare adelante —tentador,
porque cachearía las ilustraciones en un POP argentino—, hay que poner el modo
SSL/TLS en **Full (strict)** para que Cloudflare valide el certificado de Caddy,
y tener presente que el límite de tamaño de request pasa a ser el del plan.

Verificar antes de seguir:

```bash
dig +short A santos.nhf.com.ar
dig +short A api.santos.nhf.com.ar
```

Los dos tienen que devolver la IP del servidor. Y que el puerto 80 llegue de
verdad desde afuera, porque si no el desafío de Let's Encrypt falla y consume
uno de los 5 intentos por hora que permite:

```bash
# en el servidor, un listener efímero sobre un directorio vacío
ssh <host> 'd=$(mktemp -d); cd "$d"; setsid nohup timeout 30 python3 -m http.server 80 --bind 0.0.0.0 >/dev/null 2>&1 </dev/null &'
# desde afuera
curl -o /dev/null -w '%{http_code}\n' http://<ip>/
```

Sin `nohup setsid` el listener muere al cerrarse la sesión SSH y el test da un
falso negativo.

### 2. Cloud Server

Crearlo con Ubuntu 24.04, instalación mínima (sin panel: Ferozo y cPanel no
hacen falta y se comen recursos). Del panel salen la IP, el hostname y el
**puerto de SSH, que en DonWeb no es el 22**.

En el firewall del panel dejar abiertos solo SSH, 80 y 443.

### 3. Provisionar

```bash
scp -P <puerto> deploy/provision.sh root@<ip>:/root/
ssh -p <puerto> root@<ip> 'bash /root/provision.sh'
```

Instala Docker, configura rotación de logs del daemon (sin eso los logs llenan
el disco), crea `/srv/santos-nhf/` y deja el `pg_dump` diario con retención de
14 días en `/usr/local/bin/santos-nhf-backup`. Con `FIREWALL=1 SSH_PORT=<puerto>`
además configura `ufw`.

### 4. Secretos del servidor

```bash
scp -P <puerto> deploy/env.example root@<ip>:/srv/santos-nhf/.env
ssh -p <puerto> root@<ip> 'chmod 600 /srv/santos-nhf/.env'
```

Completar en el servidor. `POSTGRES_PASSWORD`, `SERVICE_SECRET`,
`EMAIL_SECRET_HASH_PEPPER` y `JWT_REFRESH_TOKEN_HASH_PEPPER` se generan con
`openssl rand -base64 32`. Los peppers nunca se rotan después: ver abajo.

### 5. Brevo

Plan gratuito, 300 envíos por día, que alcanza de sobra para códigos de
verificación y resets. En Brevo: Settings → SMTP & API → pestaña SMTP. El login
tiene forma `9xxxxx@smtp-brevo.com` y la clave es una *SMTP key*, no la
contraseña de la cuenta.

Autenticar el dominio en Brevo y agregar en la zona DNS lo que pida: el TXT de
verificación, los DKIM, SPF y DMARC. Sin eso los mails caen en spam, y el peor
momento para descubrirlo es justo cuando todos los usuarios necesitan su código
de reset.

Mandar una prueba a Gmail y a Outlook antes de seguir.

Las claves van al `.env` como `SMTP_USERNAME`, `SMTP_PASSWORD` y
`SMTP_FROM_ADDRESS`. El código las lee como passwords de Serverpod
(`smtpUsername`, `smtpPassword`, …) en
`saints_nhf_server/lib/src/email/verification_emails.dart`. Si falta alguna, el
código de verificación se escribe en el log en vez de enviarse, y en producción
queda además un log de error nombrando las que faltan.

Para probar en local, poner esas claves bajo `development:` en
`config/passwords.yaml`, **no** bajo `shared:`. Con las cinco presentes,
desarrollo deja de loguear el código y lo manda de verdad.

### 6. Secretos de GitHub

En Settings → Secrets and variables → Actions:

| Secreto | Qué es |
| --- | --- |
| `DEPLOY_HOST` | IP o hostname del Cloud Server |
| `DEPLOY_PORT` | puerto de SSH del panel de DonWeb |
| `DEPLOY_USER` | usuario con el que entra el workflow |
| `DEPLOY_SSH_KEY` | clave privada, completa, cuya pública está en el servidor |
| `HEALTHCHECK_URL` | `https://santos.nhf.com.ar/`, recién cuando el DNS resuelva |

Mientras `HEALTHCHECK_URL` no esté definido el paso de verificación avisa y no
falla, así que el workflow ya se puede usar antes de tener dominio.

La imagen se publica en GHCR y el pull en el servidor usa el `GITHUB_TOKEN` del
propio run, que vive lo que dura el deploy: no hay ningún PAT de larga vida.

### 7. Primer deploy

Push a `main`, o Actions → Deploy → Run workflow. El workflow compila la app
web, construye y publica la imagen taggeada con el SHA, copia el compose y el
Caddyfile, y hace `pull` + `up -d`.

Verificar: `https://santos.nhf.com.ar/` sirve la app, la API responde y
`docker compose logs -f server` no tiene errores.

### 8. Migrar los datos

`scloud` da host, puerto y nombre de la base de Serverpod Cloud, y deja crear un
usuario para conectarse. Con eso:

```bash
pg_dump -h <host-scloud> -U <usuario> -d <base> --format=custom --no-owner \
  --no-acl -f saints_nhf.dump

scp -P <puerto> saints_nhf.dump root@<ip>:/tmp/
ssh -p <puerto> root@<ip>
docker compose -f /srv/santos-nhf/docker-compose.yml cp \
  /tmp/saints_nhf.dump postgres:/tmp/
docker compose -f /srv/santos-nhf/docker-compose.yml exec postgres \
  pg_restore -U serverpod -d saints_nhf --no-owner --no-acl /tmp/saints_nhf.dump
```

Usar el `pg_dump` de la versión de destino o superior. Importante: la tabla de
migraciones viaja en el dump, así que el `migrate` del stack no va a querer
reaplicar nada. Confirmarlo antes de dejar entrar tráfico.

Las ilustraciones **no** se migran: se vuelven a subir optimizadas (ver abajo),
lo que de paso resuelve el problema del peso.

## Migraciones del esquema

Las migraciones se aplican en el deploy, no a mano. El servicio `migrate` del
compose corre la misma imagen que `server` pero con
`--role=maintenance --apply-migrations`: en ese rol Serverpod aplica las
migraciones pendientes, se saltea el resto de las tareas de mantenimiento,
reintenta la conexión a la base hasta 6 veces y termina el proceso con un código
de salida que refleja el resultado. `server` depende de él con
`condition: service_completed_successfully`, así que solo arranca si la
migración salió bien.

Los archivos de `saints_nhf_server/migrations/` viajan dentro de la imagen (el
Dockerfile los copia), así que la imagen y su esquema son una sola unidad
desplegable. En desarrollo el flujo no cambia: `create_migration` y
`apply_migrations` por MCP, y el resultado se commitea.

Qué pasa cuando una migración falla: `docker compose up -d` recrea en orden de
dependencia y nunca llega a tocar `server`, así que el contenedor viejo sigue
sirviendo con la imagen anterior, y el workflow se marca en rojo. Es el
comportamiento que queremos —fallar sin tirar el servicio— pero conviene
confirmarlo la primera vez que pase de verdad.

Dos límites que hay que tener presentes:

- Mientras `migrate` corre, el `server` viejo sigue atendiendo, así que hay unos
  segundos en que el código anterior habla con el esquema nuevo. Con una
  migración aditiva (una columna nueva, una tabla nueva) no pasa nada. Con una
  destructiva —renombrar o borrar una columna que el código viejo todavía lee—
  hay una ventana de errores, y el camino correcto es partirla en dos deploys:
  primero agregar y empezar a escribir en lo nuevo, después borrar lo viejo.
- El rollback del código no revierte el esquema. Volver a desplegar el commit
  anterior baja la imagen vieja, pero la migración ya corrió. Si la migración
  era destructiva, el rollback necesita su propia migración hacia atrás.

Si la base queda desincronizada de las migraciones (drift), la salida es una
repair migration, que no está en el compose porque no debería ser rutina:

```bash
docker compose run --rm --entrypoint ./bin/server server \
  --mode=production --role=maintenance --apply-repair-migration
```

## Contraseñas de los usuarios

Los peppers de Serverpod Cloud (`emailSecretHashPepper`,
`jwtRefreshTokenHashPepper`) no se pueden recuperar, así que en el servidor nuevo
son valores nuevos. Consecuencias:

- Ninguna contraseña guardada valida. Todos los usuarios existentes tienen que
  pasar por "olvidé mi contraseña".
- Todas las sesiones se caen, que es lo que queremos de todas formas.
- **No se pierde nada más**: cuentas, colección, cartas, rachas y perfiles
  viajan intactos en el dump. Lo único que cambia es la credencial.

Por eso Brevo tiene que estar andando y con el dominio autenticado **antes** del
cambio de DNS: el reset es el único camino de vuelta. Y con 300 envíos diarios
en el plan gratuito, si hay más de 300 cuentas hay que escalonar la ola o pasar
unos días al plan pago.

Nunca rotar esos dos peppers después del corte sin pasarlos a
`fallbackSecretHashPeppers`, que existe justo para eso.

## Imágenes

`tools/optimizar_ilustraciones.sh <carpeta>` convierte a WebP con
transparencia, limita el lado mayor a 1200 px (alcanza para la tarjeta
compartible de 1080 × 1350) y saca los metadatos. En la colección actual: 109 MB
a 10 MB, un 91% menos, ~110 KB promedio. Variables: `MAX_LADO`, `CALIDAD`,
`MINIATURA=1`.

Las optimizadas se suben desde el panel admin, una por santo. El límite sigue
siendo 6 MB por imagen (`AdminSaintEndpoint.maxIllustrationBytes`), muy por
encima de lo que pesan ahora.

Cada ilustración se guarda con `Cache-Control: public, max-age=31536000,
immutable`, y su URL pública lleva `?v=<updatedAt>` (`SaintMapper`). O sea: el
cliente la cachea un año y, cuando el admin reemplaza la imagen, cambia
`updatedAt`, cambia la URL y se baja la nueva sin purgar nada. En móvil el
cacheo lo hace `cached_network_image` en disco; en web, el browser.

## Operación

```bash
# estado y logs
docker compose ps
docker compose logs -f server

# backup manual
/usr/local/bin/santos-nhf-backup

# restaurar un backup
gunzip -c backups/saints_nhf-<fecha>.sql.gz \
  | docker compose exec -T postgres psql -U serverpod -d saints_nhf

# consola SQL
docker compose exec postgres psql -U serverpod -d saints_nhf
```

**Rollback**: Actions → Deploy → Run workflow desde el commit anterior. Cada
imagen queda taggeada con su SHA, así que volver atrás es volver a desplegar.
Ojo con las migraciones: el rollback del código no revierte el esquema, así que
un deploy que agregó una migración destructiva no se deshace solo.

**Actualizar Postgres**: la versión está pineada en el compose. Hoy es 16 porque
es lo que publica Serverpod (`ghcr.io/serverpod/postgres:16`, los únicos tags
son `16` y `pg16`) y también la versión del Postgres embebido que usan
desarrollo y los tests. Subir producción sola dejaría prod como el único entorno
distinto. Si se sube igual, es cambiar el tag, dump, restore con el cliente de
la versión nueva, y correr la suite de integración antes.

## Pendientes

Hecho: servidor creado y provisionado (Docker, swap, rotación de logs, backup
diario), compose y Caddyfile instalados en `/srv/santos-nhf/`, imágenes de
postgres y caddy pre-bajadas, `.env` creado con `POSTGRES_PASSWORD`,
`SERVICE_SECRET` y los dos peppers generados en el servidor, y las dos claves
SSH instaladas.

- [ ] Completar en `/srv/santos-nhf/.env`: `ADMIN_EMAILS`, `SMTP_USERNAME`,
      `SMTP_PASSWORD` y `ACME_EMAIL`. Los cuatro son datos que no pasan por el
      chat.
- [ ] Dominio pago y delegado, con los A/AAAA apuntando al servidor. Hasta que
      resuelva, **no** levantar el stack: Caddy falla el desafío de Let's
      Encrypt y entra en backoff.
- [ ] Dominio autenticado en Brevo (TXT, DKIM, SPF, DMARC) y prueba a Gmail y
      Outlook.
- [ ] Secretos de GitHub: `DEPLOY_HOST`, `DEPLOY_PORT`, `DEPLOY_USER` y
      `DEPLOY_SSH_KEY` (la privada de `~/.ssh/santos_nhf_ci_ed25519`).
- [ ] Primer deploy y migración de los datos desde Serverpod Cloud.
- [ ] Subir las 93 ilustraciones optimizadas.
- [ ] Avisar a los usuarios existentes que tienen que resetear la contraseña.
- [ ] Apagar el proyecto de Serverpod Cloud, recién con todo verificado.
