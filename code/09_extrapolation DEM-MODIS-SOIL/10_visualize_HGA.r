# --
# Visualize HGA
# ---

rm(list=ls())

library(dplyr)
library(reshape2)
library(ggplot2)
library(maps)

wdrdata = "~/R/carbon-stocks/RData/"
wdtables= "~/R/carbon-stocks/tables/"
wdfun = "~/R/carbon-stocks/fun/"
wdpng = "~/R/carbon-stocks/png/"
wddata = "~/R/carbon-stocks/data/"

load(file.path(wdrdata,"carbon-stocks.RData"))
source(file.path(wdfun,"resave.r"))


# --- subset ----
ggdat = dplyr::select(HGA,c(LON,LAT,BASAL_AREA,CAT))
ggdat = ggdat[complete.cases(ggdat),]

# map 1 = simple heatmap
gg = ggplot() + 
    geom_polygon(data=us_states3,
    aes(x=long, y=lat,group=group), 
    fill="transparent", color="black",size=0.2)

gg = gg + 
    geom_raster(data=ggdat,aes(fill=BASAL_AREA,x=LAT, y=LON,
    interpolate=T))

gg = gg + xlim(c(min(ggdat$LAT),max(ggdat$LAT)))
gg = gg + ylim(c(min(ggdat$LON),max(ggdat$LON)))

gg = gg + ggtitle("Interpolated Basal Area")

gg

file=file.path(wdpng,"INTERPOLATED_BA_HEATMAP.png")
ggsave(file,gg,scale = 2)



# map 2  = categories
gg = ggplot() + 
  geom_polygon(data=us_states3,
               aes(x=long, y=lat,group=group), 
               fill="transparent", color="black",size=0.2)

gg = gg + 
  geom_raster(data=ggdat,aes(fill=CAT,x=LAT, y=LON,
                             interpolate=T))

gg = gg + xlim(c(min(ggdat$LAT),max(ggdat$LAT)))
gg = gg + ylim(c(min(ggdat$LON),max(ggdat$LON)))

gg = gg + ggtitle("Interpolated Basal Area")

gg

file=file.path(wdpng,"INTERPOLATED_BA_BREAK-CAT.png")
ggsave(file,gg,scale = 2)
