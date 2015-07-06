library(UslanUtility)
library(lubridate)
library(foreign)
library(zoo)
library(rterm)
library(dplyr)
library(tidyr)
cdx("EOM")


source("./data_flow/a_import/code/import_master.R")

source("./data_flow/b_clean/code/clean.R")

source("./data_flow/c_infer/code/infer.R")
source("./data_flow/c_infer/code/data_dictionary.R")


source("./data_flow/d_impute/code/impute.R")

save(file, file = paste0("./data_flow/e_analyze/code/Ecotope_GUI/data.rda"))

# takes a VERY long time
source("./data_flow/e_analyze/code/pre_smooth.R")





shinyapps::deployApp("./data_flow/e_analyze/code/Ecotope_GUI")
# ,launch.browser=FALSE

