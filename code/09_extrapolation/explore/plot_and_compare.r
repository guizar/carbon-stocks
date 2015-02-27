library(raster)
library(rgdal)

load("~/R/carbon-stocks/Rdata/MODIS_EVI.RData")
load("~/R/carbon-stocks/Rdata/SOIL.RData")

#----- PLOT GLAS SHOTS AGAINST RASTERS 

# Rasterize SPDF
source("~/R/carbon-stocks/code/09_extrapolation/03_sp_to_raster.r")


#---- Plot and compare
plot(us_states3)
plot(roiPoly, add=T)
plot(soil_neighbour_10, add=T)

# ext1= drawExtent() ## LOW ZOOM
ext = extent(71.83263,-71.82401,43.1067,43.11392) ## HIGH ZOOM

# MODIS

plot(r_MODIS_EVI ,xlim =c(xmin(ext),xmax(ext)), ylim=c(ymin(ext), ymax(ext)))
plot(DF_GLAH14_10, col="Red", pch=19, add=T)
text(modis_neighbour_10,labels = c(1:9), cex=0.5)


# SOIL
# plot and compare
plot(r_SOIL, 2,xlim =c(xmin(ext),xmax(ext)), ylim=c(ymin(ext), ymax(ext)))
plot(DF_GLAH14_10, col="Red", pch=19, add=T)
text(soil_neighbour_10,labels = c(1:27), cex=0.5)
