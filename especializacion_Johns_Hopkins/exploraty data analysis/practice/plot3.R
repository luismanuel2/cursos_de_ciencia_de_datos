library(ggplot2)
library(dplyr)
NEI <- readRDS("summarySCC_PM25.rds")


sub1<-subset(NEI,fips == "24510")
sub2<-sub1 %>% group_by(type,year) %>% summarise(sum = sum(Emissions))%>% as.data.frame
g<-ggplot(sub2,aes(year,sum))
g + geom_point() +facet_wrap(~type, nrow = 1, ncol = 4)+theme_bw(base_family = "Avenir", base_size = 10)+labs(y = "Emissions")+ggtitle("emissions in Baltimore by type")