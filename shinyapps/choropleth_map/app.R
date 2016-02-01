## Choropleth map app ##

# Load the necessary packages
library(dplyr) ; library(rgdal) ; library(leaflet) ; library(classInt)

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
    column(2,
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
    paste0(input$category, " offences by LSOA in Manchester")
  })
  
  output$period <- renderText({
    req(input$category)
    paste("during November 2015")
  })
  
  output$map <- renderLeaflet({
    req(input$category)
    
    lsoa@data <- left_join(lsoa@data, selected())
    
    lsoa$rate <- round((lsoa$n / lsoa$pop_All.Ag) * 1000, 1)
    
    qpal <- colorQuantile("YlGn", lsoa$rate, n = 5, na.color = "#bdbdbd")

    popup <- paste0("<strong>LSOA: </strong>",
                    lsoa$LSOA11CD,
                    "<br><strong>Category: </strong>",
                    lsoa$category,
                    "<br><strong>Rate: </strong>",
                    lsoa$rate)
    
    leaflet(lsoa) %>% 
      addProviderTiles("CartoDB.Positron") %>% 
      addPolygons(data = lsoa, fillColor = ~qpal(rate), fillOpacity = 0.7, 
                  color = "white", weight = 2, popup = popup) %>% 
      addLegend(pal = qpal, values = ~rate, opacity = 0.7,
              position = 'bottomright', 
              title = paste0(input$category, "<br>", " per 1,000 population"))
  })

})

shinyApp(ui, server)
