library(raster)
library(rgdal)

# read
FIA.plot.info <- read.delim("~/R/carbon-stocks/data/FIA/FIA plot info.txt")
FIA.NE <- read.delim("~/R/carbon-stocks/data/FIA/FIA_NewEngland.txt")


# change coord names
colnames(FIA.plot.info)[4] = "y"
colnames(FIA.plot.info)[5] = "x"

colnames(FIA.NE)[4] = "y"
colnames(FIA.NE)[5] = "x"

# FIA df
FIA= FIA.plot.info[,c("y","x","PFT6.BA","PFT7.BA","PFT8.BA","PFT9.BA","PFT10.BA", "PFT11.BA")]

FIA.NE= FIA.NE[,c("y","x","PFT6","PFT7","PFT8","PFT9","PFT10", "PFT11")]
colnames(FIA.NE) = c("y","x","PFT6.BA","PFT7.BA","PFT8.BA","PFT9.BA","PFT10.BA", "PFT11.BA")

FIA = rbind(FIA,FIA.NE)


FIA_spdf <- FIA

coordinates(FIA_spdf) <- ~x+y




#####
#####

# get closest match betwen FIA and LAI_waveform
library(FNN)
library(raster)

# get.knnx
closestMatch_FIA_GLAH = get.knnx(data=FIA_spdf@coords, query=LAI_3m_df[1:2],k = 1)



## SEE UNIQUE MATCHES
as.vector(unique(closestMatch_FIA_GLAH$nn.index)) ## indexed in FIA_spdf



## FOR THE DBH CALCULATION (03_dbh_matched_FIA) USE knnx_LC_waveForm_LAI and LAI_3m_df





#### not needed
# # conver LAI_3m to SPDF
# LAI_3m_spdf = LAI_3m_spdf
# coordinates(LAI_3m_spdf) <- ~x+y
# 
# ## Crop landcover SPDF to matched records
# LAI_3m_spdf <- LAI_3m_spdf[as.vector(unique(knnx_LC_waveForm_LAI$nn.index)),]
# 
# 
# 
# ## Plot to see the match
# plot(FIA_matched)
# ext<-drawExtent()
# 
# plot(FIA_matched,ylim = c(ymin(ext), ymax(ext)), xlim=c(xmin(ext),xmax(ext)))
# points(LAI_waveForm)
# 
# 
# 
# 
# 
# 
# 
# ########## THE OTHER WAY AROUND - same thing
# # get.knnx
# knnx_LC_waveForm_LAI_2 <- get.knnx(LAI_waveForm[1:2],FIA_spdf@coords,1)
# 
# 
# ## Crop landcover SPDF to matched records
# FIA_matched_2 <- FIA_matched[as.vector(knnx_LC_waveForm_LAI_2[["nn.index"]]),]
# 
# ## add eucledian distances
# FIA_matched_2$dist_to_closest <-knnx_LC_waveForm_LAI_2$nn.dist
# 
# ## Plot to see the match
# plot(FIA_matched_2)
# ext<-drawExtent()
# 
# plot(FIA_matched,ylim = c(ymin(ext), ymax(ext)), xlim=c(xmin(ext),xmax(ext)))
# points(LAI_waveForm)
# 
# 
# 
# 
