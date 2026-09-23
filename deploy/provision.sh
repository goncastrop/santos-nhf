#!/usr/bin/env bash
# Prepara un Cloud Server de DonWeb recién creado (Ubuntu 24.04, instalación
# mínima) para correr el stack de `docker-compose.yml`. Es idempotente: se puede
# volver a correr sin romper nada.
#
#   scp -P <puerto> deploy/provision.sh root@<ip>:/root/
#   ssh -p <puerto> root@<ip> 'bash /root/provision.sh'
#
# Ojo: en DonWeb el SSH no escucha en el 22, el puerto sale en el panel.
#
# Variables:
#   FIREWALL=1   configura ufw además del firewall del panel de DonWeb.
#   SSH_PORT     obligatorio si FIREWALL=1. Sin esto te quedás afuera.
set -euo pipefail

app_dir=/srv/santos-nhf
backup_dir=$app_dir/backups
retencion_dias=14

if [[ $EUID -ne 0 ]]; then
  echo "correr como root" >&2
  exit 1
fi

echo "==> Paquetes base"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq ca-certificates curl gnupg rsync

if ! command -v docker >/dev/null 2>&1; then
  echo "==> Docker"
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    >/etc/apt/sources.list.d/docker.list
  apt-get update -qq
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin
else
  echo "==> Docker ya instalado: $(docker --version)"
fi

# Sin esto los logs de los contenedores crecen sin límite hasta llenar el disco.
if [[ ! -f /etc/docker/daemon.json ]]; then
  echo "==> Rotación de logs de Docker"
  mkdir -p /etc/docker
  cat >/etc/docker/daemon.json <<'JSON'
{
  "log-driver": "json-file",
  "log-opts": { "max-size": "10m", "max-file": "3" }
}
JSON
  systemctl restart docker
fi

echo "==> Directorios"
mkdir -p "$app_dir" "$backup_dir"
chmod 700 "$app_dir" "$backup_dir"

# Las imágenes de Ubuntu del cloud vienen sin swap. Con 2 GB de RAM el stack
# entra con aire, pero un pico sin swap termina en el OOM killer matando
# Postgres sin aviso; con swap termina en unos segundos lentos.
if [[ -z "$(swapon --show --noheadings)" ]]; then
  echo "==> Swapfile de 2 GB"
  fallocate -l 2G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=2048
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  grep -q '^/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >>/etc/fstab
  # Usar swap solo cuando haga falta de verdad, no para ganar page cache.
  echo 'vm.swappiness=10' >/etc/sysctl.d/99-swappiness.conf
  sysctl -q -p /etc/sysctl.d/99-swappiness.conf
else
  echo "==> Swap ya activo"
fi

echo "==> Backup diario de la base"
cat >/usr/local/bin/santos-nhf-backup <<BASH
#!/usr/bin/env bash
# Dump diario de la base. Los snapshots de DonWeb no son backup: se borran a
# los 28 días y son del servidor entero, no de la base.
set -euo pipefail
cd $app_dir
archivo=$backup_dir/saints_nhf-\$(date +%Y%m%d-%H%M).sql.gz
docker compose exec -T postgres \\
  pg_dump -U serverpod -d saints_nhf --format=plain | gzip >"\$archivo"
find $backup_dir -name 'saints_nhf-*.sql.gz' -mtime +$retencion_dias -delete
BASH
chmod 700 /usr/local/bin/santos-nhf-backup

# 03:20 hora del servidor. Ajustar el timezone si hace falta:
# timedatectl set-timezone America/Argentina/Buenos_Aires
cat >/etc/cron.d/santos-nhf-backup <<'CRON'
20 3 * * * root /usr/local/bin/santos-nhf-backup
CRON
chmod 644 /etc/cron.d/santos-nhf-backup

if [[ "${FIREWALL:-0}" == "1" ]]; then
  if [[ -z "${SSH_PORT:-}" ]]; then
    echo "FIREWALL=1 necesita SSH_PORT o te quedás sin acceso" >&2
    exit 1
  fi
  echo "==> ufw (ssh en $SSH_PORT, http, https)"
  apt-get install -y -qq ufw
  ufw allow "$SSH_PORT/tcp"
  ufw allow 80/tcp
  ufw allow 443/tcp
  ufw --force enable
else
  echo "==> ufw omitido (FIREWALL=1 para activarlo). El firewall del panel de"
  echo "    DonWeb ya filtra aguas arriba: dejá abiertos solo SSH, 80 y 443."
fi

echo
echo "Listo. Falta:"
echo "  1. copiar deploy/docker-compose.yml y deploy/Caddyfile a $app_dir"
echo "  2. crear $app_dir/.env a partir de deploy/env.example (chmod 600)"
echo "  3. apuntar santos.nhf.com.ar y api.santos.nhf.com.ar a esta IP"
echo "  4. docker login ghcr.io && docker compose -f $app_dir/docker-compose.yml up -d"
