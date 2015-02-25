library(rhdf5)
library(raster)
library(rgdal)

setwd("/home/a/ag/ag448/Documents/carbon-stocks")

## Maps
### writeOGR(us, ".", "data/us_states", driver = "ESRI Shapefile")
us_states49 = readOGR(dsn = "data/us_states.shp", layer = "us_states")
us = readOGR(dsn = "data/us_map.shp", layer = "us_map")
####  world = readOGR(dsn="data/countries_shp/countries.shp", layer="countries")

## Explore files
head(us_map)
us_map$NAME_1

---
## New SPDF with states
###     List of states
states_list <-c("Massachusetts", "New Hampshire", "Vermont")
###     Convert from characters to factors
us$NAME_1 <-as.character(us$NAME_1)
###     Subset
states <-us[(us$NAME_1 %in% states_list),]

## Delimit area of study
study_area <- extent(-72.5,-71.75,42.0,43.5)

---
