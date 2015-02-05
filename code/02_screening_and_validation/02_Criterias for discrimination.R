## Criterion 1

condensed_crit1 <- unlist(list_i_numPk,use.names = F) >= 2

qplot(unlist(list_i_numPk,use.names = F), geom = "histogram",main = paste("i_numPk N=",length(unlist(list_i_numPk,use.names = F)),sep=""),xlab = "Number of peaks", fill=condensed_crit1)

length(unlist(list_i_numPk,use.names = F))


## Criterion 2
### Max Rec Amp volts
condensed_d_maxRecAmp <- list_d_maxRecAmp[[1]]
condensed_d_maxRecAmp <- append(condensed_d_maxRecAmp,list_d_maxRecAmp[[2]])
condensed_d_maxRecAmp <- append(condensed_d_maxRecAmp,list_d_maxRecAmp[[3]])
condensed_d_maxRecAmp <- append(condensed_d_maxRecAmp,list_d_maxRecAmp[[4]])
condensed_d_maxRecAmp <- append(condensed_d_maxRecAmp,list_d_maxRecAmp[[5]])
condensed_d_maxRecAmp <- append(condensed_d_maxRecAmp,list_d_maxRecAmp[[6]])
condensed_d_maxRecAmp <- append(condensed_d_maxRecAmp,list_d_maxRecAmp[[7]])
condensed_d_maxRecAmp <- append(condensed_d_maxRecAmp,list_d_maxRecAmp[[8]])

library(ggplot2)
qplot(condensed_d_maxRecAmp, , geom = "histogram", binwidth = 0.05, xlim = c(0,max(condensed_d_maxRecAmp)+0.01), main = paste("d_maxRecAmp N=",length(unlist(list_d_maxRecAmp,use.names = F)),sep=""),xlab = "Volts")

#qplot(condensed_d_maxRecAmp, ,geom = "histogram", binwidth = 0.05, xlim = c(0,max(condensed_d_maxRecAmp)+0.01),main = paste("d_maxRecAmp N=",length(unlist(list_d_maxRecAmp,use.names = F)),sep=""),xlab = "Volts", fill= condensed_crit2)

### 
condensed_d_sDevNsOb1 <- list_d_sDevNsOb1[[1]]
condensed_d_sDevNsOb1 <- append(condensed_d_sDevNsOb1,list_d_sDevNsOb1[[2]])
condensed_d_sDevNsOb1 <- append(condensed_d_sDevNsOb1,list_d_sDevNsOb1[[3]])
condensed_d_sDevNsOb1 <- append(condensed_d_sDevNsOb1,list_d_sDevNsOb1[[4]])
condensed_d_sDevNsOb1 <- append(condensed_d_sDevNsOb1,list_d_sDevNsOb1[[5]])
condensed_d_sDevNsOb1 <- append(condensed_d_sDevNsOb1,list_d_sDevNsOb1[[6]])
condensed_d_sDevNsOb1 <- append(condensed_d_sDevNsOb1,list_d_sDevNsOb1[[7]])
condensed_d_sDevNsOb1 <- append(condensed_d_sDevNsOb1,list_d_sDevNsOb1[[8]])

library(ggplot2)
qplot(condensed_d_sDevNsOb1, geom = "histogram", binwidth = .0005,main=paste("d_sDevNsOb1 N=",length(unlist(list_d_sDevNsOb1,use.names = F)),sep=""),xlab = "Hertz")

#qplot(condensed_d_sDevNsOb1, geom = "histogram", binwidth = 0.0005,main = "d_sDevNsOb1 N=3360",xlab = "Hertz", fill=condensed_crit2)



# 
# ## Find intervals and plot them
# library(classInt)
# brks_d_maxRecAmp <- classIntervals(condensed_d_maxRecAmp,style = "quantile", n=4)
# 
# ## data frame
# df_d_maxRecAmp <- data.frame(value=condensed_d_maxRecAmp, brks=brks_d_maxRecAmp$brks)
# 
# qplot(data= df_d_maxRecAmp, value, geom = "histogram", fill = as.factor(brks), binwidth = 0.05,main = "d_maxRecAmp N=3360",xlab = "Volts")
# 
# qplot(data= df_d_maxRecAmp, as.factor(brks), geom = "histogram")


## Criterion 3
library(ggplot2)

# # boxplot per GLAS
# ggplot(elevation_criteria_cleaned, aes(x=GLAS, y=DEM_GLAS_diff), fill=GLAS_obs,) + geom_boxplot()

##Boxplot with xlabs
xlabs <- paste(levels(elevation_criteria_cleaned$GLAS),"\n(N=",table(elevation_criteria_cleaned$GLAS),")",sep="")
ggplot(elevation_criteria_cleaned,aes(x=GLAS,y=DEM_GLAS_diff,color=GLAS))+geom_boxplot()+scale_x_discrete(labels=xlabs) + labs(title=paste("DEM - GLAS (-100 mts threshold) N=",length(unlist(elevation_criteria_cleaned$GLAS)),sep=""))
rm(xlabs)

# # one big boxplot
# qplot(factor(0), DEM_GLAS_diff, data=elevation_criteria_cleaned, geom="boxplot")

## Extract quantiles
q00 <- quantile(elevation_criteria_cleaned$DEM_GLAS_diff, .00)
q95 <- quantile(elevation_criteria_cleaned$DEM_GLAS_diff, .95)

rm(q00)
rm(q95)


## density and percentiles (crazy outliers)
dens <- density(elevation_criteria_cleaned$DEM_GLAS_diff)
df <- data.frame(x=dens$x, y=dens$y)
probs <- c(0.1, 0.25, 0.5, 0.75, 0.95)
quantiles <- quantile(elevation_criteria_cleaned$DEM_GLAS_diff, prob=probs)
df$quant <- factor(findInterval(df$x,quantiles))
ggplot(df, aes(x,y)) + geom_line() + geom_ribbon(aes(ymin=0, ymax=y, fill=quant,)) + scale_x_continuous(breaks=quantiles) + scale_fill_brewer(guide="none")
rm(probs)
rm(q95)
rm(quantiles)
rm(df)


# histogram + density
ggplot(elevation_criteria_cleaned, aes(x=DEM_GLAS_diff), fill=GLAS,)+ geom_histogram(aes(y=..density..), binwidth=5, colour="black", fill="white") + geom_density(alpha=.2, fill="#FF6666") + labs(title="Distribution of the differences between GLAS derived elevation and average DEM cells") + xlab("x = mean(DEM[i1]:DEM[i9]) - GLAS[i]") + ylab("")


#=========== Dealing with the outliers

# Bool DEM_GLAS_diff <-100
elevation_criteria_df$"-100mts_threshold" <- !elevation_criteria_df$DEM_GLAS_diff < -100


# Remove <- 100
elevation_criteria_cleaned <- elevation_criteria_df[!elevation_criteria_df$DEM_GLAS_diff < -100,]
# ========

####################### = CORRECTED OUTLIERS

# CRITERION 3
# 95th percentile  difference between GLAS DEM
# histogram + density
q95_DEM_GLAS <- quantile(elevation_criteria_cleaned$DEM_GLAS_diff, .95)
ggplot(elevation_criteria_cleaned, aes(x=DEM_GLAS_diff), fill=GLAS,)+ geom_histogram(aes(y=..density..), binwidth=5, colour="black", fill="white") + geom_density(alpha=.2, fill="#FF6666") + labs(title=paste("Differences between DEM and GLAS elevation N=",length(unlist(elevation_criteria_cleaned$GLAS)),sep="")) + xlab("x = mean(DEM[i1]:DEM[i9]) - GLAS[i]") + ylab("") + annotate("text", x=50, y=0.03, label=paste("95th percentile=",round(print(q95_DEM_GLAS),digits = 2),sep=""))
rm(q95_DEM_GLAS)

##Boxplot with xlabs
xlabs <- paste(levels(elevation_criteria_cleaned$GLAS),"\n(N=",table(elevation_criteria_cleaned$GLAS),")",sep="")
ggplot(elevation_criteria_cleaned,aes(x=GLAS,y=DEM_GLAS_diff,color=GLAS))+geom_boxplot()+scale_x_discrete(labels=xlabs) + labs(title=paste("DEM - GLAS (-100 mts threshold) N=",length(unlist(elevation_criteria_cleaned$GLAS)),sep=""))
rm(xlabs)

# CRITERION 4 
# 95th percentile  difference between MIN AND MAX DEM

# histogram + density
q95_DEM_min_max <- quantile(elevation_criteria_cleaned$DEM_max_min_diff, .95)
ggplot(elevation_criteria_cleaned, aes(x=DEM_max_min_diff), fill=GLAS,)+ geom_histogram(aes(y=..density..), binwidth=2, colour="black", fill="white") + geom_density(alpha=.2, fill="#FF6666") + labs(title=paste("Differences between DEM max and min N=",length(unlist(elevation_criteria_cleaned$GLAS)),sep="")) + xlab("Meters") + ylab("") + annotate("text", x=30, y=0.03, label=paste("95th percentile=",round(print(q95_DEM_min_max),digits = 2),sep=""))
#rm(q95_DEM_min_max)

##Boxplot with xlabs
xlabs <- paste(levels(elevation_criteria_cleaned$GLAS),"\n(N=",table(elevation_criteria_cleaned$GLAS),")",sep="")
ggplot(elevation_criteria_cleaned,aes(x=GLAS,y=DEM_max_min_diff,color=GLAS))+geom_boxplot()+scale_x_discrete(labels=xlabs) + labs(title=paste("Differences between DEM max and min N=",length(unlist(elevation_criteria_cleaned$GLAS)),sep=""))
rm(xlabs)


######### 

## Create sumary DF
summary_criteria_df <- elevation_criteria_df

## Criterion 1
# 
summary_criteria_df$criterion_1 <- unlist(list_i_numPk,use.names = F) >= 2

## Criterion 2
summary_criteria_df$criterion_2 <- unlist(criterion2)

## Criterion 3 
# 95th percentile  difference between GLAS DEM

summary_criteria_df$criterion_3 <- summary_criteria_df$DEM_GLAS_diff < q95_DEM_GLAS

# Criterion 4
# 95th percentile  difference between GLAS DEM

summary_criteria_df$criterion_4 <- summary_criteria_df$DEM_max_min_diff < q95_DEM_min_max

## Summary of TRUEs

summary_criteria_df$summary <- summary_criteria_df$"-100mts_threshold"==TRUE & summary_criteria_df$criterion_1==T & summary_criteria_df$criterion_2==T & summary_criteria_df$criterion_3==T & summary_criteria_df$criterion_4==T

summary(summary_criteria_df$summary)

write.table(summary_criteria_df, file="summary_table.csv",sep = ",",row.names = T,col.names = T)
