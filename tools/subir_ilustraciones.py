#!/usr/bin/env python3
"""Genera el SQL que sube las ilustraciones al storage de la base.

  python3 tools/subir_ilustraciones.py <carpeta> <asignacion.csv> >ilustraciones.sql

Escribe exactamente lo mismo que el endpoint `adminSaint.uploadIllustration`:
el archivo va a `serverpod_cloud_storage` con el `path` determinístico
`saints/<id>/illustration.<ext>`, su `contentType` y el `Cache-Control` de un año
inmutable, y el santo queda apuntando ahí con el `updatedAt` actualizado, que es
lo que cambia el `?v=` de la URL pública y hace que el cliente baje la imagen
nueva en lugar de la cacheada.

El SQL es idempotente: `on conflict` reemplaza los bytes si el path ya existe,
así que se puede volver a correr para reemplazar imágenes.

Aplicar con una sola transacción, para que un error no deje la mitad puesta:
  psql -v ON_ERROR_STOP=1 --single-transaction -f ilustraciones.sql
"""

import base64
import csv
import sys
from pathlib import Path

CACHE_CONTROL = 'public, max-age=31536000, immutable'
TIPOS = {'.webp': 'image/webp', '.png': 'image/png',
         '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg'}
MAXIMO = 6 * 1024 * 1024  # AdminSaintEndpoint.maxIllustrationBytes


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        return 1
    carpeta, csv_path = Path(sys.argv[1]), Path(sys.argv[2])

    filas = list(csv.DictReader(csv_path.open(encoding='utf-8')))
    puestos, total_bytes = 0, 0
    salida = ['-- Generado por tools/subir_ilustraciones.py', 'begin;']

    for fila in filas:
        nombre_archivo = (fila.get('archivo') or '').strip()
        if not nombre_archivo:
            continue
        origen = carpeta / nombre_archivo
        if not origen.is_file():
            print(f'FALTA el archivo "{nombre_archivo}" '
                  f'(santo {fila["id"]} {fila["santo"]})', file=sys.stderr)
            return 1
        ext = origen.suffix.lower()
        if ext not in TIPOS:
            print(f'extensión no permitida: {origen.name}', file=sys.stderr)
            return 1
        datos = origen.read_bytes()
        if not datos:
            print(f'archivo vacío: {origen.name}', file=sys.stderr)
            return 1
        if len(datos) > MAXIMO:
            print(f'{origen.name} supera los 6 MB del endpoint', file=sys.stderr)
            return 1

        saint_id = int(fila['id'])
        path = f'saints/{saint_id}/illustration{ext}'
        b64 = base64.b64encode(datos).decode()
        total_bytes += len(datos)
        puestos += 1

        salida.append(f'-- {saint_id} {fila["santo"]} <- {origen.name} '
                      f'({len(datos) // 1024} KB)')
        salida.append(
            'insert into serverpod_cloud_storage '
            '("storageId", path, "addedTime", "byteData", verified, '
            '"contentType", "cacheControl") values '
            f"('public', '{path}', now(), decode('{b64}', 'base64'), true, "
            f"'{TIPOS[ext]}', '{CACHE_CONTROL}') "
            'on conflict ("storageId", path) do update set '
            '"byteData" = excluded."byteData", '
            '"addedTime" = excluded."addedTime", '
            '"contentType" = excluded."contentType", '
            '"cacheControl" = excluded."cacheControl", '
            'verified = true;'
        )
        salida.append(
            f'update saint set "illustrationPath" = \'{path}\', '
            f'"updatedAt" = now() where id = {saint_id};'
        )

    salida.append('commit;')
    print('\n'.join(salida))
    print(f'-- {puestos} ilustraciones, {total_bytes // 1024} KB de imágenes',
          file=sys.stderr)
    print(f'{puestos} ilustraciones listas para subir '
          f'({total_bytes // 1024} KB)', file=sys.stderr)
    return 0


if __name__ == '__main__':
    sys.exit(main())
