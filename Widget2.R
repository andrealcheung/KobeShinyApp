#Attach necessary packages
library(shiny)
library(shinythemes)

####ccs theme######
css <- HTML(" body {
    background-color: #F6BD01; color : 500394
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
                   tabPanel("Watch", HTML('<iframe width="620" height="415" src="https://www.youtube.com/embed/JZGEzREaYRA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')), #video embbed
                   tabPanel("What Happened", textOutput("What Happened")),
                   tabPanel("Official Game Recap", textOutput("recap")))
      ))))



########Server#########
server <- shinyServer(function(input, output){

  
  
  
  
})






shinyApp(ui, server)
