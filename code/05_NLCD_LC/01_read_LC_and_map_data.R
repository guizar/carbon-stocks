library(rhdf5)

# # define h5 file
# setwd("~/R/carbon-stocks")
# NLCD_LC_h5<- 'data/NLCD_LC_harvard.h5' 
# #NLCD_LC_h5<- 'RDF/NLCD_LC_harvard.h5' 
# 
# # define attributes
# att_lats <- "cell_ul_corner_lats"
# att_lons <- "cell_ul_corner_lons"
# att_landc <- "landcover"
# 
# # read data
# LC_lats <- h5read(NLCD_LC_h5,att_lats)
# LC_lons <- h5read(NLCD_LC_h5,att_lons)
# LC_landc <- h5read(NLCD_LC_h5,att_landc)
# 
# # Create SPDF
# LC_spdf <- data.frame(x=as.vector(LC_lons), y=as.vector(LC_lats), landcover=as.vector(LC_landc))
# 
# # to SPDF
# coordinates(LC_spdf) <- ~x+y
# 
# # Save
# save(list = ls(pattern = "LC_spdf"),file = LC_spdf.RData)

# plot
plot_path <- "NLCD_LC_h5.png"
png(filename=plot_path, units="in", width=17/4, height=23/4, res=250)
plot(LC_spdf)
dev.off()

##########

# get closest match betwen LC_ and LAI_waveform
library(FNN)
library(raster)

# get.knnx
knnx_LC_waveForm_LAI <- get.knnx(data=LC_spdf@coords, query=LAI_waveForm[1:2],1)

## Crop landcover SPDF to matched records
LC_spdf_matched <- LC_spdf[as.vector(knnx_LC_waveForm_LAI[["nn.index"]]),]

## add eucledian distances
LC_spdf_matched$dist_to_closest <-knnx_LC_waveForm_LAI$nn.dist

## Plot to see the match
plot(LC_spdf_matched)
ext<-drawExtent()

plot(LC_spdf_matched,ylim = c(ymin(ext), ymax(ext)), xlim=c(xmin(ext),xmax(ext)))
points(LAI_waveForm)


#### load NLCD cublassification
# library("RCurl")
# nlcd_subclasses_df <- getURL("https://docs.google.com/spreadsheets/d/1RdLBX8x9r_JuxMIxd6v5YFiV0kOA7MWIcpQhqBWth8s/export?format=csv")
# nlcd_subclasses_df <- read.csv(textConnection(nlcd_subclasses_df),header = T)

## add subclass to SPDF
LC_spdf_matched$subclass <- as.character(nlcd_subclasses_df$land_cover_type[match(LC_spdf_matched$landcover, nlcd_subclasses_df$NLCD)])



## Some visuals
library(ggplot2)
library(ggmap)
# library(RColorBrewer)
# cols <- brewer.pal(8,"Dark2")
# pal <- colorRampPalette(cols)
# color_array<- pal(20) 


#histogram
plotname <- file.path("png",paste("Landcover_hist_2",".png",sep = "_"))
png(filename=plotname,units="in", width=17/2, height=23/2, res=200 )
ggplot(LC_spdf_matched@data, aes(subclass, fill = subclass))+geom_histogram(binwidth = 1) + scale_fill_brewer(palette = "Dark2",type = qual)  + labs(title="Matched GLAH14 shots landcover") + theme(legend.title=element_blank()) + scale_x_discrete(breaks=NULL) + xlab(label = "Landcover")
dev.off()


#boxplot

# x labels
library(plyr)
dat = ddply(.data = LC_spdf_matched@data, .(subclass), summarise, mean_LAI = mean(waveFormLAI))
xlab <-paste("mean=",round(dat$mean_LAI,2), sep="")

plotname <- file.path("png",paste("Landcover_LAI_boxplot_2",".png",sep = "_"))
png(filename=plotname,units="in", width=18, height=7, res=200 )

ggplot(LC_spdf_matched@data, aes(x = subclass, y=waveFormLAI, fill = subclass))+geom_boxplot()+ scale_fill_brewer(palette = "Dark2",type = qual)  + labs(title="Waveform derived LAI by landcover") + theme(legend.title=element_blank()) + scale_x_discrete(labels=xlab) + xlab(label = "") + ylab(label = "LAI")
dev.off()



# Map with breaks
plotname <- file.path("png",paste("landcover_map_2",".png",sep = "_"))
png(filename=plotname,units="in", width=17/2, height=23/2, res=200 )

ggmap(roiGgmap)+geom_point(aes(x =LC_spdf_matched$x , y = LC_spdf_matched$y, colour = LC_spdf_matched$subclass),data = LC_spdf_matched@data) + scale_fill_brewer(palette = "Dark2",type = qual) + theme(legend.title=element_blank())

dev.off()    
