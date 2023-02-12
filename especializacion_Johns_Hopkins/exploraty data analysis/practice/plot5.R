NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

sub0<-subset(NEI,fips == "24510")
s<-as.character(SCC$EI.Sector)

sub1<-SCC[grep("Vehicle",s),1]

sub2<-subset(sub0,SCC %in% sub1)
sub3<-split(sub2,sub2$year)
x<-c(1999,2002,2005,2008)
plot(x,sapply(X = sub3,FUN=function(x){sum(x$Emissions)}),main = "emissions from motor vehicle in Baltimore",xlab="Year",ylab="Emissions",pch=19)

