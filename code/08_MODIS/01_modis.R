# EXTRACT MODIS EVI OR BOUNDONG BOX

# /research/geog/data2/DATA/pedram/int
# modis.h12v04.evi.int.hdr
# modis.h12v04.evi.int.img

# for the full time series
library(raster)
library(rgdal)
library(rhdf5)
# modsinu = brick("data/modish12v04_midjuly.img")
# 
# # plot(mod)
# projection(modsinu)
# crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 "
# 
# mod = projectRaster(modsinu,crs = crs)
# 
# # crop to ROI
# modRoi = crop(mod, roiExt)
# 
# writeRaster(modRoi,file="data/modis_midjuly_ROI","raster")

modis = brick("data/modis_midjuly_ROI.gri")

# calculationa
modAve = mean(modis)
modave = calc(modis,fun = mean) #same thing

# range
modrange = range(modis)

# summary(modave[1:ncell(modave)] == modAve[1:ncell(modAve)])

modDiff = modis - modAve
# 
# 
# ppi = 300
# plotname = file.path("png",paste("modis",".png",sep = "_"))
# png(filename=plotname,width=18*ppi, height=12*ppi, res=ppi )
# plot(modis)
# dev.off() 
# 
# plotname = file.path("png",paste("modis_hist",".png",sep = "_"))
# png(filename=plotname,width=18*ppi, height=12*ppi, res=ppi )
# hist(modis)
# dev.off() 
# 
# plotname = file.path("png",paste("modis_mean",".png",sep = "_"))
# png(filename=plotname,width=9*ppi, height=6*ppi, res=ppi )
# plot(modAve)
# dev.off() 
# 
# plotname = file.path("png",paste("modis_mean_hist",".png",sep = "_"))
# png(filename=plotname,width=9*ppi, height=6*ppi, res=ppi )
# hist(modAve)
# dev.off() 
# 
# 
# plotname = file.path("png",paste("modis_diff",".png",sep = "_"))
# png(filename=plotname,width=18*ppi, height=12*ppi, res=ppi )
# plot(modDiff)
# dev.off() 
# 
# plotname = file.path("png",paste("modis_diff_hist",".png",sep = "_"))
# png(filename=plotname,width=18*ppi, height=12*ppi, res=ppi )
# hist(modDiff)
# dev.off() 
# 
# plotname = file.path("png",paste("modis_range",".png",sep = "_"))
# png(filename=plotname,width=18*ppi, height=12*ppi, res=ppi )
# plot(modrange)
# dev.off() 



# Averaging 2003 [4]- 2008 [9]
mod03_08 = dropLayer(modis,1:3)
mod03_08 = dropLayer(mod03_08,7:11)
mean_mod03_08 = mean(mod03_08)

# plotname = file.path("png",paste("modis_2003-2008",".png",sep = "_"))
# png(filename=plotname,width=6*ppi, height=9*ppi, res=ppi )
# plot(mod03_08)
# dev.off()

# plotname = file.path("png",paste("modis_2003-2008_hist",".png",sep = "_"))
# png(filename=plotname,width=9*ppi, height=6*ppi, res=ppi )
# hist(mod03_08)
# dev.off()

## write hdf5
h5createFile("modis_mean.h5")

h5createGroup("modis_mean.h5","coord")

lon = coordinates(mean_mod03_08)[,1]
lat = coordinates(mean_mod03_08)[,2]
values = mean_mod03_08@data@values

h5write(lon, "modis_mean.h5","/lon")
h5write(lat, "modis_mean.h5","/lat")
h5write(values, "modis_mean.h5","/values")



# write raster brick

h5ls("modis_mean.h5")

h5createFile("modis.h5")
h5write(lon, "modis.h5","/lon")
h5write(lat, "modis.h5","/lat")

midjuly.4 = values(mod03_08$modish12v04_midjuly.4)
midjuly.5 = values(mod03_08$modish12v04_midjuly.5)
midjuly.6 = values(mod03_08$modish12v04_midjuly.6)
midjuly.7 = values(mod03_08$modish12v04_midjuly.7)
midjuly.8 = values(mod03_08$modish12v04_midjuly.8)
midjuly.9 = values(mod03_08$modish12v04_midjuly.9)

h5write(midjuly.4,"modis.h5","/midjuly_4")
h5write(midjuly.5,"modis.h5","/midjuly_5")
h5write(midjuly.6,"modis.h5","/midjuly_6")
h5write(midjuly.7,"modis.h5","/midjuly_7")
h5write(midjuly.8,"modis.h5","/midjuly_8")
h5write(midjuly.9,"modis.h5","/midjuly_9")



