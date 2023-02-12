NEI <- readRDS("summarySCC_PM25.rds")


sub1<-split(NEI,NEI$year)
x<-c(1999,2002,2005,2008)
plot(x,sapply(X = sub1,FUN=function(x){sum(x$Emissions)}),main="total emissions",xlab="Year",ylab="ylab",pch=19)

