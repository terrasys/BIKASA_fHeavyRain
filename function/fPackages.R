#-----------------------------------------------------------------------------------------------------
print("Load all required packages and dowload/install non-existent packages")
#-----------------------------------------------------------------------------------------------------
loadandinstall <- function(mypkg=c("automap",
                                   "ClusterR",
                                   "gtools",
                                   "chron",
                                   "data.table",
                                   "doSNOW",
                                   "foreign",
                                   "geosphere",
                                   "grid",
                                   "gstat",
                                   "lattice",
                                   "parallel",
                                   "raster",
                                   "RCurl",
                                   "rgdal",
                                   "RSAGA",
                                   "stringr",
                                   "utils",
                                   "sf",
                                   "velox",
                                   "lubridate",
                                   "gtools")) {
  print('Loading required R-Packages or installing them, if not already installed')
  for(i in seq(along=mypkg)){
    if (!is.element(mypkg[i],installed.packages()[,1])){install.packages(mypkg[i])}
    library(mypkg[i], character.only=TRUE)
  }
}
