# Postwork 01 Introducción a R y Software

Comenzamos importando los datos de soccer de la temporada 2019/2020 de la primera división de la liga española que se puede encontrar en el enlace: https://www.football-data.co.uk/spainm.php

``` R
futbolData <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
```
De los datos obtenidos, tomamos los goles anotados de cada equipo local (`FTHG`) y visitante (`FTAG`).

```R
homeGoals <- futbolData$FTHG  #Goles anotados por los equipos que jugaron en casa

awayGoals <- futbolData$FTAG  #Goles anotados por los equipos que jugaron como visitante
```

Utilizando la función `table()`, por medio de clasificación cruzada construimos una “tabla de contigencia”, la cual determina en **cuántas ocasiones** de las distintas anotaciones realizadas (0,1,2,…), se tuvo el mismo resultado, es decir, en cuántos encuentros el marcador fue 0, 1, 2, y así
sucesivamente.

```R
table(homeGoals)

#homeGoals
# 0   1   2   3   4   5   6 
#88 132  99  38  14   8   1 
```

Con las tablas de contigencias obtenidas para las anotaciones de los equipos locales y los equipos visitantes, calculamos la probabilidad marginal en cada caso, al dividirlas entre el total de partidos que se jugaron. La probabilidad simple o marginal se refiere a la probabilidad de ocurrencia de un suceso.
Matemáticamente, si <img src="https://latex.codecogs.com/svg.latex?\small&space;X"/> es la variable aleatoria que cuenta el número de goles anotados (ya sea local o visitante), esta probabilidad la calculamos como:

<p align="center">
  <img src="https://latex.codecogs.com/svg.latex?\small&space;P(X=n)=\frac{\textrm{Partidos\hspace{.1cm}con\hspace{.1cm}marcador\hspace{.1cm}igual\hspace{.1cm}a\hspace{.1cm}n}}{\textrm{Partidos\hspace{.1cm}totales}}"/>
 </p>

``` R
table(homeGoals)/length(homeGoals) # Probabilidad marginal equipo de casa

table(awayGoals)/length(awayGoals) # Probabilidad marginal equipo visitante
```
Cuando se está interesado en conocer la probabilidad de que dos sucesos se verifiquen simultáneamente, se habla de probabilidad conjunta. Para el calculo de la probabilidad conjunta se llaman ambos vectores `homeGoals` y  `awayGoals` dentro el comando `table`.

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

Dividimos entre la cantidad de casos para obtener la probabilidad conjunta. En este caso, si <img src="https://latex.codecogs.com/svg.latex?\small&space;X"/> es la variable aleatoria que denota el marcador local y <img src="https://latex.codecogs.com/svg.latex?\small&space;Y"/> el marcador visitante, el cálculo de tales probabilidades viene dado por:

<p align="center">
  <img src="https://latex.codecogs.com/svg.latex?\small&space;P(X=n;Y=m)=\frac{\textrm{Partidos\hspace{.1cm}cuyo\hspace{.1cm}marcador\hspace{.1cm}fue\hspace{.1cm}n-m\hspace{.1cm}}}{\textrm{Partidos\hspace{.1cm}totales}}"/>
 </p>

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
# Postwork 02 Programación y manipulación de datos en R

Antes de comenzar este postwork se debe designar el espacio de trabajo con el comando `setwd()`, de preferencia una carpeta que contenga solo los archivos con los que se van a trabajar.

Importamos los datos de soccer de las temporadas 2017/2018, 2018/2019 y 2019/2020 de la primera división de la liga española a R, los datos los puedes encontrar en el siguiente enlace: https://www.football-data.co.uk/spainm.php .

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

Leemos cada uno de los `.csv` y los almacenamos en una lista `ligaEsp` en R para facilitar su manipulación. 

```R
ligaEsp <- lapply(dir(), read.csv)
```
Para garantizar que únicamente se lean los archivos con terminación `.csv` en  `dir()`, podemos hacer:

```R
ligaEsp <- lapply(list.files(pattern ="*.csv"), read.csv)
```
Con ayuda de los comandos `str()` , `summary()`, `head()` y `View()` conocemos un poco más la estructura de los datos, de esta manera podemos encontrar irregularidades, las cuales procesamos para dejar los datos de una manera “limpia” y optima, seleccionando solo aquellos datos necesarios para el análisis. 

```R
str(ligaEsp[[1]]); str(ligaEsp[[2]]); str(ligaEsp[[3]])

head(ligaEsp[[1]]); head(ligaEsp[[2]]); head(ligaEsp[[3]])

summary(ligaEsp[[1]]); summary(ligaEsp[[2]]); summary(ligaEsp[[3]])

View(ligaEsp[[1]]); View(ligaEsp[[2]]); View(ligaEsp[[3]])
```
En este caso en específico, observamos que los datos cuentan con un campo de fecha, pero no todos tienen el mismo formato, esto deberá ser modificado, pero antes seleccionaremos las columnas de interés (Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR) utilizando la librería `dplyr`.

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
Por último unimos los tres dataframes en uno solo. Con el comando ``do.call()`` combinamos todos los datos en un solo dataframe. Utilizando el argumento ``rbind`` indicamos que cada dataframe individual de la lista se una en un nuevo renglón al finalizar anterior. 

Y nuevamente observamos la estructura de nuestros datos. 

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

# Postwork 03 Análisis Exploratorio de Datos con R

Cargamos el dataframe obtenido en el [Postwork 02](https://github.com/edsatan/Proyecto-R/tree/main/Postwork-02) y modificamos el formato de las fechas (utilizando el comando `mutate()`) para facilitar más adelante su manipulación.
 ```R
data <- read.csv("https://raw.githubusercontent.com/edsatan/Proyecto-R/main/dataPostwork2.csv")

data <- mutate(data, Date = as.Date(Date, "%Y-%m-%d"))
```

Seleccionamos nuestras columnas de interés (goles de casa `FTHG` y goles de visitante `FTAG`) para realizar el cálculo de las probabilidades marginales y conjunta como en el [Postwork 01](https://github.com/edsatan/Proyecto-R/tree/main/Postwork-01)

```R
homeGoals2 <- data$FTHG
awayGoals2 <- data$FTAG
```

Calculamos las probabilidades marginales y la conjunta

* Probabilidad marginal equipo de casa

```R
probCasa <- table(homeGoals2)/length(homeGoals2)
probCasa

#homeGoals2
#          0           1           2           3           4           5           6           7           8 
#0.232456140 0.327192982 0.266666667 0.112280702 0.035087719 0.019298246 0.005263158 0.000877193 0.000877193 
```

* Probabilidad marginal equipo visitante

```R
probVisitante <- table(awayGoals2)/length(awayGoals2)
probVisitante

#awayGoals2
#          0           1           2           3           4           5           6 
#0.351754386 0.340350877 0.212280702 0.054385965 0.028947368 0.009649123 0.002631579 
```

* Probabilidad conjunta

```R
probConjunta <- table(homeGoals2, awayGoals2)/length(homeGoals2)
probConjunta

#          awayGoals2
#homeGoals2           0           1           2           3           4           5           6
#         0 0.078070175 0.080701754 0.045614035 0.018421053 0.005263158 0.004385965 0.000000000
#         1 0.115789474 0.114912281 0.068421053 0.017543860 0.008771930 0.001754386 0.000000000
#         2 0.087719298 0.093859649 0.061403509 0.011403509 0.008771930 0.001754386 0.001754386
#         3 0.044736842 0.032456140 0.024561404 0.006140351 0.001754386 0.001754386 0.000877193
#         4 0.014035088 0.010526316 0.007017544 0.000000000 0.003508772 0.000000000 0.000000000
#         5 0.008771930 0.005263158 0.004385965 0.000000000 0.000877193 0.000000000 0.000000000
#         6 0.002631579 0.001754386 0.000000000 0.000877193 0.000000000 0.000000000 0.000000000
#         7 0.000000000 0.000877193 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000
#         8 0.000000000 0.000000000 0.000877193 0.000000000 0.000000000 0.000000000 0.000000000

```

Para entender mejor los resultados de las operaciones realizadas, desplegaremos unos gráficos utilizando la librería `ggplot2`. 

```R
library(ggplot2)
```

Para el caso de las probabilidades marginales, se optó por utilizar un gráfico de barras, permitiéndonos observar la distribución y comportamiento de las distintas probabilidades de una manera más rápida y sencilla.

```R
probCasaPlot <- ggplot() + 
                geom_col(aes(x=0:8, y=probCasa), color="black", fill="blue")+
                ggtitle("Probabilidades Marginales FTHG") +
                ylab("Porcentaje") +
                xlab("Goles") + 
                theme_light()

probCasaPlot
```

<p align="center">
  <img src="Sesion3_plot1.png" />
</p>

```R
probVisitantePlot <- ggplot() + 
                     geom_col(aes(x=0:6, y=probVisitante), color="black", fill="green")+
                     ggtitle("Probabilidades Marginales FTAG") +
                     ylab("Porcentaje") +
                     xlab("Goles") + 
                     theme_light()
probVisitantePlot
```

<p align="center">
  <img src="Sesion3_plot2.png" />
</p>

Para la probabilidad conjunta, en donde interactuan dos variables, goles de locales y goles de visitantes, optamos por un mapa de calor para ilustrar los resultados. Por medio de un mapa de calor podemos determinar los disntintos valores de probabilidad obtenidos dependiendo de la tonalidad que adquieran, permitiendo un análisis visual sencillo y rápido de los resultados.

```R
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
```

<p align="center">
  <img src="Sesion3_plot3.png" />
</p>

# Postwork 04 Algunas distribuciones, teorema central del límite y contraste de hipótesis

Cargamos el archivo del [postwork 2](https://github.com/edsatan/Proyecto-R/tree/main/Postwork-02) y seleccionamos las columnas de interés

```R
data <- read.csv("dataPostwork2.csv")

homeGoals2 <- data$FTHG
awayGoals2 <- data$FTAG
``` 

El objetivo es obtener una tabla de cocientes al dividir estas probabilidades conjuntas por el producto de las probabilidades marginales correspondientes. Creamos un Dataframe con la probabilidad conjunta.

```R
probdf <- as.data.frame(table(homeGoals2, awayGoals2)/length(homeGoals2))
```

Renombramos la columna de `frecuencia` como `conjunta`

```R
colnames(probdf)[3] <- "Conjunta"
```

Agregamos la probabilidad marginal del equipo de casa

```R
probdf$marginalcasa <- probCasa
```

Hacemos un vector de la probabilidad marginal del equipo visitante que se repita de la forma a la columna awayGoals2

```R
probVisitanteVector <- rep(probVisitante,length(probCasa))
probVisitanteVector<- probVisitanteVector[order(names(probVisitanteVector))]
probdf$marginalvisita <- probVisitanteVector
```

Agregamos la columna del producto de las probabilidades marginales

```R
probdf$prodMarginal <- probdf$marginalcasa*probdf$marginalvisita
```
Y por último agregamos la columna del cociente de la probabilidad conjunta entre el producto de las marginales y mostramos el dataframe final

```R
probdf$cociente <- probdf$Conjunta/probdf$prodMarginal

head(probdf,10)
#   homeGoals2 awayGoals2    Conjunta marginalcasa marginalvisita prodMarginal  cociente
#1           0          0 0.078070175  0.232456140      0.3517544 0.0817674669 0.9547829
#2           1          0 0.115789474  0.327192982      0.3517544 0.1150915666 1.0060639
#3           2          0 0.087719298  0.266666667      0.3517544 0.0938011696 0.9351621
#4           3          0 0.044736842  0.112280702      0.3517544 0.0394952293 1.1327151
#5           4          0 0.014035088  0.035087719      0.3517544 0.0123422592 1.1371571
#6           5          0 0.008771930  0.019298246      0.3517544 0.0067882425 1.2922240
#7           6          0 0.002631579  0.005263158      0.3517544 0.0018513389 1.4214464
#8           7          0 0.000000000  0.000877193      0.3517544 0.0003085565 0.0000000
#9           8          0 0.000000000  0.000877193      0.3517544 0.0003085565 0.0000000
#10          0          1 0.080701754  0.232456140      0.3403509 0.0791166513 1.0200350
```
Grafícamos la tabla de cocientes para conocer la distribución

```R
tablaCocientesPlot <-   ggplot() + 
                        geom_histogram(aes(probdf$cociente), color="black", fill="purple", binwidth = 0.3)+
                        ggtitle("Tabla de Cocientes") +
                        ylab("Frecuencia") +
                        xlab("Cocientes") + 
                        theme_light()

tablaCocientesPlot
```

<p align="center">
  <img src="cocientes.png" />
</p>

Internamente, lo que se está haciendo es observar de manera empírica si es objetivo asumir que los goles de local y de visitante, al ser vistos como variables aletorias, son independientes. En estadística, dos variables aleatorias <img src="https://latex.codecogs.com/svg.latex?\small&space;X"/> y <img src="https://latex.codecogs.com/svg.latex?\small&space;Y"/> se dicen independientes si la distribución conjunta de estas es igual al producto de las distribuciones marginales, esto es:

<p align="center">
  <img src="https://latex.codecogs.com/svg.latex?\small&space;f(x,y)=f(x)f(y)"/>
 </p>

Lo que es lo mismo que decir:

<p align="center">
  <img src="https://latex.codecogs.com/svg.latex?\small&space;\frac{f(x,y)}{f(x)f(y)}=1"/>
 </p>

Como ya contamos con estimaciones para la distribución conjunta, así como para las marginales correspondientes, una manera de verificar la hipótesis de independencia es mediante los cocientes de tales estimaciones, de ahí el procedimiento que hemos realizado en esta parte del proyecto.

A continuación, obtendremos tablas de cocientes simuladas a través de un procedimiento de remuestreo conocido como Bootstrap.

**Nota.** -Bootstrap es un método de remuestreo propuesto por Bradley Efron en 1979 que se aplica en situaciones en donde la muestra de datos disponible es muy pequeña. A través de la generación de nuevas muestras basadas en la original, se aumenta la cantidad de datos e información con la que trabajar, de esta manera calculando las medias de cada muestra se puede determinar la distribución de los datos de manera gráfica.

En este caso para implementar el método de boostrap en `R` se utilizó la función `sample()`, la cual dandole una muestra de datos, genera una “nueva muestra” basada en la original, y como el boostrap necesita una mayor cantidad de muestras, utilizando la función `replicate()` determinamos cuantas veces se tendrá que ejecutar la función `sample` generando en cada repetición más muestras.


La idea es simular muestras de los marcadores a partir de los originales. Cada simulación de estos nos permitirá construir una nueva tabla de cocientes. Esto lo haremos `n=10000` veces. Estableceremos una semilla para poder replicar los resultados.

```R
# Simulación de los marcadores.
set.seed(10)
n = 10000
marcadores <- paste(data$FTHG, "-" ,data$FTAG, sep="")
bootstrap <- replicate(n, sample(marcadores, replace=TRUE))
```
Ahora definimos dos matrices: `tablaCocientes` y  `muestraCocientes`, las cuales alamacenarán la suma acumulada de los cocientes simulados y las muestras de los mismos, respectivamente.

```R
tablaCocientes <- matrix(rep(0,16), ncol=4)
muestraCocientes <- matrix(ncol= 16)
```

Iteramos ahora 10 mil veces para construir en cada ocasión una nueva tabla de cocientes.

```R
for(i in 1:n){
  # Marcador simulado i
  sim <- bootstrap[,i]
  marcador_sim <- matrix(as.numeric(unlist(strsplit(sim, "-"))), ncol=length(sim), byrow=FALSE)
  marcador.home <- marcador_sim[1,]
  marcador.away <- marcador_sim[2,]
  
  # Ditribución conjunta para el escenario simulado i
  p_conj <- table(marcador.home,marcador.away)/casos
  p_conj <- as.matrix(p_conj)  
  
  # Distribuciones marginales para el escenario simulado i
  marg.home <- apply(p_conj ,1, sum)
  marg.away <- apply(p_conj ,2, sum)
  
  # Tabla de cocientes de la simulación i
  Cocientes <- p_conj
  for(i in 1:dim(p_conj)[1]){
    for(j in 1:dim(p_conj)[2]){
      Cocientes[i,j] <- Cocientes[i,j]/(marg.home[i]*marg.away[j])
    }
  }
  
  # Tabla acumulada de cocientes
  tablaCocientes = tablaCocientes + Cocientes[1:4, 1:4]
  
  # Matriz con muestra de cocientes
  muestraCocientes = rbind(muestraCocientes, c(Cocientes[1,1:4], Cocientes[2,1:4],
                                               Cocientes[3,1:4], Cocientes[4,1:4]))
}
```
Notemos que en cada iteración se acumula en la matriz `tablaCocientes` los cocientes obtenidos para los marcadores más probables, esto es: hasta 3-3. Además, se guardan las muestras en la matriz `muestraCocientes`. Luego, Dividimos `tablaCocientes` entre 10 mil para obtener las medias de cada casilla (marcador posible) y convertimos a un data frame la matriz `muestraCocientes`, a la cual también se le renombran sus columnas según los marcadores.



```R
tablaCocientes <- tablaCocientes/n
muestraCocientes <- as.data.frame(muestraCocientes[-1, ]) # Eliminando primer registro con NA's

colnames(muestraCocientes) <- c("0-0", "0-1", "0-2", "0-3", "1-0", "1-1", "1-2", "1-3",
                                "2-0", "2-1", "2-2", "2-3", "3-0", "3-1", "3-2", "3-3")
```
Construimos ahora un histograma para cada marcador, en el cual se muestra primero las anotaciones del equipo local (H) y luego las del equipo visitante (A).

```R
# Construcción de histogramas
par(mfrow=c(4,4))
for(i in 1:dim(muestraCocientes)[2]){
  marcador <- colnames(muestraCocientes)[i]  
  hist(muestraCocientes[,i],col=i,las=1, xlab='', breaks=20,
       main=paste('Marcador (H-A):', marcador), ylab= 'Frecuencia')  
}
```
<p align="center">
  <img src="marcadores.png" />
</p>

Finalmente, imprimimos la tabla con los cocientes promedio para cada uno de los marcadores elegidos (más probables o comunes).

```R
tablaCocientes

#          marcador.away
#marcador.home      0         1         2         3           
#         0 0.9542136 1.0200379 0.9249799 1.4585520 
#         1 1.0065278 1.0311455 0.9845862 0.9891774 
#         2 0.9352090 1.0344093 1.0849736 0.7852945 
#         3 1.1330502 0.8506767 1.0300172 0.9982570
```

__Conclusión__

Dados los histogramas y las medias por casilla para los marcadores, nos parece razonable asumir que para los marcadores más comunes, existe una mayor independencia o evidencia para decir que las variables aletorias que describen el número de goles (local y visitantes), son independientes. Esto es más evidente para marcadores donde no hay más de 2 goles por equipo (0-0, 0-1, ..., 2-2). Si observamos, para marcadores donde algún equipo marcó 3 goles, el cociente no es tan cercano a 1.

# Postwork 05 Regresión lineal y clasificación

Utilizando nuevamente DataFrame de datos de soccer de la liga española de las temporadas 2017-2018, 2018-2019 y 2019-2020 generado en el Prework 2, renombraremos sus columnas `Date`, `HomeTeam`, `FTHG`, `AwayTeam` y `FTAG`, por `date`, `home.team`, `home.score`, `away.team` y `away.score`, respectivamente. Lo anterior lo podemos hacer con ayuda de la función `select` del paquete `dplyr`. Con ayuda de la función `write.csv` guarda el data frame como un archivo `.csv` con nombre `soccer.csv`.

```R
library(dplyr)
```

Seleccionamos el directorio de trabajo con el comando `setwd(/ruta)`

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

Unión de los dataframes

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

Ahora utilizaremos la librería `fbRanks` con su función `create.fbRanks.dataframes()`, la cual requiere que tenga, en específico, el nombre de las columnas que se mencionó anteriormente. Con estos datos, la función nos genera dos listas, una con los nombres de los equipos y otra con los distintos resultados de los encuentros. Estos nuevos datos pueden ser asignados de manera directa a la función `rank.teams()` utilizando a su vez el modelo poisson ponderado en el tiempo de Dixon y Coles, el cual permite realizar predicciones del rendimiento de los equipos en los disintos encuentros. De esta manera logramos obtener mejores estadísticas de los encuentros de nuestro data frame.

```R
library(fbRanks)

listasoccer <-create.fbRanks.dataframes("soccer.csv")
anotaciones <-listasoccer$scores
equipos <- listasoccer$teams
```

A continuación, con ayuda de la función `unique` creamos un vector de fechas (fecha) que no se repitan y que correspondan a las fechas en las que se jugaron partidos, además de guardar una variable (`n`) que contenga el número de fechas diferentes. Posteriormente, con la función `rank.teams` y usando como argumentos los dataframes `anotaciones` y `equipos`, creamos un ranking de equipos usando únicamente datos desde la fecha inicial y hasta la penúltima fecha en la que se jugaron partidos.

```R
fechas <- unique(anotaciones$date)
n <- length(fechas)
ranking <-rank.teams(anotaciones, equipos, max.date=fechas[n-1], min.date = fechas[1])
``` 

Finalmente, se estiman las probabilidades de los eventos, el equipo de casa gana, el equipo visitante gana o el resultado es un empate para los partidos que se
jugaron en la última fecha del vector fechas.

```R
p <- predict(ranking, date = fechas[n])
```

# Postwork 06 Series de tiempo

Para este ejercicio, importamos el conjunto de datos `match.data.csv` a R y se agregó una nueva columna `sumagoles` que contenga la suma de goles por partido.

```R
link = paste("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/",
             "main/Sesion-06/Postwork/match.data.csv", sep = "")
match.data <- read.csv(link, header = TRUE)
match.data$sumagoles <- match.data$home.score + match.data$away.score
```

A continuación, obtuvimos el promedio por mes de la suma de goles.

```R
library(dplyr)

serie <- match.data %>% mutate(anio_mes = substr(date, 1, 7)) %>%
  group_by(anio_mes) %>% summarize(goles_prom = mean(sumagoles))
```

En seguida construimos la serie de tiempo (Una serie de tiempo son datos estadísticos que se recopilan, observan o registran en intervalos de tiempo regulares [diario, semanal, semestral, anual, etc]) del promedio por mes de la suma de goles hasta diciembre de 2019 y se graficó la serie de tiempo correspondiente.


```R
serie.ts <- ts(serie$goles_prom, end = c(2019, 12), frequency = 10)

plot(serie.ts, las = 1, col = 4, lwd = 2, xlab = "Tiempo", ylab = "Goles",
     main = "Serie de Goles Promedio",
     sub = "Serie mensual: Agosto de 2010 a Diciembre de 2019")
```
<p align="center">
  <img src="seriedetiempo.png" />
</p>

__Observaciones__

Notamos que para casi todos los meses contemplados entre Agosto de 2010 y Junio de 2020, los meses de junio y julio no se encuentran en el histórico. Esto debido a que en dichos meses no hay temporada futbolística. Por esta razón, asignamos `frequency = 10` (frecuencia) a nuestra serie de tiempo `serie.ts`, con el propósito de ajustar la periodicidad lo mejor posible a los datos que tenemos. Sin embargo, una frecuencia de 12 sólo desplazaría ligeramente la gráfica, por lo que ambas opciones son viables.

# Postwork 07 RStudio Cloud - Github, conexiones con BDs y lectura de datos externos

El objetivo de este postwork es realizar el alojamiento de un fichero `.csv` a una base de datos (BDD), en un local host de Mongodb a través de `R`. Lo primero que se realiza es crear una conexión desde `Mongo Atlas` a `Mongo Compas`. Estando dentro de Compas se crea una base de datos con el nombre `match_games` y dentro de esta base de datos se crea la colección `match`. Dentro de la colección `match` se carga el archivo [`match.data.csv`](https://github.com/edsatan/Proyecto-R/blob/main/Postwork-07/match.data.csv) y nos cambiamos a `R Studio`

Dentro de `R Studio` primero instalamos la librería `mongolite`

```R
install.packages("mongolite")

library("mongolite")
```

Posteriormente realizamos la conexion con nuestro servidor de la siguiente forma
```R
cone <- mongo("match", url = "mongodb+srv://manueeellll:manuel21@cluster0.1vtxm.mongodb.net/match_games?retryWrites=true&w=majority")
```

Relizamos un `count` para conocer el número de registros en la base de datos. En este caso se puede verificar que son 3800 entradas o documentos. 

```R
cone$count()
#[1] 3800
```

Realizamos una consulta para conocer el número de goles que metió el Real Madrid el 20 de diciembre de 2015 y contra que equipo jugó para saber si ganó o perdió

```R
consulta <- cone$find(query = '{"date":"2015-12-20","home.team":"Real Madrid"}')  

consulta
#        date   home.team home.score away.team away.score
#1 2015-12-20 Real Madrid         10 Vallecano          2
```

El Real Madrid en ese partido anotó 10 goles y jugó contra el equipo Vallecano, como podemos ver en la consulta de arriba. Por supuesto que fue goleada.

Por último, cerramos la conexión con la base de datos

```R
rm(cone)
```

# Postwork 08 Dashboards con Shiny - Entorno GUI

Comenzamos cargando las librerías necesarias para le creación de Dashboard
```R
library(shiny)
library(shinydashboard)
library(shinythemes)
```

Seleccionamos el directorio de trabajo en donde se almacenan los datos del archivo `match.data.csv`
```R
setwd("C:/Users/santa/Desktop/R/Sesion 08/Postwork8/data")
data <- read.csv("match.data.csv")
```

Dentro del ambiente del ``ui``  creamos cuatro `menuItem` para cada una de las pestañas: Gráfica de barras, Probabilidades, Data Table y Factores de ganancia.
```R
ui <-fluidPage(
        
        dashboardPage(
            
            dashboardHeader(title = "Postwork 8 - Equipo 9"),
            
            dashboardSidebar(
                
                sidebarMenu(
                    menuItem("Gráfica de Barras", tabName = "Barras", icon = icon("bar-chart-o")),
                    menuItem("Probabilidades", tabName = "probs", icon = icon("file-picture-o")),
                    menuItem("Data Table", tabName = "data_table", icon = icon("table")),
                    menuItem("Factores de ganancia", tabName = "fact", icon = icon("area-chart"))
                )
                
            ),
```

En el dashboardBody agregamos los elementos de cada una de las pestañas. En la primera pestaña se inicializa un gráfico de tipo `Barras`, un `selectInput` para seleccionar las variables a graficar, las cuales se indican en el vector `choices`.
```R
            dashboardBody(
                
                tabItems(
                    
                    # Histograma
                    tabItem(tabName = "Barras",
                            fluidRow(
                                titlePanel("Gráfico de Barras del archivo match.data"), 
                                selectInput("xx", "Seleccione el valor de X",
                                            choices = c("home.score", "away.score")),
                                
                                box(plotOutput("plot1",width = 650, height = 650)),
                                
                            )
                    ),
```

En la segunda pestaña se muestran tres imagenes generadas en el Postwork 03
```R
                    # Probabilidades
                    tabItem(tabName = "probs",
                            fluidRow(
                                titlePanel(h3("Probabilidad Marginal: equipo local")),
                                img(src = "Sesion3_plot1.png", 
                                     height = 350, width = 450),
                                h3("Probabilidad Marginal: equipo visitante"),
                                img(src = "Sesion3_plot2.png", 
                                    height = 350, width = 450),
                                h3("Probabilidades conjuntas"),
                                img(src = "Sesion3_plot3.png", 
                                    height = 350, width = 450)
                            )
                    ),
```

En la tercera se inicializa una pestaña para un `Data Table`.

```R
                    
                    
                    # Data Table
                    tabItem(tabName = "data_table",
                            fluidRow(        
                                titlePanel(h3("Table Match")),
                                dataTableOutput ("data_table")
                            )
                    ), 
```
Y por último, en la cuarta pestaña se muestras las imágenes generadas por el código [``momios.R``](https://github.com/beduExpert/Programacion-R-Santander-2021/blob/main/Sesion-08/Postwork/momios.R)

```R
                    # Factores de ganancia
                    tabItem(tabName = "fact",
                            fluidRow(
                                titlePanel(h3("Factor de ganancia: Máximo")),
                                img(src = "Momios_max.png", 
                                     height = 350, width = 450),
                                h3("Factor de ganancia: Promedio"),
                                img( src = "Momios_prom.png", 
                                     height = 350, width = 450)
                            )
                    )
                    
                )
            )
        )
    )
```

De aquí en adelante es la parte que corresponde al `server`. Aquí corresponde llamar a la gráfica de la primera pestaña con los comandos de la librería `ggplot2`

```R
server <- function(input, output) {
    library(ggplot2)
    
    #Gráfico de Histograma
    output$plot1 <- renderPlot({
        
        
        ggplot(data, aes(x = as.factor(data[,input$xx]))) + 
            geom_bar(color="black", fill = "steelblue") +
            facet_wrap(as.factor(data$away.team)) +
            xlab("Goles")+ 
            ylab("Frecuencia")
        
        
    })
```

Y llamar al `Data Table` de la última pestaña. Con el comando `options` seleccionamos la cantidad de datos que se van a mostrar en nuestro Dashboard.
```R
    #Data Table
    output$data_table <- renderDataTable( {data}, 
                                          options = list(aLengthMenu = c(5,25,50),
                                                         iDisplayLength = 5)
    )
    
    
}

shinyApp(ui, server)
```

El `Dashboard` se puede visualizar en el siguiente [enlace](https://edsantamaria.shinyapps.io/Dashboard/)
