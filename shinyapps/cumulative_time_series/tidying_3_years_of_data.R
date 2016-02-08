## Tidying 3 years of data ##

# Load the necessary packages
library(tidyr) 
library(dplyr)
library(lubridate)

# Set your working directory to where the CSV files are stored
setwd("../")

# Read the 2013 crime data
jan <- read.csv("2013-01-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
feb <- read.csv("2013-02-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
mar <- read.csv("2013-03-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
apr <- read.csv("2013-04-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
may <- read.csv("2013-05-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
jun <- read.csv("2013-06-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
jul <- read.csv("2013-07-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
aug <- read.csv("2013-08-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
sep <- read.csv("2013-09-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
oct <- read.csv("2013-10-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
nov <- read.csv("2013-11-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
dec <- read.csv("2013-12-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)

# Merge the 2013 data frames
crimes_2013 <- do.call(rbind, list(jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec))
rm(jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)

# Read the 2014 crime data
jan <- read.csv("2014-01-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
feb <- read.csv("2014-02-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
mar <- read.csv("2014-03-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
apr <- read.csv("2014-04-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
may <- read.csv("2014-05-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
jun <- read.csv("2014-06-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
jul <- read.csv("2014-07-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
aug <- read.csv("2014-08-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
sep <- read.csv("2014-09-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
oct <- read.csv("2014-10-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
nov <- read.csv("2014-11-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)
dec <- read.csv("2014-12-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)

# Merge the 2014 data frames
crimes_2014 <- do.call(rbind, list(jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec))
rm(jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)

# Read the 2015 crime data
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
dec <- read.csv("2015-12-greater-manchester-street.csv", header = T, stringsAsFactors = FALSE)

# Merge the 2015 data frames
crimes_2015 <- do.call(rbind, list(jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec))
rm(jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)

# Merge the three years
crimes <- do.call(rbind, list(crimes_2013, crimes_2014, crimes_2015))
rm(crimes_2013, crimes_2014, crimes_2015) # remove the unused dataframes from the R session

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
crimes$borough <- droplevels(crimes$borough)

# Filter crimes with missing coordinates
crimes <- crimes %>% filter(!is.na(long))

# Retain only police recorded crimes by excluding 'Anti-social behaviour'
crimes <- crimes %>% filter(category != "Anti-social behaviour")

# Change the class of some variables
crimes$date <- as.Date(crimes$date, format = "%Y-%m_d")
crimes$lsoa <- as.factor(crimes$lsoa)
crimes$category <- as.factor(crimes$category)

# Export the tidy data as a CSV for later use
write.csv(crimes, "crime_data_2013-2015.csv", row.names = FALSE)
saveRDS(crimes, file="crime_data_2013-2015.rds") # or as a smaller .rds file
