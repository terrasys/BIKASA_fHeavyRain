#Basic Settings
#-----------------------------------------------------------------------------------------------------
W.DIR = "d:/Dropbox/_git/BIKASA_HeavyPrec/"
FUNC.DIR = "_function/"

print("Import functions")
#-----------------------------------------------------------------------------------------------------
source(file.path(W.DIR,FUNC.DIR,"fPackages.R"))
source(file.path(W.DIR,FUNC.DIR,"fHeavyRain.R"))


#-----------------------------------------------------------------------------------------------------
print("Load functions")
#-----------------------------------------------------------------------------------------------------
loadandinstall()

WI.DIR = ".../"
OUT.DIR = "..."
SHP = "..."
OUT.NAME = "..."
WI = "RADOLANGT10MM"
#WI = "RADOLANMAX"
BUFFER = 5000
fHeavyRain(WI.DIR,
           WI,
           SHP,
           EPSG.WI=31467,
           OUT.DIR,
           OUT.NAME,
           BUFFER)

#-----------------------------------------------------------------------------------------------------
print("Plots")
#-----------------------------------------------------------------------------------------------------
setwd(OUT.DIR)
#RADOLANGT10MM.pdf
o <- read.csv2(paste(OUT.DIR,"DESTLI0503850019_RADOLANGT10MM_buffer5000.csv",sep=""))
{pdf("DESTLI0503850019_RADOLANGT10MM.pdf", height=5,width=8)
plot(o$DOY,o$MAX,
     ylim=c(0,max(o$MAX)+1),
     col="blue",
     pch=1,
     ylab=expression(paste(italic(Sigma), "(", italic(SNI),")")),
     #ylab=expression(paste(italic(SNI))),
     xlab="Kalendertag",
     xaxt="n")

x1 <- seq(1,365,10)
x2 <- seq(1,365,2)
axis(1, at=x2, col.tick="grey", las=1,labels=FALSE,cex=1.2)
axis(1, at=x1, col.axis="black", las=2,cex=1.2)
#plotting opf months
DIM <- data.frame("DIM"=NULL)
for(i in 1:12){
  x <- days_in_month(i)[[1]]
  DIM <- rbind(DIM,x)
}
SUM <- data.frame("SUM"=NULL)
for(i in 1:12){
  SUM <-  rbind(SUM,sum(DIM[1:i,]))
}

for(i in 1:11){
  abline(v=SUM[i,],col="grey")
}
abline(v=0,col="grey")
abline(v=365,col="grey")
text(x = SUM[[1]], y = max(o$MAX)+1, 
     label =  c("Jan","Feb","Mar","Apr","Mai","Jun","Jul","Aug","Sep","Okt","Nov","Dez"), 
     pos = 2, 
     cex = 0.8, 
     col = "grey")

dev.off()
}
o <- read.csv2(paste(OUT.DIR,"DESTLI0503850019_RADOLANMAX_buffer5000.csv",sep=""))
{pdf("DESTLI0503850019_RADOLANMAX.pdf", height=5,width=8)
  plot(o$DOY,o$MAX,
       ylim=c(0,max(o$MAX)+1),
       col="blue",
       pch=1,
       ylab=expression(paste(italic(Sigma), "(", italic(N^max),") [mm]")),
       #ylab=expression(paste(italic(SNI))),
       xlab="Kalendertag",
       xaxt="n")
  
  x1 <- seq(1,365,10)
  x2 <- seq(1,365,2)
  axis(1, at=x2, col.tick="grey", las=1,labels=FALSE,cex=1.2)
  axis(1, at=x1, col.axis="black", las=2,cex=1.2)
  #plotting opf months
  DIM <- data.frame("DIM"=NULL)
  for(i in 1:12){
    x <- days_in_month(i)[[1]]
    DIM <- rbind(DIM,x)
  }
  SUM <- data.frame("SUM"=NULL)
  for(i in 1:12){
    SUM <-  rbind(SUM,sum(DIM[1:i,]))
  }
  
  for(i in 1:11){
    abline(v=SUM[i,],col="grey")
  }
  abline(v=0,col="grey")
  abline(v=365,col="grey")
  text(x = SUM[[1]], y = max(o$MAX)+1, 
       label =  c("Jan","Feb","Mar","Apr","Mai","Jun","Jul","Aug","Sep","Okt","Nov","Dez"), 
       pos = 2, 
       cex = 0.8, 
       col = "grey")
  
  dev.off()
}
