### Criteria 1


condensed_crit1 <- unlist(list_i_numPk,use.names = F) >= 2
table(condensed_crit1)

### Criteria 2
condensed_crit2 <- criteria2_bool[[1]]
condensed_crit2 <- append(condensed_crit2,criteria2_bool[[2]])
condensed_crit2 <- append(condensed_crit2,criteria2_bool[[3]])
condensed_crit2 <- append(condensed_crit2,criteria2_bool[[4]])
condensed_crit2 <- append(condensed_crit2,criteria2_bool[[5]])
condensed_crit2 <- append(condensed_crit2,criteria2_bool[[6]])
condensed_crit2 <- append(condensed_crit2,criteria2_bool[[7]])
condensed_crit2 <- append(condensed_crit2,criteria2_bool[[8]])

table(condensed_crit2)

## COmpare bools criteria 2

## d_sDevNsOb1 value, shots that exceeded
(unlist(list_d_sDevNsOb1,use.names = F)[!unlist(criteria2_bool,use.names = F)])*2

## d_maxRecAmp value, shots that exceeded
unlist(list_d_maxRecAmp,use.names = F)[!unlist(criteria2_bool,use.names = F)]

