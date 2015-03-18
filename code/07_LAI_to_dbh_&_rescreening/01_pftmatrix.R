
pftmatrix <-data.frame(id=NULL,pft6=NULL,pft8=NULL,pft9=NULL,pft10=NULL,pft11=NULL)

for ( i in seq(length(GLAH14_pulses))){
        for (e in seq(length(pftcodes$Code))) {
        end <- formatC(as.numeric(substr(pftcodes$Code[e],4,6)),width=2,flag="0")
        shot=paste(names(GLAH14_pulses[i]),end,sep="_")
        assign(pftcodes$Code[e],1)
        codes <- !pftcodes$Code %in% pftcodes$Code[e]
        codes <- pftcodes$Code[codes]
        for (f in codes){
                assign(f,0)
        }
        df<-data.frame(id=shot,pft6=pft6,pft8=pft8,pft9=pft9,pft10=pft10,pft11=pft11, stringsAsFactors = F)
        
        pftmatrix <- rbind(pftmatrix,df)
        }
}

rm(i)
rm(e)
rm(f)
rm(df)
rm(end)
rm(codes)
rm(shot)
rm(pft6)
rm(pft8)
rm(pft9)
rm(pft11)
rm(pft10)
