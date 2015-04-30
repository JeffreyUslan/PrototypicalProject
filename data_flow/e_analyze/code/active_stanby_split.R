cdx("EOM")
load(paste0("./data_flow/d_impute/data/deliverable/Ecotope.rda"))


# enduse="Lights"



active_split=function(tmpfile,enduse,window){
  
  dates=as.POSIXct(dates)
  start=min(which(file$DateTime>dates[1]))-window
  n_finish=max(which(file$DateTime<dates[2]))
  ind=which(names(file)==enduse)
  tmpfile=data.frame(file[start:n_finish,ind])
  
  tmpfile$x= rollapply(tmpfile, window, mean, na.rm = TRUE,fill=NA)  
    
    active_time=length(which(tmpfile[,1]>tmpfile$x))
    standby_time=length(which(tmpfile[,1]<tmpfile$x))

    active_kw=mean(tmpfile[which(tmpfile[,1]>tmpfile$x),1],na.rm=TRUE)
    standby_kw=mean(tmpfile[which(tmpfile[,1]<tmpfile$x),1],na.rm=TRUE)
        
    active_pct_time=100*active_time/(active_time+standby_time)
    standby_pct_time=100*standby_time/(active_time+standby_time)
  
    return_df=data.frame(active_pct_time,standby_pct_time,active_kw,standby_kw)
    return_df=apply(return_df,2,function(x){x=round(x,2)})
    names(return_df)=c("Active Time","Standby Time","Active Mean","Standby Mean")
  return(return_df)
}


days=7
window=288*days

light_vec=active_split(file,"Lights",window)
Work_Station_Receptacles_vec=active_split(file,"Work_Station_Receptacles",window)

df=rbind(light_vec,Work_Station_Receptacles_vec)

df

