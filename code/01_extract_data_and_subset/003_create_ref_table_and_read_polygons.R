library(stringr)
library(raster)
library(rgdal)
library(sp)


load("~/R/carbon-stocks/Rdata/002_GLAH_attributes.RData")


## Create Data Frames 

### GLAH01

ind_DF_GLAH01 <-ls(pattern="^DF_GLAH01",)

for (i in seq_len(length(ind_DF_GLAH01))) {
	data=get(ind_DF_GLAH01[[i]])
	#i_shot_count=get(ind_DF_GLAH01[[1]])
	GLAH01=rep(substr(x = ind_DF_GLAH01[[i]], start = 11, stop = 12), each=nrow(get(ind_DF_GLAH01[[i]])))
	GLAH01_rownumber=1:nrow(get(ind_DF_GLAH01[[i]]))
	assign(paste("DF_01",substr(x = ind_DF_GLAH01[[i]], start = 11, stop = 12),sep="_"), data.frame(data,GLAH01,GLAH01_rownumber, row.names=NULL, stringsAsFactors = F))
        rm(data)
        rm(GLAH01)
        rm(GLAH01_rownumber)
        rm(i)
}
rm(ind_DF_GLAH01)

Reference_GLAH01 <- data.frame()
ind_DF_01 <-ls(pattern="^DF_01",)
for (i in seq_len(length(ind_DF_01))) {
	Reference_GLAH01 <- rbind(get(ind_DF_01[i]),Reference_GLAH01)
	rm(i)
}
rm(list=ind_DF_01)
rm(ind_DF_01)

keeps <- c("i_rec_ndx","i_shot_count","GLAH01","GLAH01_rownumber")
Reference_GLAH01 <- Reference_GLAH01[,keeps,drop=FALSE]
rm(keeps)


### GLAH14

ind_DF_GLAH14 <-ls(pattern="^DF_GLAH14",)

for (i in seq_len(length(ind_DF_GLAH14))) {
	data=get(ind_DF_GLAH14[[i]])
	#i_shot_count=get(ind_DF_GLAH14[[1]])
	GLAH14=rep(substr(x = ind_DF_GLAH14[[i]], start = 11, stop = 12), each=nrow(get(ind_DF_GLAH14[[i]])))
	GLAH14_rownumber=1:nrow(get(ind_DF_GLAH14[[i]]))
	assign(paste("DF_14",substr(x = ind_DF_GLAH14[[i]], start = 11, stop = 12),sep="_"), data.frame(data,GLAH14,GLAH14_rownumber, row.names=NULL, stringsAsFactors = F))
        rm(data)
        rm(GLAH14)
        rm(GLAH14_rownumber)
        rm(i)
}
rm(ind_DF_GLAH14)

Reference_GLAH14 <- data.frame()
ind_DF_14 <-ls(pattern="^DF_14",)
for (i in seq_len(length(ind_DF_14))) {
	Reference_GLAH14 <- rbind(get(ind_DF_14[i]),Reference_GLAH14)
	rm(i)
}
rm(list=ind_DF_14)
rm(ind_DF_14)

keeps <- c("i_rec_ndx","i_shot_count","GLAH14","GLAH14_rownumber")
Reference_GLAH14 <- Reference_GLAH14[,keeps,drop=FALSE]
rm(keeps)

## Match records
Matched_records_reference <- merge(Reference_GLAH14, Reference_GLAH01, by=c("i_rec_ndx","i_shot_count"))


## Maps
### writeOGR(us, ".", "data/us_states", driver = "ESRI Shapefile")
us_states49 = readOGR(dsn = "data/us_states.shp", layer = "us_states")
us = readOGR(dsn = "data/us_map.shp", layer = "us_map")
####  world = readOGR(dsn="data/countries_shp/countries.shp", layer="countries")


## New SPDF with states
###     List of states
states_list <-c("Massachusetts", "New Hampshire", "Vermont")
###     Convert from characters to factors
us$NAME_1 <-as.character(us$NAME_1)
###     Subset
us_states3 <-us[(us$NAME_1 %in% states_list),]
rm(us)
rm(states_list)
