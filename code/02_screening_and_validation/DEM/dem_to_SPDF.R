library(rgdal)
library(raster)

## Create SPDF with DEM data

# load("~/R/carbon-stocks/Rdata/dem.RData") this dataset is living in APOLLO

DEM_DF <- data.frame(x = as.vector(lons), y= as.vector(lats), DEM = as.vector(dem))


## DF to SPDF : 
coordinates(DEM_DF) <- ~x+y


## PRUEBA

# dem1000<- dem[10000:11000,]
# plot(us_states3)
# plot(roiPoly, add=T)
# points(dem1000)

## Save

save(list = ls(pattern = "DEM_DF"),file = "~/R/carbon-stocks/Rdata/DEM_DF.RData")


