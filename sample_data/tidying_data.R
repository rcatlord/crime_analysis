## Tidying data ##

# Download crime data from data.police.uk and unzip the folders
# Place all of the CSV files into a single folder called 'data'

# Install the necessary R packages
install.packages(c("tidyverse", "lubridate", "stringr"))

# Load the packages
library(tidyverse) ; library(lubridate) ; library(stringr)

# Set your working directory to the folder where the CSV files are stored
setwd("../data")

# Find all file names in the 'data' folder that end in .csv
filenames <- dir(pattern = "*.csv")
filenames

# Read in the files and combine them into one data frame
crimes <- filenames %>% 
  map(read_csv) %>%
  reduce(rbind)

# Check the data
glimpse(crimes)

# Convert ‘Month’ to a date variable
crimes$Month <- parse_date_time(crimes$Month, "ym")

# Split LSOA.name and retain just the Borough name
crimes <- separate(crimes, `LSOA name`, into = c("Borough", "x"), sep = -5)

# Trim the trailing space on 'Borough' and convert it to a factor
crimes$Borough <- str_trim(crimes$Borough, side = "right") 
crimes$Borough <- as.factor(crimes$Borough)
levels(crimes$Borough) # check the different boroughs

# Select and rename some of the variables
crimes <- crimes %>% select(date = Month,
                            location = Location,
                            borough = Borough,
                            lsoa = `LSOA code`,
                            category = `Crime type`,
                            long = Longitude,
                            lat = Latitude)

# Retain only the Metropolitan Boroughs of Greater Manchester
crimes <- filter(crimes, grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', borough))

# Filter crimes with missing coordinates
crimes <- crimes %>% filter(!is.na(long))

# Retain only police recorded crimes by excluding 'Anti-social behaviour'
crimes <- crimes %>% filter(category != "Anti-social behaviour")

# Export the tidy data as a CSV for later use
write_csv(crimes, "crime_data.csv")
saveRDS(crimes, file="crime_data.rds") # or as a smaller .rds file
