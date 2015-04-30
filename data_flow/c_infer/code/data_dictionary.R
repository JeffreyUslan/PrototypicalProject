data_dictionary=data.frame(Variable=names(file))
data_dictionary$Enduse=NA
data_dictionary$Units=NA
data_dictionary$Measured_Calculated=NA
data_dictionary$Description=NA


data_dictionary$min=apply(file,2,function(x){round(min(as.numeric(x),na.rm=TRUE),1)})
data_dictionary$median_above_zero=apply(file,2,function(x){round(median(as.numeric(x[which(as.numeric(x)>0)]),na.rm=TRUE),1)})
data_dictionary$max=apply(file,2,function(x){round(max(as.numeric(x),na.rm=TRUE),1)})

write.csv(data_dictionary,paste0("./data_flow/data_dictionary.csv"),row.names=FALSE)

write.csv(data_dictionary,paste0("./data_flow/e_analyze/code/Ecotope_GUI/data_dictionary.csv"),row.names=FALSE)
