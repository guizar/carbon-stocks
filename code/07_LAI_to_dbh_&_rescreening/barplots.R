library(ggplot2)

ppi = 300

## PFMATRIX
file = file.path("/Users/alejandroguizar/Dropbox/carbon_stocks_sussex_proj/shared/png/","basal_area_pfmatrix.png")


plot = ggplot(CSS_DBH_MATRIX_4266, aes(x=Basal_area_total, fill=as.factor(pfti)))
plot = plot + geom_histogram()
plot = plot + xlim(0,150)



png(filename=file,width=9*ppi, height=6*ppi, res=ppi )
plot
dev.off() 


###

summary(CSS_DBH_MATRIX_4266$Basal_area_total > 200 & CSS_DBH_MATRIX_4266$pfti==6)

## MATCHED FIA
file = file.path("/Users/alejandroguizar/Dropbox/carbon_stocks_sussex_proj/shared/png/","basal_area_matchedFIA.png")


plot = ggplot(CSS_DBH_854, aes(x=Basal_area_total,))
plot = plot + geom_histogram()
plot = plot + xlim(0,150)



png(filename=file,width=9*ppi, height=6*ppi, res=ppi )
plot
dev.off() 


