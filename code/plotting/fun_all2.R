# ------------------------------------------------------------------ #
# Remember to load carbon_stocks.Rdata before executing the script and click "Source on Save"
# If you don't have RColorBrewer enabled, just type in the command= install.packages("RColorBrewer")

## Tip
# type View(Matched_records_reference) to select a row number


## Options:
matchedTable_rown = 18 
plotWave <- T # Plot raw waveform?? T or F
plotModelWave <- T  # Plot modeled waveform?? T or F
cropToSig <- F # Crop vertical axis to signal beg and end? T or F
savePlot <- F ## Nothing will be plotted but a png will be saved in the png_shots folder 
writeCsv <- F # Write CSV files? T or F
# ------------------------------------------------------------------ #


## Record/shot values
rec <- Matched_records_reference$i_rec_ndx[matchedTable_rown]               
shot <-Matched_records_reference$i_shot_count[matchedTable_rown]
df <- Matched_records_reference[Matched_records_reference$i_rec_ndx==rec & Matched_records_reference$i_shot_count==shot,]

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

# Normalize modelwave
#for (i in 1:length(list_gauss_curves)){
#       modelwave <- modelwave*(1/max(modelwave))*d_maxSmAmp_m
#}




#######################  Plot results

#-------- Plot parameters 
library(RColorBrewer)
pal <- brewer.pal(8,"Set2")
ltype <-c(5,4,1,1,1,1,1,1)
lwidth <-c(1,2,1,1,1,1,1,1)
# -------------- # 

# Get record / shot labels
rec_lab <- paste("record",rec,sep = ":")
shot_lab <- paste("shot",shot,sep = ":")

## Save plot??
if ( savePlot==T) { 
        shots_path <- file.path("png_shots/",paste(rec_lab,shot_lab,".png",sep = "_"))
        png(filename=shots_path, units="in", width=17/4, height=23/4, res=250)
}

## Create new empty space for plot
plot.new()
par(mar=c(3,3,3,3))

## Define vertical limits
if (cropToSig ==T){
        plot.window(ylim = c(d_SigEndOff_m, d_SigBegOff_m), xlim = c(0, max(modelwave)+ 0.05), xaxs="i", yaxs="i")} else {
                plot.window(ylim=c(min(vertical_waveform$height), max(vertical_waveform$height)), xlim=c(0, max(modelwave)+ 0.05))
        }

## Plot Waveform
if (plotWave==T){
lines(y= vertical_waveform$height, x=vertical_waveform$volts, ann = FALSE,  lty=ltype[1],  lwd=lwidth[1], cex= 0.3, col=pal[1])
}

### Plot Modelwave
if (plotModelWave ==T){
lines (modelwave,vertical_waveform$height, lty=ltype[2], lwd=lwidth[2], col= pal[2])
}

### Plot Gaussians
for (i in 1:length(list_gauss_curves)){
        lines(list_gauss_curves[[i]],vertical_waveform$height, lwd=lwidth[0.7], col= pal[i+2])
}

### Add axis
## Add box
box()
# Bottom axis
axis(1, col.axis="black",hadj =0.2, las=1, cex.axis=0.7, tck=-0.02, lwd=1)
# Left axis
axis(2, col.axis="black", padj = 0.5, las=2, cex.axis=0.7, lwd=1, tck=-0.02)
# Right axis
axis(4, at=d_gpCntRngOff_m,labels=round(d_gpCntRngOff_m,digits = 2),col.axis="black", las=2, cex.axis=0.5, tck=+.03)
# Right axis labels
if( cropToSig==F){
axis(4, at=d_SigBegOff_m,labels="SigBegOff",col.axis="black", las=2, cex.axis=0.5, tck=+.03)
axis(4, at=d_SigEndOff_m,labels="SigEndOff",col.axis="black", las=2, cex.axis=0.5, tck=+.03)
}
mtext("d_gpCntRngOff", side=4, line=0, cex=0.5,las=3, col="black")

# add minor ticks
library(Hmisc)
library(survival)
minor.tick(nx=5, ny=5, tick.ratio=0.2)

# add legend
legend(x = "topright",
       legend = c("Waveform", "Modelwave", c(ind_gauss[1:length(ind_gauss)])),col = pal, cex=0.5, lty =ltype, lwd = lwidth)

# add Signal beg/end lines
if ( cropToSig==F){
        abline(h = d_SigBegOff_m, lty=8, lwd=0.5)
        abline(h = d_SigEndOff_m,lty=8,lwd=0.5 )
}

# add title
title(main=paste(rec_lab,shot_lab,sep = "   "), xlab="Volts", ylab="Meters", line = 2)

#### Save plot?
if ( savePlot==T) { 
        rm(shots_path)
        dev.off()
}

### Write CSV?
if (writeCsv==T){
write.csv(as.data.frame(list_gauss_curves), file="gauss_curves.csv")

write.csv(data.frame("d_gpCntRngOff_m" = d_gpCntRngOff_m,"d_Gsigma_m" = d_Gsigma_m,"d_Gamp_m"= d_Gamp_m),file="gauss_data.csv")

write.csv(vertical_waveform, "waveform.csv")
}

