## shiny apps

This sub-directory contains a number of simple [shiny](http://shiny.rstudio.com) apps. You can run them locally in your R session by running the following code: 

```
library(shiny)
runGitHub("cat-lord/crime_analysis", subdir = "shinyapps/bar_charts/")
runGitHub("cat-lord/crime_analysis", subdir = "shinyapps/dotplot/")
runGitHub("cat-lord/crime_analysis", subdir = "shinyapps/time_series/")
```


