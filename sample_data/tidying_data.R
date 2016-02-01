## Tidying data ##

# Load the necessary packages
library(tidyr) 
library(dplyr)
library(lubridate)

# Set your working directory to where the CSV files are stored
setwd("../")

# Read the crime data
dec <- read.csv("2014-12-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
jan <- read.csv("2015-01-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
feb <- read.csv("2015-02-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
mar <- read.csv("2015-03-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
apr <- read.csv("2015-04-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
may <- read.csv("2015-05-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
jun <- read.csv("2015-06-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
jul <- read.csv("2015-07-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
aug <- read.csv("2015-08-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
sep <- read.csv("2015-09-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
oct <- read.csv("2015-10-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
nov <- read.csv("2015-11-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)

# Merge the data frames
crimes <- do.call(rbind, list(dec, jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov))
rm(dec, jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov) # remove the unused dataframes from the R session

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
crimes <- crimes %>% select(month = Month,
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
