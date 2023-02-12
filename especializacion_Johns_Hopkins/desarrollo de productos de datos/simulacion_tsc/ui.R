#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Coordinate descent"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("iter",
                        "Numero de iteraciones:",
                        min = 1,
                        max = 100,
                        value = 2),
            numericInput("box1",  withMathJax(helpText("$$X_0$$")), value = -1.5),
            numericInput("box2", withMathJax(helpText("$$Y_0$$")), value = -1.5),
            numericInput("box3", withMathJax(helpText("$$\\alpha$$")), value = 0.01)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(id="tabs",
                        tabPanel("ejemplo 1",br(),plotlyOutput("plot1",width="800px"),br(),
                                 splitLayout(plotlyOutput("plot2")),
                                 br()),
                        tabPanel("ejemplo 2",br(),plotlyOutput("plot3",width="800px"),br(),
                                 splitLayout(plotlyOutput("plot4"))
                                 ,br()))
            
        )
    )
))
