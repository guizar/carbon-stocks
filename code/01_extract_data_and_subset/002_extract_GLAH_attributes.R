library(rhdf5)

## Based on the objects from previous code
load("001_GLAH_subsetting.RData")

setwd("/home/a/ag/ag448/Documents/carbon-stocks")
GL01_wd<- 'data/GLAS/GLAH01' 
GL14_wd<- 'data/GLAS/GLAH14' 


files_GLAH01 <- data.frame(id=formatC(seq_len(length(list.files(path = GL01_wd))), width=2, flag="0"), file=list.files(path = GL01_wd, pattern =".H5", full.names = F) ,stringsAsFactors = F )
files_GLAH01[,1] <- as.numeric(files_GLAH01[,1])


files_GLAH14 <- data.frame(id=formatC(seq_len(length(list.files(path = GL14_wd))), width=2, flag="0"), file=list.files(path = GL14_wd, pattern =".H5", full.names = F) ,stringsAsFactors = F )
files_GLAH14[,1] <- as.numeric(files_GLAH14[,1])


# GLAH01
## RecWaveform
att_r_rng_wf <- "/Data_40HZ/Waveform/RecWaveform/r_rng_wf"

# GLAH14
### Elevation_Surfaces
att_d_refRng <- "/Data_40HZ/Elevation_Surfaces/d_refRng"
att_d_elev<- "/Data_40HZ/Elevation_Surfaces/d_elev"

### Elevation_Offsets
att_d_gpCntRngOff <- "/Data_40HZ/Elevation_Offsets/d_gpCntRngOff"
att_d_SigBegOff <- "/Data_40HZ/Elevation_Offsets/d_SigBegOff"
att_d_SigEndOff <- "/Data_40HZ/Elevation_Offsets/d_SigEndOff"
att_d_ldRngOff <- "/Data_40HZ/Elevation_Offsets/d_ldRngOff"

### Waveform
att_d_Gamp <- "/Data_40HZ/Waveform/d_Gamp"
att_d_Gsigma <- "/Data_40HZ/Waveform/d_Gsigma"
att_d_Garea <- "/Data_40HZ/Waveform/d_Garea"
att_i_numPk <- "/Data_40HZ/Waveform/i_numPk"
att_d_maxRecAmp <- "/Data_40HZ/Waveform/d_maxRecAmp"
att_d_maxSmAmp <- "/Data_40HZ/Waveform/d_maxSmAmp"

### Reflectivity
att_d_sDevNsOb1 <- "/Data_40HZ/Reflectivity/d_sDevNsOb1"

## GLAH01
## RecWaveform
for (id in files_GLAH01$id){
        assign(paste("r_rng_wf",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL01_wd,files_GLAH01[[c(2,id)]]),att_r_rng_wf))
        rm(id)
}

rm(r_rng_wf_02)
rm(r_rng_wf_04)
rm(r_rng_wf_06)
rm(r_rng_wf_08)
rm(r_rng_wf_10)
rm(r_rng_wf_12)

r_rng_wf_01 <- r_rng_wf_01[,list_indices_GLAH01[[1]], drop=T]
r_rng_wf_03 <- r_rng_wf_03[,list_indices_GLAH01[[2]], drop=T]
r_rng_wf_05 <- r_rng_wf_05[,list_indices_GLAH01[[3]], drop=T]
r_rng_wf_07 <- r_rng_wf_07[,list_indices_GLAH01[[4]], drop=T]
r_rng_wf_09 <- r_rng_wf_09[,list_indices_GLAH01[[5]], drop=T]
r_rng_wf_11 <- r_rng_wf_11[,list_indices_GLAH01[[6]], drop=T]
r_rng_wf_13 <- r_rng_wf_13[,list_indices_GLAH01[[7]], drop=T]

ind_r_rng_wf <-ls(pattern="^r_rng_wf",) 
list_r_rng_wf <- mget(ind_r_rng_wf, .GlobalEnv)
rm(list = ind_r_rng_wf)
rm(ind_r_rng_wf)


# GLAH14
## Elevation_Surfaces
### d_refRng
for (id in files_GLAH14$id){
        assign(paste("d_refRng",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_refRng))
        rm(id)
}

rm(d_refRng_02)
rm(d_refRng_03)
rm(d_refRng_11)

d_refRng_01 <- d_refRng_01[list_indices_GLAH14[[1]], drop=T]
d_refRng_04 <- d_refRng_04[list_indices_GLAH14[[2]], drop=T]
d_refRng_05 <- d_refRng_05[list_indices_GLAH14[[3]], drop=T]
d_refRng_06 <- d_refRng_06[list_indices_GLAH14[[4]], drop=T]
d_refRng_07 <- d_refRng_07[list_indices_GLAH14[[5]], drop=T]
d_refRng_08 <- d_refRng_08[list_indices_GLAH14[[6]], drop=T]
d_refRng_09 <- d_refRng_09[list_indices_GLAH14[[7]], drop=T]
d_refRng_10 <- d_refRng_10[list_indices_GLAH14[[8]], drop=T]


ind_d_refRng <-ls(pattern="^d_refRng",) 
list_d_refRng <- mget(ind_d_refRng, .GlobalEnv)
rm(list = ind_d_refRng)

### d_elev
for (id in files_GLAH14$id){
        assign(paste("d_elev",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_elev))
        rm(id)
}

rm(d_elev_02)
rm(d_elev_03)
rm(d_elev_11)

d_elev_01 <- d_elev_01[list_indices_GLAH14[[1]], drop=T]
d_elev_04 <- d_elev_04[list_indices_GLAH14[[2]], drop=T]
d_elev_05 <- d_elev_05[list_indices_GLAH14[[3]], drop=T]
d_elev_06 <- d_elev_06[list_indices_GLAH14[[4]], drop=T]
d_elev_07 <- d_elev_07[list_indices_GLAH14[[5]], drop=T]
d_elev_08 <- d_elev_08[list_indices_GLAH14[[6]], drop=T]
d_elev_09 <- d_elev_09[list_indices_GLAH14[[7]], drop=T]
d_elev_10 <- d_elev_10[list_indices_GLAH14[[8]], drop=T]


ind_d_elev <-ls(pattern="^d_elev",) 
list_d_elev <- mget(ind_d_elev, .GlobalEnv)
rm(list = ind_d_elev)

## Elevation_Offsets
### d_gpCntRngOff
for (id in files_GLAH14$id){
        assign(paste("d_gpCntRngOff",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_gpCntRngOff))
        rm(id)
}

rm(d_gpCntRngOff_02)
rm(d_gpCntRngOff_03)
rm(d_gpCntRngOff_11)

d_gpCntRngOff_01 <- d_gpCntRngOff_01[,list_indices_GLAH14[[1]], drop=T]
d_gpCntRngOff_04 <- d_gpCntRngOff_04[,list_indices_GLAH14[[2]], drop=T]
d_gpCntRngOff_05 <- d_gpCntRngOff_05[,list_indices_GLAH14[[3]], drop=T]
d_gpCntRngOff_06 <- d_gpCntRngOff_06[,list_indices_GLAH14[[4]], drop=T]
d_gpCntRngOff_07 <- d_gpCntRngOff_07[,list_indices_GLAH14[[5]], drop=T]
d_gpCntRngOff_08 <- d_gpCntRngOff_08[,list_indices_GLAH14[[6]], drop=T]
d_gpCntRngOff_09 <- d_gpCntRngOff_09[,list_indices_GLAH14[[7]], drop=T]
d_gpCntRngOff_10 <- d_gpCntRngOff_10[,list_indices_GLAH14[[8]], drop=T]

ind_d_gpCntRngOff <-ls(pattern="^d_gpCntRngOff",) 
list_d_gpCntRngOff <- mget(ind_d_gpCntRngOff, .GlobalEnv)
rm(list = ind_d_gpCntRngOff)

### d_SigBegOff
for (id in files_GLAH14$id){
        assign(paste("d_SigBegOff",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_SigBegOff))
        rm(id)
}

rm(d_SigBegOff_02)
rm(d_SigBegOff_03)
rm(d_SigBegOff_11)

d_SigBegOff_01 <- d_SigBegOff_01[list_indices_GLAH14[[1]], drop=T]
d_SigBegOff_04 <- d_SigBegOff_04[list_indices_GLAH14[[2]], drop=T]
d_SigBegOff_05 <- d_SigBegOff_05[list_indices_GLAH14[[3]], drop=T]
d_SigBegOff_06 <- d_SigBegOff_06[list_indices_GLAH14[[4]], drop=T]
d_SigBegOff_07 <- d_SigBegOff_07[list_indices_GLAH14[[5]], drop=T]
d_SigBegOff_08 <- d_SigBegOff_08[list_indices_GLAH14[[6]], drop=T]
d_SigBegOff_09 <- d_SigBegOff_09[list_indices_GLAH14[[7]], drop=T]
d_SigBegOff_10 <- d_SigBegOff_10[list_indices_GLAH14[[8]], drop=T]

ind_d_SigBegOff <-ls(pattern="^d_SigBegOff",) 
list_d_SigBegOff <- mget(ind_d_SigBegOff, .GlobalEnv)
rm(list = ind_d_SigBegOff)

### d_SigEndOff
for (id in files_GLAH14$id){
        assign(paste("d_SigEndOff",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_SigEndOff))
        rm(id)
}

rm(d_SigEndOff_02)
rm(d_SigEndOff_03)
rm(d_SigEndOff_11)

d_SigEndOff_01 <- d_SigEndOff_01[list_indices_GLAH14[[1]], drop=T]
d_SigEndOff_04 <- d_SigEndOff_04[list_indices_GLAH14[[2]], drop=T]
d_SigEndOff_05 <- d_SigEndOff_05[list_indices_GLAH14[[3]], drop=T]
d_SigEndOff_06 <- d_SigEndOff_06[list_indices_GLAH14[[4]], drop=T]
d_SigEndOff_07 <- d_SigEndOff_07[list_indices_GLAH14[[5]], drop=T]
d_SigEndOff_08 <- d_SigEndOff_08[list_indices_GLAH14[[6]], drop=T]
d_SigEndOff_09 <- d_SigEndOff_09[list_indices_GLAH14[[7]], drop=T]
d_SigEndOff_10 <- d_SigEndOff_10[list_indices_GLAH14[[8]], drop=T]

ind_d_SigEndOff <-ls(pattern="^d_SigEndOff",) 
list_d_SigEndOff <- mget(ind_d_SigEndOff, .GlobalEnv)
rm(list = ind_d_SigEndOff)

### d_ldRngOff
for (id in files_GLAH14$id){
        assign(paste("d_ldRngOff",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_ldRngOff))
        rm(id)
}

rm(d_ldRngOff_02)
rm(d_ldRngOff_03)
rm(d_ldRngOff_11)

d_ldRngOff_01 <- d_ldRngOff_01[list_indices_GLAH14[[1]], drop=T]
d_ldRngOff_04 <- d_ldRngOff_04[list_indices_GLAH14[[2]], drop=T]
d_ldRngOff_05 <- d_ldRngOff_05[list_indices_GLAH14[[3]], drop=T]
d_ldRngOff_06 <- d_ldRngOff_06[list_indices_GLAH14[[4]], drop=T]
d_ldRngOff_07 <- d_ldRngOff_07[list_indices_GLAH14[[5]], drop=T]
d_ldRngOff_08 <- d_ldRngOff_08[list_indices_GLAH14[[6]], drop=T]
d_ldRngOff_09 <- d_ldRngOff_09[list_indices_GLAH14[[7]], drop=T]
d_ldRngOff_10 <- d_ldRngOff_10[list_indices_GLAH14[[8]], drop=T]

ind_d_ldRngOff <-ls(pattern="^d_ldRngOff",) 
list_d_ldRngOff <- mget(ind_d_ldRngOff, .GlobalEnv)
rm(list = ind_d_ldRngOff)

### Waveform
### d_Gamp
for (id in files_GLAH14$id){
        assign(paste("d_Gamp",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_Gamp))
        rm(id)
}

rm(d_Gamp_02)
rm(d_Gamp_03)
rm(d_Gamp_11)

d_Gamp_01 <- d_Gamp_01[,list_indices_GLAH14[[1]], drop=T]
d_Gamp_04 <- d_Gamp_04[,list_indices_GLAH14[[2]], drop=T]
d_Gamp_05 <- d_Gamp_05[,list_indices_GLAH14[[3]], drop=T]
d_Gamp_06 <- d_Gamp_06[,list_indices_GLAH14[[4]], drop=T]
d_Gamp_07 <- d_Gamp_07[,list_indices_GLAH14[[5]], drop=T]
d_Gamp_08 <- d_Gamp_08[,list_indices_GLAH14[[6]], drop=T]
d_Gamp_09 <- d_Gamp_09[,list_indices_GLAH14[[7]], drop=T]
d_Gamp_10 <- d_Gamp_10[,list_indices_GLAH14[[8]], drop=T]

ind_d_Gamp <-ls(pattern="^d_Gamp",) 
list_d_Gamp <- mget(ind_d_Gamp, .GlobalEnv)
rm(list = ind_d_Gamp)

### d_Gsigma
for (id in files_GLAH14$id){
        assign(paste("d_Gsigma",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_Gsigma))
        rm(id)
}

rm(d_Gsigma_02)
rm(d_Gsigma_03)
rm(d_Gsigma_11)

d_Gsigma_01 <- d_Gsigma_01[,list_indices_GLAH14[[1]], drop=T]
d_Gsigma_04 <- d_Gsigma_04[,list_indices_GLAH14[[2]], drop=T]
d_Gsigma_05 <- d_Gsigma_05[,list_indices_GLAH14[[3]], drop=T]
d_Gsigma_06 <- d_Gsigma_06[,list_indices_GLAH14[[4]], drop=T]
d_Gsigma_07 <- d_Gsigma_07[,list_indices_GLAH14[[5]], drop=T]
d_Gsigma_08 <- d_Gsigma_08[,list_indices_GLAH14[[6]], drop=T]
d_Gsigma_09 <- d_Gsigma_09[,list_indices_GLAH14[[7]], drop=T]
d_Gsigma_10 <- d_Gsigma_10[,list_indices_GLAH14[[8]], drop=T]

ind_d_Gsigma <-ls(pattern="^d_Gsigma",) 
list_d_Gsigma <- mget(ind_d_Gsigma, .GlobalEnv)
rm(list = ind_d_Gsigma)

### d_Garea
for (id in files_GLAH14$id){
        assign(paste("d_Garea",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_Garea))
        rm(id)
}

rm(d_Garea_02)
rm(d_Garea_03)
rm(d_Garea_11)

d_Garea_01 <- d_Garea_01[,list_indices_GLAH14[[1]], drop=T]
d_Garea_04 <- d_Garea_04[,list_indices_GLAH14[[2]], drop=T]
d_Garea_05 <- d_Garea_05[,list_indices_GLAH14[[3]], drop=T]
d_Garea_06 <- d_Garea_06[,list_indices_GLAH14[[4]], drop=T]
d_Garea_07 <- d_Garea_07[,list_indices_GLAH14[[5]], drop=T]
d_Garea_08 <- d_Garea_08[,list_indices_GLAH14[[6]], drop=T]
d_Garea_09 <- d_Garea_09[,list_indices_GLAH14[[7]], drop=T]
d_Garea_10 <- d_Garea_10[,list_indices_GLAH14[[8]], drop=T]

ind_d_Garea <-ls(pattern="^d_Garea",) 
list_d_Garea <- mget(ind_d_Garea, .GlobalEnv)
rm(list = ind_d_Garea)

### i_numPk
for (id in files_GLAH14$id){
        assign(paste("i_numPk",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_i_numPk))
        rm(id)
}

rm(i_numPk_02)
rm(i_numPk_03)
rm(i_numPk_11)

i_numPk_01 <- i_numPk_01[list_indices_GLAH14[[1]], drop=T]
i_numPk_04 <- i_numPk_04[list_indices_GLAH14[[2]], drop=T]
i_numPk_05 <- i_numPk_05[list_indices_GLAH14[[3]], drop=T]
i_numPk_06 <- i_numPk_06[list_indices_GLAH14[[4]], drop=T]
i_numPk_07 <- i_numPk_07[list_indices_GLAH14[[5]], drop=T]
i_numPk_08 <- i_numPk_08[list_indices_GLAH14[[6]], drop=T]
i_numPk_09 <- i_numPk_09[list_indices_GLAH14[[7]], drop=T]
i_numPk_10 <- i_numPk_10[list_indices_GLAH14[[8]], drop=T]

ind_i_numPk <-ls(pattern="^i_numPk",) 
list_i_numPk <- mget(ind_i_numPk, .GlobalEnv)
rm(list = ind_i_numPk)

### d_maxRecAmp
for (id in files_GLAH14$id){
        assign(paste("d_maxRecAmp",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_maxRecAmp))
        rm(id)
}

rm(d_maxRecAmp_02)
rm(d_maxRecAmp_03)
rm(d_maxRecAmp_11)

d_maxRecAmp_01 <- d_maxRecAmp_01[list_indices_GLAH14[[1]], drop=T]
d_maxRecAmp_04 <- d_maxRecAmp_04[list_indices_GLAH14[[2]], drop=T]
d_maxRecAmp_05 <- d_maxRecAmp_05[list_indices_GLAH14[[3]], drop=T]
d_maxRecAmp_06 <- d_maxRecAmp_06[list_indices_GLAH14[[4]], drop=T]
d_maxRecAmp_07 <- d_maxRecAmp_07[list_indices_GLAH14[[5]], drop=T]
d_maxRecAmp_08 <- d_maxRecAmp_08[list_indices_GLAH14[[6]], drop=T]
d_maxRecAmp_09 <- d_maxRecAmp_09[list_indices_GLAH14[[7]], drop=T]
d_maxRecAmp_10 <- d_maxRecAmp_10[list_indices_GLAH14[[8]], drop=T]

ind_d_maxRecAmp <-ls(pattern="^d_maxRecAmp",) 
list_d_maxRecAmp <- mget(ind_d_maxRecAmp, .GlobalEnv)
rm(list = ind_d_maxRecAmp)

### d_maxSmAmp
for (id in files_GLAH14$id){
        assign(paste("d_maxSmAmp",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_maxSmAmp))
        rm(id)
}

rm(d_maxSmAmp_02)
rm(d_maxSmAmp_03)
rm(d_maxSmAmp_11)

d_maxSmAmp_01 <- d_maxSmAmp_01[list_indices_GLAH14[[1]], drop=T]
d_maxSmAmp_04 <- d_maxSmAmp_04[list_indices_GLAH14[[2]], drop=T]
d_maxSmAmp_05 <- d_maxSmAmp_05[list_indices_GLAH14[[3]], drop=T]
d_maxSmAmp_06 <- d_maxSmAmp_06[list_indices_GLAH14[[4]], drop=T]
d_maxSmAmp_07 <- d_maxSmAmp_07[list_indices_GLAH14[[5]], drop=T]
d_maxSmAmp_08 <- d_maxSmAmp_08[list_indices_GLAH14[[6]], drop=T]
d_maxSmAmp_09 <- d_maxSmAmp_09[list_indices_GLAH14[[7]], drop=T]
d_maxSmAmp_10 <- d_maxSmAmp_10[list_indices_GLAH14[[8]], drop=T]

ind_d_maxSmAmp <-ls(pattern="^d_maxSmAmp",) 
list_d_maxSmAmp <- mget(ind_d_maxSmAmp, .GlobalEnv)
rm(list = ind_d_maxSmAmp)



### Reflectivity
### d_sDevNsOb1
for (id in files_GLAH14$id){
        assign(paste("d_sDevNsOb1",formatC(id,width=2,flag="0"),sep="_"), h5read(file.path(GL14_wd,files_GLAH14[[c(2,id)]]),att_d_sDevNsOb1))
        rm(id)
}

rm(d_sDevNsOb1_02)
rm(d_sDevNsOb1_03)
rm(d_sDevNsOb1_11)

d_sDevNsOb1_01 <- d_sDevNsOb1_01[list_indices_GLAH14[[1]], drop=T]
d_sDevNsOb1_04 <- d_sDevNsOb1_04[list_indices_GLAH14[[2]], drop=T]
d_sDevNsOb1_05 <- d_sDevNsOb1_05[list_indices_GLAH14[[3]], drop=T]
d_sDevNsOb1_06 <- d_sDevNsOb1_06[list_indices_GLAH14[[4]], drop=T]
d_sDevNsOb1_07 <- d_sDevNsOb1_07[list_indices_GLAH14[[5]], drop=T]
d_sDevNsOb1_08 <- d_sDevNsOb1_08[list_indices_GLAH14[[6]], drop=T]
d_sDevNsOb1_09 <- d_sDevNsOb1_09[list_indices_GLAH14[[7]], drop=T]
d_sDevNsOb1_10 <- d_sDevNsOb1_10[list_indices_GLAH14[[8]], drop=T]

ind_d_sDevNsOb1 <-ls(pattern="^d_sDevNsOb1",) 
list_d_sDevNsOb1 <- mget(ind_d_sDevNsOb1, .GlobalEnv)
rm(list = ind_d_sDevNsOb1)

rm(list=ls(pattern="att_"))
rm(list=ls(pattern="*_wd"))

save.image("002_GLAH_attributes.RData")


########
library(rhdf5)

GL01_wd<- 'data/GLAS/GLAH01'
file = "GLAH01_033_2107_003_0279_2_01_0001.H5"

time05 =h5read(file.path(GL01_wd,file),"/METADATA")
time05 = h5ls(file.path(GL01_wd,file), FALSE)

write.csv(time05,"output.csv")

fid <-H5Fopen(file.path(GL01_wd,file))
# Get the number of global attributes
H5O(fid,time_start)



time_start =  "time_coverage_start"
time_end = "time_coverage_end"

