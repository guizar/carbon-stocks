library(raster)
library(rgdal)

# # Over DF_SPDF with DEM_SPDF
# # Since DEM is just too large, i'll subset it to every 1000th element
# 
# # Extract every 1000th element
# nth <- round(length(dem_spdf)/1000,digits = 0)
# dem1000 <- dem_spdf[seq(1, length(dem_spdf), nth),]
# 
# plot(roiPoly)
# points(dem1000) ## good to go
# points(DF_GLAH14_01, col="red")
# 

## Define BBoxes
bbox_01<- DF_GLAH14_01@bbox
bbox_04<- DF_GLAH14_04@bbox
bbox_05<- DF_GLAH14_05@bbox
bbox_06<- DF_GLAH14_06@bbox
bbox_07<- DF_GLAH14_07@bbox
bbox_08<- DF_GLAH14_08@bbox
bbox_09<- DF_GLAH14_09@bbox
bbox_10<- DF_GLAH14_10@bbox

## Expand bbox selection
bbox_01[,1] <- bbox_01[,1]-0.00038889
bbox_01[,2] <- bbox_01[,2]+0.00038889
bbox_04[,1] <- bbox_04[,1]-0.00038889
bbox_04[,2] <- bbox_04[,2]+0.00038889
bbox_05[,1] <- bbox_05[,1]-0.00038889
bbox_05[,2] <- bbox_05[,2]+0.00038889
bbox_06[,1] <- bbox_06[,1]-0.00038889
bbox_06[,2] <- bbox_06[,2]+0.00038889
bbox_07[,1] <- bbox_07[,1]-0.00038889
bbox_07[,2] <- bbox_07[,2]+0.00038889
bbox_08[,1] <- bbox_08[,1]-0.00038889
bbox_08[,2] <- bbox_08[,2]+0.00038889
bbox_09[,1] <- bbox_09[,1]-0.00038889
bbox_09[,2] <- bbox_09[,2]+0.00038889
bbox_10[,1] <- bbox_10[,1]-0.00038889
bbox_10[,2] <- bbox_10[,2]+0.00038889

# Start by cropping to DF's

cropped_dem_01 <- crop(dem_spdf, DF_GLAH14_01@bbox)
cropped_dem_04 <- crop(dem_spdf, DF_GLAH14_04@bbox)
cropped_dem_05 <- crop(dem_spdf, DF_GLAH14_05@bbox)
cropped_dem_06 <- crop(dem_spdf, DF_GLAH14_06@bbox)
cropped_dem_07 <- crop(dem_spdf, DF_GLAH14_07@bbox)
cropped_dem_08 <- crop(dem_spdf, DF_GLAH14_08@bbox)
cropped_dem_09 <- crop(dem_spdf, DF_GLAH14_09@bbox)
cropped_dem_10 <- crop(dem_spdf, DF_GLAH14_10@bbox)

save(list = ls(pattern = "cropped_dem_"), file = "cropped_DEMs.RData")

# Unfortunately not getting any match
# Over DF_SPDF DEM_SPDF

# over_01 <- over(x = DF_GLAH14_01, y = cropped_dem_01,returnList = F)
# over_04 <- over(x = DF_GLAH14_04, y = cropped_dem_04,returnList = F)
# over_05 <- over(x = DF_GLAH14_05, y = cropped_dem_05,returnList = F)
# over_06 <- over(x = DF_GLAH14_06, y = cropped_dem_06,returnList = F)
# over_07 <- over(x = DF_GLAH14_07, y = cropped_dem_07,returnList = F)
#over_08 <- over(x = cropped_dem_08, y = testa[,1],returnList = T)
# over_09 <- over(x = DF_GLAH14_09, y = cropped_dem_09,returnList = F)
# over_10 <- over(x = DF_GLAH14_10, y = cropped_dem_10,returnList = F)
# save(list = ls(pattern = "over_"), file = "over.RData")

## spDists no longer necessary
# spDist_01 <- spDists(DF_GLAH14_01, cropped_dem_01, longlat = T)
# spDist_04 <- spDists(DF_GLAH14_04, cropped_dem_04, longlat = T)
# spDist_05 <- spDists(DF_GLAH14_05, cropped_dem_05, longlat = T)
# spDist_06 <- spDists(DF_GLAH14_06, cropped_dem_06, longlat = T)
# spDist_07 <- spDists(DF_GLAH14_07, cropped_dem_07, longlat = T)
# spDist_08 <- spDists(DF_GLAH14_08, cropped_dem_08, longlat = T)
# spDist_09 <- spDists(DF_GLAH14_09, cropped_dem_09, longlat = T)
# spDist_10 <- spDists(DF_GLAH14_10, cropped_dem_10, longlat = T)
# 
# save(list = ls(pattern = "spDist_"), file = "spDist.RData")


