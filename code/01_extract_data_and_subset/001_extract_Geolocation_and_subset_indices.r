library(raster)
library(rgdal)
library(rhdf5)


### Setwd
setwd("/home/a/ag/ag448/Documents/carbon-stocks")
# setwd("~/R/carbon-stocks")


#/////////////////////////// GLAH14
GL14_wd<- 'data/GLAS/GLAH14' 
files_GLAH14 <- data.frame(id=formatC(seq_len(length(list.files(path = GL14_wd))), width=2, flag="0"), file=list.files(path = GL14_wd, pattern =".H5", full.names = F) ,stringsAsFactors = F )
write.csv(files_GLAH14, file="data/files_GLAH14.csv", row.names=F)
files_GLAH14[,1] <- as.numeric(files_GLAH14[,1])


## Extract Geolocation attributes
### Define att object
att_Geoloc <- "/Data_40HZ/Geolocation/"

#### Extract Lon Lat values
for (id in files_GLAH14$id){
        assign(paste("geo_GLAH14",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]), att_Geoloc))
        rm(id)
}

### Group geolocation values in a single list, and delete individual objects
ind_geo_GLAH14 <-ls(pattern="^geo_GLAH14",)
list_geo_GLAH14 <- mget(ind_geo_GLAH14, .GlobalEnv)
rm(list = ind_geo_GLAH14)


## Create a data.frame with the xy path for each GLAS file
for(i in seq_len(length(list_geo_GLAH14))) {
        x <-  list_geo_GLAH14[[i]][[2, drop=T]]
        x <- x - 360 ## wgs84 adjustment
        y <-  list_geo_GLAH14[[i]][[1, drop=T]]
        assign(paste("xycoord_GLAH14",formatC(i,width=2,flag="0"),sep="_"), data.frame(x,y))
        rm(x)
        rm(y) 
        rm(i)
}


### Melt XY obj in a single list and delete them
ind_xy_GLAH14 <-ls(pattern="^xycoord_GLAH14",) 
list_xy_GLAH14 <- mget(ind_xy_GLAH14, .GlobalEnv)
rm(list = ind_xy_GLAH14)


## Extract Index and shot number attributes
#### Define attributes

att_i_rec_ndx <- "/Data_40HZ/Time/i_rec_ndx" ## Record index
att_i_shot_count <- "/Data_40HZ/Time/i_shot_count" ## shot count

### Extract record indices
for (id in files_GLAH14$id){
        assign(paste("i_rec_GLAH14",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_i_rec_ndx))
        rm(id)
}

#### Extract i_shot_count data
for (id in files_GLAH14$id){
        assign(paste("i_shot_GLAH14",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_i_shot_count))
        rm(id)
}

## Attributes lists to data.frame
### Melt attribute obj in a single list and delete them
ind_i_rec_GLAH14 <-ls(pattern="^i_rec_GLAH14",)
ind_i_shot_GLAH14 <-ls(pattern="^i_shot_GLAH14",)

list_i_rec_GLAH14 <- mget(ind_i_rec_GLAH14, .GlobalEnv)
list_i_shot_GLAH14 <- mget(ind_i_shot_GLAH14, .GlobalEnv)

rm(list = ind_i_shot_GLAH14)


### Create Data Frames by: | x | y | i_rec | i_shot |
for (i in files_GLAH14$id){
        assign(paste("DF_GLAH14",formatC(i,width=2,flag="0"),sep="_"), data.frame(x = list_xy_GLAH14[[i]][,1], y = list_xy_GLAH14[[i]][,2], i_rec_ndx= list_i_rec_GLAH14[[i]], i_shot_count= list_i_shot_GLAH14[[i]]))
        rm(i)
}


## Create SpatialPointsDataFrame and Crop to ROI
### Convert DF to SpatialPointsDataFrame

coordinates(DF_GLAH14_01) <- ~x+y
coordinates(DF_GLAH14_02) <- ~x+y
coordinates(DF_GLAH14_03) <- ~x+y
coordinates(DF_GLAH14_04) <- ~x+y
coordinates(DF_GLAH14_05) <- ~x+y
coordinates(DF_GLAH14_06) <- ~x+y
coordinates(DF_GLAH14_07) <- ~x+y
coordinates(DF_GLAH14_08) <- ~x+y
coordinates(DF_GLAH14_09) <- ~x+y
coordinates(DF_GLAH14_10) <- ~x+y
coordinates(DF_GLAH14_11) <- ~x+y

### Define a ROI
roiExt  <- extent(-72.5,-71.75,42.0,43.5)
roiPoly <- as(roiExt, 'SpatialPolygons') 

### Crop to ROI
cropped_GLAH14_01 <- crop(x = DF_GLAH14_01 ,y = roiPoly)
cropped_GLAH14_02 <- crop(x = DF_GLAH14_02 ,y = roiPoly)
cropped_GLAH14_03 <- crop(x = DF_GLAH14_03 ,y = roiPoly)
cropped_GLAH14_04 <- crop(x = DF_GLAH14_04 ,y = roiPoly)
cropped_GLAH14_05 <- crop(x = DF_GLAH14_05 ,y = roiPoly)
cropped_GLAH14_06 <- crop(x = DF_GLAH14_06 ,y = roiPoly)
cropped_GLAH14_07 <- crop(x = DF_GLAH14_07 ,y = roiPoly)
cropped_GLAH14_08 <- crop(x = DF_GLAH14_08 ,y = roiPoly)
cropped_GLAH14_09 <- crop(x = DF_GLAH14_09 ,y = roiPoly)
cropped_GLAH14_10 <- crop(x = DF_GLAH14_10 ,y = roiPoly)
cropped_GLAH14_11 <- crop(x = DF_GLAH14_11 ,y = roiPoly)



### Which DFs were left standing? (i.e. data found within bbox)
ind_cropped_GLAH14 <-ls(pattern="^cropped_GLAH14",)
list_cropped_GLAH14 <- mget(ind_cropped_GLAH14, .GlobalEnv)

out <-capture.output(summary(list_cropped_GLAH14))
cat(out,file="data/cropped_files_GLAH14.txt",sep="\n",append=F) ## Have a look at this file

rm(list_cropped_GLAH14)


### Remove DF which data is outside BBOX
rm(DF_GLAH14_02)
rm(DF_GLAH14_03)
rm(DF_GLAH14_11)

### Extract TRUE value indices
indices_GLAH14_01 <- as.numeric(row.names(cropped_GLAH14_01))
indices_GLAH14_04 <- as.numeric(row.names(cropped_GLAH14_04))
indices_GLAH14_05 <- as.numeric(row.names(cropped_GLAH14_05))
indices_GLAH14_06 <- as.numeric(row.names(cropped_GLAH14_06))
indices_GLAH14_07 <- as.numeric(row.names(cropped_GLAH14_07))
indices_GLAH14_08 <- as.numeric(row.names(cropped_GLAH14_08))
indices_GLAH14_09 <- as.numeric(row.names(cropped_GLAH14_09))
indices_GLAH14_10 <- as.numeric(row.names(cropped_GLAH14_10))


### Remove unused values
DF_GLAH14_01 <- cropped_GLAH14_01
DF_GLAH14_04 <- cropped_GLAH14_04
DF_GLAH14_05 <- cropped_GLAH14_05
DF_GLAH14_06 <- cropped_GLAH14_06
DF_GLAH14_07 <- cropped_GLAH14_07
DF_GLAH14_08 <- cropped_GLAH14_08
DF_GLAH14_09 <- cropped_GLAH14_09
DF_GLAH14_10 <- cropped_GLAH14_10

### Final summary
ind_sum_GLAH14 <-ls(pattern="^DF_GLAH14",)
list_sum_GLAH14 <- mget(ind_sum_GLAH14, .GlobalEnv)

summary <- out<-capture.output(summary(list_sum_GLAH14))
cat(out,file="data/summary_GLAH14.txt",sep="\n",append=F) ## Have a look at this file

### Remove unused obj
rm(list=ind_i_rec_GLAH14)
rm(list=ind_cropped_GLAH14)
rm(GL14_wd)
rm(out)
rm(summary)
rm(list=ls(pattern="^att_",))
rm(list=ls(pattern="^list",))
rm(list=ls(pattern="^ind_",))



#### GLAH01 ////////////////

GL01_wd<- 'data/GLAS/GLAH01' 

files_GLAH01 <- data.frame(id=formatC(seq_len(length(list.files(path = GL01_wd))), width=2, flag="0"), file=list.files(path = GL01_wd, pattern =".H5", full.names = F) ,stringsAsFactors = F )
write.csv(files_GLAH01, file="data/files_GLAH01.csv", row.names=F)
files_GLAH01[,1] <- as.numeric(files_GLAH01[,1])


## Extract Geolocation attributes
### Define att object
att_Geoloc <- "/Data_1HZ/Geolocation/"

#### Extract Lon Lat values
for (id in files_GLAH01$id){
        assign(paste("geo_GLAH01",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL01_wd,files_GLAH01[[c(2,id)]]), att_Geoloc))
        rm(id)
}

### Group geolocation values in a single list, and delete individual objects
ind_geo_GLAH01 <-ls(pattern="^geo_GLAH01",)
list_geo_GLAH01 <- mget(ind_geo_GLAH01, .GlobalEnv)
rm(list = ind_geo_GLAH01)


## Create a data.frame with the xy path for each GLAS file
for(i in seq_len(length(list_geo_GLAH01))) {
        x <-  list_geo_GLAH01[[i]][[2, drop=T]]
        x <- x - 360 ## wgs84 adjustment
        x <- rep(x, each=40)
        y <-  list_geo_GLAH01[[i]][[1, drop=T]]
        y <- rep(y, each=40)
        assign(paste("xycoord_GLAH01",formatC(i,width=2,flag="0"),sep="_"), data.frame(x,y))
        rm(x)
        rm(y) 
        rm(i)
}


### Melt XY obj in a single list and delete them
ind_xy_GLAH01 <-ls(pattern="^xycoord_GLAH01",) 
list_xy_GLAH01 <- mget(ind_xy_GLAH01, .GlobalEnv)
rm(list = ind_xy_GLAH01)


# Extract Index and shot number attributes
### Define attributes

att_i_rec_ndx <- "/Data_40HZ/Time/i_rec_ndx" ## Record index
att_i_shot_count <- "/Data_40HZ/Time/i_shot_count" ## shot count

### Extract record indices
for (id in files_GLAH01$id){
        assign(paste("i_rec_GLAH01",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL01_wd,files_GLAH01[[c(2,id)]]),att_i_rec_ndx))
        rm(id)
}

#### Extract i_shot_count data
for (id in files_GLAH01$id){
        assign(paste("i_shot_GLAH01",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL01_wd,files_GLAH01[[c(2,id)]]),att_i_shot_count))
        rm(id)
}

## Attributes lists to data.frame
### Melt attribute obj in a single list and delete them
ind_i_rec_GLAH01 <-ls(pattern="^i_rec_GLAH01",)
ind_i_shot_GLAH01 <-ls(pattern="^i_shot_GLAH01",)

list_i_rec_GLAH01 <- mget(ind_i_rec_GLAH01, .GlobalEnv)
list_i_shot_GLAH01 <- mget(ind_i_shot_GLAH01, .GlobalEnv)

rm(list = ind_i_shot_GLAH01)


### Create Data Frames by: | x | y | i_rec | i_shot |
for (i in files_GLAH01$id){
        assign(paste("DF_GLAH01",formatC(i,width=2,flag="0"),sep="_"), data.frame(x = list_xy_GLAH01[[i]][,1], y = list_xy_GLAH01[[i]][,2], i_rec_ndx= list_i_rec_GLAH01[[i]], i_shot_count= list_i_shot_GLAH01[[i]]))
        rm(i)
}


## Create SpatialPointsDataFrame and Crop to ROI
### Convert DF to SpatialPointsDataFrame

coordinates(DF_GLAH01_01) <- ~x+y
coordinates(DF_GLAH01_02) <- ~x+y
coordinates(DF_GLAH01_03) <- ~x+y
coordinates(DF_GLAH01_04) <- ~x+y
coordinates(DF_GLAH01_05) <- ~x+y
coordinates(DF_GLAH01_06) <- ~x+y
coordinates(DF_GLAH01_07) <- ~x+y
coordinates(DF_GLAH01_08) <- ~x+y
coordinates(DF_GLAH01_09) <- ~x+y
coordinates(DF_GLAH01_10) <- ~x+y
coordinates(DF_GLAH01_11) <- ~x+y
coordinates(DF_GLAH01_12) <- ~x+y
coordinates(DF_GLAH01_13) <- ~x+y

### Define a ROI
roiExt  <- extent(-72.5,-71.75,42.0,43.5)
roiPoly <- as(roiExt, 'SpatialPolygons') 

### Crop to ROI
cropped_GLAH01_01 <- crop(x = DF_GLAH01_01 ,y = roiPoly)
cropped_GLAH01_02 <- crop(x = DF_GLAH01_02 ,y = roiPoly)
cropped_GLAH01_03 <- crop(x = DF_GLAH01_03 ,y = roiPoly)
cropped_GLAH01_04 <- crop(x = DF_GLAH01_04 ,y = roiPoly)
cropped_GLAH01_05 <- crop(x = DF_GLAH01_05 ,y = roiPoly)
cropped_GLAH01_06 <- crop(x = DF_GLAH01_06 ,y = roiPoly)
cropped_GLAH01_07 <- crop(x = DF_GLAH01_07 ,y = roiPoly)
cropped_GLAH01_08 <- crop(x = DF_GLAH01_08 ,y = roiPoly)
cropped_GLAH01_09 <- crop(x = DF_GLAH01_09 ,y = roiPoly)
cropped_GLAH01_10 <- crop(x = DF_GLAH01_10 ,y = roiPoly)
cropped_GLAH01_11 <- crop(x = DF_GLAH01_11 ,y = roiPoly)
cropped_GLAH01_12 <- crop(x = DF_GLAH01_12 ,y = roiPoly)
cropped_GLAH01_13 <- crop(x = DF_GLAH01_13 ,y = roiPoly)

### Which DFs were left standing? (i.e. data found within bbox)
ind_cropped_GLAH01 <-ls(pattern="^cropped_GLAH01",)
list_cropped_GLAH01 <- mget(ind_cropped_GLAH01, .GlobalEnv)

out <-capture.output(summary(list_cropped_GLAH01))
cat(out,file="data/cropped_files_GLAH01.txt",sep="\n",append=F) ## Have a look at this file

rm(list_cropped_GLAH01)


### Remove DF which data is outside BBOX
rm(DF_GLAH01_02)
rm(DF_GLAH01_04)
rm(DF_GLAH01_05)
rm(DF_GLAH01_06)
rm(DF_GLAH01_08)
rm(DF_GLAH01_10)
rm(DF_GLAH01_12)

### Extract TRUE value indices
indices_GLAH01_01 <- as.numeric(row.names(cropped_GLAH01_01))
indices_GLAH01_03 <- as.numeric(row.names(cropped_GLAH01_03))
indices_GLAH01_05 <- as.numeric(row.names(cropped_GLAH01_05))
indices_GLAH01_07 <- as.numeric(row.names(cropped_GLAH01_07))
indices_GLAH01_09 <- as.numeric(row.names(cropped_GLAH01_09))
indices_GLAH01_11 <- as.numeric(row.names(cropped_GLAH01_11))
indices_GLAH01_13 <- as.numeric(row.names(cropped_GLAH01_13))


### Remove unused values
DF_GLAH01_01 <- cropped_GLAH01_01
DF_GLAH01_03 <- cropped_GLAH01_03
DF_GLAH01_05 <- cropped_GLAH01_05
DF_GLAH01_07 <- cropped_GLAH01_07
DF_GLAH01_09 <- cropped_GLAH01_09
DF_GLAH01_11 <- cropped_GLAH01_11
DF_GLAH01_13 <- cropped_GLAH01_13

### Final summary
ind_sum_GLAH01 <-ls(pattern="^DF_GLAH01",)
list_sum_GLAH01 <- mget(ind_sum_GLAH01, .GlobalEnv)

summary <- out<-capture.output(summary(list_sum_GLAH01))
cat(out,file="data/summary_GLAH01.txt",sep="\n",append=F) ## Have a look at this file

### Remove unused obj
rm(list=ind_i_rec_GLAH01)
rm(list=ind_cropped_GLAH01)
rm(GL01_wd)
rm(out)
rm(summary)
rm(list=ls(pattern="^att_",))
rm(list=ls(pattern="^list",))
rm(list=ls(pattern="^ind_",))


## list of indices GLAH01
list_indices_GLAH01 <-ls(pattern="^indices_GLAH01",)
list_indices_GLAH01 <- mget(list_indices_GLAH01, .GlobalEnv)
rm(list=ls(pattern="^indices_GLAH01",))

## list of indices GLAH14
list_indices_GLAH14 <-ls(pattern="^indices_GLAH14",)
list_indices_GLAH14 <- mget(list_indices_GLAH14, .GlobalEnv)
rm(list=ls(pattern="^indices_GLAH14",))

save.image("001_GLAH_subsetting.RData")