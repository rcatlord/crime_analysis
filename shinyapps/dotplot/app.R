library(shiny) ; library(dplyr) ; library(rcdimple)

crimes <- read.csv("crime_data.csv", header = T) %>%
  filter(date == "2015-11-01") %>% 
  group_by(category, borough) %>%
  summarise(n = n())

ui <- shinyUI(fluidPage(
    fluidRow(
      column(10, offset = 1, 
             br(),
             dimpleOutput('plot'),
             uiOutput("category", align = "center")
      ))))
  
server <- function(input, output, session) {
    
    output$category <- renderUI({
      selectInput("category", "Select a category:",
                  choices = levels(crimes$category),
                  selected = "Burglary")
    })
    
    selected <- reactive({
      df <- filter(crimes, category==input$category)
    })
    
    output$plot <- renderDimple({
      selected() %>%
        dimple(borough ~ n, type = "bubble", height = 500, width = "100%") %>%
        xAxis(type = "addMeasureAxis", showGridlines = F, title = "Number of crimes") %>%
        yAxis(type = "addCategoryAxis", orderRule = "Frequency", showGridlines = F, title = "") %>%
        default_colors(c("#7a0177", "#7a0177")) %>%
        add_title(html = paste0("<div style='text-align:center;width:100%'>
                                <b style = 'font-size:100%;'>", input$category, " ", paste('offences in November 2015'),
                                "</div>"))
    })
    
}

shinyApp(ui, server)
