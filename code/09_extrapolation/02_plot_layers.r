# plot
library(ggplot2)

# modis evi
MODIS_EVI = data.frame(value=MODIS_EVI_DF@data, x=MODIS_EVI_DF@coords[,1], y=MODIS_EVI_DF@coords[,2])
                                  
m1 = ggplot() + geom_raster(data=MODIS_EVI,aes(fill=modis_evi,x=x, y=y),interpolate = T)
m1



# soil
SOIL = data.frame(value=SOIL_DF@data, x=SOIL_DF@coords[,1], y=SOIL_DF@coords[,2])

# clay
m2 = ggplot() + geom_raster(data=SOIL,aes(fill=value.clay,x=x, y=y),interpolate = T)
m2

# sand
m2 = ggplot() + geom_raster(data=SOIL,aes(fill=value.sand,x=x, y=y),interpolate = T)
m2


# DEM neighbours
demneigh = data.frame(value=dem_neighbours@data, x=dem_neighbours@coords[,1], y=dem_neighbours@coords[,2])

m1 = ggplot() + geom_raster(data=demneigh,aes(fill=dem,x=x, y=y),interpolate = T)
m1





