# not working!










# Import the point map:

wesepe.c <- read.delim("http://spatial-analyst.net/DATA/wesepe_c.eas", skip=5, col.names=c("X","Y","c3"))
str(wesepe.c)

# convert to a spatial point data layer:

coordinates(wesepe.c) <-~X+Y
spplot(wesepe.c["c3"], col.regions=bpy.colors(), scales=list(draw = TRUE))

# Estimate the sampling density and related cell size:

wesepe.area <- (wesepe.c@bbox[1,2]-wesepe.c@bbox[1,1])*(wesepe.c@bbox[2,2]-wesepe.c@bbox[2,1])
wesepe.dens <- length(wesepe.c$c3)/wesepe.area * 1e6    # 48 observations per km^2
wesepe.pixsize0 <- 0.0791 * sqrt(wesepe.area/length(wesepe.c$c3)) # 11.44169







#---- MODIS EVI

# Selection of the cell size for interpolation purposes:
# Estimate the sampling density and related cell size:

MODIS_EVI.area <- (MODIS_EVI_DF@bbox[1,2]-MODIS_EVI_DF@bbox[1,1])*(MODIS_EVI_DF@bbox[2,2]-MODIS_EVI_DF@bbox[2,1])
MODIS_EVI.dens <- length(MODIS_EVI_DF$modis_evi)/MODIS_EVI.area * 1e6    # 48 observations per km^2
MODIS_EVI.pixsize0 <- 0.0791 * sqrt(MODIS_EVI.area/length(MODIS_EVI_DF$modis_evi)) # 11.44169

# look at the spreading between the points:

library(spatstat)
MODIS_EVI.ppp <- as(MODIS_EVI_DF["modis_evi"], "ppp")
plot(MODIS_EVI.ppp)
dist.MODIS_EVI <- nndist(MODIS_EVI.ppp$x, MODIS_EVI.ppp$y)
dist.box <- boxplot(dist.MODIS_EVI, col="grey")
hist(dist.MODIS_EVI, breaks=30, col="grey")  # shows close to normal distribution;

MODIS_EVI.pixsize1 <- dist.box$stats[3]/2   # 57.1696
MODIS_EVI.pixsize2 <- qnorm(0.05, mean=mean(dist.MODIS_EVI), sd=sd(dist.MODIS_EVI), lower.tail=T)  # 14.14624
MODIS_EVI.pixsize3 <- quantile(dist.MODIS_EVI, probs=0.01)  # 4.472136

# now analyze the auto-correlation structure of the target variable:

library(gstat)
MODIS_EVI_DF$tmodis_evi <- log(MODIS_EVI_DF$modis_evi/(1-MODIS_EVI_DF$modis_evi))  # logit transformation is used to prevent the target variable to exceed 0-1 range;
sel = !is.infinite(MODIS_EVI_DF$tmodis_evi)
plot(variogram(tmodis_evi~1, MODIS_EVI_DF[sel,]))
tmodis_evi.var <- variogram(tmodis_evi~1, MODIS_EVI_DF[sel,])
tmodis_evi.vgm <- fit.variogram(tmodis_evi.var, vgm(nugget=0.5*var(MODIS_EVI_DF[sel,]$tmodis_evi), model="Exp", range=sqrt(MODIS_EVI.area)/3, psill=var(MODIS_EVI_DF[sel,]$tmodis_evi)))
plot(tmodis_evi.var, tmodis_evi.vgm, plot.nu=T)
tmodis_evi.vgm

MODIS_EVI.pixsize4 <- tmodis_evi.vgm[2,"range"]*3/2   # 160.6867  (for an exponential model);
m.pairs <- sum(subset(tmodis_evi.var, dist<tmodis_evi.vgm[2,"range"]*3, np))  # number of point pairs within the range of spatial dependence;
MODIS_EVI.pixsize5 <- tmodis_evi.vgm[2,"range"]*3 * (m.pairs)^(-1/3)  # 21.63857

# Interpolate the target variable using various cell sizes:
# this is just for a comparison;

# first, generate grids based on the results we got above:

grid.MODIS_EVI.0 <- expand.grid(x=seq(MODIS_EVI_DF@bbox["X","min"]+MODIS_EVI.pixsize0/2,MODIS_EVI_DF@bbox["X","max"]-MODIS_EVI.pixsize0/2,MODIS_EVI.pixsize0), y=seq(MODIS_EVI_DF@bbox["Y","min"]+MODIS_EVI.pixsize0/2,MODIS_EVI_DF@bbox["Y","max"]-MODIS_EVI.pixsize0/2,MODIS_EVI.pixsize0))
gridded(grid.MODIS_EVI.0) <- ~x+y
grid.MODIS_EVI.1 <- expand.grid(x=seq(MODIS_EVI_DF@bbox["X","min"]+MODIS_EVI.pixsize1/2,MODIS_EVI_DF@bbox["X","max"]-MODIS_EVI.pixsize1/2,MODIS_EVI.pixsize0), y=seq(MODIS_EVI_DF@bbox["Y","min"]+MODIS_EVI.pixsize1/2,MODIS_EVI_DF@bbox["Y","max"]-MODIS_EVI.pixsize1/2,MODIS_EVI.pixsize1))
gridded(grid.MODIS_EVI.1) <- ~x+y
grid.MODIS_EVI.5 <- expand.grid(x=seq(MODIS_EVI_DF@bbox["X","min"]+MODIS_EVI.pixsize5/2,MODIS_EVI_DF@bbox["X","max"]-MODIS_EVI.pixsize5/2,MODIS_EVI.pixsize0), y=seq(MODIS_EVI_DF@bbox["Y","min"]+MODIS_EVI.pixsize5/2,MODIS_EVI_DF@bbox["Y","max"]-MODIS_EVI.pixsize5/2,MODIS_EVI.pixsize5))
gridded(grid.MODIS_EVI.5) <- ~x+y

# run ordinary block kriging and compare the outputs:
# this can be time-consuming for large datasets!!

MODIS_EVI_DFf <- remove.duplicates(MODIS_EVI_DF[sel,], zero=1)
gstat.MODIS_EVI <- gstat(id=c("tmodis_evi"), formula=tmodis_evi~1, data=MODIS_EVI_DFf, model=tmodis_evi.vgm)
modis_evi.krige0 <- predict.gstat(gstat.MODIS_EVI, nmax=20, newdata=grid.MODIS_EVI.0, block=c(MODIS_EVI.pixsize0,MODIS_EVI.pixsize0), beta=1, BLUE=FALSE)
modis_evi.krige1 <- predict.gstat(gstat.MODIS_EVI, nmax=40, newdata=grid.MODIS_EVI.1, block=c(MODIS_EVI.pixsize1,MODIS_EVI.pixsize1), beta=1, BLUE=FALSE)
modis_evi.krige5 <- predict.gstat(gstat.MODIS_EVI, nmax=40, newdata=grid.MODIS_EVI.5, block=c(MODIS_EVI.pixsize5,MODIS_EVI.pixsize5), beta=1, BLUE=FALSE)
# back-transform the values;
modis_evi.krige0$tmodis_evi <- exp(modis_evi.krige0$tmodis_evi.pred)/(1+exp(modis_evi.krige0$tmodis_evi.pred))
modis_evi.krige1$tmodis_evi <- exp(modis_evi.krige1$tmodis_evi.pred)/(1+exp(modis_evi.krige1$tmodis_evi.pred))
modis_evi.krige5$tmodis_evi <- exp(modis_evi.krige5$tmodis_evi.pred)/(1+exp(modis_evi.krige5$tmodis_evi.pred))

spplot(modis_evi.krige1["tmodis_evi"], col.regions=bpy.colors(), at=seq(0,1,0.05), sp.layout=list("sp.points", pch="+", col="cyan", MODIS_EVI_DF))

par(mfrow=c(1, 3))
image(modis_evi.krige0["tmodis_evi"], col=bpy.colors(), asp=1)
image(modis_evi.krige5["tmodis_evi"], col=bpy.colors(), asp=1)
image(modis_evi.krige1["tmodis_evi"], col=bpy.colors(), asp=1)
# This is Fig.11 in http://dx.doi.org/10.1016/j.cageo.2005.11.008

# Conclusions: sampling density corresponds to cell size of 12 m; the coarsest legible cell size is 57 m;
# statistically optimal cell size suitable to represent the spatial auto-correlation for this target variable is 22 m;
