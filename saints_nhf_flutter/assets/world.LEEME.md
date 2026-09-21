# world.json

Contornos de las costas y las fronteras nacionales del mundo, para el mapa de
la pestaña Santos. Se dibuja con un `CustomPainter`: la app no usa ningún
servicio de mapas, así que el mapa funciona sin conexión y no depende de
ninguna cuota ni clave.

**Origen**: Natural Earth, `ne_50m_admin_0_countries`, que está en dominio
público ("No permission is needed to use Natural Earth. Crediting the authors
is unnecessary"). https://www.naturalearthdata.com

**Cómo se generó**: de cada país se tomaron los anillos exteriores, se
simplificaron con Ramer-Douglas-Peucker (tolerancia 0,10°) y se redondearon a
tres decimales. Quedan 993 contornos y unos 18.400 puntos, 263 KB. Se eligió
la escala 1:50m y no la de 1:110m porque con el zoom del mapa la más gruesa
dibujaba Italia y España como polígonos de diez lados.

**Formato**: una lista de contornos; cada contorno es una lista plana de
`[lng, lat, lng, lat, ...]`. Es más liviano de parsear que el GeoJSON anidado
y es todo lo que el pintor necesita.
