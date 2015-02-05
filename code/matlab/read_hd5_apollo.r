## EXPLORE FILES IN APOLLO

cd r_wd
module load R
R
library(rhdf5)

# MODIS_LC_harvard.h5 
dataset <- "/mnt/geog/ag448/r_wd/RDF/MODIS_LC_harvard.h5"

#List the content of the HDF5 file.
tmp <- h5ls(dataset)
tmp

# see metadata
#out <- H5Fopen(dataset)



lon <- h5read(dataset, "cell_center_lons")
lat <- h5read(dataset, "cell_center_lats")
landc <- h5read(dataset, "landcover")
dim(landc)

#crop to desired area
lonRan <- c(-72.5, -71.75)
latRan <- c(42, 43.5)
lonKeep <- which(lon > lonRan[1] & lon < lonRan[2])
latKeep <- which(lat> latRan[1] & lat< latRan[2])

landc2 <- landc[lonKeep, latKeep, 1]
range(landc2)
landc2 <- replace(landc2, landc2 == -32768, NaN)
range(landc2, na.rm=TRUE)
landc2 <- (landc2 + 273.15) * 0.01 # change from deg Kelvin to deg Celsius and scale by 0.01 (p.45 http://data.nodc.noaa.gov/pathfinder/Version5.2/GDS_TechSpecs_v2.0.pdf)
range(landc2, na.rm=TRUE)

lon2 <- lon[lonKeep] # subset of lon values
lat2 <- rev(lat[latKeep]) # subset of lat values , and reverse for increasing values
landc2 <- landc2[,rev(seq(latKeep))] # reverse column order (lat) for increasing values








h5ls(dataset,all=T)
landc <- "landcover"
o<-h5read(dataset,landc)


# NLCD_LC_harvard.h5 
dataset <- "/mnt/geog/ag448/r_wd/RDF/NLCD_LC_harvard.h5"
dataset<- h5ls(dataset,all=T)
out <- H5Fopen(dataset)







## F   FUN
h5metadata <- function(fileN, group, natt){
        out <- H5Fopen(fileN)
        g <- H5Gopen(out,group)
        output <- list()
        for(i in 0:(natt-1)){
                ## Open the attribute
                a <- H5Aopen_by_idx(g,i)
                output[H5Aget_name(a)] <-  H5Aread(a)
                ## Close the attributes
                H5Aclose(a)
        }
        H5Gclose(g)
        H5Fclose(out)
        return(output)
}

struct <- h5ls(dataset,all=T)
        g <- paste(struct[2,1:2],collapse="/")
h5metadata(dataset,g,struct$num_attrs[2])