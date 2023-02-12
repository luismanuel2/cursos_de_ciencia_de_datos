#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(ggplot2)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    set.seed(1000)
    x<-seq(-6,6,by=0.01)
    y<-cos(x)+rnorm(length(x))
    data<-data.frame(x=x,y=y)
    
    model<-reactive({
        brushed_data <- brushedPoints(data, input$brush1,
                                      xvar = "x", yvar = "y")
        pot<-input$grade
        if(nrow(brushed_data) < 2){
            return(lm(y ~ poly(x,pot), data = data))
        }
        
        lm(y ~ poly(x,pot), data = brushed_data)
    })
    pred<-reactive({
        mod<-model()
        xp<-signif(input$valx,digits = 5)
        yp<-signif(predict(mod,newdata = data.frame(x=xp)),digits = 5)
        data.frame(x=xp,y=yp)
    })
    
    output$plot <- renderPlot({
        qplot(x,y,data=data,xlim = c(-6.2,6.2),ylim = c(-4.2,4))+
            geom_line(data=data.frame(x=x,y=predict(model(),newdata = data.frame(x))),color="blue",size=1.2)+
            theme_bw()+geom_point(data=pred(),color="blue",size=6)
        #plot(data$x,data$y,bty="n")
        #if(!is.null(model())){
        #   lines(x,predict(model(),newdata = data.frame(x)),
        #                            col="blue",lwd=2)
        #}
        
    })
    
    output$textmod <- renderText({
        if(input$showmod){
            mod<-model()
            txt<-""
            n<-length(mod$coefficients)
            for (i in 1:n) {
                coef<-signif(mod$coefficients[[i]],digits = 5)
                txt<-paste0(txt,coef,
                            ifelse(i>1,paste0("x^",i-1),""),
                            ifelse(i<n,ifelse(mod$coefficients[[i+1]]>0,"+",""),""))
            }
            txt
        }
        
    })
    
    output$pred<-renderText({
        if(input$showpred){
            calpred<-pred()
            paste0("x=",calpred$x,",y=",calpred$y)
        }
    })
    
    
})
