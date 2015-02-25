library(rgdal)
library(raster)

## Create SPDF with DEM data

load("~/R/carbon-stocks/Rdata/dem.RData")

dem <- data.frame(x = as.vector(lons), y= as.vector(lats), dem = as.vector(dem))


## DF to SPDF : 
coordinates(dem) <- ~x+y


## PRUEBA

dem1000<- dem[10000:11000,]
plot(us_states3)
plot(roiPoly, add=T)
points(dem1000)

## Save
dem_spdf <- dem
save(list = ls(pattern = "dem_spdf"),file = "dem_spdf.RData")


