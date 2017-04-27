### choropleth map app (advanced)

This [shiny](http://shiny.rstudio.com) app uses the [leaflet](https://rstudio.github.io/leaflet/) R package.
<br>
<br>

<img src="https://github.com/rcatlord/crime_analysis/blob/master/images/advanced_choropleth_map_app.png" alt="fig1" width="800">

<br>

Run the app locally in your R session with:

```
library(shiny)
runGitHub("rcatlord/crime_analysis", subdir = "shinyapps/advanced_choropleth_map/")
```

<br>

#### Data sources     
The vector layer of Manchester's Lower Super Output Areas was downloaded from 
[data.gov.uk](https://data.gov.uk/dataset/lower_layer_super_output_area_lsoa_boundaries) 
and mid-2013 population estimates from the [Office for National Statistics](http://www.ons.gov.uk/ons/rel/sape/small-area-population-estimates/mid-2014-and-mid-2013/rft-coa-north-east-2013.zip).
