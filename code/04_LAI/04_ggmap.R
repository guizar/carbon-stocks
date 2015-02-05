## ggmap

library(ggmap)
library(ggplot2)

## Download basemap
roiGgmap <- get_map(location =c(xmin(roiExt),ymin(roiExt),xmax(roiExt),ymax(roiExt)),maptype = "toner",source = "stamen",filename = "roiGgmap.png")

#======#


######## Modelwave

## Create breaks
max_modelWave <- max(LAI_modelWave$LAI)
min_modelWave <- min(LAI_modelWave$LAI)
hist(LAI_modelWave$LAI) # just to see what's going on
byseq <- 1
brk <- seq(from = min_modelWave, to=max_modelWave+byseq, by = 1)
brk <- round(brk,digits = 1)
brk_leg <-NULL
for (n in brk){
        brk_leg[n] <- paste(brk[n]," - ",brk[n+1])
}

# To have a feel of the data, visualize the distribution with the following commands. Play with the N breaks
#intervals<- hist(LAI_modelWave$LAI, breaks =6 , plot = FALSE)

# include cut breaks in data.frame
LAI_modelWave$cut <- cut(LAI_modelWave$LAI, breaks = brk, labels = brk_leg, right = FALSE)


# Heatmap
# ggmap(roiGgmap)+geom_point(aes(x =LAI_modelWave$x , y = LAI_modelWave$y, colour = LAI_modelWave$LAI),data = LAI_modelWave)  +scale_colour_gradient2(low = "#0000FF", mid = "#FFFFFF", high ="#FF0000",  midpoint = median(LAI_modelWave$LAI), space = "rgb", guide = "colourbar") + labs(title="GLAS modelWave derived LAI")

# Map with breaks
plot_path <- file.path("png",paste("map_modelwave_LAI",".png",sep = "_"))
png(filename=plot_path,units="in", width=17/2, height=23/2, res=200 )
ggmap(roiGgmap)+geom_point(aes(x =LAI_modelWave$x , y = LAI_modelWave$y, colour = LAI_modelWave$cut),data = LAI_modelWave) + scale_fill_brewer( palette="PuOr",type = qual) + labs(title="GLAS modelWave derived LAI") + theme(legend.title=element_blank())
dev.off()




####### Waveform
## Create breaks
max_waveForm <- max(LAI_waveForm$LAI)
min_waveForm <- min(LAI_waveForm$LAI)
hist(LAI_waveForm$LAI) # just to see what's going on
byseq <- 1
brk <- seq(from = min_waveForm, to=max_waveForm+byseq, by = byseq)
brk <- round(brk,digits = 1)
brk_leg <-NULL
for (n in brk){
        brk_leg[n] <- paste(brk[n]," - ",brk[n+1])
}

# To have a feel of the data, visualize the distribution with the following commands. Play with the N breaks
#intervals<- hist(LAI_waveForm$LAI, breaks =6 , plot = FALSE)

# include cut breaks in data.frame
LAI_waveForm$cut <- cut(LAI_waveForm$LAI, breaks = brk, labels = brk_leg, right = FALSE)

# Heatmap
# ggmap(roiGgmap)+geom_point(aes(x =LAI_waveForm$x , y = LAI_waveForm$y, colour = LAI_waveForm$LAI),data = LAI_waveForm)  +scale_colour_gradient2(low = "#0000FF", mid = "#FFFFFF", high ="#FF0000",  midpoint = median(LAI_waveForm$LAI), space = "rgb", guide = "colourbar") + labs(title="GLAS waveform derived LAI")

# Map with breaks
plot_path <- file.path("png",paste("map_waveform_LAI",".png",sep = "_"))
png(filename=plot_path,units="in", width=17/2, height=23/2, res=200 )
ggmap(roiGgmap)+geom_point(aes(x =LAI_waveForm$x , y = LAI_waveForm$y, colour = LAI_waveForm$cut),data = LAI_waveForm) + scale_fill_brewer(palette="PuOr",type = seq) + labs(title="GLAS waveform derived LAI") + theme(legend.title=element_blank())
dev.off()

rm(max_waveForm)
rm(min_waveForm)
rm(min_modelWave)
rm(max_modelWave)
rm(brk)
rm(byseq)
rm(brk_leg)

#save.image("carbon_stocks.RData")
