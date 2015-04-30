load(paste0("./data_flow/a_import/data/deliverable/Ecotope.rda"))


if (length(which(file001$error > 1))) file001 = file001[-which(file001$error > 1), ]
if (length(which(file002$error > 1))) file002 = file002[-which(file002$error > 1), ]
if (length(which(file003$error > 1))) file003 = file003[-which(file003$error > 1), ]
if (length(which(file250$error > 1))) file250 = file250[-which(file250$error > 1), ]


# remove variables with only NA values
file001 = omit_NA_cols(file001)
file002 = omit_NA_cols(file002)
file003 = omit_NA_cols(file003)
file250 = omit_NA_cols(file250)
# remove variables with only 0 values
file001 = omit_zero_cols(file001)
file002 = omit_zero_cols(file002)
file003 = omit_zero_cols(file003)
file250 = omit_zero_cols(file250)
 

source("./data_flow/b_clean/code/raw_dictionary.R")
#make the thing!
variable_alias_ref <- read.csv("./data_flow/b_clean/data/variable_alias_ref.csv")

file001 = name_fix(file001, variable_alias_ref)
file002 = name_fix(file002, variable_alias_ref)
file003 = name_fix(file003, variable_alias_ref)
file250 = name_fix(file250, variable_alias_ref)


#changed the metering protocol, need to make changes after that point (April 23, 2015)
#correct Service
file001$Service=rowSums(cbind(file001$Service,rowMeans(cbind(file001$Service.1,file001$Service.2),na.rm=TRUE)),na.rm=TRUE)
file001$Service.1=NULL
file001$Service.2=NULL
#correct lights
file001$Lights=rowSums(cbind(file001$Lights,file001$Lights.1),na.rm=TRUE)
file001$Lights.1=NULL
#correct Heat Pump
file002$HP=rowSums(cbind(file002$HP,file002$HP.1),na.rm=TRUE)
file002$HP.1=NULL
file002$Work_Station_Receptacles=file002$Work_Station_Receptacles*2
#correct Work_Station_Receptacles
file003$Work_Station_Receptacles=rowSums(cbind(file003$Work_Station_Receptacles,file003$Work_Station_Receptacles.1/2),na.rm=TRUE)
file003$Work_Station_Receptacles.1=NULL
#correct Phone Alarm
file003$Phone_Alarm=rowMeans(cbind(file003$Phone_Alarm,file003$Phone_Alarm.1/2),na.rm=TRUE)
file003$Phone_Alarm.1=NULL
#Correct Heat Pump
file003$HP=rowSums(cbind(file003$HP,file003$HP.1,file003$HP.2),na.rm=TRUE)
file003$HP.1=NULL
file003$HP.2=NULL


# time stamps
file001$DateTime = ymd_hms((file001$DateTime))
file002$DateTime = ymd_hms((file002$DateTime))
file003$DateTime = ymd_hms((file003$DateTime))
file250$DateTime = ymd_hms((file250$DateTime))

file001 = file001[order(file001$DateTime), ]
file002 = file002[order(file002$DateTime), ]
file003 = file003[order(file003$DateTime), ]
file250 = file250[order(file250$DateTime), ]
# add non-present time_stamps (makes graphing easier later)
file001 = continuous_uniform_time(tmpfile = file001, DateTime = "DateTime")
file002 = continuous_uniform_time(tmpfile = file002, DateTime = "DateTime")
file003 = continuous_uniform_time(tmpfile = file003, DateTime = "DateTime")
file250 = continuous_uniform_time(tmpfile = file250, DateTime = "DateTime")





# forcing variables ranges
var_ranges = read.csv("./data_flow/b_clean/data/var_ranges.csv")
file001 = var_range_fix(tmpfile = file001, var_ranges = var_ranges)
file002 = var_range_fix(tmpfile = file002, var_ranges = var_ranges)
file003 = var_range_fix(tmpfile = file003, var_ranges = var_ranges)
file250 = var_range_fix(tmpfile = file250, var_ranges = var_ranges)

# merging this all together

file001$DateTime = as.character(file001$DateTime)
file002$DateTime = as.character(file002$DateTime)
file003$DateTime = as.character(file003$DateTime)
file250$DateTime = as.character(file250$DateTime)

file = merge(file001, file002, by = "DateTime", all = TRUE)
file = merge(file, file003, by = "DateTime", all = TRUE)
file = merge(file, file250, by = "DateTime", all = TRUE)


file$DateTime = ymd_hms(file$DateTime)
file$DateTime = force_tz(file$DateTime, tzone = "America/Los_Angeles")
# correcting time zone
file$DateTime = file$DateTime - (60 * 60 * 7)

#Some more variable correcting
file$HP=rowSums(cbind(file$HP.x,file$HP.y),na.rm=TRUE)
file$HP.x=NULL
file$HP.y=NULL
file$Work_Station_Receptacles=rowSums(cbind(file$Work_Station_Receptacles.x,file$Work_Station_Receptacles.y),na.rm=TRUE)
file$Work_Station_Receptacles.x=NULL
file$Work_Station_Receptacles.y=NULL



save(file, file = paste0("./data_flow/b_clean/data/deliverable/Ecotope.rda")) 





svdDenoise=function(A,nrg=.9,remove=0){
#   require(matlab)
  require(matrixStats)
  require(stats)
  if (!(nrg<=1 && nrg>=0)){print("Energy must be between 0 and 1")}
  #identify dimensions
  m<-dim(A)[1];n<-dim(A)[2];
  
  s<-svd(A);singularv<-s$d;sumsv<-sum(singularv)
  if (remove==0){
    for (i in 1:n){
      Pnrg=sum(singularv[1:i])/sumsv
      if (Pnrg>=nrg){
        numFeat=i
        #     print(numFeat)
        break
      }
    }
    #   plot(cumsum(s$d))
    newSing=s$d[1:numFeat]
  } else {
    newSing=s$d[1:(n-remove)]
    i=n-remove
  }
  red_S=zeros(n)
  for (j in 1:i){
    red_S[j,j]=newSing[j]
  }
  
  newA=((s$u)%*%(red_S))%*%t(s$v)
  
  
}



