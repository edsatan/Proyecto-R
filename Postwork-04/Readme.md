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
