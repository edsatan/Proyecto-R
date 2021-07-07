
# Proyecto R
Proyecto final del primer módulo de la fase dos del programa BEDU Disruptive Skills: Data Science

* [Postwork01](https://github.com/edsatan/Proyecto-R/tree/main/Postwork-01)
* [Postwork02](https://github.com/edsatan/Proyecto-R/tree/main/Postwork-02)

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
