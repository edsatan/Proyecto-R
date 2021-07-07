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
