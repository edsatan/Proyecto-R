
# Proyecto R
Proyecto final del primer módulo de la fase dos del programa BEDU Disruptive Skills: Data Science

## Postwork 01


Comenzamos importando los datos de soccer de la temporada 2019/2020 de la primera división de la liga española que se puede encontrar en el enlace: https://www.football-data.co.uk/spainm.php

``` R
futbolData <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
```

Del dataframe ```futbolData``` extraemos las columnas de interés 

```R
homeGoals <- futbolData$FTHG  #Goles anotados por los equipos que jugaron en casa

awayGoals <- futbolData$FTAG  #Goles anotados por los equipos que jugaron como visitante
```

La función ``table`` utiliza los factores de clasificación cruzada para construir una tabla de contingencia de los conteos en cada combinación de factores. Por ejemplo

```R
table(homeGoals)

#homeGoals
# 0   1   2   3   4   5   6 
#88 132  99  38  14   8   1 
```

Este comando clasificó la cantidad de goles marcados por el equipo de casa y su frecuencia. Para calcular la probabilidad marginal solo se divide entre el total de partidos (casos). Se hace lo mismo con el equipo visitante.

``` R
table(homeGoals)/length(homeGoals) # Probabilidad marginal equipo de casa

table(awayGoals)/length(awayGoals) # Probabilidad marginal equipo visitante
```

Para el calculo de la probabilidad conjunta se llaman ambos vectores ```homeGoals``` y  ```awayGoald``` en el comando ```table```.

```R

table(homeGoals, awayGoals) # Tabla conjunta

#         awayGoals
#homeGoals  0  1  2  3  4  5
#        0 33 28 15  8  2  2
#        1 43 49 32  5  3  0
#        2 39 35 20  3  2  0
#        3 14 14  7  2  1  0
#        4  4  5  4  0  1  0
#        5  2  3  3  0  0  0
#        6  1  0  0  0  0  0

```
Dividimos entre la cantidad de casos para obtener la probabilidad conjunta

```R

table(homeGoals, awayGoals) / length(homeGoals) # Probabilidad conjunta

#         awayGoals
#homeGoals           0           1           2           3           4           5
#        0 0.086842105 0.073684211 0.039473684 0.021052632 0.005263158 0.005263158
#        1 0.113157895 0.128947368 0.084210526 0.013157895 0.007894737 0.000000000
#        2 0.102631579 0.092105263 0.052631579 0.007894737 0.005263158 0.000000000
#        3 0.036842105 0.036842105 0.018421053 0.005263158 0.002631579 0.000000000
#        4 0.010526316 0.013157895 0.010526316 0.000000000 0.002631579 0.000000000
#        5 0.005263158 0.007894737 0.007894737 0.000000000 0.000000000 0.000000000
#        6 0.002631579 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000

```

Por último, como comprobación podemos sumar todas las probabilidades y el resultado debería ser igual a 1

```R
m <- table(homeGoals, awayGoals)/length(homeGoals)
sum(m)
```

## Postwork 02
setwd("/home/jairock/Documents/beduDS/fase2/postwork/data")

##1. Descarga de los datos
le1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
le1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
le1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

##Con ayuda de la función `download.file` descargamos los archivos en el directorio previamente elegido
download.file(url = le1718, destfile = "le1718.csv", mode = "wb")
download.file(url = le1819, destfile = "le1819.csv", mode = "wb")
download.file(url = le1920, destfile = "le1920.csv", mode = "wb")

##Carga de datos
ligaEsp <- lapply(dir(), read.csv)

#2. Estructura de los dataframes
str(ligaEsp[[1]]); str(ligaEsp[[2]]); str(ligaEsp[[3]])

head(ligaEsp[[1]]); head(ligaEsp[[2]]); head(ligaEsp[[3]])

summary(ligaEsp[[1]]); summary(ligaEsp[[2]]); summary(ligaEsp[[3]])

View(ligaEsp[[1]]); View(ligaEsp[[2]]); View(ligaEsp[[3]])

#3. Selección de las columnas de interés (Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR)
library(dplyr)

ligaEsp <- lapply(ligaEsp, select, Date, HomeTeam:FTR)

#4. Fortmato de la fecha
str(ligaEsp)

##Estadarizamos el formato de fecha para los distintos DF
ligaEsp[[1]] <- mutate(ligaEsp[[1]], Date = as.Date(Date, "%d/%m/%y"))
ligaEsp[[2]] <- mutate(ligaEsp[[2]], Date = as.Date(Date, "%d/%m/%Y"))
ligaEsp[[3]] <- mutate(ligaEsp[[3]], Date = as.Date(Date, "%d/%m/%Y"))

str(ligaEsp)
View(ligaEsp[[1]]); View(ligaEsp[[2]]); View(ligaEsp[[3]])

#4.1 Unión de los dataframes
data <- do.call(rbind, ligaEsp)
dim(data)

View(data)
str(data)
head(data)
class(data)

## ------------------------------- PostWork3 -----------------------------------

##1. Con el último data frame obtenido en el postwork de la sesión 2,
#elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
homeGoals2 <- data$FTHG
awayGoals2 <- data$FTAG

##La probabilidad (marginal) de que el equipo que juega en casa 
##anote x goles (x = 0, 1, 2, ...)
probCasa <- table(homeGoals2)/length(homeGoals2)
names(probCasa)

##La probabilidad (marginal) de que el equipo que juega como 
##visitante anote y goles (y = 0, 1, 2, ...)
probVisitante <- table(awayGoals2)/length(awayGoals2)

# La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como
# visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)
probConjunta <- table(homeGoals2, awayGoals2)/length(homeGoals2)
probConjunta
##2. Realiza lo siguiente:

##Un gráfico de barras para las probabilidades marginales estimadas del número 
##de goles que anota el equipo de casa

probCasaPlot <- ggplot() + 
                geom_col(aes(x=0:8, y=probCasa), color="black", fill="blue")+
                ggtitle("Probabilidades Marginales FTHG") +
                ylab("Porcentaje") +
                xlab("Goles") + 
                theme_light()

probCasaPlot

##Un gráfico de barras para las probabilidades marginales estimadas del número 
##de goles que anota el equipo visitante.
probVisitantePlot <- ggplot() + 
                     geom_col(aes(x=0:6, y=probVisitante), color="black", fill="green")+
                     ggtitle("Probabilidades Marginales FTAG") +
                     ylab("Porcentaje") +
                     xlab("Goles") + 
                     theme_light()
probVisitantePlot

#Un HeatMap para las probabilidades conjuntas estimadas de los números de goles 
#que anotan el equipo de casa y el equipo visitante en un partido.
install.packages("reshape2")
library(reshape2)

probConjunta <- melt(probConjunta)

probConjuntaPlot <- ggplot()+
  geom_tile(aes(x=probConjunta$homeGoals2, y=probConjunta$awayGoals2, fill=probConjunta$value))+ 
  labs(x="Goles Local", y="Goles Visitante", fill="Porcentaje")+
  scale_x_continuous(breaks = unique(probConjunta[,1]))+ ##Determinamos los valores unicos para X
  scale_y_continuous(breaks = unique(probConjunta[,2]))+ ##Determinamos los valores unicos para y
  scale_fill_gradient2(high = "green", mid = "black")
probConjuntaPlot

## ------------------------------- PostWork4 -----------------------------------
##1. Obtén una tabla de cocientes al dividir estas probabilidades conjuntas por 
##el producto de las probabilidades marginales correspondientes.

#Creamos un Dataframe con la probabilidad conjunta
probdf <- as.data.frame(table(homeGoals2, awayGoals2)/length(homeGoals2))

#renombramos la columna de frecuencia 
colnames(probdf)[3] <- "Conjunta"

#Agregamos la probabilidad marginal del equipo de casa
probdf$marginalcasa <- probCasa

#Hacemos un vector de la probabilidad marginal del equipo visitante
#que se repita de la forma a la columna awayGoals2
probVisitanteVector <- rep(probVisitante,length(probCasa))
probVisitanteVector<- probVisitanteVector[order(names(probVisitanteVector))]
probdf$marginalvisita <- probVisitanteVector

#Cociente
#Agregamos la columna del producto de las probabilidades marginales
probdf$prodMarginal <- probdf$marginalcasa*probdf$marginalvisita

#Agregamos la columna del cociente de la probabilidad conjunta entre el producto
# de las marginales
probdf$cociente <- probdf$Conjunta/probdf$prodMarginal
head(probdf,10)

tablaCocientesPlot <-   ggplot() + 
                        geom_histogram(aes(probdf$cociente), color="black", fill="purple", binwidth = 0.3)+
                        ggtitle("Tabla de Cocientes") +
                        ylab("Frecuencia") +
                        xlab("Cocientes") + 
                        theme_light()

tablaCocientesPlot

##2. Mediante un procedimiento de boostrap, obtén más cocientes similares a los 
##obtenidos en la tabla del punto anterior.

##Aplicamos el remuestreo bootstrap
bootstrap <- replicate(n=10000, sample(probdf$cociente, replace=TRUE))

dim(bootstrap) ##Obtenemos el remuestreo en cada nueva columna

##Obtenemos las medias de cada uno de los remuestreos
mediasBS <- apply(bootstrap, MARGIN = 2, FUN = mean)
summary(mediasBS)

mediasBSPlot <-   ggplot() + 
  geom_histogram(aes(mediasBS), color="black", fill="purple")+
  ggtitle("Tabla de medias remuestreadas \"BootStrapping") +
  ylab("Frecuencia") +
  xlab("Medias") + 
  theme_light()

mediasBSPlot

##Menciona en cuáles casos le parece razonable suponer que los cocientes 
##de la tabla en el punto 1, son iguales a 1 (en tal caso tendríamos independencia 
##de las variables aleatorias X y Y).

"""
  - A menor cantidad de goles, existe una mayor independencia
  
"""
