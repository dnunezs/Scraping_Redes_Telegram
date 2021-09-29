#############################################################################################################################################
# Librerias y datos
#############################################################################################################################################
# Limpiar el espacio de trabajo
rm(list=ls())

# importar librerias
library(xml2)
library(rvest)
library(dplyr)
library(readr)
library(beepr)

# Ruta de la carpeta del proyecto
setwd("XXXXXXXXX")

###########################################################################
# Descarga de datos del Drive compartido                              #####
###########################################################################

# Carga del archivo: lista con los canales de telegram
lista_canales <- read_csv("canales_telegram.csv")

###########################################################################
# EXTRACCIÓN DE MENSAJES REENVIADOS EN BUCLE                           ####
###########################################################################

# Creamos/vaciamos un data frame vacio donde iremos añadiendo los datos que descarguemos
lista_actualizada <- data.frame()

# Canales que no están en la web, no resgistrados o eliminados
canales_fallo <-  c()

# Ponemos la url generica de la web
urltgstat_generica <- "https://tgstat.com/channel/@"

# Hacemos un bucle para descargar la información de todos los canales
for (i in 1:nrow(lista_canales)){
  # Segunda parte de la URL que se refiere al canal concreto
  Canal <- as.character(lista_canales[i,1])
  
  perct <- round(i / nrow(lista_canales)*100, 2)
  print(paste0(perct, "%. ","Canal: ", Canal, ". Nº: ", i, " de ", nrow(lista_canales), "." ))
  
  # Se unen las dos partes de la URL
  url_canal <- paste(urltgstat_generica, Canal, sep = "")
  
  fallo <- 0
  
  # cargamos la URL capturando los errores
  fallo <- tryCatch(
    {
      Telegram <- read_html(url_canal)
    },
    error=function(cond) {
      message(paste(Canal, "no está en la web."))
      return(1)
      
    }

  )
  
  # si no ha encontrado el canal lo guarda en otra lista y pasa al siguiente
  if (as.character(fallo) == 1){
    x <- length(canales_fallo) + 1
    canales_fallo[x] <- Canal
    next
  } 
  
  # Descargamos los datos de los enlaces en la web que hacen referencia a los canales 
  Tlgm_links <- Telegram %>% 
    html_nodes('.forwards-list')
  
  #  tgstat solo muestra los últimos 50 mensajes reenviados
  n = 50
  
  # Seleccionamos los links de los canales mencionados por el canal principal
  Mencion_del_canal <- vector()
  for (i in 1:n){
    try(Mencion_del_canal[i] <- xml_attrs(xml_child(xml_child(xml_child(xml_child(Tlgm_links[[2]], i), 1), 1), 1))[["href"]]
        , silent = TRUE)
  }
  
  # Seleccionamos los links de lo canales que han mencionado al canal principal
  Canal_mencionado <- vector()
  for (i in 1:n){
    try(Canal_mencionado[i] <- xml_attrs(xml_child(xml_child(xml_child(xml_child(Tlgm_links[[1]], i), 1), 1), 1))[["href"]]
        , silent = TRUE)
  }
  
  # Creamos un data frame con los canales mencionados por el canal principal
  if (length(Mencion_del_canal) != 0){
    df_Menciones <- data.frame(
      "Source" = Canal
      ,"Target" = Mencion_del_canal
    )
    # Eliminamos la parte del enlace para quedarnos solo con el nombre del canal
    df_Menciones$Target <-  gsub("https://tgstat.com/channel/", "", df_Menciones$Target)
    df_Menciones$Target <-  gsub("@", "", df_Menciones$Target)
    lista_actualizada = rbind(lista_actualizada, df_Menciones)
    
  }
  
  # Creamos un data frame con los canales que han mencionado al canal principal
  if (length(Canal_mencionado) != 0){
    df_Mencionado <- data.frame(
      "Source" = Canal_mencionado
      ,"Target" = Canal
    )
    
    df_Mencionado$Source <-  gsub("https://tgstat.com/channel/", "", df_Mencionado$Source)
    df_Mencionado$Source <-  gsub("@", "", df_Mencionado$Source)
    lista_actualizada = rbind(lista_actualizada, df_Mencionado)
  }
  
  
  Sys.sleep(10)
  
}
# Ejecutar junto con el bucle, ya que emite un sonido que nos avisará cuando acabe o se pare el bucle
beep(sound = 1)

# Limpieza posterior de algunos canales que tienen url estatales
lista_actualizada$Source <-  gsub("https://tgstat.ru/en/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://tgstat.ru/en/channel/", "", lista_actualizada$Target)

lista_actualizada$Source <-  gsub("https://ir.tgstat.com/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://ir.tgstat.com/channel/", "", lista_actualizada$Target)

lista_actualizada$Source <-  gsub("https://uz.tgstat.com/en/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://uz.tgstat.com/en/channel/", "", lista_actualizada$Target)

lista_actualizada$Source <-  gsub("https://uk.tgstat.com/en/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://uk.tgstat.com/en/channel/", "", lista_actualizada$Target)

lista_actualizada$Source <-  gsub("https://by.tgstat.com/en/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://by.tgstat.com/en/channel/", "", lista_actualizada$Target)

lista_actualizada$Source <-  gsub("https://cn.tgstat.com/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://cn.tgstat.com/channel/", "", lista_actualizada$Target)

lista_actualizada$Source <-  gsub("https://et.tgstat.com/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://et.tgstat.com/channel/", "", lista_actualizada$Target)

lista_actualizada$Source <-  gsub("https://in.tgstat.com/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://in.tgstat.com/channel/", "", lista_actualizada$Target)

lista_actualizada$Source <-  gsub("https://kg.tgstat.com/en/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://kg.tgstat.com/en/channel/", "", lista_actualizada$Target)

lista_actualizada$Source <-  gsub("https://kaz.tgstat.com/en/channel/", "", lista_actualizada$Source)
lista_actualizada$Target <-  gsub("https://kaz.tgstat.com/en/channel/", "", lista_actualizada$Target)

###########################################################################
# Se crea una lista para hacer otra bola de nieve                      ####
###########################################################################

# Guardamos la base en CSV lista para cargar en Gephi
write.csv(lista_actualizada, file = "Dataset_Gephi_Telegram_2.csv", row.names = FALSE)

# Creamos una nueva lista para hacer ejecutar otra vez el bucle y obtener más canales conectados
lista_canales <- c(lista_actualizada$Source, lista_actualizada$Target)
lista_canales <- unique(lista_canales)
lista_canales

# Guardamos la nueva lista de canales 
write.csv(lista_canales, file = "lista_canales_2.csv", row.names = FALSE)

# Guardamos la lista de canales que no están en la web
write.csv(canales_fallo, file = "lista_canales_fallo_2.csv", row.names = FALSE)


