setwd("/home/jairock/Documents/beduDS/fase2/postwork/")
## ------------------------------- PostWork1 -----------------------------------
##Cargamos el archivo
futbolData <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

##Goles anotados por los equipos que jugaron en casa
homeGoals <- futbolData$FTHG

##Goles anotados por los equipos que jugaron como visitante
awayGoals <- futbolData$FTAG

##La probabilidad (marginal) de que el equipo que juega en casa 
##anote x goles (x = 0, 1, 2, ...)
table(homeGoals)/length(homeGoals)

##La probabilidad (marginal) de que el equipo que juega como 
##visitante anote y goles (y = 0, 1, 2, ...)
table(awayGoals)/length(awayGoals)

# La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como
# visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)
table(homeGoals, awayGoals)/length(homeGoals)

##Comprobación de las probabilidades
m <- as.matrix(table(homeGoals, awayGoals)/length(homeGoals))
sum(m) ##Se espera 1
