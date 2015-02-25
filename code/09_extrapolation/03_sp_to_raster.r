library(raster)
library(rgdal)

# MODIS_EVI
proj4string(MODIS_EVI_DF)=CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
MODIS_EVI_DF = spTransform(MODIS_EVI_DF,CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

gridded(MODIS_EVI_DF)=T
r_MODIS_EVI = raster(MODIS_EVI_DF)

projection(r_MODIS_EVI) = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
plot(r_MODIS_EVI, add=T)

# SOIL (irregular)
proj4string(SOIL_DF)=CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
SOIL_DF = spTransform(SOIL_DF,CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

gridded(SOIL_DF)=T
# tolerance error, su ggested:  0.0277778 

pixels = SpatialPixelsDataFrame(SOIL_DF, tolerance=0.0277778, SOIL_DF@data)


r_SOIL = brick (pixels)

projection(r_SOIL) = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
plot(r_SOIL,2)


# | | | | | | rawwaveform
