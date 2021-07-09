```R
install.packages("mongolite")

library("mongolite")

cone <- mongo("match", url = "mongodb+srv://manueeellll:manuel21@cluster0.1vtxm.mongodb.net/match_games?retryWrites=true&w=majority")

cone$count()

consulta <- cone$find(query = '{"date":"2015-12-20","home.team":"Real Madrid"}')           

consulta

rm(cone)
```

