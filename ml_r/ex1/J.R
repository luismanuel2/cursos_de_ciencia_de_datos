funcioncosto<-function(x,y,theta)
{
  m<-length(y)
  J<-1/(2*m)*t(x%*%theta-y)%*%(x%*%theta-y)
  
}
gradientDescent<-function(x,y,theta, alpha,iteration)
{
  m<-length(y)
  Jh<-rep(0,iteration)
  for(i in 1:iteration){
    theta<-theta-alpha/m*t(x)%*%(x%*%theta-y)
    Jh[i]<-funcioncosto(x,y,theta)
  }
  return( list(theta,Jh))
}