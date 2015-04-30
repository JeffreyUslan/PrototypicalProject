



load(paste0("./data_flow/c_infer/data/deliverable/Ecotope.rda"))

cdx("qclcd")
# WST_file=read.dta("../data/WASeattle24233hrly.dta")
WST_file=read.dta("../data/WASeattle24234hrly.dta")
WST_file$readTime=as.POSIXlt(round(as.double(WST_file$readTime)/(5*60))*(5*60),origin=(as.POSIXlt('1970-01-01')))

WST_file=WST_file[,c(2,4)]
names(WST_file)=c("WST","hold")

# $this could definitely be more sophisticated
WST_file=WST_file[!duplicated(WST_file),]

WST_mean=mean(WST_file$WST,na.rm=TRUE)
WST_sd=sd(WST_file$WST,na.rm=TRUE)
outlier_inds=which(WST_file$WST>(WST_mean+4*WST_sd) | WST_file$WST<(WST_mean-4*WST_sd))
WST_file=WST_file[-outlier_inds,]
# sum(duplicated(WST_file))

WST_file$hold=as.character(WST_file$hold)
file$hold=as.character(file$DateTime)
file=merge(file,WST_file,by="hold",all.x=TRUE)
file$hold=NULL

#bring in the ecotope billing data
data(ecotope)
ecotope$Service_Billed=ecotope$kwhd/24
ecotope$hold=as.character(as.POSIXct(ecotope$dateStart))
ecotope=ecotope[c("hold","Service_Billed")]

file$hold=as.character(file$DateTime)
file=merge(file,ecotope,by="hold",all.x=TRUE)
file$hold=NULL
#filling in kw for fair weighting
bill_ind=which(!is.na(file$Service_Billed))
for (i in 1:(length(bill_ind)-1)){
  file$Service_Billed[bill_ind[i]:(bill_ind[i+1]-1)]=file$Service_Billed[bill_ind[i]]
}
ecotope_sqft=2688
file$Annualized_EUI_Billed=file$Service_Billed*8760*3.412/ecotope_sqft

#mean imputation for single NA observations
# file=single_pt_avg_impute(tmpfile=file)

n_nums=sapply(file,is.numeric)

file[,n_nums]=na.approx(file[,n_nums])




cdx("EOM")
save(file,file=paste0("./data_flow/d_impute/data/deliverable/Ecotope.rda"))



