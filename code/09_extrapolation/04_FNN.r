library(rgdal)
library(FNN)
library(raster)

load("~/R/carbon-stocks/Rdata/MODIS_EVI.RData")
load("~/R/carbon-stocks/Rdata/SOIL.RData")

## get closest modis index for every glas shot
MODIS_knnx_01 <- get.knnx(data=MODIS_EVI_DF@coords, query=DF_GLAH14_01@coords,1)
MODIS_knnx_04 <- get.knnx(data=MODIS_EVI_DF@coords, query=DF_GLAH14_04@coords,1)
MODIS_knnx_05 <- get.knnx(data=MODIS_EVI_DF@coords, query=DF_GLAH14_05@coords,1)
MODIS_knnx_06 <- get.knnx(data=MODIS_EVI_DF@coords, query=DF_GLAH14_06@coords,1)
MODIS_knnx_07 <- get.knnx(data=MODIS_EVI_DF@coords, query=DF_GLAH14_07@coords,1)
MODIS_knnx_08 <- get.knnx(data=MODIS_EVI_DF@coords, query=DF_GLAH14_08@coords,1)
MODIS_knnx_09 <- get.knnx(data=MODIS_EVI_DF@coords, query=DF_GLAH14_09@coords,1)
MODIS_knnx_10 <- get.knnx(data=MODIS_EVI_DF@coords, query=DF_GLAH14_10@coords,1)

## get modis xy
MODIS_knnx_01$modis_xy <- coordinates(MODIS_EVI_DF[as.vector(MODIS_knnx_01$nn.index),])
MODIS_knnx_04$modis_xy <- coordinates(MODIS_EVI_DF[as.vector(MODIS_knnx_04$nn.index),])
MODIS_knnx_05$modis_xy <- coordinates(MODIS_EVI_DF[as.vector(MODIS_knnx_05$nn.index),])
MODIS_knnx_06$modis_xy <- coordinates(MODIS_EVI_DF[as.vector(MODIS_knnx_06$nn.index),])
MODIS_knnx_07$modis_xy <- coordinates(MODIS_EVI_DF[as.vector(MODIS_knnx_07$nn.index),])
MODIS_knnx_08$modis_xy <- coordinates(MODIS_EVI_DF[as.vector(MODIS_knnx_08$nn.index),])
MODIS_knnx_09$modis_xy <- coordinates(MODIS_EVI_DF[as.vector(MODIS_knnx_09$nn.index),])
MODIS_knnx_10$modis_xy <- coordinates(MODIS_EVI_DF[as.vector(MODIS_knnx_10$nn.index),])

## get 9 closest points
MODIS_knnx_01$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_01$modis_xy,9)
MODIS_knnx_04$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_04$modis_xy,9)
MODIS_knnx_05$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_05$modis_xy,9)
MODIS_knnx_06$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_06$modis_xy,9)
MODIS_knnx_07$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_07$modis_xy,9)
MODIS_knnx_08$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_08$modis_xy,9)
MODIS_knnx_09$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_09$modis_xy,9)
MODIS_knnx_10$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_10$modis_xy,9)

# range
range(MODIS_knnx_01$nn.dist)
range(MODIS_knnx_04$nn.dist)
range(MODIS_knnx_05$nn.dist)
range(MODIS_knnx_06$nn.dist)
range(MODIS_knnx_07$nn.dist)
range(MODIS_knnx_08$nn.dist)
range(MODIS_knnx_09$nn.dist)
range(MODIS_knnx_10$nn.dist)

## Subset cropped modis to neighbour points 
modis_neighbour_01 <- MODIS_EVI_DF[as.vector(MODIS_knnx_01$modis_pts$nn.index),]
modis_neighbour_04 <- MODIS_EVI_DF[as.vector(MODIS_knnx_04$modis_pts$nn.index),]
modis_neighbour_05 <- MODIS_EVI_DF[as.vector(MODIS_knnx_05$modis_pts$nn.index),]
modis_neighbour_06 <- MODIS_EVI_DF[as.vector(MODIS_knnx_06$modis_pts$nn.index),]
modis_neighbour_07 <- MODIS_EVI_DF[as.vector(MODIS_knnx_07$modis_pts$nn.index),]
modis_neighbour_08 <- MODIS_EVI_DF[as.vector(MODIS_knnx_08$modis_pts$nn.index),]
modis_neighbour_09 <- MODIS_EVI_DF[as.vector(MODIS_knnx_09$modis_pts$nn.index),]
modis_neighbour_10 <- MODIS_EVI_DF[as.vector(MODIS_knnx_10$modis_pts$nn.index),]


#---- SOIL
## get closest soil index for every glas shot
SOIL_knnx_01 <- get.knnx(data=SOIL_DF@coords, query=DF_GLAH14_01@coords,1)
SOIL_knnx_04 <- get.knnx(data=SOIL_DF@coords, query=DF_GLAH14_04@coords,1)
SOIL_knnx_05 <- get.knnx(data=SOIL_DF@coords, query=DF_GLAH14_05@coords,1)
SOIL_knnx_06 <- get.knnx(data=SOIL_DF@coords, query=DF_GLAH14_06@coords,1)
SOIL_knnx_07 <- get.knnx(data=SOIL_DF@coords, query=DF_GLAH14_07@coords,1)
SOIL_knnx_08 <- get.knnx(data=SOIL_DF@coords, query=DF_GLAH14_08@coords,1)
SOIL_knnx_09 <- get.knnx(data=SOIL_DF@coords, query=DF_GLAH14_09@coords,1)
SOIL_knnx_10 <- get.knnx(data=SOIL_DF@coords, query=DF_GLAH14_10@coords,1)

## get soil xy
SOIL_knnx_01$soil_xy <- coordinates(SOIL_DF[as.vector(SOIL_knnx_01$nn.index),])
SOIL_knnx_04$soil_xy <- coordinates(SOIL_DF[as.vector(SOIL_knnx_04$nn.index),])
SOIL_knnx_05$soil_xy <- coordinates(SOIL_DF[as.vector(SOIL_knnx_05$nn.index),])
SOIL_knnx_06$soil_xy <- coordinates(SOIL_DF[as.vector(SOIL_knnx_06$nn.index),])
SOIL_knnx_07$soil_xy <- coordinates(SOIL_DF[as.vector(SOIL_knnx_07$nn.index),])
SOIL_knnx_08$soil_xy <- coordinates(SOIL_DF[as.vector(SOIL_knnx_08$nn.index),])
SOIL_knnx_09$soil_xy <- coordinates(SOIL_DF[as.vector(SOIL_knnx_09$nn.index),])
SOIL_knnx_10$soil_xy <- coordinates(SOIL_DF[as.vector(SOIL_knnx_10$nn.index),])

## get 9 closest points
SOIL_knnx_01$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_01$soil_xy,9*3)
SOIL_knnx_04$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_04$soil_xy,9*3)
SOIL_knnx_05$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_05$soil_xy,9*3)
SOIL_knnx_06$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_06$soil_xy,9*3)
SOIL_knnx_07$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_07$soil_xy,9*3)
SOIL_knnx_08$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_08$soil_xy,9*3)
SOIL_knnx_09$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_09$soil_xy,9*3)
SOIL_knnx_10$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_10$soil_xy,9*3)


## Subset cropped soil to neighbour points 
soil_neighbour_01 <- SOIL_DF[as.vector(SOIL_knnx_01$soil_pts$nn.index),]
soil_neighbour_04 <- SOIL_DF[as.vector(SOIL_knnx_04$soil_pts$nn.index),]
soil_neighbour_05 <- SOIL_DF[as.vector(SOIL_knnx_05$soil_pts$nn.index),]
soil_neighbour_06 <- SOIL_DF[as.vector(SOIL_knnx_06$soil_pts$nn.index),]
soil_neighbour_07 <- SOIL_DF[as.vector(SOIL_knnx_07$soil_pts$nn.index),]
soil_neighbour_08 <- SOIL_DF[as.vector(SOIL_knnx_08$soil_pts$nn.index),]
soil_neighbour_09 <- SOIL_DF[as.vector(SOIL_knnx_09$soil_pts$nn.index),]
soil_neighbour_10 <- SOIL_DF[as.vector(SOIL_knnx_10$soil_pts$nn.index),]

# LONLAT
# 1.5 arc sec radious
# 3 arc seco


# 0.0002777778, 0.0002777778  * 3
# DEM might be the same res
# zoom in plot, see what's happening
