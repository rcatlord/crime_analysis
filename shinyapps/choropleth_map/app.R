## Choropleth map app ##

# Load the necessary packages
library(dplyr) ; library(rgdal) ; library(leaflet) ; library(classInt) ; library(RColorBrewer)

# Load the crime data
crimes <- read.csv("crime_data.csv", header = T) %>% 
  filter(borough == "Manchester",
         month == "2015-11-01") %>% 
  group_by(category, lsoa, borough) %>%
  summarise(n = n()) %>% 
  rename(LSOA11CD = lsoa) %>% 
  as.data.frame()

# Load the borough boundary vector layer 
lsoa <- readOGR("manchester_lsoa.geojson", "OGRGeoJSON")

ui <- shinyUI(fluidPage(
  fluidRow(
    column(7, offset = 1,
           br(),
           div(h4(textOutput("title"), align = "center"), style = "color:black"),
           div(h5(textOutput("period"), align = "center"), style = "color:black"),
           br())),
  fluidRow(
    column(7, offset = 1,
           leafletOutput("map", height="600")),
    column(3,
           uiOutput("category", align = "left")))
  ))

server <- (function(input, output, session) {
  
  output$category <- renderUI({
    selectInput("category", "Select a crime category:",
                choices = levels(crimes$category),
                selected = "Burglary")
  })  
  
  selected <- reactive({
    df <- filter(crimes, category==input$category)
  })
  
  output$title <- renderText({
    req(input$category)
    paste0(input$category, " offences in Manchester")
  })
  
  output$period <- renderText({
    req(input$category)
    paste("during November 2015")
  })
  
  output$map <- renderLeaflet({
    req(input$category)
    
    lsoa@data <- left_join(lsoa@data, selected(), by = "LSOA11CD")
    
    lsoa$rate <- round((lsoa$n / lsoa$pop_All.Ag) * 1000, 1)
    
    palette <- brewer.pal(5, "Oranges")
    
    pal_n <- classIntervals(lsoa$n, n=5, style="quantile")
    lsoa$col_n <- findColours(pal_n, palette)
    
    pal_rate <- classIntervals(lsoa$rate, n=5, style="quantile")
    lsoa$col_rate <- findColours(pal_rate, palette)
    
    popup_n <- paste0("<strong>LSOA: </strong>",
                    lsoa$LSOA11CD,
                    "<br><strong>Category: </strong>",
                    lsoa$category,
                    "<br><strong>Count: </strong>",
                    lsoa$n)
    
    popup_rate <- paste0("<strong>Category: </strong>",
                          lsoa$category,
                          "<br><strong>LSOA: </strong>",
                          lsoa$LSOA11CD,
                          "<br><strong>Rate: </strong>",
                          lsoa$rate)
    
    leaflet(lsoa) %>% 
      addProviderTiles("CartoDB.Positron") %>% 
      addPolygons(data = lsoa, fillColor = ~col_n, fillOpacity = 0.7, 
                  color = "#bdbdbd", weight = 2, popup = popup_n, group = "Count") %>% 
      addPolygons(data = lsoa, fillColor = ~col_rate, fillOpacity = 0.7, 
                  color = "#bdbdbd", weight = 2, popup = popup_rate, group = "Rate per 1000 population") %>% 
      addLayersControl(
      baseGroups = c("Count", "Rate per 1000 population"),
      options = layersControlOptions(collapsed = FALSE)) %>% 
      addLegend(position = "bottomright", 
                colors = c(RColorBrewer::brewer.pal(5, "Oranges"), "#bdbdbd"),
                labels = c("0% - 20%", "20% - 40%", "40% - 60%", "60% - 80%", "80% - 100%", "No crime"), 
                opacity = 0.7,
                title = "Quantile ranges")
  })
  
})

shinyApp(ui, server)

