

El objetivo de este postwork es realizar el alojamiento de un fichero `.csv` a una base de datos (BDD), en un local host de Mongodb a través de `R`. Lo primero que se realiza es crear una conexión desde `Mongo Atlas` a `Mongo Compas`. Estando dentro de Compas se crea una base de datos con el nombre `match_games` y dentro de esta base de datos se crea la colección `match`. Dentro de la colección `match` se carga el archivo [`match.data.csv`](https://github.com/edsatan/Proyecto-R/blob/main/Postwork-07/match.data.csv) y cambiamos a `R Studio`

Dentro de `R Studio` primeo instalamos la librería `mongolite`

```R
install.packages("mongolite")

library("mongolite")
```

Posteriormente realizamos la conexion con nuestro servidor de la siguiente forma
```R
cone <- mongo("match", url = "mongodb+srv://manueeellll:manuel21@cluster0.1vtxm.mongodb.net/match_games?retryWrites=true&w=majority")
```

Relizamos un `count` para conocer el número de registros en la base de datos

```R
cone$count()
```

```R
> cone$count()
[1] 3800
```

Consulta para conocer el número de goles que metió el Real Madrid el 20 de diciembre de 2015 y contra que equipo jugó, ¿perdió ó fue goleada?

```R
consulta <- cone$find(query = '{"date":"2015-12-20","home.team":"Real Madrid"}')           

consulta
```

El Real Madrid en ese partido anoto 10 goles y jugo contra el equipo Vallecano como podemos ver en la consulta de abajo

```R
> consulta
        date   home.team home.score away.team away.score
1 2015-12-20 Real Madrid         10 Vallecano          2
```
Por supuesto que fue goleada.

Por último, cerramos la conexión con la base de datos

```R
rm(cone)
```
