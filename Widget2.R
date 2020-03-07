#Attach necessary packages
library(shiny)
library(shinythemes)

####ccs theme######
css <- HTML(" body {
    background-color: #FDBA21; color : 500394
}")


#######User Interface##########
ui <- fluidPage(
  tags$head(tags$style(css)),
  
  titlePanel("5 of Kobe's Greatest Moments"),
  
  sidebarLayout(
    sidebarPanel(
      #select input for the moment that you to explore
      selectInput("selectmoment", "Select A Moment", c("Kobe to Shaq Alley Oop","81 Points","No Flinch", "Passing Michael Jordan", "Final Game")), #choices
    ),
    
    mainPanel(
      #Kobe to Shaq Alley Oop
      (tabsetPanel(type = "tab", #create different tabs
                   tabPanel("What Happened"),
                   tabPanel("Watch"), #video embbed
                   tabPanel("Official Game Recap", textOutput("recap")))
      ))))



########Server#########
server <- shinyServer(function(input, output){

output$selectmoment <- renderUI()
  
  
  
})






shinyApp(ui, server)
