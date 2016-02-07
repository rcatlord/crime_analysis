## Choropleth map ##

library(dplyr) ; library(rgdal) ; library(leaflet) ; library(classInt) ; library(RColorBrewer)

crimes <- read.csv("crime_data.csv", header = T) %>% 
  filter(borough == "Manchester",
         date == "2015-11-01") %>% 
  group_by(category, lsoa) %>%
  summarise(n = n()) %>% 
  rename(LSOA11CD = lsoa) %>% 
  as.data.frame()

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
           wellPanel(
           uiOutput("category", align = "left"),
           br(),
           uiOutput("class", align = "left"),
           uiOutput("breaks", align = "left"),
           uiOutput("colours", align = "left"),
           uiOutput("opacity", align = "left")),
           br(),
           tags$div(class = "header", checked = NA,
                    tags$strong("Data sources"),
                    tags$li(tags$a(href="https://data.police.uk", "Greater Manchester Police recorded crime")),
                    tags$li(tags$a(href="http://www.ons.gov.uk/ons/taxonomy/index.html?nscl=Population+Estimates#tab-data-tables", "Mid-2013 population estimates")),
                    tags$li(tags$a(href="https://data.gov.uk/dataset/lower_layer_super_output_area_lsoa_boundaries", "LSOA boundaries")))))
))

server <- (function(input, output, session) {
  
  output$category <- renderUI({
    selectInput("category", "Crime category:",
                choices = levels(crimes$category),
                selected = "Burglary")
  })  
  
  output$class <- renderUI({
    radioButtons("class", "Thematic classification:",
                 choices = c("Equal intervals" = "equal", "Quantile" = "quantile", "Natural breaks" = "jenks"),
                 selected = "jenks")
  }) 
  
  output$breaks <- renderUI({
    numericInput("breaks", "Breaks:", 5,
                 min = 3, max = 7)
  })
  
  output$colours <- renderUI({
    selectInput("colours", "Palette:",
                choices = c("Blues", "Greens", "Oranges", "Purples", "Reds"),
                selected = "Greens")
  })
  
  selected <- reactive({
    crimes[crimes$category == input$category,]
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
      addProviderTiles("CartoDB.Positron", group = "CartoDB.Positron") %>%
      addProviderTiles("OpenStreetMap.BlackAndWhite", group = "OpenStreetMap") %>% 
      addProviderTiles("Stamen.TonerLite", group = "Stamen.TonerLite") %>%
      setView(lat = lat, lng = lng, zoom = zoom) %>% 
      addLayersControl(position = 'bottomleft',
                       baseGroups = c("CartoDB.Positron", "OpenStreetMap", "Stamen.TonerLite"),
                       options = layersControlOptions(collapsed = FALSE))
  })
      
    observe({
      req(input$category)
      
      lsoa@data <- left_join(lsoa@data, selected())
      lsoa$rate <- round((lsoa$n / lsoa$pop_All.Ag) * 1000, 1) 
      
      
      palette <- brewer.pal(input$breaks, input$colours)
      classes <- classIntervals(lsoa$rate, n = input$breaks, style = input$class)
      lsoa$cols <- findColours(classes, palette)
      breaks <- round(classes$brks, 1)
      
      # make labels for legend
      labels = matrix(1:(length(breaks)-1))
      for(j in 1:length(labels )){labels [j] = paste(as.character(breaks[j]),"-",as.character(breaks[j+1]))}
      
      popup <- paste0("<strong>LSOA: </strong>",
                      lsoa$LSOA11CD,
                      "<br><strong>Category: </strong>",
                      lsoa$category,
                      "<br><strong>Count: </strong>",
                      lsoa$n,
                      "<br><strong>Rate: </strong>",
                      lsoa$rate)
      
      leafletProxy("map", data = lsoa) %>%
        clearShapes() %>% 
        clearControls() %>% 
        addPolygons(data = lsoa, stroke = TRUE, color = "white", weight = 1, opacity = 1,
                    fill = TRUE, fillColor = ~cols, fillOpacity = 0.8, popup = popup) %>%
        addLegend(position = "bottomright",
                  colors = RColorBrewer::brewer.pal(input$breaks, input$colours),
                  labels = labels,
                  opacity = 0.8,
                  title = paste0(input$category, "<br>", " per 1,000 population"))
  })

    observe({
      input$reset_button
      leafletProxy("map") %>% 
        setView(lat = lat, lng = lng, zoom = zoom)
    })      

})

shinyApp(ui, server)

