#
# Postwork 8 - Equipo 9
#

library(shiny)
library(shinydashboard)
library(shinythemes)

#Esta parte es el análogo al ui.R
setwd("C:/Users/santa/Desktop/R/Sesion 08/Postwork8/data")
data <- read.csv("match.data.csv")

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
            
            dashboardBody(
                
                tabItems(
                    
                    # Histograma
                    tabItem(tabName = "Barras",
                            fluidRow(
                                titlePanel("Histograma de las variables del data set mtcars"), 
                                selectInput("xx", "Seleccione el valor de X",
                                            choices = c("home.score", "away.score")),
                                
                                box(plotOutput("plot1",width = 650, height = 650)),
                                
                            )
                    ),
                    
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
                    
                    
                    
                    # Data Table
                    tabItem(tabName = "data_table",
                            fluidRow(        
                                titlePanel(h3("Table Match")),
                                dataTableOutput ("data_table")
                            )
                    ), 
                    
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

#De aquí en adelante es la parte que corresponde al server




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
    
    #Data Table
    output$data_table <- renderDataTable( {data}, 
                                          options = list(aLengthMenu = c(5,25,50),
                                                         iDisplayLength = 5)
    )
    
    
}



shinyApp(ui, server)