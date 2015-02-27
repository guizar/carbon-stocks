# RASTERIZE (TO SHARE WITH ALEX)

# MODIS_1pts
MODIS_RAS = MODIS_1pts
proj4string(MODIS_RAS)=CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
MODIS_RAS = spTransform(MODIS_RAS,CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

gridded(MODIS_RAS)=T
MODIS_RAS = raster(MODIS_RAS)

projection(MODIS_RAS) = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
plot(r_MODIS_EVI, add=T)


filename = file.path("~/R/carbon-stocks/data/","MODIS_1pts.tif")
writeRaster(MODIS_RAS, filename=filename, format="GTiff", overwrite=TRUE)