## Choropleth map app ##

# Load the necessary packages
library(dplyr) ; library(rgdal) ; library(leaflet)

# Load the crime data
crimes <- read.csv("crime_data.csv", header = T) %>% 
  filter(borough == "Manchester",
         date == "2015-11-01") %>% 
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
           leafletOutput("map", height="530"),
           br(),
           actionButton("reset_button", "Reset view")),
    column(3,
           uiOutput("category", align = "left")))
))

server <- (function(input, output, session) {
  
  output$category <- renderUI({
    radioButtons("category", "Select a crime category:",
                choices = levels(crimes$category),
                selected = "Burglary")
  })  
  
  selected <- reactive({
    subset(crimes,
           category==input$category)
  })
  
  output$title <- renderText({
    req(input$category)
    paste0(input$category, " offences by LSOA in Manchester")
  })
  
  output$period <- renderText({
    req(input$category)
    paste("during November 2015")
  })
  
  lat <- 53.442788
  lng <- -2.244708
  zoom <- 11
  
  output$map <- renderLeaflet({
    
    leaflet() %>% 
      addProviderTiles("CartoDB.Positron") %>% 
      setView(lat = lat, lng = lng, zoom = zoom)
  })
    
    observe({
  
      lsoa@data <- left_join(lsoa@data, selected())
      lsoa$rate <- round((lsoa$n / lsoa$pop_All.Ag) * 1000, 1)
      
      qpal <- colorQuantile("YlGn", lsoa$rate, n = 5, na.color = "#bdbdbd")
      
      popup <- paste0("<strong>LSOA: </strong>",
                      lsoa$LSOA11CD,
                      "<br><strong>Category: </strong>",
                      lsoa$category,
                      "<br><strong>Rate: </strong>",
                      lsoa$rate)
      
      leafletProxy("map", data = lsoa) %>%
        addProviderTiles("CartoDB.Positron") %>% 
        clearShapes() %>% 
        clearControls() %>% 
        addPolygons(data = lsoa, fillColor = ~qpal(rate), fillOpacity = 0.7, 
                  color = "white", weight = 2, popup = popup) %>%
        addLegend(pal = qpal, values = ~rate, opacity = 0.7,
                  position = 'bottomright', 
                  title = paste0(input$category, "<br>", " per 1,000 population"))
  })

    observe({
      input$reset_button
      leafletProxy("map") %>% setView(lat = lat, lng = lng, zoom = zoom)
    })      

})

shinyApp(ui, server)
