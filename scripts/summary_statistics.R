## Summary statistics ##

# Load the necessary packages
library(tidyverse)

# Set your working directory to where the crime data are stored
setwd("../")

# Read the data
crimes <- read_csv("crime_data.csv")

# Frequency of crime by borough (in descending order)
count(crimes, borough, sort = TRUE)

# Frequency of crime category (in descending order)
count(crimes, category, sort = TRUE)

# Frequency and percent of crime category (in descending order)
count(crimes, category, sort = TRUE) %>%
  mutate(percent = round(n/sum(n)*100, 1))

# Frequency of crime category by borough (in descending order)
crimes %>%
  group_by(category, borough) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  arrange(desc(n)) 

# Mean frequency of crime category per borough
crimes %>%
  group_by(borough, category) %>%
  summarise(total = n()) %>% 
  group_by(category) %>% 
  summarise(average = round(mean(total, na.rm=TRUE), 0))

# Frequency and percent of Vehicle crime by borough (in descending order)
crimes %>% 
  filter(category == "Vehicle crime") %>% 
  group_by(borough) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  arrange(desc(n)) %>%
  mutate(percent = round(n/sum(n)*100, 1))
