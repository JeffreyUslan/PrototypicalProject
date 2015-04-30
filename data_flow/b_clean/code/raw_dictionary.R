


raw_dictionary=data.frame(Variable=c(names(file001),names(file002),names(file003),names(file250)))
raw_dictionary$Enduse=NA
raw_dictionary$Units=NA
raw_dictionary$Measured_Calculated=NA
raw_dictionary$Description=NA


raw_dictionary = raw_dictionary[!duplicated(raw_dictionary), ]
write.csv(raw_dictionary,paste0("./data_flow/b_clean/data/raw_data_dictionary.csv"),row.names=FALSE)


