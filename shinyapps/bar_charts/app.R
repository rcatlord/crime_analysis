## Bar charts app ##

library(shiny) ; library(tidyr) ; library(dplyr) ; library(highcharter)

crimes <- read.csv("crime_data.csv", header = T) %>% 
  group_by(borough, category) %>%
  summarize(n = n())

ui <- shinyUI(fluidPage(
  fluidRow(
    column(7, offset = 1,
           br(),
           highchartOutput("plot",height = "500px")),
    column(3,
           br(),
           uiOutput("borough", align = "left")))
))


server <- function(input, output) {
  
  output$borough <- renderUI({
    selectInput("borough", "Select a borough:",
                choices = levels(crimes$borough),
                selected = "Manchester")
  })
  
  selected <- reactive({
    df <- filter(crimes, borough==input$borough)
  })
  
  output$plot <- renderHighchart({
    df <- selected()[order(selected()$n),]
    
    hc <- highchart() %>%
      hc_title(text = paste0("Crimes in ", input$borough)) %>% 
      hc_subtitle(text = "January - December 2015") %>% 
      hc_xAxis(categories = df$category) %>% 
      hc_add_series(name = "Number of crimes", data = df$n, type = "bar", showInLegend = FALSE) %>% 
      hc_yAxis(title = list(text = "")) %>% 
      hc_credits(enabled = TRUE, text = "data.police.uk",
                 href = "http://data.police.uk",
                 style = list(fontSize = "12px")) %>%
      hc_exporting(enabled = TRUE)
    hc %>% hc_add_theme(hc_theme_538())
    
  })
  
}

shinyApp(ui = ui, server = server)
