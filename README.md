## Crime analysis in R

This growing repository contains scripts that enable users to load, tidy, manipulate, summarise and (interactively) visualise police recorded crime data in R.

#### Getting started

Download R from [https://cran.r-project.org](https://cran.r-project.org) and load some sample crime data into your R session:

``` r
install.packages(c("tidyverse", "lubridate"))

library(tidyverse) ; library(lubridate)

crimes <- read_csv("https://raw.githubusercontent.com/rcatlord/crime_analysis/master/sample_data/crime_data.csv") %>% 
  mutate(date = ymd(date))
```

or just right-click on the ['Raw'](https://github.com/cat-lord/crime_analysis/blob/master/sample_data/crime_data.csv) button and download the CSV file:

<img src="https://github.com/cat-lord/crime_analysis/blob/master/images/raw.png" alt="raw" width="200">

The data are crimes recorded by Greater Manchester Police between January and December 2015 which were downloaded from [data.police.uk](https://data.police.uk).

The scripts and [shiny](http://shiny.rstudio.com) apps will work with any data downloaded from [data.police.uk](https://data.police.uk) but they will need to share the same structure, i.e. be [tidy](https://vimeo.com/33727555) first. Follow the [tidying_data](https://github.com/cat-lord/crime_analysis/blob/master/sample_data/tidying_data.R) script for instructions.

#### The scripts
  
* [summary statistics](https://github.com/cat-lord/crime_analysis/blob/master/scripts/summary_statistics.R)
* [the 80-20 rule](https://github.com/cat-lord/crime_analysis/blob/master/scripts/the_80-20_rule.R)
* [repeat locations](https://github.com/cat-lord/crime_analysis/blob/master/scripts/repeat_locations.R)
* calculating rates of crime (forthcoming)
* point pattern analysis (forthcoming)

#### Data visualisations

There are several scripts to create simple [data visualisations](https://github.com/cat-lord/crime_analysis/tree/master/data_visualisations) including Cleveland-style dotplots and calendar heatmaps.

#### Shiny apps

This repository includes several simple [shiny apps](https://github.com/cat-lord/crime_analysis/tree/master/shinyapps) that allow users to interactively visualise crime data.

* [bar charts](https://github.com/cat-lord/crime_analysis/tree/master/shinyapps/bar_charts)
* [choropleth map (basic)](https://github.com/cat-lord/crime_analysis/tree/master/shinyapps/basic_choropleth_map)
* [choropleth map (advanced)](https://github.com/cat-lord/crime_analysis/tree/master/shinyapps/advanced_choropleth_map)
* [cumulative time series](https://github.com/cat-lord/crime_analysis/tree/master/shinyapps/cumulative_time_series)
* [dotplot](https://github.com/cat-lord/crime_analysis/tree/master/shinyapps/dotplot)
* [time series](https://github.com/cat-lord/crime_analysis/tree/master/shinyapps/time_series)

#### Links

* Brunsdon, C., & Comber, L. (2015). [An Introduction to R for Spatial Analysis and Mapping](https://uk.sagepub.com/en-gb/eur/an-introduction-to-r-for-spatial-analysis-and-mapping/book241031). London: Sage.
* Clarke, R.V., & J.E. Eck. (2003). [Become a Problem Solving Crime Analyst In 55 small steps](http://www.popcenter.org/library/reading/pdfs/55stepsUK.pdf). Jill Dando Institute of Crime Science, University College London.
* Lovelace, R. & Cheshire, J. (2014 and ongoing). Introduction to visualising spatial data in R. 
([PDF](https://cran.r-project.org/doc/contrib/intro-spatial-rl.pdf) | [GitHub repo](https://github.com/Robinlovelace/Creating-maps-in-R))
