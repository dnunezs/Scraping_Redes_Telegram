# Librerias ####
library(xml2)
library(rvest)
library(dplyr)

###########################################################################
# EXTRACCIÓN DE MENSAJES REENVIADOS EN BUCLE                           ####
###########################################################################

# Hay que asegurarse de que los canales aparecen en la web tgstat.com sino hay que registrarlos
# paro poder descargar la información

# Creamos un data frame vacio donde iremos añadiendo los datos que descarguemos
DF_conjunto <- data.frame()

# Anadimos la lista de los canales a descargar
lista_canales <- c(  "Canal_1", "Canal_2", "Canal_3", "Canal_n")

# Ponemos la url generica de la web
urltgstat_generica <- "https://tgstat.com/channel/@"

# Hacemos un bucle para descarga la información de todos los canales
for (i in 1:length(lista_canales)){
  # Segunda parte de la URL que se refiere al canal concreto
  Canal <- lista_canales[i]
  
  # Se unen las dos partes de la URL
  url_canal <- paste(urltgstat_generica, Canal, sep = "")
  
  # cargamos la URL
  Telegram <- read_html(url_canal)
  
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
    DF_conjunto = rbind(DF_conjunto, df_Menciones)
    
  }
  
  # Creamos un data frame con los canales que han mencionado al canal principal
  if (length(Canal_mencionado) != 0){
    df_Mencionado <- data.frame(
      "Source" = Canal_mencionado
      ,"Target" = Canal
    )
    
    df_Mencionado$Source <-  gsub("https://tgstat.com/channel/", "", df_Mencionado$Source)
    df_Mencionado$Source <-  gsub("@", "", df_Mencionado$Source)
    DF_conjunto = rbind(DF_conjunto, df_Mencionado)
  }
  Sys.sleep(10)
}

# Limpieza posterior de algunos canales que tienen url estatales

DF_conjunto$Source <-  gsub("https://tgstat.ru/en/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://tgstat.ru/en/channel/", "", DF_conjunto$Target)

DF_conjunto$Source <-  gsub("https://ir.tgstat.com/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://ir.tgstat.com/channel/", "", DF_conjunto$Target)

DF_conjunto$Source <-  gsub("https://uz.tgstat.com/en/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://uz.tgstat.com/en/channel/", "", DF_conjunto$Target)

DF_conjunto$Source <-  gsub("https://uk.tgstat.com/en/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://uk.tgstat.com/en/channel/", "", DF_conjunto$Target)

DF_conjunto$Source <-  gsub("https://by.tgstat.com/en/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://by.tgstat.com/en/channel/", "", DF_conjunto$Target)

DF_conjunto$Source <-  gsub("https://cn.tgstat.com/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://cn.tgstat.com/channel/", "", DF_conjunto$Target)

DF_conjunto$Source <-  gsub("https://et.tgstat.com/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://et.tgstat.com/channel/", "", DF_conjunto$Target)

DF_conjunto$Source <-  gsub("https://in.tgstat.com/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://in.tgstat.com/channel/", "", DF_conjunto$Target)

DF_conjunto$Source <-  gsub("https://kg.tgstat.com/en/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://kg.tgstat.com/en/channel/", "", DF_conjunto$Target)

DF_conjunto$Source <-  gsub("https://kaz.tgstat.com/en/channel/", "", DF_conjunto$Source)
DF_conjunto$Target <-  gsub("https://kaz.tgstat.com/en/channel/", "", DF_conjunto$Target)

# Guardamos la base en CSV lista para cargar en Gephi
write.csv(DF_conjunto, file = "Redes Telegram R.csv", row.names = FALSE)




