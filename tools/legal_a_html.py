#!/usr/bin/env python3
"""Genera las páginas legales del sitio a partir de docs/legal/*.md.

    python3 tools/legal_a_html.py

Los Markdown son la fuente: se editan ahí y se vuelve a correr esto. Las
páginas quedan en saints_nhf_server/web/pages/ y el servidor las sirve en
/privacidad, /terminos y /acerca (ver lib/server.dart). /acerca es la página
principal que figura en la pantalla de consentimiento de Google: tiene que
verse sin JavaScript, cosa que la app de Flutter no puede.

Entiende solo lo que usan esos documentos: títulos con # y ##, párrafos,
listas con guion (con sublistas de dos espacios), **negrita**, *cursiva* y
links [texto](url). No hace falta instalar nada.
"""

import html
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCES = {
    'politica-de-privacidad.md': 'privacidad.html',
    'terminos-y-condiciones.md': 'terminos.html',
    'acerca.md': 'acerca.html',
}

PAGE = """<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title}</title>
<link rel="icon" type="image/png" href="/favicon.png">
<style>
  :root {{ color-scheme: dark; }}
  body {{
    margin: 0; background: #0C0B16; color: #F2E7CF;
    font: 16px/1.65 "Nunito Sans", system-ui, -apple-system, "Segoe UI", sans-serif;
  }}
  main {{ max-width: 720px; margin: 0 auto; padding: 32px 20px 64px; }}
  h1 {{ color: #D9B25F; font-size: 1.7rem; line-height: 1.25; margin: 0 0 8px; }}
  h2 {{ color: #D9B25F; font-size: 1.15rem; margin: 2em 0 0.5em; }}
  p, li {{ color: #F2E7CF; }}
  em {{ color: #B9AE95; }}
  strong {{ color: #F1D89A; font-weight: 700; }}
  a {{ color: #F1D89A; }}
  ul {{ padding-left: 1.25em; }}
  li {{ margin: 0.25em 0; }}
  .back {{ display: inline-block; margin-bottom: 24px; color: #B9AE95; text-decoration: none; }}
  footer {{ margin-top: 48px; color: #B9AE95; font-size: 0.9rem; }}
</style>
</head>
<body>
<main>
<a class="back" href="/">← Volver a Santos NHF</a>
{body}
<footer>Santos NHF · <a href="/acerca">Acerca</a> · <a href="/privacidad">Privacidad</a> · <a href="/terminos">Términos</a></footer>
</main>
</body>
</html>
"""


def inline(text):
    text = html.escape(text, quote=False)
    text = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', text)
    text = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', text)
    text = re.sub(r'\*([^*]+)\*', r'<em>\1</em>', text)
    return text


def convert(markdown):
    out = []
    title = 'Santos NHF'
    paragraph = []
    # Stack of open lists by indent; each item collects its continuation lines.
    lists = []

    def flush_paragraph():
        if paragraph:
            out.append('<p>' + inline(' '.join(paragraph)) + '</p>')
            paragraph.clear()

    def close_lists(to_indent=-1):
        while lists and lists[-1] > to_indent:
            out.append('</li></ul>')
            lists.pop()

    for raw in markdown.splitlines():
        line = raw.rstrip()
        if not line.strip():
            flush_paragraph()
            continue
        item = re.match(r'^( *)- (.*)$', line)
        if line.startswith('# '):
            flush_paragraph(); close_lists()
            title = line[2:].strip()
            out.append('<h1>' + inline(title) + '</h1>')
        elif line.startswith('## '):
            flush_paragraph(); close_lists()
            out.append('<h2>' + inline(line[3:].strip()) + '</h2>')
        elif item:
            flush_paragraph()
            indent = len(item.group(1))
            if lists and lists[-1] == indent:
                out.append('</li><li>' + inline(item.group(2)))
            elif lists and lists[-1] > indent:
                close_lists(indent)
                out.append('</li><li>' + inline(item.group(2)))
            else:
                out.append('<ul><li>' + inline(item.group(2)))
                lists.append(indent)
        elif lists and raw.startswith(' '):
            # Continuation of the current list item.
            out[-1] += ' ' + inline(line.strip())
        else:
            close_lists()
            paragraph.append(line.strip())
    flush_paragraph(); close_lists()
    return title, '\n'.join(out)


def main():
    for source, target in SOURCES.items():
        markdown = (ROOT / 'docs' / 'legal' / source).read_text(encoding='utf-8')
        title, body = convert(markdown)
        page = PAGE.format(title=html.escape(title), body=body)
        path = ROOT / 'saints_nhf_server' / 'web' / 'pages' / target
        path.write_text(page, encoding='utf-8')
        print(f'{source} -> {path.relative_to(ROOT)}')


if __name__ == '__main__':
    main()
