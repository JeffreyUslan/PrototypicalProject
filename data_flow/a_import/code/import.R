# Jeffrey Uslan December 2015


# change directory
setwd("//storage/RBSA_secure/NEEA/2011_RBSA_Metering_40415/data_and_analysis/SMdata/90002/001EC60014FE_001EC600148D/001EC60014FE_001EC600148D")



# should probably use lists here so we can nest loops read in and export 001s
siteFiles001 = list.files(pattern = "^mb-001")
siteFiles001_b = list.files(path = "../", pattern = "^mb-001")
siteFiles001_b = sapply(siteFiles001_b, function(x) {
  paste0("../", x)
})
#get all names of potential files
siteFiles001 = c(siteFiles001, siteFiles001_b)
#check to see uf file001 has been saved before
if (class(try(load(file = paste0("./processed001.rda")), silent = TRUE)) != "try-error") {
  if (length(attributes(file001)$sites_processed) > 0) {
    processed_files001=attributes(file001)$sites_processed
    #remove files that have already been processed
    siteFiles001 = siteFiles001[-which(siteFiles001 %in% processed_files001)]
    
  }
} 

#check if there are any new files
if (length(siteFiles001) > 0) {
  print(paste("Processing", length(siteFiles001), "001 files"))
  append = NULL
  
  #append the new files
  for (file in siteFiles001) {
    
    tmpfile = try(read.csv(paste0("./", file)))
    if ("try-error" %in% class(tmpfile))     next
    
    append = rbind.all.columns(append, tmpfile)
  }
  #check to see uf file001 has been saved before  
  if (class(try(load(file = paste0("./processed001.rda")), silent = TRUE)) != "try-error") {
    #apparently the order here is very important or it wipes out the attributes
    file001 = rbind.all.columns(file001,append)
  } else {
    file001 = append
  }
  
  #removing duplicates
  file001 = distinct(file001)
  
  # passing on sites processed in rda attributes
  if (length(attributes(file001)$sites_processed) > 0) {
    attr(file001, "sites_processed") = c(processed_files001, siteFiles001)
  } else {
    attr(file001, "sites_processed") = siteFiles001
  }
  save(file001, file = paste0("./processed001.rda"))
}

# should probably use lists here so an nest loops read in and export 002s
siteFiles002 = list.files(pattern = "^mb-002")
siteFiles002_b = list.files(path = "../", pattern = "^mb-002")
if (length(siteFiles002_b)>0){
  siteFiles002_b = sapply(siteFiles002_b, function(x) {
    paste0("../", x)
  })
  siteFiles002 = c(siteFiles002, siteFiles002_b)
}
if (class(try(load(file = paste0("./processed002.rda")), silent = TRUE)) != "try-error") {
  if (length(attributes(file002)$sites_processed) > 0) {
    processed_files002=attributes(file002)$sites_processed
    siteFiles002 = siteFiles002[-which(siteFiles002 %in% processed_files002)]
    
  }
}

if (length(siteFiles002) > 0) {
  print(paste("Processing", length(siteFiles002), "002 files"))
  append = NULL
  
  for (file in siteFiles002) {
    
    tmpfile = try(read.csv(paste0("./", file)),silent=TRUE)
    if ("try-error" %in% class(tmpfile))       next
    
    append = rbind.all.columns(append, tmpfile)
  }
  
  if (class(try(load(file = paste0("./processed002.rda")), silent = TRUE)) != "try-error") {
    file002 = rbind.all.columns(file002,append)
  } else {
    file002 = append
  }
  
  
  # passing on sites processed in rda attributes
  file002 = distinct(file002)
  if (length(attributes(file002)$sites_processed) > 0) {
    attr(file002, "sites_processed") = c(processed_files002, siteFiles002)
  } else {
    attr(file002, "sites_processed") = siteFiles002
  }
  save(file002, file = paste0("./processed002.rda"))
}
# read in and export 003s
siteFiles003 = list.files(pattern = "^mb-003")
siteFiles003_b = list.files(path = "../", pattern = "^mb-003")
siteFiles003_b = sapply(siteFiles003_b, function(x) {
  paste0("../", x)
})
siteFiles003 = c(siteFiles003, siteFiles003_b)
if (class(try(load(file = paste0("./processed003.rda")), silent = TRUE)) != "try-error") {
  if (length(attributes(file003)$sites_processed) > 0) {
    processed_files003=attributes(file003)$sites_processed
    siteFiles003 = siteFiles003[-which(siteFiles003 %in% processed_files003)]
    
  }
}

if (length(siteFiles003) > 0) {
  print(paste("Processing", length(siteFiles003), "003 files"))
  append = NULL
  for (file in siteFiles003) {
    tmpfile = try(read.csv(paste0("./", file)))
    if ("try-error" %in% class(tmpfile))       next
    
    
    append = rbind.all.columns(append, tmpfile)
    
  }
  
  if (class(try(load(file = paste0("./processed003.rda")), silent = TRUE)) != "try-error") {
    file003 = rbind.all.columns(file003,append)
  } else {
    file003 = append
  }
  # passing on sites processed in rda attributes
  file003 = distinct(file003)
  if (length(attributes(file003)$sites_processed) > 0) {
    attr(file003, "sites_processed") = c(processed_files003, siteFiles003)
  } else {
    attr(file003, "sites_processed") = siteFiles003
  }
  
  save(file003, file = paste0("./processed003.rda"))
}


# read in and export 250s
siteFiles250 = list.files(pattern = "^mb-250")
siteFiles250_b = list.files(path = "../", pattern = "^mb-250")
siteFiles250_b = sapply(siteFiles250_b, function(x) {
  paste0("../", x)
})
siteFiles250 = c(siteFiles250, siteFiles250_b)
if (class(try(load(file = paste0("./processed250.rda")), silent = TRUE)) != "try-error") {
  if (length(attributes(file250)$sites_processed) > 0) {
    processed_files250=attributes(file250)$sites_processed
    siteFiles250 = siteFiles250[-which(siteFiles250 %in% processed_files250)]
    
  }
}
if (length(siteFiles250) > 0) {
  print(paste("Processing", length(siteFiles250), "250 files"))
  append = NULL
  
  for (file in siteFiles250) {
    tmpfile = try(read.csv(paste0("./", file)))
    if ("try-error" %in% class(tmpfile))       next
    
    
    append = rbind.all.columns(append, tmpfile)
    
  }
  
  if (class(try(load(file = paste0("./processed250.rda")), silent = TRUE)) != "try-error") {
    file250 = rbind.all.columns(file250,append)
  } else {
    file250 = append
  }
  # passing on sites processed in rda attributes
  file250 = distinct(file250)
  if (length(attributes(file250)$sites_processed) > 0) {
    attr(file250, "sites_processed") = c(processed_files250, siteFiles250)
  } else {
    attr(file250, "sites_processed") = siteFiles250
  }
  save(file250, file = paste0("./processed250.rda"))
}
