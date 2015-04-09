
#--
# a. Each of the new 18 CSS files will have a 'X' number of individual GLAS pulses. We need this number to create the 'Fractional Area'
# b. ADD 1 new bare row to each of the 18 CSS files. Populate it with a name 'BR', a dbh of 0.2 and a lambda of 0.1, and a PFT value of 10.
# c. ADD 1 final grass row to each of the 18 CSS files. Populate it with a name 'GR', a dbh of 0.723 and a lambda of 0.196, and a PFT value of 5.
# d. Create a new column for each of the 18 CSS files, and attribute a value of (NLCDForest/X). E.g. if there are 10 GLAS pulses and the NLCD fraction is 0.8, then this would be 0.08 for the whole column.
  # e. For the bare row created in step b above, give a single value for the new column of 'NLCDbare' from Harvard_Grid_attributes.txt.
# f. For the grass row created in step c above, give a single value for the new column of 'NLCDgrass' from Harvard_Grid_attributes.txt.
# --

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

# -- A) count GLAS pulses TO HGAPER CSS_CAT----

DATA_CAT_18 = DATA %>% 
  group_by(CAT) %>% 
  summarise(COUNT = n()) %>%
  arrange(COUNT)


HGA_CAT_18 = HGA %>% 
  group_by(CAT) %>% 
  summarise(COUNT = n()) %>%
  arrange(COUNT)

# save files
file = file.path(file.path(wdtables,"HGA_by_CAT.csv"))
write.csv(HGA_CAT_18, file, row.names=F)

file = file.path(file.path(wdtables,"DATA_by_CAT.csv"))
write.csv(DATA_CAT_18, file, row.names=F)

# add to carbon-stocks
rdata = file.path(wdrdata,"carbon-stocks.RData")
resave(HGA_CAT_18,DATA_CAT_18,file = rdata)
rm(rdata)


# -- B) !!! [IT WILL APPEND NEW ROWS EVERY TIME IS EVALUATED] ADD 1 new bare row to each of the 18 CSS files. Populate it with a name 'BR', a dbh of 0.2 and a lambda of 0.1, and a PFT value of 10  ----
# Col 7 = lambda
# Col 4  =  dbh 
# Col 6 = PFT

cssls = ls(pattern = "CAT_[0-1][0-9]_CSS")
for (i in cssls) {
  if (!is.null(get(i))){
  assign(i,rbind(get(i),c(0,"BR",length(get(i)[,1])+1,0.2,0,10)))
  } else {
  rm(i)  
  }
}

#  ADD 1 final grass row to each of the 18 CSS files. Populate it with a name 'GR', a dbh of 0.723 and a lambda of 0.196, and a PFT value of 5.

for (i in cssls) {
  if (!is.null(get(i))){
    assign(i,rbind(get(i),c(0,"GR",length(get(i)[,1])+1,0.723,0,5)))  
  } else {
    rm(i)  
  }
}

# ---- write data ----
# Save these changes to csv
for (i in cssls) {
  file = file.path("~/R/carbon-stocks/tables/CAT_CSS",paste(i,".csv",sep=""))
  write.csv(get(i),file,row.names=F)
}

# save RDaata
file = file.path("~/R/carbon-stocks/RData/","CAT_CSS.RData")
save(list=(ls(pattern = "^CAT_")),file=file)
rm(file)

# REMOVE ALL
rm(list = ls())