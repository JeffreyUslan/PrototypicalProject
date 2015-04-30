library(reports)
library(ggplot2)
library(reshape2)
library(lubridate)
library(htmltools)
library(shiny)
library(dplyr)
library(tidyr)
library(xtable)
library(EcotopePackage)
library(zoo)
# library(ggvis)



load("data.rda")
load("data_day_smooth.rda")
load("data_week_smooth.rda")
load("data_four_week_smooth.rda")


source("./gui_functions.R")

data_dictionary=read.csv("./data_dictionary_manual_edit.csv")
