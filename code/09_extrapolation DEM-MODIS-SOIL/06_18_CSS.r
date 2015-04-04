#---
#Add together all individual GLAS CSS files in each category (i.e. you should now have 18 CSS files where each will have many pulses). There may be a situation where one of the 18 categories does not have a GLAS pulse. This is fine...create a blank CSS file.
#---

# make an index object for each category
# subset css name
# read and rbind

rm(list = ls())

library(dplyr)

wdrdata = "~/R/carbon-stocks/RData/"
wdtables= "~/R/carbon-stocks/tables/"

# load DATA object
load(file.path(wdrdata,"carbon-stocks.RData"))


# --- Define  categories ----
S1 = "0.1-0.6"
S2 = "0.6-0.9"
D1 = "103-200"
D2 = "200-450"
D3 = "450-776"
E1 = "4412-6000"
E2 = "6000-6500"
E3 = "6500-7175"


# --- Generate CAT Indices ----
CAT_01 = dplyr::filter(DATA, SAND_CUTOFF == S1 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E1)[,1]
CAT_02 = dplyr::filter(DATA, SAND_CUTOFF == S1 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E2)[,1]
CAT_03 = dplyr::filter(DATA, SAND_CUTOFF == S1 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E3)[,1]
CAT_04 = dplyr::filter(DATA, SAND_CUTOFF == S1 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E1)[,1]
CAT_05 = dplyr::filter(DATA, SAND_CUTOFF == S1 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E2)[,1]
CAT_06 = dplyr::filter(DATA, SAND_CUTOFF == S1 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E3)[,1]
CAT_07 = dplyr::filter(DATA, SAND_CUTOFF == S1 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E1)[,1]
CAT_08 = dplyr::filter(DATA, SAND_CUTOFF == S1 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E2)[,1]
CAT_09 = dplyr::filter(DATA, SAND_CUTOFF == S1 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E3)[,1]
CAT_10 = dplyr::filter(DATA, SAND_CUTOFF == S2 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E1)[,1]
CAT_11 = dplyr::filter(DATA, SAND_CUTOFF == S2 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E2)[,1]
CAT_12 = dplyr::filter(DATA, SAND_CUTOFF == S2 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E3)[,1]
CAT_13 = dplyr::filter(DATA, SAND_CUTOFF == S2 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E1)[,1]
CAT_14 = dplyr::filter(DATA, SAND_CUTOFF == S2 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E2)[,1]
CAT_15 = dplyr::filter(DATA, SAND_CUTOFF == S2 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E3)[,1]
CAT_16 = dplyr::filter(DATA, SAND_CUTOFF == S2 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E1)[,1]
CAT_17 = dplyr::filter(DATA, SAND_CUTOFF == S2 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E2)[,1]
CAT_18 = dplyr::filter(DATA, SAND_CUTOFF == S2 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E3)[,1]

# --- Append a COLUM for each CAT ----
  DATA = DATA %>% 
    mutate(CAT = 
    ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E1,"CAT_01",
    ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E2,"CAT_02",
    ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E3,"CAT_03",
    ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E1,"CAT_04",
    ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E2,"CAT_05",
    ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E3,"CAT_06",
    ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E1,"CAT_07",
    ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E2,"CAT_08",
    ifelse(SAND_CUTOFF == S1 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E3,"CAT_09",
    ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E1,"CAT_10",
    ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E2,"CAT_11",
    ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D1 & EVI_CUTOFF == E3,"CAT_12",                                                                                           
    ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E1,"CAT_13",
    ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E2,"CAT_14",
    ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D2 & EVI_CUTOFF == E3,"CAT_15",
    ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E1,"CAT_16",
    ifelse(SAND_CUTOFF == S2 & DEM_CUTOFF ==  D3 & EVI_CUTOFF == E2,
   "CAT_17","CAT_18"))))))))))))))))))
  
# rm cat labels
rm(list = c("S1","S2","D1","D2","D3","E1","E2","E3"))


# append RDatasets (carbon-stocks and DATA)
source(file.path(wdfun,"append_RData.r"))

# --- RBIND CSS_DBH_854 data | one table per category ----

# Transform DATA ID col to characters
DATA$ID = as.character(DATA$ID)

# load CSS_DBH_854 data
load(file.path(wdrdata,"CSS_DBH_854.RData"))
cats = ls(pattern = "^CAT_")
 
# --- loop over cats object, and create a CAT_XX_CSS table using cssxxx files ----

for (i in cats){
  cssxx = mget(i)[[1]] ## string of matched css_xx_xxx
  print(i)
  print(cssxx)
  catcss = mget(cssxx) ## list of css per cat
  
  
  if (length(cssxx) != "0"){ ## IF CLAS NOR EMPTY
  
    
  df = data.frame() ## placeholder
  for ( e in seq(length(catcss))){
    e  = catcss [[e]]  ## exctract d.f.
    df = rbind(df,e)
  }
  
  colnames(df)= c("1","2","4","5","6","7")
  
  # write csv
  file = file.path("~/R/carbon-stocks/tables/CAT_CSS/",
                   paste(i,"CSS",sep="_"))
  write.csv(df, 
            paste(file,".csv",sep=""), row.names=F)
  
  # write object
  assign(paste(i,"CSS",sep="_"),df)
 
  
  } else { # IF EMPTY
  
    
   # write csv
   file = file.path("~/R/carbon-stocks/tables/CAT_CSS/",
                    paste(i,"CSS",sep="_"))
   
   write.csv(NULL, 
             paste(file,".csv",sep=""), row.names=F)
   
   # write object
   assign(paste(i,"CSS",sep="_"),NULL)
  
 }
}

# write RData for all the CAT_XX_CSS objects
file = file.path("~/R/carbon-stocks/RData/","CAT_CSS.RData")
save(list=(ls(pattern = "^CAT_")),file=file)

rm(file)

# REMOVE ALL
rm(list = ls())
