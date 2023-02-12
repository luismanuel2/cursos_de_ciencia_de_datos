NEI <- readRDS("summarySCC_PM25.rds")


sub1<-subset(NEI,fips == "24510")
sub2<-split(sub1,sub2$year)
plot(x,sapply(X = sub2,FUN=function(x){sum(x$Emissions)}),main = "emissions in Baltimore",xlab="Year",ylab="Emissions",pch=19)