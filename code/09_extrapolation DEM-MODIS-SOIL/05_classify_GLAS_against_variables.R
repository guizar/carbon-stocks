# ---
# Separate all GLAS pulses into 18 categories. These are:
#   a. Sand Fraction cutoff of 0.6 (2 criteria)
#   b. DEM cuttoffs of 200m and 450m (3 criteria)
#   c. EVI cutoffs of 6000 and 6500 (3 criteria)
# ---

library(dplyr)

wdrdata = "~/R/carbon-stocks/RData/"
wdtables= "~/R/carbon-stocks/tables/"
wdfun = "~/R/carbon-stocks/fun/"


load(file.path(wdrdata,"carbon-stocks.RData"))

# --- Define categories ----
# These is how it will look like
# SAND_CUTOFF | min-06 | 06-max
# DEM_CUTOFF  | min-200 | 200-450 | 450-max
# EVI_CUTOFF  | min-6000 | 6000-6500 | 6500-max 

sand_1t = round(min(DATA$SAND),digits = 1)
sand_2d = 0.6
sand_3d = round(max(DATA$SAND),digits = 1)

dem_1t = round(min(DATA$DEM),digits = 0)
dem_2d = 200
dem_3d = 450
dem_4h = round(max(DATA$DEM),digits = 0)

evi_1t = round(min(DATA$EVI),digits = 0)
evi_2d = 6000
evi_3d = 6500
evi_4h = round(max(DATA$EVI),digits = 0)


# Create Columns with these categories 
DATA = DATA %>% 
  mutate(SAND_CUTOFF = ifelse(SAND < 0.6,paste(sand_1t,sand_2d,sep="-"),
                                paste(sand_2d,sand_3d,sep="-"))) %>% 
           
  mutate(DEM_CUTOFF = ifelse(DEM < 200,paste(dem_1t,dem_2d,sep="-"),
                      ifelse(DEM > 450,paste(dem_3d,dem_4h,sep="-"),
                             paste(dem_2d,dem_3d,sep="-")))) %>% 
    
  mutate(EVI_CUTOFF = ifelse(EVI < 6000,paste(evi_1t,evi_2d,sep="-"),
                      ifelse(EVI > 6500,paste(evi_3d,evi_4h,sep="-"),
                              paste(evi_2d,evi_3d,sep="-"))))

rm(sand_1t)
rm(sand_2d)
rm(sand_3d)
rm(dem_1t)
rm(dem_2d)
rm(dem_3d)
rm(dem_4h)
rm(evi_1t)
rm(evi_2d)
rm(evi_3d)
rm(evi_4h)

# append RDatasets (carbon-stocks and DATA)
source(file.path(wdfun,"append_RData.r"))