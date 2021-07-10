# Postwork 02 Programación y manipulación de datos en R

Antes de comenzar este postwork se debe designar el espacio de trabajo con el comando `setwd()`

Importamos los datos de soccer de las temporadas 2017/2018, 2018/2019 y 2019/2020 de la primera división de la liga española a R, los datos los puedes encontrar en el siguiente enlace: https://www.football-data.co.uk/spainm.php 

```R
le1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
le1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
le1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
```

Con ayuda de la función `download.file` descargamos los archivos en el directorio previamente elegido 

```R
download.file(url = le1718, destfile = "le1718.csv", mode = "wb")
download.file(url = le1819, destfile = "le1819.csv", mode = "wb")
download.file(url = le1920, destfile = "le1920.csv", mode = "wb")
```

Cargamos los datos en la lista `ligaEsp`
```R
ligaEsp <- lapply(dir(), read.csv)
```

Los siguientes comandos sirven para conocer la estructura de los dataframes almacenados en la lista `ligaEsp`

```R
str(ligaEsp[[1]]); str(ligaEsp[[2]]); str(ligaEsp[[3]])

head(ligaEsp[[1]]); head(ligaEsp[[2]]); head(ligaEsp[[3]])

summary(ligaEsp[[1]]); summary(ligaEsp[[2]]); summary(ligaEsp[[3]])

View(ligaEsp[[1]]); View(ligaEsp[[2]]); View(ligaEsp[[3]])
```

Seleccionamos las columnas de interés (Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR) utilizando la librería `dplyr` y mostramos la nueva estructura 

```R
library(dplyr)

ligaEsp <- lapply(ligaEsp, select, Date, HomeTeam:FTR)

str(ligaEsp)
```
Cambiamos el forrmato de la fecha de `chr` a `Date` con el comando `mutate`. En este paso se debe tener claro el formato en el que se encuentra escritas las fechas. Con el comando `str` verificamos que se haya realizado de forma correcta el cambio.

```R
ligaEsp[[1]] <- mutate(ligaEsp[[1]], Date = as.Date(Date, "%d/%m/%y"))
ligaEsp[[2]] <- mutate(ligaEsp[[2]], Date = as.Date(Date, "%d/%m/%Y"))
ligaEsp[[3]] <- mutate(ligaEsp[[3]], Date = as.Date(Date, "%d/%m/%Y"))

str(ligaEsp)
View(ligaEsp[[1]]); View(ligaEsp[[2]]); View(ligaEsp[[3]])
```
Por último unimos los tres dataframes en uno solo. Y nuevamente observamos la estructura de nuestros datos. 

```R
data <- do.call(rbind, ligaEsp)
dim(data)

View(data)
str(data)
head(data)
class(data)
``` 

Como paso extra para el postwork 03, vamos a almacenar el dataframe resultante `data` en el archivo [`dataPostwork2.csv`](https://github.com/edsatan/Proyecto-R/blob/main/Postwork-02/dataPostwork2.csv)

```R
write.csv(data, "dataPostwork2.csv", row.names = FALSE)
``` 

<h3 align="center"> ⏭️ <a href="https://github.com/edsatan/Proyecto-R/tree/main/Postwork-03"> Postwork 03</a></h3>

