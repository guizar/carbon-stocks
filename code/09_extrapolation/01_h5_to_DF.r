## Extrapolation 01

# source("http://bioconductor.org/biocLite.R")
# biocLite("rhdf5")

# The code below is for data living @ APOLO

library(rhdf5)
library(sp)



# Soil NEW DATA JUST UPDATED BY ALEX (02/20)
# h5ls("/mnt/geog/aa812/RDF/HF_soiltexture.h5")
# group name       otype dclass         dim
# 0     / CLAY H5I_DATASET  FLOAT 2701 x 5401
# 1     /  LAT H5I_DATASET  FLOAT 2701 x 5401
# 2     /  LON H5I_DATASET  FLOAT 2701 x 5401
# 3     / SAND H5I_DATASET  FLOAT 2701 x 5401

# Modis evi
# h5ls("r_wd/RDF/MODIS_EVI_HF.h5")
# group   name       otype dclass   dim
# 0     /    lat H5I_DATASET  FLOAT 45593
# 1     /    lon H5I_DATASET  FLOAT 45593
# 2     / values H5I_DATASET  FLOAT 45593

# DEM (alredy converted to R DF)
# h5ls("r_wd/RDF/MODIS_EVI_HF.h5")

#////////////////// Convert H5 data to R DF

SOIL = "/mnt/geog/aa812/RDF/HF_soiltexture.h5"

# Soil ATTRIBUTES
SOIL_CLAY="/CLAY"
SOIL_LAT="/LAT"
SOIL_LON ="/LON"
SOIL_SAND="/SAND"

# Soil ATTRIBUTES
SOIL_CLAY="/CLAY"
SOIL_LAT="/LAT"
SOIL_LON ="/LON"
SOIL_SAND="/SAND"

# EXTRACT VARS
SOIL_CLAY=h5read(SOIL,SOIL_CLAY)
SOIL_LAT=h5read(SOIL,SOIL_LAT)
SOIL_LON =h5read(SOIL,SOIL_LON)
SOIL_SAND=h5read(SOIL,SOIL_SAND)

setwd("/mnt/geog/ag448/r_wd")

SOIL_DF <- data.frame(x = as.vector(SOIL_LON), y= as.vector(SOIL_LAT), clay = as.vector(SOIL_CLAY), sand = as.vector(SOIL_SAND))

## DF to SPDF : 
coordinates(SOIL_DF) <- ~x+y

# save and remove
save(list = ls(pattern = "SOIL_DF"), file = "SOIL.RData")
rm(list=ls())


#-----

# MODIS EVI
ME = "r_wd/RDF/MODIS_EVI_HF.h5"

# MODIS_EVI ATTRIBUTES

LAT="/lat"
LON ="/lon"
MODIS_EVI="/values"

# EXTRACT VARS
LAT=h5read(ME,LAT)
LON =h5read(ME,LON)
MODIS_EVI=h5read(ME,MODIS_EVI)

MODIS_EVI_DF <- data.frame(x = as.vector(LON), y= as.vector(LAT), modis_evi = as.vector(MODIS_EVI))

## DF to SPDF : 
coordinates(MODIS_EVI_DF) <- ~x+y

# save and remove
save(list = ls(pattern = "MODIS_EVI_DF"), file = "MODIS_EVI.RData")
rm(list=ls())

