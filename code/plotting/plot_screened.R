
screened_01 <- summary_criteria_df$GLAS_obs[summary_criteria_df$GLAS=="01" & summary_criteria_df$summary==T]
screened_04 <- summary_criteria_df$GLAS_obs[summary_criteria_df$GLAS=="04" & summary_criteria_df$summary==T]
screened_05 <- summary_criteria_df$GLAS_obs[summary_criteria_df$GLAS=="05" & summary_criteria_df$summary==T]
screened_06 <- summary_criteria_df$GLAS_obs[summary_criteria_df$GLAS=="06" & summary_criteria_df$summary==T]
screened_07 <- summary_criteria_df$GLAS_obs[summary_criteria_df$GLAS=="07" & summary_criteria_df$summary==T]
screened_08 <- summary_criteria_df$GLAS_obs[summary_criteria_df$GLAS=="08" & summary_criteria_df$summary==T]
screened_09 <- summary_criteria_df$GLAS_obs[summary_criteria_df$GLAS=="09" & summary_criteria_df$summary==T]
screened_10 <- summary_criteria_df$GLAS_obs[summary_criteria_df$GLAS=="10" & summary_criteria_df$summary==T]

ind_screened <-ls(pattern="^screened",) 
list_screened <- mget(ind_screened, .GlobalEnv)
rm(list = ind_screened)
rm(ind_screened)

###3## Plot 
library(RColorBrewer)

## Parameters 
pal <- brewer.pal(8, "Set3")


## Main frame and title
plot(roiPoly)
title(main="Available shots")# xlab="Volts", ylab="Meters", line = 2)

## Plot points
points(DF_GLAH14_01[list_screened$screened_01,], pch=20, col = pal[1],)
points(DF_GLAH14_02[list_screened$screened_02,], pch=20, col = pal[2],)
points(DF_GLAH14_03[list_screened$screened_03,], pch=20, col = pal[3],)
points(DF_GLAH14_04[list_screened$screened_04,], pch=20, col = pal[4],)
points(DF_GLAH14_05[list_screened$screened_05,], pch=20, col = pal[5],)
points(DF_GLAH14_06[list_screened$screened_06,], pch=20, col = pal[6],)
points(DF_GLAH14_07[list_screened$screened_07,], pch=20, col = pal[7],)
points(DF_GLAH14_08[list_screened$screened_08,], pch=20, col = pal[8],)

legend(x = "topright",
       legend = c("01", "04", "05", "06", "07", "08", "09", "10"),col = pal, cex=0.5, pch=20)



########## Plot shots
#####  match available shots and GLAH01/14 matched table

### Which GLAS 14 tracks were matched
unique(Matched_records_reference$GLAH14)

## Select a track
glasTrack <- "04"

# screened records
list_screened[paste("screened_",glasTrack,sep="")]

# create an index of availabe shots
available <- list_screened[[paste("screened_",glasTrack,sep="")]] %in% Matched_records_reference$GLAH14_rownumber[Matched_records_reference$GLAH14==glasTrack]

# View table of matched index, and select row.number for fun_all.R script
View(Matched_records_reference[Matched_records_reference$GLAH14==glasTrack,][available,])

# clean wd
rm(available)
rm(glasTrack)




## not necessary
# plot GLAH14 and GLAH01 points


rec <- 227757924

plot(DF_GLAH01_05[DF_GLAH01_05$i_rec_ndx==rec,], col="Red")

ext <- drawExtent()

plot(DF_GLAH01_05[DF_GLAH01_05$i_rec_ndx==rec,], col="Red", xlim =c(xmin(ext),xmax(ext)), ylim=c(ymin(ext), ymax(ext)))

for (i in Matched_records_reference$GLAH14_rownumber[Matched_records_reference$i_rec_ndx==rec]) {
        points(DF_GLAH14_04[i,])        
}
rm(rec)
