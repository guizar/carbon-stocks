
####
# Create a list for the available GLAH14 shots that meet 
# the screening criteria
# 
# Terminology:
# available shots: those that have GLAH14 and GLAH01 data (Matched_records_reference)
# screened shots: those that meet the screening criteria

GLAH14_validated_shots <- list()

## Available shots (file number)
GLAH14_validated_shots$files <- unique(Matched_records_reference$GLAH14)

## Extract Matched_table index by file number
for (i in seq(length(GLAH14_validated_shots$files))){
assign(paste("bool",GLAH14_validated_shots$files[i],sep="_"),Matched_records_reference$GLAH14==GLAH14_validated_shots$files[i])
}

# include bool vectors in GLAH14_validated_shots list
ind_file_bool <- ls(pattern = "^bool_")
GLAH14_validated_shots <- c(mget(ind_file_bool, .GlobalEnv), GLAH14_validated_shots)
rm(list=ind_file_bool)

## Extract indices (rownumbers) of available shots by file number
for (i in seq(length(ind_file_bool))){
assign(paste("indx",substr(ind_file_bool[i],6,7),sep="_"),as.numeric(Matched_records_reference[GLAH14_validated_shots[[ind_file_bool[i]]],"GLAH14_rownumber"]))
}

# include indx vectors in GLAH14_validated_shots list
ind_indx <- ls(pattern = "^indx")
GLAH14_validated_shots <- c(mget(ind_indx, .GlobalEnv), GLAH14_validated_shots)
rm(list=ind_indx)
rm(ind_indx)
rm(ind_file_bool)


## Match available shots with screened shots

for (i in seq(length(GLAH14_validated_shots$files))){
        summ_temp <- summary_criteria_df[summary_criteria_df$GLAS==GLAH14_validated_shots$files[i],]
        
        summ_temp <- summ_temp[summ_temp$summary==T,]
        
        l <- summ_temp$GLAS_obs %in% GLAH14_validated_shots[[paste("indx",GLAH14_validated_shots$files[i],sep="_")]]
        
        assign(paste("screened",GLAH14_validated_shots$files[i],sep="_"),summ_temp$GLAS_obs[l])
rm(l)
rm(summ_temp)            
}

ind_screened <- ls(pattern = "^screened")
GLAH14_validated_shots <- c(mget(ind_screened, .GlobalEnv), GLAH14_validated_shots)
rm(list=ind_screened)
rm(ind_screened)
##############################



# save.image("carbon_stocks.RData")
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
rm(ind_gauss)
rm(ind_signBegEnd)
rm(LAI)
rm(maxLAI)
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
rm(pulse_tmp)
rm(iname)
rm(list_gauss_curves)
rm(elev)

