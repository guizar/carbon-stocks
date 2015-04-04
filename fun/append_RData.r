# simple script to update carbon-stocks.RData and DATA.RData - these files are used constantly during the analys

wdrdata = "~/R/carbon-stocks/RData/"

# save carbon-stocks image (all relevant datasets are there)
save.image(file.path(wdrdata,"carbon-stocks.RData"))
# save DATA obect 
save(list = ls(pattern = "DATA"), file = file.path(wdrdata,"DATA.RData"))