

setwd('C:/Users/luism/Dropbox/ciencia de datos/ml_r/ex1')
#grafica
print("corriendo")
a<-readline(prompt="enter para continuar")
print("ya")
dat<-read.table('ex1data1.txt',sep=",")
plot(dat)

#funcion de costo y gradiente de descenso
readline(prompt="enter para continuar")

m<-dim(dat)
m<-m[1]
x<-cbind(rep(1,m),dat[,1])
y<-dat[,2]

source('J.R')
theta<-rbind(0,0)
iteration <- 1500
alpha <- 0.01

print("prueba de la función de costo ...debe ser 32.07 ")
J<-funcioncosto(x,y,theta)
print(J)

print("prueba de la función de costo ...debe ser 54.24 ")
theta<-rbind(-1,2)
J<-funcioncosto(x,y,theta)
print(J)

print("Running Gradient Descent ... -3.6303\n  1.1664\n")
da<-gradientDescent(x,y,theta, alpha,iteration)
print(da[[1]])