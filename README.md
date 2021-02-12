# Scraping para analizar una red social en Telegram
Web Scraping en la página de estadísticas de Telegram [tgstat](https://tgstat.com/), para obtener los canales que reenvían mensajes de un canal y los canales de los que reenvía el canal objetivo.

## Ejemplo

- Si tomamos el canal de Telegram de Xataka la URL sería la siguiente:
https://tgstat.com/channel/@xataka

- El nombre a introducir en el código sería el nombre del canal que viene después de la @ y que es el mismo que aparece en Telegram en la descripción del canal de la siguiente manera:
https://t.me/xataka

- Una vez introducido el canal, el código descarga, por un lado, los nombres de los canales que han reenviado mensajes de Xataka en su canal. Por otro lado, descarga los canales de los que Xataka ha reenviado mensajes en su canal.

- Tras esto, se guardan todos los datos en un csv que se puede introducir directamente en [Gephi](https://gephi.org/) para su análisis.

## Consideraciones

- El código está pensado para poder descargar la información de varios canales a la vez mediante un bucle, por lo que se podrían introducir infinitos canales.

- El límite de canales que aparecen en la web es de 50, por lo que si son canales muy prolíficos en reenvío de mensajes faltaran muchos canales
