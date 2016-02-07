## Heatmap ##

# Load the necessary packages
library(dplyr) 
library(tidyr)

# Set your working directory to where the crime data are stored
setwd("../")

# Read the data
crimes <- read.csv("crime_data.csv", header = T)

## Using ggplot2
library(ggplot2)

df <- crimes %>%
  filter(borough == "Manchester") %>%
  group_by(category, date) %>%
  summarise(n = n())

ggplot(df, aes(x=category, y=date, fill=n)) +
  geom_tile(aes(fill=n)) +
  geom_text(aes(label=n), size=4, color="black") +
  scale_x_discrete("", expand = c(0,0)) +
  scale_y_discrete("", expand = c(0,-2)) +
  scale_fill_gradient("Frequency", low = "white", high = "steelblue") +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  theme(axis.text=element_text(size=12)) +
  theme(legend.position="none") +
  ggtitle("Crime levels in Manchester by month\n") +
  theme(plot.title = element_text(face="bold", size="20"))

ggsave("calendar_heatmap.png", scale = 1, dpi = 300)

## Using d3heatmap
library(d3heatmap)

df <- crimes %>%
  filter(borough == "Manchester") %>%
  group_by(category, date) %>%
  summarise(n = n()) %>%
  spread(date, n, fill = 0)
row.names(df) <- df$category
df$category <- NULL

d3heatmap(df, scale="column", dendrogram = "none",
          color = scales::col_quantile("Blues", NULL, 5),
          # color = scales::col_bin("Blues", NULL, bins = 7, pretty = TRUE, na.color = "#808080"),
          xaxis_font_size = 10, yaxis_font_size = 10)



