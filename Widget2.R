#Attach necessary packages
library(shiny)

ui <- fluidPage(
  titlePanel("5 of Kobe's Greatest Moments"),
  sidebarLayout(
    sidebarPanel(
      selectInput("select", "Select A Moment", c("Kobe to Shaq Alley Oop","81 Points","No Flinch", "Passing Michael Jordan", "Final Game")),
    ),
    mainPanel(
      tabsetPanel(type = "tab",
                  tabPanel("What Happened", textOutput("What Happened")),
                  tabPanel("Watch", HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/JZGEzREaYRA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')),
                  tabPanel("Official Game Recap", textOutput("recap"))
                  )
    )))
  
server <- shinyServer(function(input, output){
  output$selectmoment <- renderText(input$select)
  
  output$WhatHappened <- renderText(input$WhatHappened)
  
  output$Watch <- renderText(input$Watch)
  
  output$recap <- renderText(input$recap)
})
  
shinyApp(ui, server)