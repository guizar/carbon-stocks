# ---
# create an RData obj with all CSS_DBH_854
# ---

rm(list = ls())
wd = "~/R/carbon-stocks/"
wdcss = "~/R/carbon-stocks/tables/CSS_DBH_854/"

files=list.files(path = wdcss, pattern =".csv", full.names = F)

for (i in files){
  print(i)
  assign(substr(i,1,10),read.csv(file.path(wdcss,i),header = T, row.names = NULL, stringsAsFactors=FALSE))
}

rm(i)
rm(files)
rm(wd)
rm(wdcss)

# save.image("~/R/carbon-stocks/RData/CSS_DBH_854.RData")

