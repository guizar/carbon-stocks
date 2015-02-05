png(filename=paste(rec_lab,shot_lab,".png",sep = "_"),units="in", width=17/4, height=23/4, res=200 )

# Plot

library(RColorBrewer)


## Parameters 
pal <- brewer.pal(3, "Dark2")
ltype <-c(5,1,4)
lwidth <-c(0.7,1,2)

## New empty space
plot.new()
par(mar=c(3,3,3,3))

plot.window(ylim = c(d_SigEndOff_m, d_SigBegOff_m), xlim = c(0, max(modelwave)+ 0.05), xaxs="i", yaxs="i")

# Title
rec_lab <- paste("record",rec,sep = ":")
shot_lab <- paste("shot",shot,sep = ":")

title(main=paste(rec_lab,shot_lab,sep = "   "), xlab="Volts", ylab="Meters", line = 2,)

## Draw lines

## Max Gauss
lines(maxGaussVolts, maxGaussHeight, lty=ltype[1], col = pal[1], lwd=lwidth[1])

## Waveform
lines(y= waveformHeight, x=waveformVolts, ann = FALSE,  lty=ltype[2],  pch=18, cex= 0.3, col=pal[2])

### Sum of gaussians
lines (modelwave,waveformHeight, lty=ltype[3], lwd=lwidth[3], col= pal[3])


# Axis bottom
axis(1, col.axis="black",hadj =0.2, las=1, cex.axis=0.7, tck=-0.02, lwd=1)

# Axis left
axis(2, col.axis="black", padj = 0.5, las=2, cex.axis=0.7, lwd=1, tck=-0.02)

# Axis right
axRight<- round(seq(from =min(maxGaussHeight), to =max(maxGaussHeight),by = 10 ))

## Add box
box()

# draw an axis on the right, with smaller text and ticks 
axis(4, at=d_gpCntRngOff_m,labels=round(d_gpCntRngOff_m,digits = 2),col.axis="black", las=2, cex.axis=0.5, tck=+.03)

# add a title for the right axis 
mtext("d_gpCntRngOff", side=4, line=0, cex=0.5,las=3, col="black")

## add minor ticks
library(Hmisc)
minor.tick(nx=5, ny=5, tick.ratio=0.2)

legend(x = "topright",
       legend = c("Peaks", "Waveform", "Modelwave"),col = pal, cex=0.5, lty =ltype, lwd = lwidth)

dev.off()