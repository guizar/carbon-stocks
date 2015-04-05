# simple script to update  DATA.RData file 
wdrdata = "~/R/carbon-stocks/RData/"

# save DATA object 
save(list = ls(pattern = "DATA"), file = file.path(wdrdata,"DATA.RData"))