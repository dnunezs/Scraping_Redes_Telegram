# Scraping para analizar una red social en Telegram
Web Scraping en la página de estadísticas de Telegram [tgstat](https://tgstat.com/), para obtener los canales que reenvían mensajes de un canal y los canales de los que reenvía el canal objetivo.

## Ejemplo

- Si tomamos el canal de Telegram de Xataka la URL sería la siguiente:
https://tgstat.com/channel/@xataka

- El nombre a introducir en el código sería el nombre del canal que viene después de la @ y que es el mismo que aparece en Telegram en la descripción del canal de la siguiente manera:
https://t.me/xataka

- Una vez introducido el canal (xataka en este caso), el código descarga, por un lado, los nombres de los canales que han reenviado mensajes de Xataka en su canal. Por otro lado, descarga los canales de los que Xataka ha reenviado mensajes en su canal.

- Tras esto, se guardan todos los datos en un csv que se puede introducir directamente en [Gephi](https://gephi.org/) para su análisis.

## Consideraciones

- El código está pensado para poder descargar la información de varios canales a la vez mediante un bucle, por lo que se podrían introducir infinitos canales.

- El límite de canales que aparecen en la web en el apartado de reenvío de mensajes es de 50, por lo que si son canales muy prolíficos en reenvío de mensajes faltarán muchos canales.

- El código lo he usado para obtener un mapa de las relaciones entre canales de Telegram. Con él, he obtenido un dataset con más de 13.000 canales. Dado que tiene miles de canales negacionistas, Qanon, neonazis... he preferido no publicarlo para no darles ningún tipo de difusión. Si algún investigador está interesado en el dataset para no partir de cero estaré encantado de compartirlo (siempre que sea con fines de investigación).

- El análisis del dataset lo podéis encontrar en mi cuenta de [Twitter](https://twitter.com/_Daniel_Nunez/status/1360205515268251655)
