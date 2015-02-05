######### FIRST RUN CODE : 04_list_post_screening_available_GLAH14_shots

###### This code extract waveform data, create modelwave based on the gaussians, calculate LAIs, and create a list with all these info.

# The final list will consist of the following information:

#  GLAH14 file| indx | height | waveform | modelwave | LAI_wave | LAI_model | maxLAIs | Ps | ind_signBegEnd | ind_signBeg_3m


# After running this code there's no need to run LAIS scripts
#################################


# create empty objects (to be filled in)
GLAH14_pulses <- list()
LAI_3m_df <-data.frame()


################# For loop: for all available and screened GLAH14

for (i in seq(length(GLAH14_validated_shots$files))){        
        matched_tmp <- Matched_records_reference[Matched_records_reference$GLAH14==GLAH14_validated_shots$files[i],]
        
        for  (e in GLAH14_validated_shots[[paste("screened",GLAH14_validated_shots$files[i],sep="_")]]){

                df <- matched_tmp[matched_tmp$GLAH14_rownumber==e,] #tmp

############################# 1.- Extract data
## r_rng_wf
m <- list_r_rng_wf[paste("r_rng_wf_",df$GLAH01,sep = "")][[1]]
r_rng_wf_m <- m[,df$GLAH01_rownumber]

## d_gpCntRngOff
m <- list_d_gpCntRngOff[paste("d_gpCntRngOff_",df$GLAH14,sep = "")][[1]]
d_gpCntRngOff_m <- m[,df$GLAH14_rownumber]

### Check and remove inf vals
check_d_gpCntRngOff <-  !d_gpCntRngOff_m==1.7976931348623157E308
d_gpCntRngOff_m <- d_gpCntRngOff_m[check_d_gpCntRngOff]

## d_gamp
m <- list_d_Gamp[paste("d_Gamp_",df$GLAH14,sep = "")][[1]]
d_Gamp_m <- m[,df$GLAH14_rownumber]
d_Gamp_m <- d_Gamp_m[check_d_gpCntRngOff]

## d_Gsigma
m <- list_d_Gsigma[paste("d_Gsigma_",df$GLAH14,sep = "")][[1]]
d_Gsigma_m <- m[,df$GLAH14_rownumber]

## d_maxRecAmp
m <- list_d_maxRecAmp[paste("d_maxRecAmp_",df$GLAH14,sep = "")]
d_maxRecAmp_m <- m[[1]][[df$GLAH14_rownumber]]

## d_maxSmAmp
m <- list_d_maxSmAmp[paste("d_maxSmAmp_",df$GLAH14,sep = "")]
d_maxSmAmp_m <- m[[1]][[df$GLAH14_rownumber]]

## d_SigEndOff
m <- list_d_SigEndOff[paste("d_SigEndOff_",df$GLAH14,sep = "")]
d_SigEndOff_m <- m[[1]][[df$GLAH14_rownumber]]

## d_SigBegOff
m <- list_d_SigBegOff[paste("d_SigBegOff_",df$GLAH14,sep = "")]
d_SigBegOff_m <- m[[1]][[df$GLAH14_rownumber]]

########################## 2.-  Match waveform volts and height

# Waveform: height ~ volts
### Height

x <- 0
heightAxis <- 0
for (i in seq(length(r_rng_wf_m))){
        x <- x -0.15
        heightAxis <- append(heightAxis, x)
}
heightAxis <-  heightAxis[-545]
rm(x)

waveform <- data.frame(height=heightAxis,volts=r_rng_wf_m)


##################### 3.-  Rearrange data vertically
# Signal beginning and end
## Set zero in the y axis
zero <- d_gpCntRngOff_m[1]

## Adjust values Beg and End vals
d_SigEndOff_m <- d_SigEndOff_m - zero
d_SigBegOff_m <- d_SigBegOff_m - zero

## Convert to positive values
d_SigEndOff_m <- d_SigEndOff_m - d_SigEndOff_m*2
d_SigBegOff_m <- d_SigBegOff_m - d_SigBegOff_m*2

## Adjust Waveform values
positive <- subset(waveform, height<zero)
positive <- rbind(waveform[waveform$height==zero,], positive)
positive$height <- positive$height - zero
positive$height <- positive$height - positive$height*2
negative <- subset(waveform,height>zero)
negative$height <- negative$height - zero
negative$height <- negative$height - negative$height*2

### rbind positive + negative
vertical_waveform <- rbind(positive, negative)
vertical_waveform <- vertical_waveform[order(vertical_waveform$height,decreasing = T),]


##################### 4.- Create  Modelwave

## Read d_gpCntRngOff values again
m <- list_d_gpCntRngOff[paste("d_gpCntRngOff_",df$GLAH14,sep = "")][[1]]
d_gpCntRngOff_m <- m[,df$GLAH14_rownumber]

### Check inf vals
check_d_gpCntRngOff <-  !d_gpCntRngOff_m==1.7976931348623157E308
d_gpCntRngOff_m <- d_gpCntRngOff_m[check_d_gpCntRngOff]

####### Rearrange data vertically
## Set zero in the y axis
zero <- d_gpCntRngOff_m[1]
## Readjust values so that d_gpCntRngOff_m[1] is zero
d_gpCntRngOff_m <- d_gpCntRngOff_m - zero
## Convert to positive vals
d_gpCntRngOff_m <- d_gpCntRngOff_m - d_gpCntRngOff_m*2

## Calculate curve
for ( i in 1:length(check_d_gpCntRngOff)){
        if (check_d_gpCntRngOff[i]==T){
                assign(paste("gauss",i,sep ="_"),dnorm(d_gpCntRngOff_m[i],mean = vertical_waveform$height,sd = (d_Gsigma_m[i]*0.15))) 
                #                assign(paste("gauss",i,sep ="_"),dnorm(d_gpCntRngOff_m[i],mean = vertical_waveform$height,sd = sqrt(d_Gsigma_m[i]))) 
        }
}

ind_gauss <-ls(pattern="^gauss_",)
list_gauss_curves <- mget(ind_gauss)
rm(list = ind_gauss) 

## Normalize individual Gaussians
for (i in 1:length(list_gauss_curves)){
        list_gauss_curves[[i]] <- list_gauss_curves[[i]]*((d_Gsigma_m[i]*0.15)*sqrt(2*pi))*d_Gamp_m[as.numeric(substr(x = ind_gauss[[i]], start = 7, stop = 7))]
        #       list_gauss_curves[[i]] <- list_gauss_curves[[i]]*(1/max(list_gauss_curves[[i]]))*d_Gamp_m[as.numeric(substr(x = ind_gauss[[i]], start = 7, stop = 7))]
}

modelwave <- 0
for (i in 1:length(list_gauss_curves)){
        modelwave <- modelwave + list_gauss_curves[[i]]   
}


########################### 5.-  Calculate waveform derived LAI

##  Create Gauss 1 data.frame
baseGauss <- data.frame(height=vertical_waveform$height, volts=list_gauss_curves$gauss_1)

modelWaveCanopy <- data.frame(height=vertical_waveform$height, volts=modelwave)


## Indices to extract data
ind_signBegEnd <-  vertical_waveform$height > d_SigEndOff_m & vertical_waveform$height < d_SigBegOff_m

## Extract waveform and Gauss_1 values between sigBeg and sigEnd
waveCanopy <- vertical_waveform[ind_signBegEnd,]
modelWaveCanopy <- modelWaveCanopy[ind_signBegEnd,]
baseGauss <- baseGauss[ind_signBegEnd,]

# Waveform cumsum and fraction
waveCanopy$cumsum <- cumsum(waveCanopy$volts)
waveCanopy$fraction <- waveCanopy$cumsum/max(waveCanopy$cumsum) 

modelWaveCanopy$cumsum <- cumsum(modelWaveCanopy$volts)
modelWaveCanopy$fraction <- modelWaveCanopy$cumsum/max(modelWaveCanopy$cumsum) 

# Gauss 1 height,  cumsum and fraction
baseGauss$height <- waveCanopy$height
baseGauss$cumsum <- cumsum(baseGauss$volts)

rg = max(baseGauss$cumsum)
rg_rv0_wave <- rg/max(waveCanopy$cumsum)
rg_rv0_model <- rg/max(modelWaveCanopy$cumsum)
rhov_rhog = 0.82

P_wave = 1 - waveCanopy$fraction *(1/(1+(rhov_rhog*rg_rv0_wave)))
P_model = 1 - modelWaveCanopy$fraction *(1/(1+(rhov_rhog*rg_rv0_model)))

LAI_wave = -log(P_wave)/(0.5*1) 
LAI_model = -log(P_model)/(0.5*1)## 0.5*1 = leaf dist * clumping fact

# maxLAI  at a height of 3m
ind_3m <- waveCanopy$height < 3.075 & waveCanopy$height > 2.925

maxLAI_wave <- LAI_wave[ind_3m]
maxLAI_model <- LAI_model[ind_3m]

## Indices d_SigBegOff_m to 3M above ground
ind_signBeg_3m <-  waveCanopy$height < d_SigBegOff_m & waveCanopy$height > 3

P_wave = P_wave[ind_signBeg_3m]
P_model = P_model[ind_signBeg_3m]

#LAI_waveForm <- data.frame(x=as.numeric(0), y=as.numeric(0), LAI=as.numeric(0), GLAS14=as.numeric(0), ind=as.numeric(0), stringsAsFactors = F)

LAI_3m_df <-rbind(LAI_3m_df, data.frame(coordinates(get(paste("DF_GLAH14",df$GLAH14,sep = "_"))[as.numeric(df$GLAH14_rownumber),]), LAI_wave=maxLAI_wave, LAI_model=maxLAI_model,GLAS14= df$GLAH14, ind=df$GLAH14_rownumber))



###### create sublist that would be added to our big list: 

# sublist name
iname <- paste(df$GLAH14,formatC(df$GLAH14_rownumber,flag = "0",width = 3),sep="_")


## extract elevation data (d_elev)
elev <- list_d_elev[[paste("d_elev",df$GLAH14,sep="_")]][df$GLAH14_rownumber]

## Indices d_SigBegOff_m to 3M above ground
ind_signBeg_3m <-  vertical_waveform$height < d_SigBegOff_m & vertical_waveform$height > 3

# sublist elements
pulse_tmp <- list(height=vertical_waveform$height, waveform=vertical_waveform$volts, modelwave=modelwave, elev=elev, LAI_wave=LAI_wave, LAI_model=LAI_model, maxLAI_wave=maxLAI_wave, maxLAI_model=maxLAI_model, P_wave=P_wave, P_model=P_model, ind_signBeg_3m=ind_signBeg_3m)

## add to major list
GLAH14_pulses[[iname]] <- pulse_tmp

        }
}


rm(baseGauss)
rm(df)
rm(m)
rm(matched_tmp)
rm(negative)
rm(positive)
rm(vertical_waveform)
rm(waveCanopy)
rm(waveform)
rm(check_d_gpCntRngOff)
rm(d_maxRecAmp_m)
rm(d_maxSmAmp_m)
rm(d_SigBegOff_m)
rm(d_SigEndOff_m)
rm(e)
rm(heightAxis)
rm(i)
rm(ind_3m)
rm(modelWaveCanopy)
rm(ind_signBeg_3m)
rm(ind_gauss)
rm(ind_signBegEnd)
rm(LAI_model)
rm(LAI_wave)
rm(maxLAI_wave)
rm(maxLAI_model)
rm(modelwave)
rm(P_model)
rm(P_wave)
rm(r_rng_wf_m)
rm(rg)
rm(rg_rv0_wave)
rm(rg_rv0_model)
rm(rhov_rhog)
rm(zero)
rm(d_Gamp_m)
rm(d_gpCntRngOff_m)
rm(d_Gsigma_m)
rm(pulse_tmp)
rm(iname)
rm(list_gauss_curves)
rm(elev)
