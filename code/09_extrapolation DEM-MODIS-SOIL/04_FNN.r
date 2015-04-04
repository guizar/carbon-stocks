# ---
# Extract closest MODIS / SOIL / DEM 
# ---

library(rgdal)
library(FNN)
library(raster)

wdrdata = "~/R/carbon-stocks/RData/"
wdtables= "~/R/carbon-stocks/tables/"

load("~/R/carbon-stocks/data/MODIS_EVI.RData")
load("~/R/carbon-stocks/data/SOIL.RData")	
load("~/R/carbon-stocks/data/DEM_DF.RData")	



# MODIS
# get closest MODIS index for every glas shot [CLOSEST 1 WORKS] - so this is quite straightforward
MODIS_600_FNN = get.knnx(data=MODIS_EVI_DF@coords, query=DATA[,c("x","y")],1)
MODIS_600_FNN$xy = coordinates(MODIS_EVI_DF[as.vector(MODIS_600_FNN$nn.index),])
MODIS_600_FNN$pts =  get.knnx(data =MODIS_EVI_DF@coords ,query = MODIS_600_FNN$xy,1)

# create SPDF
MODIS_600 = MODIS_EVI_DF[as.vector(MODIS_600_FNN$pts$nn.index),]




# --- Extract closest 9 DEM/SOIL points for each GLAS shot ----

# --- DEM
# get closest 9 DEM index for every glas shot
DEM_5400_FNN = get.knnx(data=DEM_DF@coords, query=DATA[,c("x","y")],k = 9)

# generate SPDF
DEM_5400 = DEM_DF[as.vector(DEM_5400_FNN$nn.index),]

# --- SOIL
# get closest 9 SOIL index for every glas shot
SOIL_5400_FNN = get.knnx(data=SOIL_DF@coords, query=DATA[,c("x","y")],k = 9)

# generate SPDF
SOIL_5400 = SOIL_DF[as.vector(SOIL_5400_FNN$nn.index),]


# --- Calculate summary values of the above 9 pts ----

# --
# The function below summarize the values of the neighbouring DEM/SOIL points per GLAS shot.
# It also generates a bounding box per GLAS shot, consisting of the area covered by the aggregation of these neighbouring points. 
# While the centroid of this bbox is already given by the XY coord of the closest matching point, we might end up using the are covered by the neighbouting points to determine the resolution of the new raster
# ---

# --- DEM ----
# Generate SPDF with the summary values  of closest 9 DEM points + bbox
DEM_600 = data.frame()
for (i in seq(length(DEM_5400_FNN$nn.index[,1]))){
  
  print(paste("row",i,sep=":"))
  
  dem_pts = DEM_DF[as.vector(DEM_5400_FNN$nn.index[i,1:9]),]
  x = coordinates(dem_pts[1,])[1] # X coordinate
  y = coordinates(dem_pts[1,])[2] # Y coordinate
  MAX = max(dem_pts$DEM)
  MIN = min(dem_pts$DEM)
  MEAN = mean(dem_pts$DEM)
  DIFF = MAX - MIN
  XMIN = min(coordinates(dem_pts)[,1]) # min X coordinate
  XMAX = max(coordinates(dem_pts)[,1]) # max X coordinate
  YMIN = min(coordinates(dem_pts)[,2]) # min Y coordinate
  YMAX = max(coordinates(dem_pts)[,2]) # max Y coordinate
  
  df = data.frame(x=x, y=y, MAX=MAX, MIN=MIN, MEAN=MEAN, DIFF=DIFF, XMIN=XMIN, XMAX=XMAX, YMIN=YMIN, YMAX=YMAX)
  
  DEM_600 = rbind(DEM_600,df)
}
    

# --- SOIL SAND ----
# Generate SPDF with the summary values  of closest 9 SOIL points + bbox
SOIL_SAND_600 = data.frame()
for (i in seq(length(SOIL_5400_FNN$nn.index[,1]))){
  
  print(paste("row",i,sep=":"))
  
  soil_pts = SOIL_DF[as.vector(SOIL_5400_FNN$nn.index[i,1:9]),]
  x = coordinates(soil_pts[1,])[1] # X coordinate
  y = coordinates(soil_pts[1,])[2] # Y coordinate
  MAX = max(soil_pts$sand)
  MIN = min(soil_pts$sand)
  MEAN = mean(soil_pts$sand)
  DIFF = MAX - MIN
  XMIN = min(coordinates(soil_pts)[,1]) # min X coordinate
  XMAX = max(coordinates(soil_pts)[,1]) # max X coordinate
  YMIN = min(coordinates(soil_pts)[,2]) # min Y coordinate
  YMAX = max(coordinates(soil_pts)[,2]) # max Y coordinate
  
  df = data.frame(x=x, y=y, MAX=MAX, MIN=MIN, MEAN=MEAN, DIFF=DIFF, XMIN=XMIN, XMAX=XMAX, YMIN=YMIN, YMAX=YMAX)
  
  SOIL_SAND_600 = rbind(SOIL_SAND_600,df)
}  

# --- SOIL CLAY ----
# Generate SPDF with the summary values  of closest 9 SOIL points + bbox
SOIL_CLAY_600 = data.frame()
for (i in seq(length(SOIL_5400_FNN$nn.index[,1]))){
  
  print(paste("row",i,sep=":"))
  
  soil_pts = SOIL_DF[as.vector(SOIL_5400_FNN$nn.index[i,1:9]),]
  x = coordinates(soil_pts[1,])[1] # X coordinate
  y = coordinates(soil_pts[1,])[2] # Y coordinate
  MAX = max(soil_pts$clay)
  MIN = min(soil_pts$clay)
  MEAN = mean(soil_pts$clay)
  DIFF = MAX - MIN
  XMIN = min(coordinates(soil_pts)[,1]) # min X coordinate
  XMAX = max(coordinates(soil_pts)[,1]) # max X coordinate
  YMIN = min(coordinates(soil_pts)[,2]) # min Y coordinate
  YMAX = max(coordinates(soil_pts)[,2]) # max Y coordinate
  
  df = data.frame(x=x, y=y, MAX=MAX, MIN=MIN, MEAN=MEAN, DIFF=DIFF, XMIN=XMIN, XMAX=XMAX, YMIN=YMIN, YMAX=YMAX)
  
  SOIL_CLAY_600 = rbind(SOIL_CLAY_600,df)
}  

# remove unused loop obj
rm(x)
rm(y)
rm(MAX)
rm(MIN)
rm(MEAN)
rm(DIFF)
rm(XMIN)
rm(XMAX)
rm(YMIN)
rm(YMAX)
rm(df)
rm(soil_pts)
rm(dem_pts)
rm(i)


# convert to SPDF
coordinates (DEM_600) <- ~x+y
coordinates (SOIL_CLAY_600) <- ~x+y
coordinates (SOIL_SAND_600) <- ~x+y

# --- Remove large datasets and save RData ----

#rm large datasets
rm(DEM_DF)
rm(SOIL_DF)
rm(MODIS_EVI_DF)
rm(DEM_5400_FNN)
rm(SOIL_5400_FNN)
rm(MODIS_600_FNN)

# save tables
write.csv(as.data.frame(DEM_600),file.path(wdtables,"DEM_600.csv"),row.names=F)
write.csv(as.data.frame(SOIL_CLAY_600),file.path(wdtables,"SOIL_CLAY_600.csv"),row.names=F)
write.csv(as.data.frame(SOIL_SAND_600),file.path(wdtables,"SOIL_SAND_600.csv"),row.names=F)
write.csv(as.data.frame(MODIS_600),file.path(wdtables,"MODIS_600.csv"),row.names=F)


# Add MEAN values to master DF
DATA$SAND =  SOIL_SAND_600$MEAN
DATA$EVI =  MODIS_600$modis_evi
DATA$DEM = DEM_600$MEAN

# save image
save.image(file.path(wdrdata,"carbon-stocks.RData"))


