

load(paste0("./data_flow/b_clean/data/deliverable/Ecotope.rda"))



ecotope_sqft=2688
#service (kw) * 24 (hours in a day) * 3.412 (wh/btu/ 2688 (square feet)
#kbtu/sqft
# file$Annualized_EUI=c((rep(0,(12*24)-1)),rollapply(file$Service*365*24*3.412/ecotope_sqft, (12*24), mean, na.rm = TRUE))
file$Annualized_EUI=file$Service*8760*3.412/ecotope_sqft





save(file,file=paste0("./data_flow/c_infer/data/deliverable/Ecotope.rda"))
