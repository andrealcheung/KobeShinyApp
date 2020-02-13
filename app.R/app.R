#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(shinythemes)
library(here)

#reading in the data
kobe <- read_csv(here("data", "data.csv")) %>%
  drop_na() #This is dropping the na values in the shots_made_flag category

# Define UI for application 
ui <- fluidPage(
  
  # Choosing a theme for the shiny app
   theme = shinytheme("united"),
   
   # Application title
   titlePanel("Kobe Bryant"),
   
   # Sidebar with a Select Input 
   sidebarLayout(
      sidebarPanel(
         selectInput(inputId = "opponent_select",
                     label = "Choose an Opponent",
                     choices = unique(kobe$opponent)
           
         )
      ),
      
      # Show a plot of the generated distribution
      mainPanel("Outputs",
         plotOutput(outputId = "shot_map")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #This is going to be the reactive object called shots_taken that will react to who the opponent is 
  shots_taken <- reactive({
    kobe %>%
      filter == input$opponent_select
  })
  
  #This is going to be the output that will render a plot of where kobe took shots from and on the court
  output$shot_map <- renderPlot({
    ggplot(shots_taken(),
           aes(x = loc_x, y = loc_y)) +
      geom_point(aes(color = shot_made_flag))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

