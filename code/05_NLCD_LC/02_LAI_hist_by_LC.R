library(ggplot2)

ggplot(LC_spdf_matched@data, aes(x= subclass, y=waveFormLAI))+geom_boxplot() + scale_fill_brewer(palette = "Dark2",type = qual)  + labs(title="LAI per NLCD subclass") + theme(legend.title=element_blank()) + xlab(label = "NLCD subclass") + ylab(label = "LAI")
dev.off()


