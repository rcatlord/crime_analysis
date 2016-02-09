library(lubridate); library(dplyr) ; library(tidyr) ; library(dygraphs) ; library(xts) ; library(htmlwidgets)

# load the data
crimes <- readRDS(file="crime_data_2013-2015.rds")

# create a year and month variable
crimes$year <- as.numeric(format(as.Date(crimes$date), format="%Y"))
crimes$month <- as.numeric(format(as.Date(crimes$date), format="%m"))

# create a frequency table
crimes <- crimes %>% 
  group_by(year, month, borough, category) %>% 
  summarise(n = n())

# adapted JavaScript functions for modifying the x-axis labels and values
# source: http://stackoverflow.com/questions/28915328/how-to-set-x-axis-in-dygraphs-for-r-to-show-just-month
getMonth_axis <- 'function(d){
var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
return monthNames[d.getMonth()];
}'
getMonth_values <- 'function(d) {
var monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", 
"October", "November", "December"];
date = new Date(d);
return monthNames[date.getMonth()]; }'

ui <- shinyUI(fluidPage(
  fluidRow(
    column(10, offset = 1, 
           h4(textOutput("title"), align = "center"),
           br(),
           dygraphOutput("chart1"),
           br(),
           uiOutput('borough', align = "center"),
           uiOutput('category', align = "center")
    ))))


ui <- shinyUI(fluidPage(
  fluidRow(
    column(3, offset = 1,
           br(),
           br(),
           uiOutput('borough', align = "left"),
           br(),
           uiOutput('category', align = "left")),
    column(6, 
           br(),
           h4(textOutput("title"), align = "right"),
           br(),
           dygraphOutput("chart1")))
))


server <- function(input, output, session) {
  
  selected <- reactive({crimes %>% filter(borough == input$borough &
                                          category == input$category)})
  
  output$borough <- renderUI({
    selectInput("borough", "Select a borough:",
                choices = levels(crimes$borough),
                selected = "Manchester")
  })
  
  output$category <- renderUI({
    radioButtons("category", "Select a category:",
                choices = levels(crimes$category),
                selected = "Burglary")
  })
  
  output$title <- renderText({ 
    validate(
      need(input$category != "", "")
    )
    paste0(input$category, " offences in ", input$borough)
  })
  
  output$chart1 <- renderDygraph({
    validate(
      need(input$category != "", "")
    )
    
    df <- selected() %>% 
      group_by(year) %>% 
      arrange(year) %>%
      mutate(cumulative_number = cumsum(n)) %>% 
      select(-n) %>%
      filter(year %in% c(2013:2015)) %>%
      spread(year, cumulative_number) 
    
    df$month <- as.Date(paste0(df$month, "-1"), format="%m-%d")
    df.xts <- xts(df, df$month) 
    df.xts$month <- NULL
    dygraph(df.xts, main = NULL, ylab = "Cumulative number of offences") %>%
      dyAxis("x", drawGrid = FALSE, valueFormatter=JS(getMonth_values), axisLabelFormatter=JS(getMonth_axis)) %>%
      dyOptions(colors = c('#2171b5',  '#a50f15', '#9ecae1'), 
                fillGraph = FALSE, includeZero = TRUE, axisLineWidth = 1, gridLineColor = "grey") %>%
      dyHighlight(highlightCircleSize = 5,
                  highlightSeriesOpts = list(strokeWidth = 3),
                  highlightSeriesBackgroundAlpha = 0.2,
                  hideOnMouseOut = FALSE) %>%
      dyLegend(width = 80, show = "follow")
  })
}


shinyApp(ui, server)
