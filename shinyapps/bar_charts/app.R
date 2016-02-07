## Bar charts app ##

library(shiny) ; library(tidyr) ; library(dplyr) ; library(rCharts)

crimes <- read.csv("crime_data.csv", header = T) %>% 
  group_by(borough, category) %>%
  summarize(n = n())

ui <- shinyUI(fluidPage(
  fluidRow(
    column(10, offset = 1, 
           br(),
           showOutput("plot", "highcharts"),
           br(),
           br(),
           uiOutput("borough", align = "center")
    ))))

server <- function(input, output) {
  
  output$borough <- renderUI({
    selectInput("borough", "Select a borough:",
                choices = levels(crimes$borough),
                selected = "Manchester")
  })
  
  selected <- reactive({
    df <- filter(crimes, borough==input$borough)
  })
  
  output$plot <- renderChart2({
    df <- selected()[order(selected()$n),]
    
    h1 <- Highcharts$new()
    h1$series(data = df$n, type = "bar", color = '#3182bd')
    h1$xAxis(categories = df$category)
    h1$yAxis(title = list(text = "Number of crimes"))
    h1$credits(text = "data.police.uk", href = "http://data.police.uk")
    h1$tooltip(useHTML = T, formatter = "#! function() { return '<b>' + 'Crimes: ' + '</b>' + this.y; } !#")
    h1$legend(enabled = F)
    h1$title(text = paste0("Crimes in ", input$borough))
    h1$subtitle(text = "(January - December 2015)")
    h1$set(width = 900, height = 400)
    return(h1)
  })
  
}

shinyApp(ui = ui, server = server)
