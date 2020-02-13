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
  drop_na() %>%
  mutate(shot_made = ifelse(shot_made_flag  > 0, "scored", "missed")) #This is dropping the na values in the shots_made_flag category

# Define UI for application 
ui <- fluidPage(
  
  # Choosing a theme for the shiny app
   theme = shinytheme("united"),
   
   # Application title
   titlePanel("Kobe Bryant"),
   
   # Sidebar with a Select Input 
   sidebarLayout(
      sidebarPanel(
         selectInput(inputId = "shot_type_select",
                     label = "Choose an shot type:",
                     choices = unique(kobe$combined_shot_type)
           
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
      filter == input$shot_type_select
  })
  
  #This is going to be the output that will render a plot of where kobe took shots from and on the court
  output$shot_map <- renderPlot({
    ggplot(shots_taken(),
           aes(x = lon, y = lat)) +
      geom_point(aes(color = shot_made))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

