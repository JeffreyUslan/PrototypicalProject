plot_gui = function(enduses, dates, smooth = 1) {
  
  
  file = gui_munge(enduses, dates, smooth)
  
  data_dictionary = data_dictionary[data_dictionary$Variable %in% enduses, ]
  
  time_ind = which(names(file) == "DateTime")
  
  melted = try(melt(data = file, id.vars = paste(names(file)[time_ind]), na.rm = TRUE), silent = TRUE)
  if (class(melted) == "try-error") 
    return(NULL)
  melted = try(merge(x = melted, y = data_dictionary, by.x = "variable", by.y = "Variable"), silent = TRUE)
  if (class(melted) == "try-error") 
    return(NULL)
  
  if (length(levels(as.factor(as.character(data_dictionary$Units)))) > 1) {
    g = ggplot(data = melted, aes(x = DateTime, y = value, colour = variable)) + theme_bw() + geom_line() + facet_grid(Units ~ 
                                                                                                                         ., scales = "free") + ylab("")
  } else {
    g = ggplot(melted) + theme_bw() + geom_line(aes(x = DateTime, y = value, colour = variable), size = 1) + ylab(as.character(data_dictionary$Units[1]))
  }
  
  g = g + scale_color_discrete(name = "Legend") + ggtitle("Ecotope Seattle Office") + xlab("Time") +theme(legend.position="left")
  g
}

table_gui = function(enduses, dates, smooth = 1) {
  tmp_file = gui_munge(enduses, dates, smooth)
  tmp_file = tbl_df(tmp_file)
  enduse_inds = which(names(tmp_file) %in% enduses)
  
  
  
  # gathering rows for table
  min_col = summarise_each(tmp_file, funs(min(., na.rm = TRUE)), enduse_inds)
  mean_col = summarise_each(tmp_file, funs(mean(., na.rm = TRUE)), enduse_inds)
  max_col = summarise_each(tmp_file, funs(max(., na.rm = TRUE)), enduse_inds)
  sd_col = summarise_each(tmp_file, funs(sd(., na.rm = TRUE)), enduse_inds)
  
  
  
  
  if (smooth==1) {
    #default to comparing to a daily smooth
    tmp_file=as.data.frame(gui_munge(enduses, dates, smooth=288))
  }
  fine_file=as.data.frame(gui_munge(enduses, dates, smooth=1))
  active_annualized_kwh_col=NULL
  standby_annualized_kwh_col=NULL
  
  for (ind in enduse_inds) {
    data_dictionary_ind=which(data_dictionary$Variable %in% names(tmp_file)[ind])
    if(as.character(data_dictionary$Units[data_dictionary_ind])=="Kilowatts"){
      
      active_ind=which(fine_file[,ind]>(1.05*tmp_file[,ind]))
      standby_ind=which(fine_file[,ind]<(1.05*tmp_file[,ind]))
      
      active_mean=mean((fine_file[active_ind,ind]),na.rm=TRUE)
      standby_mean=mean((fine_file[standby_ind,ind]),na.rm=TRUE)
      
      active_pct_time=length(active_ind)/(length(active_ind)+length(standby_ind))
      standby_pct_time=1-active_pct_time
      
      active_annualized_kwh=active_mean*8760*active_pct_time
      standby_annualized_kwh=standby_mean*8760*standby_pct_time
      
      
    } else {
      active_annualized_kwh=NA
      standby_annualized_kwh=NA
    }
    active_annualized_kwh_col=c(active_annualized_kwh_col,active_annualized_kwh)
    standby_annualized_kwh_col=c(standby_annualized_kwh_col,standby_annualized_kwh)
  }
  
  
  cool_table = t(as.data.frame(rbind(min_col, mean_col, max_col, sd_col,
                                     active_annualized_kwh_col,standby_annualized_kwh_col)))
  cool_table=as.data.frame(cbind(rownames(cool_table),cool_table))
  colnames(cool_table) = c("Variable","Minimum", "Mean", "Maximum", "Standard Deviation",
                           "Annualized Active kWh","Annualized Standby kWh")
  rownames(cool_table)=NULL
  
  
  cool_table[,(2:ncol(cool_table))]=apply(cool_table[,(2:ncol(cool_table))],2,as.numeric)
  cool_table=omit_NA_cols(cool_table)
  cool_table=arrange(cool_table,Variable)
  return(cool_table)
}

dictionary_gui = function(enduses) {
  data_dictionary = data_dictionary[data_dictionary$Variable %in% enduses, ]
  data_dictionary$Enduse = NULL
  row.names(data_dictionary) = NULL
  data_dictionary=arrange(data_dictionary,Variable)
  return(data_dictionary)
}

gui_munge = function(enduses, dates, smooth = 1) {
  # rdas=list.files(pattern='.rda') for (file in rdas) {load(file)}
  if (smooth == "1") {
    file = file
  } else if (smooth == "288") {
    file = day_smooth
  } else if (smooth == "2016") {
    file = week_smooth
  } else {
    file = four_week_smooth
  }
  
  # omiting irrelevant end uses
  
  end_inds = which(names(file) %in% enduses)
  time_ind = which(names(file) == "DateTime")
  file = file[, c(time_ind, end_inds)]
  
  
  # data selection
  dates = as.POSIXct(dates)
  
  start = try(min(which(file$DateTime > dates[1])), silent = TRUE)
  if (class(start) == "try-error") {
    return(NULL)
  } else if (length(start) == 0) {
    start = 1
  }
  
  
  
  n_finish = max(which(file$DateTime < dates[2]))
  if (length(n_finish) == 0) 
    n_finish = nrow(file)
  
  
  file = file[start:n_finish, ]
  
  
  
  return(file)
}



compare_gui = function(enduses, dates, smooth = 1) {
  # for (file in rdas) {load(file)}
  file = gui_munge(enduses, dates, smooth)
  
  if (length(enduses) == 1) {
    names(file)[2] = "var"
    g = ggplot(file) + theme_bw()
    g = g + geom_density(aes(x = var), color = "red") + xlab(as.character(enduses)[1]) + ylab("Density")
    g = g + ggtitle(paste0(as.character(enduses)[1], " Density"))
  } else if (length(enduses) == 2) {
    
    names(file)[c(2, 3)] = c("var1", "var2")
    g = ggplot(file) + theme_bw()
    g = g + geom_point(aes(x = var1, y = var2), size = 0.1, color = "darkorchid3") + xlab(as.character(enduses)[2]) + ylab(as.character(enduses)[1])
    g = g + geom_smooth(aes(x = var1, y = var2))
    g = g + ggtitle(paste0(as.character(enduses)[1], " Vs ", as.character(enduses)[2]))
  } else {
    stop("Please select only 1-2 variables.")
  }
  g
  }