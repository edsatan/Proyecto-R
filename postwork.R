## POSTWORKS
## ------------------------------- PostWork1 -----------------------------------
##Cargamos el archivo
futbolData <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

##Goles anotados por los equipos que jugaron en casa
homeGoals <- futbolData$FTHG

##Goles anotados por los equipos que jugaron como visitante
awayGoals <- futbolData$FTAG

##La probabilidad (marginal) de que el equipo que juega en casa 
##anote x goles (x = 0, 1, 2, ...)
table(homeGoals)/length(homeGoals)

##La probabilidad (marginal) de que el equipo que juega como 
##visitante anote y goles (y = 0, 1, 2, ...)
table(awayGoals)/length(awayGoals)

# La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como
# visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)
table(homeGoals, awayGoals)/length(homeGoals)

##Comprobación de las probabilidades
m <- as.matrix(table(homeGoals, awayGoals)/length(homeGoals))
sum(m) ##Se espera 1

## ------------------------------- PostWork2 -----------------------------------

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
library(ggplot2)

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

write.csv(data, "dataPostwork2.csv", row.names = FALSE)
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
#install.packages("reshape2")
-library(reshape2)

probConjuntaDF <- melt(probConjunta)

probConjuntaPlot <- ggplot()+
                    geom_tile(aes(x=probConjuntaDF$homeGoals2, y=probConjuntaDF$awayGoals2, fill=probConjuntaDF$value))+ 
                    labs(x="Goles Local", y="Goles Visitante", fill="Porcentaje")+
                    scale_x_continuous(breaks = unique(probConjuntaDF[,1]))+ ##Determinamos los valores unicos para X
                    scale_y_continuous(breaks = unique(probConjuntaDF[,2]))+ ##Determinamos los valores unicos para y
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

## """A menor cantidad de goles, existe una mayor independencia """

#### ------------------- Postwork Sesión 5 ------------------- ####

# 1. A partir del conjunto de datos de soccer de la liga española de las temporadas 2017/2018,
# 2018/2019 y 2019/2020, crea el data frame SmallData, que contenga las columnas date, home.team,
# home.score, away.team y away.score; esto lo puede hacer con ayuda de la función select del paquete
# dplyr. Luego establece un directorio de trabajo y con ayuda de la función write.csv guarda el data
# frame como un archivo csv con nombre soccer.csv. Puedes colocar como argumento row.names = FALSE
# en write.csv.
library(dplyr)


setwd("C:/Users")

##Carga de datos
dataurl1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
dataurl1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
dataurl1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"

download.file(dataurl1718, destfile = "dataurl1718.csv", mode = "wb")
download.file(dataurl1819, destfile = "dataurl1819.csv", mode = "wb")
download.file(dataurl1920, destfile = "dataurl1920.csv", mode = "wb")

ligaEsp <- lapply(list.files(pattern ="*.csv"), read.csv)
ligaEsp <- lapply(ligaEsp, select, Date, HomeTeam:FTAG)
ligaEsp[[1]] <- mutate(ligaEsp[[1]], Date = as.Date(Date, "%d/%m/%y"))
ligaEsp[[2]] <- mutate(ligaEsp[[2]], Date = as.Date(Date, "%d/%m/%Y"))
ligaEsp[[3]] <- mutate(ligaEsp[[3]], Date = as.Date(Date, "%d/%m/%Y"))

# Union de los dataframes
SmallData <- do.call(rbind, ligaEsp)

# Rwnomvramos columnas
SmallData <- rename(SmallData, date = Date, 
                    home.team = HomeTeam, 
                    home.score = FTHG,
                    away.team = AwayTeam,
                    away.score = FTAG)
str(SmallData)
head(SmallData)

# Guardamos el archivo
write.csv(SmallData, "soccer.csv", row.names = FALSE)


# 2. Con la función create.fbRanks.dataframes del paquete fbRanks importe el archivo soccer.csv
# a R y al mismo tiempo asignelo a una variable llamada listasoccer. Se creará una lista con los
# elementos scores y teams que son data frames listos para la función rank.teams. Asigna estos
# data frames a variables llamadas anotaciones y equipos.

library(fbRanks)

listasoccer <-create.fbRanks.dataframes("soccer.csv")
anotaciones <-listasoccer$scores
equipos <- listasoccer$teams

# 3. Con ayuda de la función unique crea un vector de fechas (fecha) que no se repitan y que
# correspondan a las fechas en las que se jugaron partidos. Crea una variable llamada n que
# contenga el número de fechas diferentes. Posteriormente, con la función rank.teams y usando
# como argumentos los data frames anotaciones y equipos, crea un ranking de equipos usando
# únicamente datos desde la fecha inicial y hasta la penúltima fecha en la que se jugaron partidos,
# estas fechas las deberá especificar en max.date y min.date. Guarda los resultados con el nombre
# ranking.

fechas <- unique(anotaciones$date)
n <- length(fechas)
ranking <-rank.teams(anotaciones, equipos, max.date=fechas[n-1], min.date = fechas[1])

# 4. Finalmente estima las probabilidades de los eventos, el equipo de casa gana, el equipo
# visitante gana o el resultado es un empate para los partidos que se jugaron en la última fecha
# del vector de fechas fecha. Esto lo puedes hacer con ayuda de la función predict y usando como
# argumentos ranking y fecha[n] que deberá especificar en date.

p <- predict(ranking, date = fechas[n])


#### ------------------- Postwork Sesion 6 ------------------- ####

# Importa el conjunto de datos match.data.csv a R y realiza lo siguiente:
# 1. Agrega una nueva columna sumagoles que contenga la suma de goles por partido.

link = paste("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/",
             "main/Sesion-06/Postwork/match.data.csv", sep = "")
match.data <- read.csv(link, header = TRUE)
match.data$sumagoles <- match.data$home.score + match.data$away.score

# 2. Obtén el promedio por mes de la suma de goles.
serie <- match.data %>% mutate(anio_mes = substr(date, 1, 7)) %>%
  group_by(anio_mes) %>% summarize(goles_prom = mean(sumagoles))


# 3. Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.
serie.ts <- ts(serie$goles_prom, end = c(2019, 12), frequency = 12)

# 4. Grafica la serie de tiempo.
plot(serie.ts, las = 1, col = 4, lwd = 2, xlab = "Tiempo", ylab = "Goles",
     main = "Serie de Goles Promedio",
     sub = "Serie mensual: Agosto de 2010 a Diciembre de 2019")


#### ------------------ Postwork Sesión 07 -------------------------#####

#1. Instalamos el paquete mongolite
install.packages("mongolite")

library("mongolite")

#2. Realizamos la conección a la base de datos

cone <- mongo("match", url = "mongodb+srv://manueeellll:manuel21@cluster0.1vtxm.mongodb.net/match_games?retryWrites=true&w=majority")

# 3. Realizamos el count() para conocer la dimensión 
cone$count()

# 4. Realizamos una consulta
consulta <- cone$find(query = '{"date":"2015-12-20","home.team":"Real Madrid"}')           

consulta
#5. Cerramos la conexión 
rm(cone)

