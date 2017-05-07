## Repeat locations ##

# Load the necessary packages
library(tidyverse) ; library(leaflet)

# Set your working directory to where the crime data are stored
setwd("../")

# Read the data
crimes <- read.csv("crime_data.csv", header = T)

# Identify repeat locations for Robbery offences
crimes %>% 
  filter(category == "Robbery") %>% 
  group_by(long, lat, borough) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  arrange(desc(n))

# Plot the top 10 repeat locations using the leaflet package
rpt_locs <- crimes %>% 
  filter(category == "Robbery") %>% 
  group_by(long, lat, location, borough) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  arrange(desc(n)) %>% 
  slice(1:10)

popup <- paste0("<strong>Frequency: </strong>", rpt_locs$n,
                "<br><strong>Location: </strong>", rpt_locs$location,
                "<br><strong>Borough: </strong>", rpt_locs$borough)

leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>% 
  addCircleMarkers(data = rpt_locs, 
                   ~long, ~lat, 
                   fillColor = "white", color = "red",  
                   radius = ~n, # this may need to be controlled e.g. radius = ~n*0.1
                   popup = ~popup) 
