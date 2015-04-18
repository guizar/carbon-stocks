# -- D) Create a new column for each of the 18 CSS files, and attribute a value of (NLCDForest/X). E.g. if there are 10 GLAS pulses and the NLCD fraction is 0.8, then this would be 0.08 for the whole column ----

rm(list=ls())

library(dplyr)

wdrdata = "~/R/carbon-stocks/RData/"
wdtables= "~/R/carbon-stocks/tables/"
wdfun = "~/R/carbon-stocks/fun/"
wddata = "~/R/carbon-stocks/data/"

load(file.path(wdrdata,"CAT_CSS.RData"))
load(file.path(wdrdata,"DATA.RData"))

source(file.path(wdfun,"resave.r"))

# Harvard_Grid_attributes
HGA = read.csv(file.path(wdtables,"Harvard_Grid_attributes.csv"),header = T)

# add additional cols
HGA$BASAL_AREA = 0
HGA$FILENAME = ""


# calculate basal area for each HGA row, creating a CSS file with adjusted NLCDForest values
for (i in seq(length(HGA[,1]))){
  
  # obtain NLCD vals
  nlcd = as.numeric(HGA[i,"NLCDForest"])
  print(paste("NLCDForest",nlcd,sep=": "))
  br = as.numeric(HGA[i,"NLCDbare"])
  gr = as.numeric(HGA[i,"NLCDgrass"])
  
  # identify corresponging CAT_SS
  c = as.character(HGA[i,"CAT"])
  cat = paste(c,"CSS",sep = "_")
  print(cat)
  
  # GET CSS
  df = get(cat)
  
  if (!is.null(df)){ ## i.e. if it is not en empty CSS
    
    # identify unique number of shots comprising NLCDForest
    shots = unique(df$"2")
    shots = shots[-which(shots %in% c("BR","GR"))] # remove these rows from the computation
    
    # Add fraction row
    df$"8" = nlcd / length(shots)
    
    # include br and gr values
    df$"8"[df$"2"=="BR"] = br
    df$"8"[df$"2"=="GR"] = gr
    
    # Calculate BA
    df$"9" = pi* 0.25 *
      as.numeric(df$"4") * # dbh 
      as.numeric(df$"4") * # dbh
      as.numeric(df$"7") * # lambda
      as.numeric(df$"8")  # fractional area
    
    ba = sum(df$"9")
    
  } else { # if it is an empty CSS
    ba =  0
  }
  
  # append basal area val
  HGA$BASAL_AREA[i] = ba
  print(ba)
  
  #WRITE CSV
  filename = paste("CSS",formatC(i,flag = 0,width = 5),sep="_")
  file = file.path("~/R/carbon-stocks/tables/CSS_HGA/",filename)
  write.csv(df,paste(file,".csv",sep=""), row.names=F)
  
  # append filename
  HGA$FILENAME[i] = filename
  print(filename)
  
  
  # write object
  # assign(filename,df)
  
}




# ---- write RData for all the HGA_CSS objects ----
# file = file.path("~/R/carbon-stocks/RData/","HGA_CSS.RData")
# save(list=(ls(pattern = "^CSS_")),file=file)
# rm(file)

# append HGA data frame to master dataset
rdata = file.path(wdrdata,"carbon-stocks.RData")
resave(HGA, file = rdata)
rm(rdata)

# save HGA table
file = file.path("~/R/carbon-stocks/tables/","HGA_CSS.csv")
write.csv(HGA,file,row.names=F)


# REMOVE ALL
rm(list = ls())


