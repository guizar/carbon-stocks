library(FNN)
library(raster)

## get closest dem index for every glas shot
knnx_01 <- get.knnx(data=dem_spdf@coords, query=DF_GLAH14_01@coords,1)
knnx_04 <- get.knnx(data=dem_spdf@coords, query=DF_GLAH14_04@coords,1)
knnx_05 <- get.knnx(data=dem_spdf@coords, query=DF_GLAH14_05@coords,1)
knnx_06 <- get.knnx(data=dem_spdf@coords, query=DF_GLAH14_06@coords,1)
knnx_07 <- get.knnx(data=dem_spdf@coords, query=DF_GLAH14_07@coords,1)
knnx_08 <- get.knnx(data=dem_spdf@coords, query=DF_GLAH14_08@coords,1)
knnx_09 <- get.knnx(data=dem_spdf@coords, query=DF_GLAH14_09@coords,1)
knnx_10 <- get.knnx(data=dem_spdf@coords, query=DF_GLAH14_10@coords,1)

## get dem xy
knnx_01$dem_xy <- coordinates(dem_spdf[as.vector(knnx_01$nn.index),])
knnx_04$dem_xy <- coordinates(dem_spdf[as.vector(knnx_04$nn.index),])
knnx_05$dem_xy <- coordinates(dem_spdf[as.vector(knnx_05$nn.index),])
knnx_06$dem_xy <- coordinates(dem_spdf[as.vector(knnx_06$nn.index),])
knnx_07$dem_xy <- coordinates(dem_spdf[as.vector(knnx_07$nn.index),])
knnx_08$dem_xy <- coordinates(dem_spdf[as.vector(knnx_08$nn.index),])
knnx_09$dem_xy <- coordinates(dem_spdf[as.vector(knnx_09$nn.index),])
knnx_10$dem_xy <- coordinates(dem_spdf[as.vector(knnx_10$nn.index),])

## get 9 closest points
knnx_01$dem_pts <-  get.knnx(data =dem_spdf@coords ,query = knnx_01$dem_xy,9)
knnx_04$dem_pts <-  get.knnx(data =dem_spdf@coords ,query = knnx_04$dem_xy,9)
knnx_05$dem_pts <-  get.knnx(data =dem_spdf@coords ,query = knnx_05$dem_xy,9)
knnx_06$dem_pts <-  get.knnx(data =dem_spdf@coords ,query = knnx_06$dem_xy,9)
knnx_07$dem_pts <-  get.knnx(data =dem_spdf@coords ,query = knnx_07$dem_xy,9)
knnx_08$dem_pts <-  get.knnx(data =dem_spdf@coords ,query = knnx_08$dem_xy,9)
knnx_09$dem_pts <-  get.knnx(data =dem_spdf@coords ,query = knnx_09$dem_xy,9)
knnx_10$dem_pts <-  get.knnx(data =dem_spdf@coords ,query = knnx_10$dem_xy,9)

## Subset cropped DEM to neighbour points 
neighbour_01 <- dem_spdf[as.vector(knnx_01$dem_pts$nn.index),]
neighbour_04 <- dem_spdf[as.vector(knnx_04$dem_pts$nn.index),]
neighbour_05 <- dem_spdf[as.vector(knnx_05$dem_pts$nn.index),]
neighbour_06 <- dem_spdf[as.vector(knnx_06$dem_pts$nn.index),]
neighbour_07 <- dem_spdf[as.vector(knnx_07$dem_pts$nn.index),]
neighbour_08 <- dem_spdf[as.vector(knnx_08$dem_pts$nn.index),]
neighbour_09 <- dem_spdf[as.vector(knnx_09$dem_pts$nn.index),]
neighbour_10 <- dem_spdf[as.vector(knnx_10$dem_pts$nn.index),]

#//////////////////

# Extract the range of elevation differences between subtracted DEM and GLAS derived elevation


## Extract all neighbouring elevation ind 
ind_neighbours<- unique(as.vector(c(knnx_01$dem_pts$nn.index,knnx_04$dem_pts$nn.index,knnx_05$dem_pts$nn.index,knnx_06$dem_pts$nn.index,knnx_07$dem_pts$nn.index,knnx_08$dem_pts$nn.index,knnx_09$dem_pts$nn.index,knnx_10$dem_pts$nn.index)))

## Create dem_neigh SPDF
dem_neighbours <- dem_spdf[ind_neighbours,]

## Some visuals
hist(dem_neighbours$dem)

plot((1:length(dem_neighbours$dem) - 1)/(length(dem_neighbours$dem) - 1), sort(dem_neighbours$dem), type="l",
       main = "Subtracted DEM Quantiles",
       xlab = "Sample Fraction",
       ylab = "Meters")



## Create elevation differences DF

ind_DF_GLAH14 <-ls(pattern="^DF_GLAH14",)
ind_knnx_GLAH14 <-ls(pattern="^knnx_",)

for (i in seq_len(length(ind_knnx_GLAH14))) {
        data_knnx=get(ind_knnx_GLAH14[[i]])
        
        for (j in seq_len(length(data_knnx$nn.index))){
        dem_pts <-dem_spdf[data_knnx$dem_pts$nn.index[j,1:9],]
        min_ <- min(dem_pts$dem)
        max_ <- max(dem_pts$dem)
        ave <- mean(dem_pts$dem)
        DEM_GLA_diff <- ave - list_d_elev[[i]][j]
        assign(paste("iter",substr(x = ind_DF_GLAH14[[i]], start = 11, stop = 12),formatC(j,width=3,flag="0"),sep="_"), data.frame(GLAS = substr(x = ind_DF_GLAH14[[i]], start = 11, stop = 12), GLAS_obs= j, GLAS_elev= list_d_elev[[i]][j], DEM_mean=ave, DEM_GLAS_diff=DEM_GLA_diff ,DEM_max=max_, DEM_min=min_, row.names=NULL, stringsAsFactors = F))
}
}
rm(dem_pts)
rm(min_)
rm(max_)
rm(ave)
rm(DEM_GLA_diff)
rm(i)
rm(j)
rm(glas_elev)
rm(data_knnx)

ind_DF_GLAH14 <-ls(pattern="^iter_",)
elevation_criteria_df<-NULL
for (i in seq_len(length(ind_DF_GLAH14))){
        elevation_criteria_df <- rbind(elevation_criteria_df,get(ind_DF_GLAH14[i]))
}
rm(list=ind_DF_GLAH14)
rm(ind_knnx_GLAH14)
rm(ind_DF_GLAH14)
rm(i)


## Add a column for the differences between DEM min and max
elevation_criteria_df$DEM_max_min_diff <-  elevation_criteria_df$DEM_max - elevation_criteria_df$DEM_min

######
# plot(DF_GLAH14_04)
# points(dem_neighbours)

## Crteria 3 and 4 DFs
# 
# for (i in seq(length(knnx_10$nn.index))){
#         dem_pts <-dem_spdf[knnx_10$dem_pts$nn.index[1,1:9],]
#         min <- min(dem_pts$dem)
#         max <- max(dem_pts$dem)
#         ave <- mean(dem_pts$dem)
#         max-min_elev_range <- max - min
# }
# knnx_10$dem_pts$nn.index[1,1:9]

## Some visuals
hist(elevation_criteria_df$DEM_GLAS_diff)

plot((1:length(elevation_criteria_df$DEM_GLAS_diff) - 1)/(length(elevation_criteria_df$DEM_GLAS_diff) - 1), sort(elevation_criteria_df$DEM_GLAS_diff), type="l",
     main = "DEM differences quantiles",
     xlab = "Sample Fraction",
     ylab = "Meters")


