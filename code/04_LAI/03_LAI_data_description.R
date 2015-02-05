# In this code I explored the differences between waveform and modelwave derived LAI. I realized that LAI_modelWave had an oultier, so I rempved it from the dataframe to plot the data and saved it in the carbon_stocks.RData --  

library(ggplot2)
## plot LAI data

plot_path <- file.path("png",paste("waveForm_LAI",".png",sep = "_"))
png(filename=plot_path,units="in", width=17/4, height=23/4, res=200 )
qplot(x = LAI_waveForm$GLAS14, y=LAI_waveForm$LAI,data =LAI_waveForm,xlab = "GLAS file", ylab = "LAI",main = "Waveform derived LAI" )
dev.off()

plot_path <- file.path("png",paste("modelWave_LAI",".png",sep = "_"))
png(filename=plot_path,units="in", width=17/4, height=23/4, res=200 )
qplot(x = LAI_modelWave$GLAS14, y=LAI_modelWave$LAI,data =LAI_modelWave,xlab = "GLAS file", ylab = "LAI", main="Modelwave derived LAI" )
dev.off()


## so there's an outlier in the modelWave, I'll create a data frame with the differences of these datasets as they are now, but for further calculations I'll remove that outlier


## difference dataframe
waveDiff <- data.frame(diff=(LAI_modelWave$LAI - LAI_waveForm$LAI),GLAS14=LAI_modelWave$GLAS14)
write.csv(waveDiff, file="waveDiff.csv")

## Where is the outlier?
match(max(waveDiff$diff), waveDiff$diff)
## Remove it
waveDiff <- waveDiff[-557,]

## Plot histogram
plot_path <- file.path("png",paste("diff_wave_modelwave_LAI_hist",".png",sep = "_"))
png(filename=plot_path,units="in", width=17/4, height=23/4, res=200 )
qplot( x=waveDiff$diff, data =waveDiff, xlab ="LAI difference (modelwaveLAI - waveformLAI)", ylab = "Count")
dev.off()


## Remove outlier from modelWave dataset and save
match(max(LAI_modelWave$LAI),table = LAI_modelWave$LAI)
LAI_modelWave <- LAI_modelWave[-557,]

rm(waveDiff)
rm(plot_path)
