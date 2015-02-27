library(rgdal)
library(FNN)
library(raster)

load("~/R/carbon-stocks/Rdata/MODIS_EVI.RData")
load("~/R/carbon-stocks/Rdata/SOIL.RData")	
load("~/R/carbon-stocks/Rdata/DEM_DF.RData")	

## get closest modis index for every glas shot [CLOSEST 1 WORKS]
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

## get closest points 
MODIS_knnx_01$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_01$modis_xy,1)
MODIS_knnx_04$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_04$modis_xy,1)
MODIS_knnx_05$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_05$modis_xy,1)
MODIS_knnx_06$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_06$modis_xy,1)
MODIS_knnx_07$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_07$modis_xy,1)
MODIS_knnx_08$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_08$modis_xy,1)
MODIS_knnx_09$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_09$modis_xy,1)
MODIS_knnx_10$modis_pts <-  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_knnx_10$modis_xy,1)

# # range
# range(MODIS_knnx_01$nn.dist)
# range(MODIS_knnx_04$nn.dist)
# range(MODIS_knnx_05$nn.dist)
# range(MODIS_knnx_06$nn.dist)
# range(MODIS_knnx_07$nn.dist)
# range(MODIS_knnx_08$nn.dist)
# range(MODIS_knnx_09$nn.dist)
# range(MODIS_knnx_10$nn.dist)

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
SOIL_knnx_01$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_01$soil_xy,9)
SOIL_knnx_04$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_04$soil_xy,9)
SOIL_knnx_05$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_05$soil_xy,9)
SOIL_knnx_06$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_06$soil_xy,9)
SOIL_knnx_07$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_07$soil_xy,9)
SOIL_knnx_08$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_08$soil_xy,9)
SOIL_knnx_09$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_09$soil_xy,9)
SOIL_knnx_10$soil_pts <-  get.knnx(data =SOIL_DF@coords ,query = SOIL_knnx_10$soil_xy,9)


## Subset cropped soil to neighbour points 
soil_neighbour_01 <- SOIL_DF[as.vector(SOIL_knnx_01$soil_pts$nn.index),]
soil_neighbour_04 <- SOIL_DF[as.vector(SOIL_knnx_04$soil_pts$nn.index),]
soil_neighbour_05 <- SOIL_DF[as.vector(SOIL_knnx_05$soil_pts$nn.index),]
soil_neighbour_06 <- SOIL_DF[as.vector(SOIL_knnx_06$soil_pts$nn.index),]
soil_neighbour_07 <- SOIL_DF[as.vector(SOIL_knnx_07$soil_pts$nn.index),]
soil_neighbour_08 <- SOIL_DF[as.vector(SOIL_knnx_08$soil_pts$nn.index),]
soil_neighbour_09 <- SOIL_DF[as.vector(SOIL_knnx_09$soil_pts$nn.index),]
soil_neighbour_10 <- SOIL_DF[as.vector(SOIL_knnx_10$soil_pts$nn.index),]

#--- DEM

## get closest DEM index for every glas shot
DEM_knnx_01 <- get.knnx(data=DEM_DF@coords, query=DF_GLAH14_01@coords,1)
DEM_knnx_04 <- get.knnx(data=DEM_DF@coords, query=DF_GLAH14_04@coords,1)
DEM_knnx_05 <- get.knnx(data=DEM_DF@coords, query=DF_GLAH14_05@coords,1)
DEM_knnx_06 <- get.knnx(data=DEM_DF@coords, query=DF_GLAH14_06@coords,1)
DEM_knnx_07 <- get.knnx(data=DEM_DF@coords, query=DF_GLAH14_07@coords,1)
DEM_knnx_08 <- get.knnx(data=DEM_DF@coords, query=DF_GLAH14_08@coords,1)
DEM_knnx_09 <- get.knnx(data=DEM_DF@coords, query=DF_GLAH14_09@coords,1)
DEM_knnx_10 <- get.knnx(data=DEM_DF@coords, query=DF_GLAH14_10@coords,1)

## get DEM xy
DEM_knnx_01$DEM_xy <- coordinates(DEM_DF[as.vector(DEM_knnx_01$nn.index),])
DEM_knnx_04$DEM_xy <- coordinates(DEM_DF[as.vector(DEM_knnx_04$nn.index),])
DEM_knnx_05$DEM_xy <- coordinates(DEM_DF[as.vector(DEM_knnx_05$nn.index),])
DEM_knnx_06$DEM_xy <- coordinates(DEM_DF[as.vector(DEM_knnx_06$nn.index),])
DEM_knnx_07$DEM_xy <- coordinates(DEM_DF[as.vector(DEM_knnx_07$nn.index),])
DEM_knnx_08$DEM_xy <- coordinates(DEM_DF[as.vector(DEM_knnx_08$nn.index),])
DEM_knnx_09$DEM_xy <- coordinates(DEM_DF[as.vector(DEM_knnx_09$nn.index),])
DEM_knnx_10$DEM_xy <- coordinates(DEM_DF[as.vector(DEM_knnx_10$nn.index),])

## get 9 closest points
DEM_knnx_01$DEM_pts <-  get.knnx(data =DEM_DF@coords ,query = DEM_knnx_01$DEM_xy,9)
DEM_knnx_04$DEM_pts <-  get.knnx(data =DEM_DF@coords ,query = DEM_knnx_04$DEM_xy,9)
DEM_knnx_05$DEM_pts <-  get.knnx(data =DEM_DF@coords ,query = DEM_knnx_05$DEM_xy,9)
DEM_knnx_06$DEM_pts <-  get.knnx(data =DEM_DF@coords ,query = DEM_knnx_06$DEM_xy,9)
DEM_knnx_07$DEM_pts <-  get.knnx(data =DEM_DF@coords ,query = DEM_knnx_07$DEM_xy,9)
DEM_knnx_08$DEM_pts <-  get.knnx(data =DEM_DF@coords ,query = DEM_knnx_08$DEM_xy,9)
DEM_knnx_09$DEM_pts <-  get.knnx(data =DEM_DF@coords ,query = DEM_knnx_09$DEM_xy,9)
DEM_knnx_10$DEM_pts <-  get.knnx(data =DEM_DF@coords ,query = DEM_knnx_10$DEM_xy,9)


## Subset cropped DEM to neighbour points 
DEM_neighbour_01 <- DEM_DF[as.vector(DEM_knnx_01$DEM_pts$nn.index),]
DEM_neighbour_04 <- DEM_DF[as.vector(DEM_knnx_04$DEM_pts$nn.index),]
DEM_neighbour_05 <- DEM_DF[as.vector(DEM_knnx_05$DEM_pts$nn.index),]
DEM_neighbour_06 <- DEM_DF[as.vector(DEM_knnx_06$DEM_pts$nn.index),]
DEM_neighbour_07 <- DEM_DF[as.vector(DEM_knnx_07$DEM_pts$nn.index),]
DEM_neighbour_08 <- DEM_DF[as.vector(DEM_knnx_08$DEM_pts$nn.index),]
DEM_neighbour_09 <- DEM_DF[as.vector(DEM_knnx_09$DEM_pts$nn.index),]
DEM_neighbour_10 <- DEM_DF[as.vector(DEM_knnx_10$DEM_pts$nn.index),]

rm(DEM_DF)
rm(MODIS_EVI_DF)
rm(SOIL_DF)

DEM_9pts =rbind(DEM_neighbour_01,DEM_neighbour_04,DEM_neighbour_05,DEM_neighbour_06,DEM_neighbour_07,DEM_neighbour_08,DEM_neighbour_09,DEM_neighbour_10)

SOIL_9pts =rbind(soil_neighbour_01,soil_neighbour_04,soil_neighbour_05,soil_neighbour_06,soil_neighbour_07,soil_neighbour_08,soil_neighbour_09,soil_neighbour_10)

MODIS_1pts =rbind(modis_neighbour_01,modis_neighbour_04,modis_neighbour_05,modis_neighbour_06,modis_neighbour_07,modis_neighbour_08,modis_neighbour_09,modis_neighbour_10)

rm(list=ls(pattern ="^DEM_neighbour"))
rm(list=ls(pattern ="^DEM_knnx"))
rm(list=ls(pattern ="^soil_neighbour"))
rm(list=ls(pattern ="^SOIL_knnx"))
rm(list=ls(pattern ="^modis_neighbour"))
rm(list=ls(pattern ="^MODIS_knnx"))

# write.csv(SOIL_9pts,"SOIL_9pts.csv")
# write.csv(DEM_9pts,"DEM_9pts.csv")
# write.csv(MODIS_1pts,"MODIS_1pts.csv")

# DEM_9pts <- read.csv("~/R/carbon-stocks/csv/DEM_9pts.csv")
# DEM_9pts = DEM_9pts[,-1]

# SOIL_9pts <- read.csv("~/R/carbon-stocks/csv/SOIL_9pts.csv")
# SOIL_9pts = SOIL_9pts[,-1]

# MODIS_1pts <- read.csv("~/R/carbon-stocks/csv/MODIS_1pts.csv")
# MODIS_1pts = MODIS_1pts[,-1]

# write.csv(SOIL_9pts,"SOIL_9pts.csv")
# write.csv(DEM_9pts,"DEM_9pts.csv")
# write.csv(MODIS_1pts,"MODIS_1pts.csv")

# careful HERE: only if you have all the elements
# save.image("carbon_stocks_sussex_prj.RData")


