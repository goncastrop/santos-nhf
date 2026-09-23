#!/usr/bin/env python3
"""Propone qué archivo de ilustración va con cada santo, para revisar a mano.

  python3 tools/emparejar_ilustraciones.py <carpeta_de_webp> <santos.txt> [salida.csv]

`santos.txt` son las filas `id|nombre|slug|illustrationPath|status` que devuelve
la base.

Criterio deliberadamente conservador: solo se propone un archivo cuando la
coincidencia es exacta, o cuando todas las palabras distintivas de uno están en
el otro y no hay ningún otro candidato. Todo lo demás queda con la columna
`archivo` vacía y sus candidatos al lado, porque ponerle la cara equivocada a un
santo es peor que dejarlo sin imagen.

La salida es un CSV con una fila por santo. Se edita la columna `archivo` y se
usa para subir.
"""

import csv
import difflib
import re
import sys
import unicodedata
from pathlib import Path

TRATAMIENTOS = re.compile(
    r'^(san|santa|santo|beato|beata|papa|sto|sta)\s+', re.IGNORECASE
)
VACIAS = {'de', 'del', 'la', 'el', 'los', 'las', 'y', 'da', 'al'}


def normalizar(texto: str) -> str:
    t = unicodedata.normalize('NFKD', texto)
    t = ''.join(c for c in t if not unicodedata.combining(c))
    t = t.lower()
    t = re.sub(r'\.(png|jpe?g|webp)$', '', t)
    t = re.sub(r'\(\d+\)', ' ', t)
    t = re.sub(r'[^a-z0-9 ]+', ' ', t)
    t = re.sub(r'\s+', ' ', t).strip()
    while True:
        nuevo = TRATAMIENTOS.sub('', t).strip()
        if nuevo == t:
            break
        t = nuevo
    return t


def clave(texto: str) -> set[str]:
    return {p for p in normalizar(texto).split() if p not in VACIAS}


def parecido(a: str, b: str) -> float:
    return difflib.SequenceMatcher(None, normalizar(a), normalizar(b)).ratio()


def main() -> int:
    if len(sys.argv) not in (3, 4):
        print(__doc__, file=sys.stderr)
        return 1
    carpeta = Path(sys.argv[1])
    lista = Path(sys.argv[2])
    salida = Path(sys.argv[3]) if len(sys.argv) == 4 else carpeta.parent / 'asignacion.csv'

    santos = []
    for linea in lista.read_text().splitlines():
        partes = linea.split('|')
        if len(partes) < 5:
            continue
        santos.append({
            'id': int(partes[0]),
            'nombre': partes[1],
            'status': partes[4],
            'archivo': '',
            'confianza': '',
            'candidatos': [],
        })

    archivos = sorted(
        p.name for p in carpeta.iterdir()
        if p.suffix.lower() in {'.webp', '.png', '.jpg', '.jpeg'}
        and not p.name.startswith('.')
    )
    usados: set[str] = set()

    # 1) Coincidencia exacta del nombre normalizado.
    for archivo in archivos:
        iguales = [s for s in santos if normalizar(s['nombre']) == normalizar(archivo)]
        if len(iguales) == 1 and not iguales[0]['archivo']:
            iguales[0]['archivo'] = archivo
            iguales[0]['confianza'] = 'exacta'
            usados.add(archivo)

    # 2) Un nombre contiene todas las palabras distintivas del otro, y es el
    #    único santo libre que cumple.
    for archivo in archivos:
        if archivo in usados:
            continue
        ka = clave(archivo)
        if not ka:
            continue
        cumplen = [
            s for s in santos
            if not s['archivo'] and (ka <= clave(s['nombre']) or clave(s['nombre']) <= ka)
        ]
        if len(cumplen) == 1:
            cumplen[0]['archivo'] = archivo
            cumplen[0]['confianza'] = 'por palabras'
            usados.add(archivo)

    # 3) El resto no se asigna: se ofrecen candidatos ordenados por parecido.
    sobrantes = [a for a in archivos if a not in usados]
    for s in santos:
        puntuados = sorted(
            ((parecido(a, s['nombre']), a) for a in sobrantes), reverse=True
        )
        s['candidatos'] = [a for p, a in puntuados[:3] if p >= 0.45]

    with salida.open('w', newline='', encoding='utf-8') as fh:
        w = csv.writer(fh)
        w.writerow(['id', 'santo', 'estado', 'archivo', 'confianza', 'candidatos'])
        for s in santos:
            w.writerow([
                s['id'], s['nombre'], s['status'], s['archivo'], s['confianza'],
                ' | '.join(s['candidatos']) if not s['archivo'] else '',
            ])

    asignados = [s for s in santos if s['archivo']]
    pendientes = [s for s in santos if not s['archivo']]

    print(f'CSV: {salida}')
    print(f'  {len(asignados)} santos con archivo propuesto '
          f'({sum(1 for s in asignados if s["confianza"] == "exacta")} exactos, '
          f'{sum(1 for s in asignados if s["confianza"] == "por palabras")} por palabras)')
    print(f'  {len(pendientes)} santos a completar a mano')
    print(f'  {len(sobrantes)} archivos sin asignar, de {len(archivos)}')
    print()
    print('A completar a mano:')
    for s in pendientes:
        cand = ' | '.join(s['candidatos']) or '(ningún candidato)'
        print(f'  {s["id"]:>3}  {s["nombre"]:<34} {cand}')
    print()
    print('Archivos que quedaron sin santo (probablemente santos aún no cargados):')
    for a in sobrantes:
        print(f'  {a}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
