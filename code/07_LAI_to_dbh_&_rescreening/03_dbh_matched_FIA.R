#--- CSS structure:----
# | 1 |
# length(base) <- 0
# | 2 |
# length(base) <- "04_31" substr(i,1,6)        
# | 3 |
# 1:length(base)
# | 4 |
# length(base) <- dbh6
# | 5 |
# height[ind_signBeg_3m]
# | 6 | 
# length(base) <- 6
# | 7 |
# is.na(lambdapft6) <- 0
# ---

library(rgdal)

wd = "~/R/carbon-stocks/"
wdrdata = "~/R/carbon-stocks/RData/"
load("~/R/carbon-stocks/RData/carbon-stocks.RData")

### INFO
# LAI_3m_df 
# Contains shot indices

# FIA_plot_spdf
# Contains FIA data

# closestMatch_FIA_GLAH
# Contains indices of matching FIA GLAH shots
###

# Iterate over pft matrix to calculate dbh vals

CSS_DBH_854 =data.frame()


for (sht in seq(length(GLAH14_pulses))){

# FIA data
FIAm = FIA_spdf[closestMatch_FIA_GLAH$nn.index[sht],]

# Glas shot
e= names(GLAH14_pulses[sht])

print(paste("GLAS =", e),sep=" ")

#print(paste("FIA =", print(FIAm@data),sep=" "))
shotnumber = GLAH14_pulses[[sht]]
LGE = shotnumber$elev
LGW = shotnumber$waveform
height = shotnumber$height
ind_signBeg_3m = shotnumber$ind_signBeg_3m
ind_signBeg = unique(match(ind_signBeg_3m[ind_signBeg_3m==T],ind_signBeg_3m))
base = height[ind_signBeg_3m]
LAIc= -log(shotnumber$P_wave)/(0.5 * 0.735)*(FIAm$PFT6.BA + FIAm$PFT8.BA) # sig beg to 3 meters
LAIh= -log(shotnumber$P_wave)/(0.5 * 0.84)*(FIAm$PFT9.BA + FIAm$PFT10.BA + FIAm$PFT11.BA)

LAI = (LAIc+LAIh)

diffLAI = diff(LAI,1)
diffLAI = c(LAI[1],diffLAI)


dbh6 = (10^(0.0331 * base + 0.8273))
dbh8 = (10^(0.0324 * base + 0.9692))
dbh9 = (10^(0.0445 * base + 0.5680))
dbh10 = (10^(0.0476 * base + 0.5192))
dbh11 = (10^(0.0290 * base + 0.8264))

# max heights for bleaf

h1 = 15 
ind_maxhite = base < (h1+0.15) & base > (h1-0.15)

maxhite = base[ind_maxhite][1]
if (base[1] <h1){
maxhite = height[ind_signBeg]
}

#### calculate biomass ####
zz = base > (h1-0.15)
zz_1 = length(zz[zz]) # indx at  > (h1-0.15)


Bleafpft6 = 0.024*dbh6^1.899
Bleafpft6[zz] = Bleafpft6[zz_1]

Bleafpft8 = 0.045*dbh8^1.683
Bleafpft8[zz] = Bleafpft8[zz_1]

Bleafpft9 = 0.0031*dbh9^2.249
Bleafpft9[zz] = Bleafpft9[zz_1]

Bleafpft10 = 0.0148*dbh10^1.86
Bleafpft10[zz] = Bleafpft10[zz_1]

Bleafpft11 = 0.0085*dbh11^1.731
Bleafpft11[zz] = Bleafpft11[zz_1]

##### lambda 
lambdapft6 = (diffLAI/(6*Bleafpft6))* FIAm$PFT6.BA
lambdapft8 = (diffLAI/(10*Bleafpft8))*FIAm$PFT8.BA
lambdapft9 = (diffLAI/(30*Bleafpft9))*FIAm$PFT9.BA
lambdapft10 = (diffLAI/(24.2*Bleafpft10))*FIAm$PFT10.BA
lambdapft11 = (diffLAI/(60*Bleafpft11))*FIAm$PFT11.BA
#####

#NPLANT LIST
nplant = list(lambdapft6=lambdapft6,lambdapft8=lambdapft8,lambdapft9=lambdapft9,lambdapft10=lambdapft10,lambdapft11=lambdapft11)


is.na(nplant$lambdapft6) = 0
is.na(nplant$lambdapft8) = 0
is.na(nplant$lambdapft9) = 0
is.na(nplant$lambdapft10) = 0
is.na(nplant$lambdapft11) = 0

       
n =c(6,8,9,10,11)


for ( i in n){

assign(paste("css",i,sep=""), 
       data.frame(
       "1"=rep(0,times = length(base)), 
       "2"=rep(e,times = length(base)),
       # "4"= 1:length(base), 
       "4"=get(paste("dbh",i,sep="")),
       "5"=base, 
       "6"=rep(substr(i,1,6),times = length(base)),
       "7"=get(paste("lambdapft",i,sep=""))))      
}

# rename cols
colnames(css6)= c("1","2","4","5","6","7")
colnames(css8)= c("1","2","4","5","6","7")
colnames(css9)= c("1","2","4","5","6","7")
colnames(css10)= c("1","2","4","5","6","7")
colnames(css11)= c("1","2","4","5","6","7")

# Rbind all css 
assign(paste("css",e,sep="_"), rbind(css6,css8,css9,css10,css11))

lenccs =  data.frame("3"=1:length(get(as.character(paste("css",e,sep="_")))[["1"]]))

colnames(lenccs)= "3"

####
assign(paste("css",e,sep="_"), cbind(get(as.character(paste("css",e,sep="_"))),lenccs))
assign(paste("css",e,sep="_"), get(as.character(paste("css",e,sep="_")))[c("1","2","3","4","5","6","7")])



# Write GLAS shot csv
file = file.path("~/R/carbon-stocks/tables/CSS_DBH_854",paste("css",e,sep="_"))
write.csv(get(as.character(paste("css",e,sep="_"))), paste(file,".csv",sep=""), row.names=F)


#### Basal area ####
# Basal area

Basal_area = ((get(as.character(paste("css",e,sep="_")))[["4"]] )^2) * get(as.character(paste("css",e,sep="_")))[["7"]] * 0.25 * pi

# plot(y=base,x=Basal_area_i[1:130],type = "line")


# Basal area total
Basal_area_total = sum(Basal_area)


# total LAI
LAItotal = max(LAI)

# total LAIm
heightMax =  max(base)

tmplist = data.frame("ID" = paste("css",e,sep="_"),
     coordinates(LAI_3m_df[sht,1:2]),
     "shot" = e,
     "Basal_area_total" = Basal_area_total, 
     "LAItotal" = LAItotal, 
     "heightMax" = heightMax)


rm(list=ls(pattern = "^css"))
rm(list=ls(pattern = "^Basal"))
rm(list=ls(pattern = "^lambdapft")) 

# add FIA info
tmplist = cbind(tmplist,FIAm@data)


## Add LGW 
# tmpsht = paste("x",formatC(1:length(LGW),width=3,flag="0"),sep="")
tmpsht =  data.frame(sht = 1:544, LGW = LGW)
tmpsht = t(tmpsht[,-1])
tmplist = cbind(tmplist,tmpsht)


CSS_DBH_854 = rbind(CSS_DBH_854,tmplist)
}

# --- WRITE files ----
#csv
file = file.path("~/R/carbon-stocks/tables","CSS_DBH_854.csv")
write.csv(CSS_DBH_854,file=file,row.names=F)


# #RData
# file = file.path("~/R/carbon-stocks/RData/","CSS_DBH_854.RData")
# save.image(get(as.character(paste("css",e,sep="_"))),file=file)

rm(file)
rm(get(as.character(paste("css",e,sep="_"))))
rm(nplant)
rm(pfti)
rm(shotnumber)
rm(zz)
rm(zz_1)
rm(LGE)
rm(LGW)
rm(LAI)
rm(LAIc)
rm(LAIh)
rm(heightMax)
rm(height)
rm(i)
rm(id)
rm(ind_maxhite)
rm(ind_signBeg)
rm(ind_signBeg_3m)
rm(h1)
rm(e)
rm(diffLAI)
rm(list=ls(pattern = "^Bleafpft"))
rm(list=ls(pattern = "^dbh"))
rm(lenccs)
rm(tmplist)
rm(tmpsht)
rm(base)
rm(zz)
rm(zz_1)
rm(LGE)
rm(LGW)
rm(LAI)
rm(LAIc)
rm(LAIh)
rm(heightMax)
rm(height)
rm(i)
rm(id)
rm(ind_maxhite)
rm(ind_signBeg)
rm(ind_signBeg_3m)
rm(h1)
rm(e)
rm(diffLAI)
rm(n)
rm(maxhite)
rm(sht)

save.image("RData/carbon-stocks.RData")
