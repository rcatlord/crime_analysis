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

# Using ggplot2
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
ggsave("dotplot.png", scale = 2, dpi = 300)

# Using rcdimple
library(rcdimple)

crimes %>% 
  filter(date == "2015-11-01", 
         category == "Bicycle theft" | category == "Burglary" | category == "Vehicle crime") %>% 
  group_by(category, borough) %>%
  summarise(n = n()) %>% 
  dimple(x = "n", y = "borough", groups = "category", type = "bubble", height = 500, width = 1000) %>%
    xAxis(type = "addMeasureAxis", showGridlines = F, title = "Number of crimes") %>%
    yAxis(type = "addCategoryAxis", orderRule = "Frequency", showGridlines = F, title = "Borough") %>%
    default_colors(RColorBrewer::brewer.pal(n=3,"Set1")) %>%
    add_title(html = paste0("<div style='text-align:center;width:100%'>
                                <b style = 'font-size:100%;'>", paste('Crimes in Greater Manchester during November 2015'),
                            "</div>")) %>% 
    add_legend(x = 500, y = 20, # position the legend on the chart
               # width = 500,
               # height = 20, 
               horizontalAlign = "right")
