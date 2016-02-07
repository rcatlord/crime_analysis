## Waffle charts ##

# Load the necessary packages
library(dplyr) ; library(tidyr)

# Set your working directory to where the crime data are stored
setwd("../")

# Read the data
crimes <- read.csv("crime_data.csv", header = T)

# Frequency of crime by borough (in descending order)
df <- crimes %>% 
  filter(date == "2015-12-01" & category == "Robbery") %>% 
  count(borough, sort = TRUE) %>%
  mutate(percent = round(n/sum(n)*100, 1)) %>% 
  select(borough, percent) %>% 
  spread(borough, percent)

df <- df[, order(-df[which(rownames(df) == '1'), ]) ]

# Use waffle
library(waffle) 
waffle(df, rows = 4, size = 2, 
       colors=(RColorBrewer::brewer.pal(n=10,"Set3")),
       title="Borough level Robbery as a proportion of total Robbery offences, 12/2015",
       legend_pos = "bottom")
ggsave("waffle.png", scale=1.5, dpi=300)
