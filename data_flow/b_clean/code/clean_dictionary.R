


clean_dictionary=data.frame(Variable=c(names(file001),names(file003),names(file250)))
clean_dictionary$Enduse=NA
clean_dictionary$Units=NA
clean_dictionary$Measured_Calculated=NA
clean_dictionary$Description=NA



write.csv(clean_dictionary,paste0("./data_flow/a_import/data/clean_data_dictionary.csv"),row.names=FALSE)

