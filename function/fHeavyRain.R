fHeavyRain <- function(WI.DIR,
                       WI,
                       SHP,
                       EPSG.WI,
                       OUT.DIR,
                       OUT.NAME,
                       BUFFER){
#List all files of a specific weather index 
setwd(file.path(WI.DIR))
l.wi <- list.files(pattern="*.asc$")
l.wi <- mixedsort(grep(paste(WI,"_*",sep=""),l.wi,value=TRUE))

#Create DOY values with three numbers
v.doy <- 1:365
for(i in 1:length(v.doy)){
  if(nchar(v.doy[i]) == 1){
    v.doy[i] <- paste("00",v.doy[i],sep="")
  }
if(nchar(v.doy[i]) == 2){
  v.doy[i] <- paste("0",v.doy[i],sep="")
}
}
#import shape file and reproject accordinmg to raster file
p <- shapefile(SHP)
p <- spTransform(p, CRS(paste('+init=epsg:',EPSG.WI,sep="")))
p <- buffer(p, width=BUFFER)
#p <- extent(p)
#calculation of DOY-specific sums and medians
df.max <- data.frame(MAX=NULL)
df.mean <- data.frame(MAX=NULL)
df.doy <- data.frame(DOY=NULL)
pb <- txtProgressBar(min=1, max=length(v.doy), style=3) 


beginCluster(detectCores()-1)
for(i in 1:length(v.doy)){
setwd(WI.DIR)
l.wi.doy <- mixedsort(grep(paste("*",v.doy[i],".asc",sep=""),l.wi,value=TRUE))
s.wi <- stack(l.wi.doy)
#s.wi.sum <- calc(s.wi, sum)/length(l.wi.doy)
s.wi.sum <- clusterR(s.wi,calc,args=list(sum,na.rm=T))
crs(s.wi.sum) <- CRS(paste('+init=epsg:',EPSG.WI,sep=""))
plot(s.wi.sum)
vx.s.wi.sum <- velox(s.wi.sum)
#writeRaster(s.wi.sum,paste(OUT.DIR,WI,"_SUM_",v.doy[i],".tif",sep=""),overwrite=TRUE)
#extract max values
#vx.r <- velox(paste(OUT.DIR,WI,"_SUM_",v.doy[i],".tif",sep=""))
vx.s.wi.sum.extract.max <- vx.s.wi.sum$extract(p, fun=max)[[1]]
vx.s.wi.sum.extract.mean <- vx.s.wi.sum$extract(p, fun=mean)[[1]]
##set values "<0" to "0"
#s.wi.sum.extract <- replace(s.wi.sum.extract, s.wi.sum.extract<0, 0)
df.max <- rbind(df.max,vx.s.wi.sum.extract.max)
df.mean <- rbind(df.mean,vx.s.wi.sum.extract.mean)
df.doy <- rbind(df.doy,as.numeric(v.doy[i]))
setTxtProgressBar(pb, i)
}
endCluster()
df <- data.frame(DOY=df.doy[[1]],MAX=df.max[[1]],MEAN=df.mean[[1]])
write.csv2(df,
           paste(OUT.DIR,OUT.NAME,WI,"_buffer",BUFFER,".csv",sep=""),
           row.names=FALSE)
}
