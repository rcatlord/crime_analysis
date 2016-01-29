## Choropleth map app ##

# Load the necessary packages
library(dplyr) ; library(rgdal) ; library(leaflet) ; library(classInt)

# Load the crime data
crimes <- read.csv("crime_data.csv", header = T) %>% 
  group_by(category, borough) %>%
  summarise(n = n()) %>% 
  rename(CTYUA12NM = borough) %>% 
  as.data.frame()

# Load the borough boundary vector layer 
boroughs <- readOGR("boroughs.geojson", "OGRGeoJSON")

ui <- shinyUI(fluidPage(
  fluidRow(
    column(10, offset = 1, 
           br(),
           div(h4(textOutput("title"), align = "center"), style = "color:black"),
           div(h5(textOutput("period"), align = "center"), style = "color:black"),
           br(),
           leafletOutput("map", height="300"),
           br(),
           uiOutput("category", align = "center")
    ))))

server <- (function(input, output, session) {
  
  output$category <- renderUI({
    selectInput("category", "Select a crime category:",
                choices = levels(crimes$category),
                selected = "Robbery")
  })  
  
  selected <- reactive({
    df <- filter(crimes, category==input$category)
  })
  
  output$title <- renderText({
    paste0(input$category, " offences in Greater Manchester")
  })
  
  output$period <- renderText({
    paste("between December 2014 and November 2015")
  })
  
  output$map <- renderLeaflet({
    req(input$category)
    boroughs@data <- left_join(boroughs@data, selected())
    
    
    pal <- colorFactor(c("#f1eef6", "#bdc9e1", "#74a9cf", "#2b8cbe", "#045a8d"), 
                        domain = boroughs$n)
    labels <- round(classIntervals(boroughs$n, 4, style="quantile")$brks, 0)

    popup <- paste0("<strong>Borough: </strong>",
                    boroughs$CTYUA12NM,
                    "<br><strong>Category: </strong>",
                    boroughs$category,
                    "<br><strong>Crimes: </strong>",
                    boroughs$n)
    
    leaflet(boroughs) %>% 
      addProviderTiles("CartoDB.Positron") %>% 
      fitBounds(-2.730521, 53.327298, -1.909622, 53.685719) %>%
      addPolygons(data = boroughs, fillColor = ~pal(n), fillOpacity = 0.8, 
                  color = "white", weight = 2, popup = popup) %>% 
      addLegend(colors = RColorBrewer::brewer.pal(5, "PuBu"),
                opacity = 0.8, 
                position = 'bottomright', 
                title = "Number of crimes", 
                labels = labels)
  })
  

  
})

shinyApp(ui, server)

