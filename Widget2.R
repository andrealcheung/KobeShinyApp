#Attach necessary packages
library(shiny)

#######User Interface##########
ui <- fluidPage(
  titlePanel("5 of Kobe's Greatest Moments"),
  sidebarLayout(
    sidebarPanel(
      selectInput("select", "Select A Moment", c("Kobe to Shaq Alley Oop","81 Points","No Flinch", "Passing Michael Jordan", "Final Game")), #choices
    ),
    mainPanel(
      tabsetPanel(type = "tab", #create different tabs
                  tabPanel("Watch", HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/JZGEzREaYRA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')), #video embbed
                  tabPanel("What Happened", textOutput("What Happened")),
                  tabPanel("Official Game Recap", textOutput("recap"))
                  )
    )))
  


########Server#########
server <- shinyServer(function(input, output){
  output$selectmoment <- renderText(input$select)
  
  output$WhatHappened <- renderText(input$WhatHappened)
  
  output$Watch <- renderText(input$Watch)
  
  output$recap <- renderText(input$recap)
})
  
shinyApp(ui, server)