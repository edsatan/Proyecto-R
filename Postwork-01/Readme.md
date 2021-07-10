# Postwork 01


Comenzamos importando los datos de soccer de la temporada 2019/2020 de la primera división de la liga española que se puede encontrar en el enlace: https://www.football-data.co.uk/spainm.php

``` R
futbolData <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
```

Del dataframe `futbolData` extraemos las columnas de interés 

```R
homeGoals <- futbolData$FTHG  #Goles anotados por los equipos que jugaron en casa

awayGoals <- futbolData$FTAG  #Goles anotados por los equipos que jugaron como visitante
```

La función `table` utiliza los factores de clasificación cruzada para construir una tabla de contingencia de los conteos en cada combinación de factores. Por ejemplo

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

Para el calculo de la probabilidad conjunta se llaman ambos vectores `homeGoals` y  `awayGoald` en el comando `table`.

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

<h3 align="center"> ⏭️ <a href="https://github.com/edsatan/Proyecto-R/tree/main/Postwork-02"> Postwork 07</a></h3>
