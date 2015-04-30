



rbind.all.columns <- function(x, y) {
  
  x.diff <- setdiff(colnames(x), colnames(y))
  y.diff <- setdiff(colnames(y), colnames(x))
  if (!is.null(x)){
    if (length(y.diff)>0 & dim(x)[2]>0) {
      x[, c(as.character(y.diff))] <- NA
    }
    
    if (length(x.diff)>0 & dim(x)[2]>0) {
      y[, c(as.character(x.diff))] <- NA
    }  
  }
  
  return(rbind(x,y))
  
  
} #end of function rbind.all.columns



name_fix = function(tmpfile){
  variable_alias_ref<-read.csv("./variable_alias_ref.csv")  
  #  fix some names
  null_inds=NULL
  rename_ind=which(names(tmpfile) %in% variable_alias_ref$variable.alias)
  for (ind in rename_ind){
    rename_to_ind=which(variable_alias_ref$variable.alias==names(tmpfile)[ind])
    if (variable_alias_ref$variable.true[rename_to_ind]=="NULL")  {
      null_inds=c(null_inds,ind)
    } else {
      names(tmpfile)[ind]=as.character(variable_alias_ref$variable.true[rename_to_ind])
    }
  }
  if (length(null_inds))  tmpfile=tmpfile[,-null_inds]
  return(tmpfile)
} #end function name_fix


