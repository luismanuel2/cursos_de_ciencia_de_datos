#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    minx<-0
    miny<-0
    fxyval<-function(x,y){6*x^2+3*x^2*y^2+6*y^2}
    dx<-function(x,y){6*x*(y^2+2)}
    dy<-function(x,y){6*y*(x^2+2)}
    X<-seq(-1.5,1.5,by=0.1);Y<-X
    Z<-outer(X = X,Y = Y,FUN = Vectorize(fxyval)) %>% t()

    
  fxyval2<-function(x,y){(x-y)^2+(x^2+y^2)}
    dx2<-function(x,y){4*x-2*y}
    dy2<-function(x,y){4*y-2*x}
    X2<-seq(-4,4,by=0.1);Y2<-X2
    Z2<-outer(X = X2,Y = Y2,FUN = Vectorize(fxyval2)) %>% t()
    
   mod1<-reactive({
       it<-input$iter
       x<-input$box1;xs<-x
       y<-input$box2;ys<-y
       alp<-input$box3
       for (i in 1:it) {
           xtemp<-x
           x<-x-alp*dx(x,y)
           y<-y-alp*dy(xtemp,y)
           xs<-c(xs,x)
           ys<-c(ys,y)
       }
       data.frame(x=xs,y=ys)
   })
   mod2<-reactive({
       it<-input$iter
       x<-input$box1;xs<-x
       y<-input$box2;ys<-y
       alp<-input$box3
       for (i in 1:it) {
           if(i%%2==1){
           x<-x-alp*1.1*dx(x,y)}
           else {
           y<-y-alp*1.3*dy(x,y)}
           xs<-c(xs,x)
           ys<-c(ys,y)
       }
       data.frame(x=xs,y=ys)
   })
   
   mod3<-reactive({
     it<-input$iter
     x<-input$box1;xs<-x
     y<-input$box2;ys<-y
     alp<-input$box3
     for (i in 1:it) {
       xtemp<-x
       x<-x-1.2*alp*dx2(x,y)
       y<-y-1.2*alp*dy2(xtemp,y)
       xs<-c(xs,x)
       ys<-c(ys,y)
     }
     data.frame(x=xs,y=ys)
   })
   mod4<-reactive({
     it<-input$iter
     x<-input$box1;xs<-x
     y<-input$box2;ys<-y
     alp<-input$box3
     for (i in 1:it) {
       if(i%%2==1){
         x<-x-alp*dx2(x,y)}
       else {
         y<-y-alp*dy2(x,y)}
       xs<-c(xs,x)
       ys<-c(ys,y)
     }
     data.frame(x=xs,y=ys)
   })
   
   
   
   
    observeEvent(input$tabs,{
        if(input$tabs=="ejemplo 1"){
   output$plot1<-renderPlotly({
       dat1<-mod1()
       dat2<-mod2()
       plot1<-plot_ly( x = ~X,y = ~Y,z = ~Z,type = 'contour')%>%  
           add_trace(x=~dat1$x,y=~dat1$y, type = "scatter",  mode = 'lines+markers',name="gradient descent") %>% 
           add_trace(x=~dat2$x,y=~dat2$y, type = "scatter",mode = 'lines+markers',name="coordinate descent")
       
   })
   output$plot2<-renderPlotly({
       dat1<-mod1()
       dat2<-mod2()
       f1<-fxyval(dat1$x,dat1$y)
       f2<-fxyval(dat2$x,dat2$y)
       n<-nrow(dat1)-1
       x<-0:n
       data<-data.frame(iteracion=x,f=f1,f2)
       plot2<-plot_ly(data, x = ~iteracion) %>% 
           add_trace(y = ~f, name = 'gradient descent',mode = 'lines',line = list(color = 'rgb(255, 127, 0)')) %>% 
           add_trace(y = ~f2, name = 'coordinate descent',mode = 'lines',line = list(color = 'rgb(0, 143, 57)')) %>% 
           layout(title = 'Grafica f(x,y)')
       
   })
   if(input$iter>=2){
   output$plot5<-renderPlotly({
     dat1<-mod1()
     dat2<-mod2()
     f1<-fxyval(dat1$x,dat1$y)
     f2<-fxyval(dat2$x,dat2$y)
     print(f1)
     print(f2)
     ind<-NULL
     if(length(f2)%%2!=0){
       ind<-seq(1,length(f2),by=2)
     }else{
       ind<-seq(1,length(f2)-1,by=2)
     }
     print(ind)
     f2<-f2[ind]
     n<-length(f2)-1
     x<-0:n
     f1<-f1[1:(n+1)]
     print(f1)
     print(f2)
     data<-data.frame(iteracion=x,f=f1,f2)
     plot5<-plot_ly(data, x = ~iteracion) %>% 
       add_trace(y = ~f, name = 'gradient descent',mode = 'lines',line = list(color = 'rgb(255, 127, 0)')) %>% 
       add_trace(y = ~f2, name = 'coordinate descent',mode = 'lines',line = list(color = 'rgb(0, 143, 57)')) %>% 
       layout(title = 'Grafica f(x,y)')
     
   })
   }
   output$table1<-renderTable({
       sys1<-system.time(mod1())
       sys2<-system.time(mod2())
       data.frame("gradient descent"=sys1[3],"coordinate descent"=sys2[3])
   })
        }
      else{
        output$plot3<-renderPlotly({
          dat1<-mod3()
          dat2<-mod4()
          plot1<-plot_ly( x = ~X2,y = ~Y2,z = ~Z2,type = 'contour')%>%  
            add_trace(x=~dat1$x,y=~dat1$y, type = "scatter",  mode = 'lines+markers',name="gradient descent") %>% 
            add_trace(x=~dat2$x,y=~dat2$y, type = "scatter",mode = 'lines+markers',name="coordinate descent")
          
        })
        output$plot4<-renderPlotly({
          dat1<-mod3()
          dat2<-mod4()
          f1<-fxyval2(dat1$x,dat1$y)
          f2<-fxyval2(dat2$x,dat2$y)
          n<-nrow(dat1)-1
          x<-0:n
          data<-data.frame(iteracion=x,f=f1,f2)
          plot4<-plot_ly(data, x = ~iteracion) %>% 
            add_trace(y = ~f, name = 'gradient descent',mode = 'lines',line = list(color = 'rgb(255, 127, 0)')) %>% 
            add_trace(y = ~f2, name = 'coordinate descent',mode = 'lines',line = list(color = 'rgb(0, 143, 57)')) %>% 
            layout(title = 'Grafica f(x,y)')
          
        })
        if(input$iter>=2){
          output$plot6<-renderPlotly({
            dat1<-mod3()
            dat2<-mod4()
            f1<-fxyval(dat1$x,dat1$y)
            f2<-fxyval(dat2$x,dat2$y)
            print(f1)
            print(f2)
            ind<-NULL
            if(length(f2)%%2!=0){
              ind<-seq(1,length(f2),by=2)
            }else{
              ind<-seq(1,length(f2)-1,by=2)
            }
            print(ind)
            f2<-f2[ind]
            n<-length(f2)-1
            x<-0:n
            f1<-f1[1:(n+1)]
            print(f1)
            print(f2)
            data<-data.frame(iteracion=x,f=f1,f2)
            plot5<-plot_ly(data, x = ~iteracion) %>% 
              add_trace(y = ~f, name = 'gradient descent',mode = 'lines',line = list(color = 'rgb(255, 127, 0)')) %>% 
              add_trace(y = ~f2, name = 'coordinate descent',mode = 'lines',line = list(color = 'rgb(0, 143, 57)')) %>% 
              layout(title = 'Grafica f(x,y)')
            
          })
        }
        output$table2<-renderTable({
          sys1<-system.time(mod3())
          sys2<-system.time(mod4())
          data.frame("gradient descent"=sys1[3],"coordinate descent"=sys2[3])
        })
      }
      
    })
        
    

})
