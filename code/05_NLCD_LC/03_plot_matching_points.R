# just to see if LAI_waveform and LC points reordered the same way

library(RColorBrewer)

cols <- brewer.pal(8,"Dark2")
pal <- colorRampPalette(cols)
color_array<- pal(5)


ext <- extent(-71.76381, -71.75613, 42.85501,42.86307)

ext <- drawExtent()

plot(LC_spdf_matched,ylim = c(ymin(ext), ymax(ext)), xlim=c(xmin(ext),xmax(ext)), col="White")

for (i in 1:5){
        points(LC_spdf_matched[i,1],col=color_array[i], pch=5)
}

for (i in 1:5){
        points(x = LAI_waveForm$x[i] , y = LAI_waveForm$y[i], col=color_array[i], pch=6)
}
