#!/usr/bin/env bash
# Optimiza las ilustraciones de los santos para la web.
#
#   ./tools/optimizar_ilustraciones.sh <carpeta_origen> [carpeta_destino]
#
# Convierte cada PNG/JPG a WebP con transparencia, limitando el lado mayor a
# MAX_LADO px (alcanza para la tarjeta compartible de 1080 x 1350) y sacando
# todos los metadatos. El nombre del archivo se conserva, solo cambia la
# extensión, así que el destino sirve tal cual para subir desde el panel admin.
#
# Variables de entorno:
#   MAX_LADO   lado mayor en píxeles (default 1200)
#   CALIDAD    calidad WebP 0-100 (default 82)
#   MINIATURA  si vale 1, además genera <nombre>@400.webp para las listas
set -euo pipefail

origen=${1:-}
destino=${2:-}
max_lado=${MAX_LADO:-1200}
calidad=${CALIDAD:-82}
miniatura=${MINIATURA:-0}

if [[ -z "$origen" || ! -d "$origen" ]]; then
  echo "uso: $0 <carpeta_origen> [carpeta_destino]" >&2
  exit 1
fi
destino=${destino:-"$origen/optimizadas"}

if ! command -v magick >/dev/null 2>&1; then
  echo "falta ImageMagick: brew install imagemagick" >&2
  exit 1
fi

mkdir -p "$destino"
total_antes=0
total_despues=0
convertidos=0

while IFS= read -r -d '' archivo; do
  nombre=$(basename "$archivo")
  base=${nombre%.*}
  salida="$destino/$base.webp"

  magick "$archivo" \
    -resize "${max_lado}x${max_lado}>" \
    -strip \
    -define webp:method=6 \
    -quality "$calidad" \
    "$salida"

  if [[ "$miniatura" == "1" ]]; then
    magick "$salida" -resize '400x400>' -define webp:method=6 \
      -quality "$calidad" "$destino/$base@400.webp"
  fi

  antes=$(stat -f%z "$archivo")
  despues=$(stat -f%z "$salida")
  total_antes=$((total_antes + antes))
  total_despues=$((total_despues + despues))
  convertidos=$((convertidos + 1))
  printf '%-52s %7s KB -> %6s KB\n' "$base" "$((antes / 1024))" "$((despues / 1024))"
done < <(find "$origen" -maxdepth 1 -type f \
  \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
  -print0 | sort -z)

if (( convertidos == 0 )); then
  echo "no se encontraron imágenes en $origen" >&2
  exit 1
fi

echo
echo "$convertidos imágenes -> $destino"
echo "antes:   $((total_antes / 1024 / 1024)) MB"
echo "después: $((total_despues / 1024 / 1024)) MB"
echo "ahorro:  $((100 - total_despues * 100 / total_antes))%"
