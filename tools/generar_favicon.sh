#!/usr/bin/env bash
# Genera el favicon y los iconos PWA de la app web a partir de la marca de
# Santos NHF: el arco de ventana de capilla que recorta las ilustraciones en las
# tarjetas (ArchClipper), en dorado sobre tinta, con parteluz.
#
#   ./tools/generar_favicon.sh
#
# Este script es la fuente de la marca: no hay SVG intermedio, porque el
# renderizador SVG interno de ImageMagick ignora los `stroke` y dibujaba mal el
# resultado. Las primitivas de dibujo son deterministas.
#
# Dos variantes a propósito, como en cualquier set de iconos serio:
#   - 32 px y más: la ventana completa, con parteluz, que se lee como ventana.
#   - 16 px: solo la silueta del arco. A ese tamaño el parteluz se empasta y
#     ensucia la figura; una silueta limpia se reconoce mejor que un detalle
#     ilegible.
set -euo pipefail

cd "$(dirname "$0")/.."
web=saints_nhf_flutter/web

tinta='#0C0B16'   # Palette.ink
dorado='#D9B25F'  # Palette.gold

if ! command -v magick >/dev/null 2>&1; then
  echo "falta ImageMagick: brew install imagemagick" >&2
  exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

arco="path 'M 136 440 L 136 232 A 120,120 0 0 1 376,232 L 376 440 Z'"
# Parteluz: un travesaño vertical y uno horizontal, en tinta sobre el dorado.
vertical="rectangle 248,150 264,440"
horizontal="rectangle 136,300 376,316"

# Marca completa, 512 px.
magick -size 512x512 "xc:$tinta" \
  -fill "$dorado" -draw "$arco" \
  -fill "$tinta" -draw "$vertical" -draw "$horizontal" \
  "$tmp/marca.png"

# Silueta sin parteluz, para los tamaños chicos.
magick -size 512x512 "xc:$tinta" -fill "$dorado" -draw "$arco" "$tmp/silueta.png"

escalar() { magick "$1" -filter Lanczos -resize "${2}x${2}" -strip "$3"; }

# Favicon PNG (el que usan los navegadores modernos) y sus tamaños chicos.
escalar "$tmp/marca.png" 32 "$web/favicon.png"
escalar "$tmp/marca.png" 48 "$tmp/f48.png"
escalar "$tmp/marca.png" 32 "$tmp/f32.png"
escalar "$tmp/silueta.png" 16 "$tmp/f16.png"

# .ico multitamaño para navegadores y buscadores que piden /favicon.ico.
magick "$tmp/f16.png" "$tmp/f32.png" "$tmp/f48.png" "$web/favicon.ico"

# Iconos PWA a sangre.
mkdir -p "$web/icons"
escalar "$tmp/marca.png" 192 "$web/icons/Icon-192.png"
escalar "$tmp/marca.png" 512 "$web/icons/Icon-512.png"

# Maskable: Android recorta hasta un 20% de cada borde, así que la marca va al
# 60% del lienzo y el resto es tinta.
for s in 192 512; do
  interior=$((s * 60 / 100))
  magick "$tmp/marca.png" -filter Lanczos -resize "${interior}x${interior}" \
    -background "$tinta" -gravity center -extent "${s}x${s}" -strip \
    "$web/icons/Icon-maskable-$s.png"
done

echo "generados en $web:"
ls -l "$web/favicon.png" "$web/favicon.ico" "$web/icons/" | awk '{print "  " $5, $9}'
