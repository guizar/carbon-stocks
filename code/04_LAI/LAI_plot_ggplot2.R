library(ggmap)

roiGgmap <- get_map(location =c(xmin(roiExt),ymin(roiExt),xmax(roiExt),ymax(roiExt)),maptype = "toner",source = "stamen")

png(filename="png/glas_waveform_derived_lai.png", units="in", width=17/2, height=23/2, res=250)

ggmap(roiGgmap)+geom_point(aes(x =waveForm_LAI_spdf$x , y = waveForm_LAI_spdf$y, colour = waveForm_LAI_spdf$LAI),data = waveForm_LAI_spdf) +scale_colour_gradient2(low = "#0000FF", mid = "#FFFFFF", high ="#FF0000",  midpoint = median(waveForm_LAI_spdf$LAI), space = "rgb", guide = "colourbar")+ labs(title = "GLAS waveform derived LAI")
dev.off()


