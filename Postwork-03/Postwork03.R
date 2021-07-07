##1. Con el último data frame obtenido en el postwork de la sesión 2,
#elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
homeGoals2 <- data$FTHG
awayGoals2 <- data$FTAG

##La probabilidad (marginal) de que el equipo que juega en casa 
##anote x goles (x = 0, 1, 2, ...)
probCasa <- table(homeGoals2)/length(homeGoals2)
probCasa

##La probabilidad (marginal) de que el equipo que juega como 
##visitante anote y goles (y = 0, 1, 2, ...)
probVisitante <- table(awayGoals2)/length(awayGoals2)
probVisitante
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
