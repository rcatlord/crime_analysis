## Crime analysis in R

This growing repository contains scripts that enable users to load, tidy, manipulate, summarise and (interactively) visualise police recorded crime data in R.

#### Getting started

Download R from [https://cran.r-project.org](https://cran.r-project.org). 

Then read some sample crime data using into your R session:

```
# download the crime_data.csv from GitHub and save it in a f0lder on your computer 
download.file("https://raw.github.com/cat-lord/crime_analysis/master/data/crime_data.csv", 
              destfile = "~/crime_data.csv", method = "curl") 
# set the working directory to where the crime_data.csv file is stored
setwd("~/")
# load crime_data.csv into your R session
crimes <- read.csv("crime_data.csv", header = T)
```

The data are crimes recorded by Greater Manchester Police between December 2014 and November 2015 which were downloaded from [data.police.uk](https://data.police.uk).

The scripts and shiny apps will work with any data downloaded from [data.police.uk](https://data.police.uk) but they will need to be tidy first. Follow the script [here](https://github.com/cat-lord/crime_analysis/blob/master/data/tidying_data.R) for instructions.

#### The scripts
  
* summary statistics
* the 80-20 rule
* repeat locations
* calculating rates of crime (forthcoming)
* point pattern analysis (forthcoming)

There are also several scripts to create simple data visualisations including Cleveland-style dotplots and calendar heatmaps.

#### Shiny apps

This repository also includes several simple [shiny](http://shiny.rstudio.com) apps that allow users to interactively visualise crime data.

* bar charts
* time series

#### Links

* Clarke, R.V., & J.E. Eck. (2003). [Become a Problem Solving Crime Analyst In 55 small steps](http://www.popcenter.org/library/reading/pdfs/55stepsUK.pdf). Jill Dando Institute of Crime Science, University College London.
* Tompson, L., Johnson, S., Ashby, M., Perkins, C., & Edwards, P. (2015). [UK open source crime data: accuracy and possibilities for research](http://www.tandfonline.com/doi/full/10.1080/15230406.2014.972456). Cartography and Geographic Information Science, 42(2), 97-111.

