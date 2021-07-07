Cargamos el dataframe obtenido en el [Postwork 02](https://github.com/edsatan/Proyecto-R/tree/main/Postwork-02) y modificamos el formato de las fechas.
 ```R
data <- read.csv("https://raw.githubusercontent.com/edsatan/Proyecto-R/main/Postwork-02/dataPostwork2.csv")
data <- mutate(data, Date = as.Date(Date, "%Y-%m-%d"))
```

Seleccionesmos nuestras columnas de interés, goles de casa (FTAH) y goles de visitante (FTAG) para realizar el cálculo de las probabilidades marginales y conjusta como en el [Postwork 01](https://github.com/edsatan/Proyecto-R/tree/main/Postwork-01)

```R
homeGoals2 <- data$FTHG
awayGoals2 <- data$FTAG
```

La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)

```R
probCasa <- table(homeGoals2)/length(homeGoals2)
names(probCasa)
```

La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)

```R
probVisitante <- table(awayGoals2)/length(awayGoals2)
```

La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)

```R
probConjunta <- table(homeGoals2, awayGoals2)/length(homeGoals2)
probConjunta
```

2. Realiza lo siguiente:

Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa

```R
probCasaPlot <- ggplot() + 
                geom_col(aes(x=0:8, y=probCasa), color="black", fill="blue")+
                ggtitle("Probabilidades Marginales FTHG") +
                ylab("Porcentaje") +
                xlab("Goles") + 
                theme_light()

probCasaPlot
```

Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.

```R
probVisitantePlot <- ggplot() + 
                     geom_col(aes(x=0:6, y=probVisitante), color="black", fill="green")+
                     ggtitle("Probabilidades Marginales FTAG") +
                     ylab("Porcentaje") +
                     xlab("Goles") + 
                     theme_light()
probVisitantePlot
```

Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.

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
