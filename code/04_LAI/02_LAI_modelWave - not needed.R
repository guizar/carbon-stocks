
for (i in seq(length(list_GLAH14_criteria$files))){
        summ_temp <- summary_criteria_df[summary_criteria_df$GLAS==list_GLAH14_criteria$files[i],]
        
        summ_temp <- summ_temp[summ_temp$summary==T,]
        
        l <- summ_temp$GLAS_obs %in% list_GLAH14_criteria[[paste("indx_file",list_GLAH14_criteria$files[i],sep="_")]]
        
        assign(paste("screened",list_GLAH14_criteria$files[i],sep="_"),summ_temp$GLAS_obs[l])
rm(l)
rm(summ_temp)            
}

ind_screened <- ls(pattern = "^screened")
list_GLAH14_criteria <- c(mget(ind_screened, .GlobalEnv), list_GLAH14_criteria)
rm(list=ind_screened)
rm(ind_screened)
##############################

############################# Create Data.frame where LAI data will be dumped (for loop will feed in)
LAI_modelWave <- data.frame(x=as.numeric(0), y=as.numeric(0), LAI=as.numeric(0), GLAS14=as.numeric(0), ind=as.numeric(0), stringsAsFactors = F)
###################


################# For loop: for all available and screened GLAH14

for (i in seq(length(list_GLAH14_criteria$files))){
        
        matched_tmp <- Matched_records_reference[Matched_records_reference$GLAH14==list_GLAH14_criteria$files[i],]
        
        for  (e in list_GLAH14_criteria[[paste("screened",list_GLAH14_criteria$files[i],sep="_")]]){

## Record/shot values
#rec <- matched_tmp$i_rec_ndx[matchedTable_rown]               
#shot <-matched_tmp$i_shot_count[matchedTable_rown]
df <- matched_tmp[matched_tmp$GLAH14_rownumber==e,]

#############################
# Extract data
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



############################## Match waveform volts and height

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



######################     Rearrange data vertically
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



###################### Create  Modelwave

## Read d_gpCntRngOff values again
m <- list_d_gpCntRngOff[paste("d_gpCntRngOff_",df$GLAH14,sep = "")][[1]]
d_gpCntRngOff_m <- m[,df$GLAH14_rownumber]

### Check inf vals
check_d_gpCntRngOff <-  !d_gpCntRngOff_m==1.7976931348623157E308
d_gpCntRngOff_m <- d_gpCntRngOff_m[check_d_gpCntRngOff]

### Rearrange data vertically
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






################################# Calculate LAI
##  Create Gauss 1 data.frame
baseGauss <- data.frame(height=vertical_waveform$height, volts=list_gauss_curves$gauss_1)

modelWaveCanopy <- data.frame(height=vertical_waveform$height, volts=modelwave)

## Indices to extract data
ind_signBegEnd <-  vertical_waveform$height > d_SigEndOff_m & vertical_waveform$height < d_SigBegOff_m

## Extract waveform and Gauss_1 values between sigBeg and sigEnd
modelWaveCanopy <- modelWaveCanopy[ind_signBegEnd,]
baseGauss <- baseGauss[ind_signBegEnd,]

# Waveform cumsum and fraction
modelWaveCanopy$cumsum <- cumsum(modelWaveCanopy$volts)
modelWaveCanopy$fraction <- modelWaveCanopy$cumsum/max(modelWaveCanopy$cumsum) 

# cumsum and fraction
baseGauss$cumsum <- cumsum(baseGauss$volts)

rg = max(baseGauss$cumsum)
rg_rv0 <- rg/max(modelWaveCanopy$cumsum)
rhov_rhog = 0.82

P = 1 - modelWaveCanopy$fraction *(1/(1+(rhov_rhog*rg_rv0)))
LAI = -log(P)/(0.5*1) ## 0.5*1 = leaf dist * clumping fact

# maxLAI_modelwave  at a height of 3m

ind_3m <- modelWaveCanopy$height < 3.075 & modelWaveCanopy$height > 2.925

maxLAI_modelwave <- LAI[ind_3m]


#LAI_modelWave <- data.frame(x=as.numeric(0), y=as.numeric(0), LAI=as.numeric(0), GLAS14=as.numeric(0), ind=as.numeric(0), stringsAsFactors = F)

LAI_modelWave <-rbind(LAI_modelWave, data.frame(coordinates(get(paste("DF_GLAH14",df$GLAH14,sep = "_"))[as.numeric(df$GLAH14_rownumber),]), LAI=maxLAI_modelwave, GLAS14= df$GLAH14, ind=df$GLAH14_rownumber))


        }
}

#### Convert to SPDF

# coordinates(waveForm_LAI_spdf) <- ~x+y

LAI_modelWave <- LAI_modelWave[-1,]
row.names(LAI_modelWave) <-NULL

rm(baseGauss)
rm(df)
rm(m)
rm(matched_tmp)
rm(negative)
rm(positive)
rm(vertical_waveform)
rm(modelWaveCanopy)
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
rm(ind_gauss)
rm(ind_signBegEnd)
rm(LAI)
rm(maxLAI_modelwave)
rm(modelwave)
rm(P)
rm(r_rng_wf_m)
rm(rg)
rm(rg_rv0)
rm(rhov_rhog)
rm(zero)
rm(d_Gamp_m)
rm(d_gpCntRngOff_m)
rm(d_Gsigma_m)

#save.image("carbon_stocks.RData")
#write.csv(LAI_modelWave,file="LAI_modelWave.csv")