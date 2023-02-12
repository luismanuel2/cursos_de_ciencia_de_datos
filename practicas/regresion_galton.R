
# solucion con matrices de los datos galton 

library(UsingR)
data(galton)
x<-cbind(rep (1, nrow (galton)),galton$parent)
y<-galton$child
solve(t(x)%*%x)%*%t(x)%*%y

#solucion con descenso de gradiante 
alpha<-0.00042
theta<-c(0,0)
m<-length(y)
ta<-list()
cost<-NULL
for (i in 1:10000) {
  #theta[1]<-theta[1]-alpha/m*sum(theta[1]+theta[2]*x[,2]-y)
  #theta[2]<-theta[2]-alpha/m*sum((theta[1]+theta[2]*x[,2]-y)*x[,2])
  theta<-theta-alpha/m*t(x)%*%(x%*%theta-y)
  c<-1/(2*m)*sum((x%*%theta-y)^2)
  ta[[i]]<-theta
  cost<-c(cost,c)
}
plot(cost)

#comparando el original con el descenso 
fit<-lm(child~parent,galton)
pr<-predict(fit)-y
pr2<-theta[1]+theta[2]*x[,2]-y
max(abs(pr2-pr))


#graficas de las distintas lineas 
plot(x[,2],y)
abline(fit,col="blue")
abline(theta[1],theta[2],col="red")

#normalizando los datos 
x<-cbind(rep (1, nrow (galton)),scale(galton$parent))
y<-scale(galton$child)
solve(t(x)%*%x)%*%t(x)%*%y
fit2<-lm(y~x[,2])


alpha<-0.00052
theta<-c(0,0)
m<-length(y)
ta<-list()
cost<-NULL
for (i in 1:10000) {
  #theta[1]<-theta[1]-alpha/m*sum(theta[1]+theta[2]*x[,2]-y)
  #theta[2]<-theta[2]-alpha/m*sum((theta[1]+theta[2]*x[,2]-y)*x[,2])
  theta<-theta-alpha/m*t(x)%*%(x%*%theta-y)
  c<-1/(2*m)*sum((x%*%theta-y)^2)
  ta[[i]]<-theta
  cost<-c(cost,c)
}
plot(cost)


co<-coef(fit)
co2<-coef(fit2)

co[1]+65*co[2]

no<-(65-mean(galton$parent))/sqrt(var(galton$parent))
es<-no*co2[2]
(es)*sqrt(var(galton$child))+mean(galton$child)
