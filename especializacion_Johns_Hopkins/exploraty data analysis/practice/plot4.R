
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

s<-as.character(SCC$EI.Sector)
sub1<-SCC[grep("Coal",s),1]
sub2<-subset(NEI,SCC %in% sub1)
sub3<-split(sub2,sub2$year)
x<-c(1999,2002,2005,2008)
plot(x,sapply(X = sub3,FUN=function(x){sum(x$Emissions)}),main="emissions from coal combustion",xlab="Year",ylab="Emissions",pch=19)

