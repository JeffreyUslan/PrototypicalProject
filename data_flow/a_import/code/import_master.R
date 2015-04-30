

source("./data_flow/a_import/code/import.R")
cdx("EOM")
save(file001,file002,file003,file250,file=paste0("./data_flow/a_import/data/last_run.rda"))
# load("./data_flow/a_import/data/last_run.rda")






save(file001,file002,file003,file250,file=paste0("./data_flow/a_import/data/deliverable/Ecotope.rda"))
