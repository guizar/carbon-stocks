# ---
# From 'Harvard_Grid_attributes.txt' create a list for all 16200 pixels between 1-18 (i.e. categories) taking the cutoffs from step 3.
# ---

rm(list = ls())

library(dplyr)

wddata = "~/R/carbon-stocks/data/"
wdrdata = "~/R/carbon-stocks/RData/"
wdtables= "~/R/carbon-stocks/tables/"
wdfun = "~/R/carbon-stocks/fun/"

HGA = read.table(file.path(wddata,"Harvard_Grid_attributes.txt"),header = T,stringsAsFactors = F)

load(file.path(wdrdata,"DATA.RData"))


# --- Define categories ----
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


# --- Create Columns with these categories ----
HGA = HGA %>% 
  mutate(SAND_CUTOFF = ifelse(SAND < 0.6,paste(sand_1t,sand_2d,sep="-"),
                              paste(sand_2d,sand_3d,sep="-"))) %>% 
  
  mutate(DEM_CUTOFF = ifelse(DEM < 200,paste(dem_1t,dem_2d,sep="-"),
                             ifelse(DEM > 450,paste(dem_3d,dem_4h,sep="-"),
                                    paste(dem_2d,dem_3d,sep="-")))) %>% 
  
  mutate(MODIS_EVI_CUTOFF = ifelse(MODIS_EVI < 6000,paste(evi_1t,evi_2d,sep="-"),
                             ifelse(MODIS_EVI > 6500,paste(evi_3d,evi_4h,sep="-"),
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



# --- append CAT column ----
S1 = "0.1-0.6"
S2 = "0.6-0.9"
D1 = "103-200"
D2 = "200-450"
D3 = "450-776"
E1 = "4412-6000"
E2 = "6000-6500"
E3 = "6500-7175"


HGA = HGA %>% 
  mutate(CAT = 
           ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D1 & MODIS_EVI_CUTOFF == E1,"CAT_01",
                  ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D1 & MODIS_EVI_CUTOFF == E2,"CAT_02",
                         ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D1 & MODIS_EVI_CUTOFF == E3,"CAT_03",
                                ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D2 & MODIS_EVI_CUTOFF == E1,"CAT_04",
                                       ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D2 & MODIS_EVI_CUTOFF == E2,"CAT_05",
                                              ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D2 & MODIS_EVI_CUTOFF == E3,"CAT_06",
                                                     ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D3 & MODIS_EVI_CUTOFF == E1,"CAT_07",
                                                            ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D3 & MODIS_EVI_CUTOFF == E2,"CAT_08",
                                                                   ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D3 & MODIS_EVI_CUTOFF == E3,"CAT_09",
                                                                          ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D1 & MODIS_EVI_CUTOFF == E1,"CAT_10",
                                                                                 ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D1 & MODIS_EVI_CUTOFF == E2,"CAT_11",
                                                                                        ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D1 & MODIS_EVI_CUTOFF == E3,"CAT_12",   
                                                                                               ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D2 & MODIS_EVI_CUTOFF == E1,"CAT_13",
                                                                                                      ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D2 & MODIS_EVI_CUTOFF == E2,"CAT_14",
                                                                                                             ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D2 & MODIS_EVI_CUTOFF == E3,"CAT_15",
                                                                                                                    ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D3 & MODIS_EVI_CUTOFF == E1,"CAT_16",
                                                                                                                           ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D3 & MODIS_EVI_CUTOFF == E2,
                                                                                                                                  "CAT_17","CAT_18"))))))))))))))))))

# rm cat labels
rm(list = c("S1","S2","D1","D2","D3","E1","E2","E3"))


# write csv
file = file.path("~/R/carbon-stocks/tables/","Harvard_Grid_attributes.csv")
write.csv(HGA,file,row.names=F)



# --- Save objects ----
# safe data object
save(list = ls(pattern = "DATA"), file = file.path(wdrdata,"DATA.RData"))
# load carbon-stocks
load(file.path(wdrdata,"carbon-stocks.RData"))
# load data object
load(file.path(wdrdata,"DATA.RData"))
# open HGA file
HGA = read.csv(file,header = T)
                           
rm(file)
# souce
source(file.path(wdfun,"append_RData.r"))


# --- quick plot ----
library(ggplot2)
library

gg = ggplot(HGA, aes(x = CAT, fill=CAT))
gg = gg + geom_histogram()
# gg = gg + theme(axis.text.x = element_blank())
gg = gg + ggtitle("Harvard_Grid_attributes categories")

file = file.path("~/R/carbon-stocks/png/","Harvard_Grid_attributes categories.png")
ggsave(file,gg,scale = 3)
rm(file)
rm(gg)
