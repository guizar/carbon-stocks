library(rhdf5)
library(sp)
library(raster)
library(rgdal)

## Files ID table
setwd("~/R/carbon-stocks")
#setwd("/home/a/ag/ag448/Documents/carbon-stocks")

files <- data.frame(id=formatC(seq_len(length(list.files(path = "data/GLAS/"))), width=2, flag="0"), file=list.files(path = "data/GLAS/") ,stringsAsFactors = F )

write.csv(files, file="Data/file_list.csv", row.names=F)

files[,1] <- as.numeric(files[,1])

## Extract GLAS Geolocation Data from HD5 files

setwd("data/GLAS/")

for (id in files$id){
    assign(paste("raw_GLAS",formatC(id,width=2,flag="0"),sep="_"), h5read(files[[c(2,id)]], "/Data_40HZ/Geolocation"))
    rm(id)
}

## Group geolocation raw data in a single list, and delete individual raw_objects

raw_list <-ls(pattern="raw_GL",)
raw_geolocation <- mget(sort(ls(pattern="raw_GL",)), .GlobalEnv)
rm(list = ls(pattern="raw_GL")) # remove raw_GL objects





## Create a data.frame with the xy path for each GLAS file
for(i in seq_len(length(raw_geolocation))) {
        x <-  raw_geolocation[[i]][[2, drop=T]]
        x <- x - 360 ## wgs84 adjustment
        y <-  raw_geolocation[[i]][[1, drop=T]]
        assign(paste("xypath",formatC(i,width=2,flag="0"),sep="_"), data.frame(x,y))
        rm(x)
        rm(y) 
        rm(i)
}

## Convert xy_path into coordinates, and remove xy_path data.frame files
xy_list <- ls(pattern="^xypath_")
for (item in xy_list) {
        assign(paste("coor",formatC(item,width=2,flag="0"),sep="_"), coordinates(get(item)))
}
rm(list = ls(pattern="^xypath_"))


----------------------------------

## Plot each path
xy_list <- ls(pattern="^xy_")
setwd("~/R/carbon-stocks/png")
# setwd("/home/a/ag/ag448/Documents/carbon-stocks/png")

## Individual plots
for (item in xy_list) {
        png(filename=paste(item,".png", sep=""),units="in", width=17, height=23, res=100 )
        plot(states, axes=T)
        title(main=item)
        plot(study_area, col="red", add=T)
        points(get(item))
        legend("topright", pch = c(0), 
               col = "Red", cex=1,
               legend = "Area of study")
        dev.off()
}

# Multiple lines
library(RColorBrewer)
cols <- brewer.pal(length(xy_list),"Set1")
pal <- colorRampPalette(cols)
cols_pal <- pal(length(xy_list))

png(filename="glas_tracks.png",units="in", width=17, height=23, res=100 )
plot(states, axes=T)
plot(study_area, col="red", add=T)
title(main="GLAS Tracks")
for (item in seq_len(length(xy_list))) {
        points(get(xy_list[item]), col = cols_pal[item], cex=2)
        }
legend("topright", pch = 1, 
       col = cols_pal, cex=1,
       legend = xy_list)
dev.off()

#for (item in seq_len(length(xy_list))) {
#        print(cols_pal[item])
#        print(xy_list[item])
# }

## Create a D.F. with the extracted material



#s <- study_area


## CHECA LO DE CREAR UN SP PARA LA ZONA QUE TE INTERESA
#crs(s) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 "

#s <-spTransform(study_area, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 "))

