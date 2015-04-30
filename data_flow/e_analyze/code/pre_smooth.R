


n_nums=sapply(file,is.numeric)

day_smooth=file
day_smooth[,n_nums]=apply(day_smooth[,n_nums],2,function(x){
  rollapply(x, 288, mean, na.rm = TRUE,fill=NA)
})

save(day_smooth,file=paste0("./data_flow/e_analyze/code/Ecotope_GUI/data_day_smooth.rda"))



week_smooth=file
week_smooth[,n_nums]=apply(week_smooth[,n_nums],2,function(x){
  rollapply(x, 2016, mean, na.rm = TRUE,fill=NA)
})

save(week_smooth,file=paste0("./data_flow/e_analyze/code/Ecotope_GUI/data_week_smooth.rda"))



four_week_smooth=file
four_week_smooth[,n_nums]=apply(four_week_smooth[,n_nums],2,function(x){
  rollapply(x, 8064, mean, na.rm = TRUE,fill=NA)
})

save(four_week_smooth,file=paste0("./data_flow/e_analyze/code/Ecotope_GUI/data_four_week_smooth.rda"))

