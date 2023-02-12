#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Final proyect"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("grade", "degree of the polynomial", 1, 4, value = 1),
            sliderInput("valx", "value of x", -6, 6, value = 0,step = 0.05),
            checkboxInput("showmod", "show/hide the equation", value = TRUE),
            checkboxInput("showpred", "show/hide the prediction", value = TRUE),
            actionLink("link",a("documentation", href="https://rpubs.com/manuel_al/803618"))
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot", brush = brushOpts(
                id = "brush1")),
            h3("Equation of the model:"),
            textOutput("textmod"),
            h3("Prediction:"),
            textOutput("pred")
        )
    )
))
