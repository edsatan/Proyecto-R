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
