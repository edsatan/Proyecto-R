A partir del conjunto de datos de soccer de la liga española de las temporadas 2017/2018, 2018/2019 y 2019/2020, crea el data frame SmallData, 
que contenga las columnas date, home.team, home.score, away.team y away.score; esto lo puede hacer con ayuda de la función select del paquete dplyr. 
Luego establece un directorio de trabajo y con ayuda de la función write.csv guarda el data frame como un archivo csv con nombre soccer.csv. 
Puedes colocar como argumento row.names = FALSE en write.csv.

```R
library(dplyr)
```

Primero se debe seleccionar el directorio de trabajo con el comando `setwd(/ruta)`

Carga de datos

```R
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
```

Union de los dataframes

```R
SmallData <- do.call(rbind, ligaEsp)
```

Renombramos las columnas

```R
SmallData <- rename(SmallData, date = Date, 
                    home.team = HomeTeam, 
                    home.score = FTHG,
                    away.team = AwayTeam,
                    away.score = FTAG)
str(SmallData)
head(SmallData)
```

Guardamos el archivo

```R 
write.csv(SmallData, "soccer.csv", row.names = FALSE)
```

Con la función create.fbRanks.dataframes del paquete fbRanks importe el archivo soccer.csv a R y al mismo tiempo asignelo a una variable llamada listasoccer. 
Se creará una lista con loselementos scores y teams que son data frames listos para la función rank.teams. Asigna estos data frames a variables llamadas anotaciones y equipos.

```R
library(fbRanks)

listasoccer <-create.fbRanks.dataframes("soccer.csv")
anotaciones <-listasoccer$scores
equipos <- listasoccer$teams
```

Con ayuda de la función unique crea un vector de fechas (fecha) que no se repitan y que correspondan a las fechas en las que se jugaron partidos. 
Crea una variable llamada n que contenga el número de fechas diferentes. Posteriormente, con la función rank.teams y usando como argumentos los data
frames anotaciones y equipos, crea un ranking de equipos usando únicamente datos desde la fecha inicial y hasta la penúltima fecha en la que se jugaron 
partidos, estas fechas las deberá especificar en max.date y min.date. Guarda los resultados con el nombre ranking.

```R
fechas <- unique(anotaciones$date)
n <- length(fechas)
ranking <-rank.teams(anotaciones, equipos, max.date=fechas[n-1], min.date = fechas[1])
``` 

Finalmente estima las probabilidades de los eventos, el equipo de casa gana, el equipo visitante gana o el resultado es un empate para los partidos que se
jugaron en la última fecha del vector de fechas fecha. Esto lo puedes hacer con ayuda de la función predict y usando como argumentos ranking y `fecha[n]` que 
deberá especificar en date.

```R
p <- predict(ranking, date = fechas[n])
```
