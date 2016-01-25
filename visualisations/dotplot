## Dotplots ##

# The Cleveland dotplot originally featured in William S. Cleveland’s book Elements of Graphing Data (1985). 
# It is similar to a bar chart but uses position rather than length to display values. 

# Load the necessary packages
library(dplyr)

# Set your working directory to where the crime data are stored
setwd("../")

# Read the data
crimes <- read.csv("crime_data.csv", header = T)

# Frequency of Burglary by borough (in descending order)
df <- crimes %>% 
  filter(category == "Burglary") %>% 
  group_by(borough) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  arrange(desc(n))

# Create a Cleveland dotplot using ggplot2
library(ggplot2)
ggplot(df, aes(x = reorder(borough, n), y = n)) + 
  geom_point(size = 12, stat = "identity", color = "black") + 
  geom_text(aes(label = n, fontface = "bold"), color = "white", size = 4) + 
  coord_flip() + 
  theme_minimal(base_size = 20) + 
  xlab("") + ylab("") + 
  ggtitle("Burglary offences in Greater Manchester") +
  scale_y_continuous(limits=c(0,max(df$n)))

# Save the dotplot as a png file
ggsave("dotplot.png", scale = 1.5, dpi = 300)
