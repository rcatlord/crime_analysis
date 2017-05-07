## The 80-20 rule ##

# A small proportion of places, offenders, victims, and property account for most of the crime.

# Load the necessary packages
library(tidyverse)

# Set your working directory to where the crime data are stored
setwd("../")

# Read the data
crimes <- read.csv("crime_data.csv", header = T)

# Calculate cumulative frequencies and percentages for Robbery
tbl <- crimes %>% 
  filter(category == "Robbery") %>% 
  group_by(borough) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  arrange(desc(n)) %>%
  mutate(percent.crimes = round(n/sum(n)*100, 1),
         cum.percent.crimes = round(cumsum(percent.crimes), 1),
         percent.boroughs = 1/n()*100,
         cum.percent.boroughs = round(cumsum(percent.boroughs), 1)) %>% 
  select(Borough = borough,
         `No. crimes` = n,
         `% crimes` = percent.crimes,
         `Cum. % crimes` = cum.percent.crimes,
         `Cum. % boroughs` = cum.percent.boroughs)

# Create a simple table and save as a pdf
library(gridExtra)
pdf("80-20_rule.pdf", height=11, width=8.5)
grid.table(tbl, rows = NULL)
dev.off()

