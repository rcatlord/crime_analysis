## Tidying data ##

# Place all of the CSV files downloaded from data.police.uk in a single folder

# Load the necessary packages
library(tidyr) 
library(dplyr)
library(lubridate)

# Set your working directory to the folder where the CSV files are stored
setwd("../")

# Read the CSV files and merge them into a single dataframe called 'crimes'
filenames <- list.files("data", pattern="*.csv", full.names=TRUE)
crimes <- read.csv(filenames[1], header = T)

for(i in 2:length(filenames)){
  crimes2 <- read.csv(filenames[i], header = T)
  crimes <- rbind(crimes, crimes2)
}

# Remove the redundant objects from the R session
rm(crimes2, filenames, i)

# Check the data
glimpse(crimes)

# Convert ‘Month’ to a date variable
crimes$Month <- parse_date_time(crimes$Month, "ym")

# Split LSOA.name and retain just the Borough name
crimes <- separate(crimes, LSOA.name, into = c("Borough", "x"), sep = -5)

# Trim the trailing space on 'Borough' and convert it to a factor
library(stringr)
crimes$Borough <- str_trim(crimes$Borough, side = "right")
crimes$Borough <- as.factor(crimes$Borough)
levels(crimes$Borough) # check the different boroughs

# Select and rename some of the variables
crimes <- crimes %>% select(date = Month,
                            location = Location,
                            borough = Borough,
                            lsoa = LSOA.code,
                            category = Crime.type,
                            long = Longitude,
                            lat = Latitude)

# Retain only the Metropolitan Boroughs of Greater Manchester
crimes <- filter(crimes, grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', borough))

# Filter crimes with missing coordinates
crimes <- crimes %>% filter(!is.na(long))

# Retain only police recorded crimes by excluding 'Anti-social behaviour'
crimes <- crimes %>% filter(category != "Anti-social behaviour")

# Export the tidy data as a CSV for later use
write.csv(crimes, "crime_data.csv", row.names = FALSE)
saveRDS(crimes, file="crime_data.rds") # or as a smaller .rds file
