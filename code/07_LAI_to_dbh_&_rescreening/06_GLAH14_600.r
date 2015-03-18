#Subset GLAH14 list to the 600 selected pulses

GLAH14_600 = list()
for (e in substr(DATA$ID,start = 5,stop = 10)){
  pulse_tmp  = GLAH14_pulses[e]  
  GLAH14_600[[e]] <- pulse_tmp
}
rm(e)
rm(pulse_tmp)



