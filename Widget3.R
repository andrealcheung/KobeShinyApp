# App 3
# Anna 

#Attach necessary packages
library(shiny)
library(tidyverse)
library(dplyr)
library(kableExtra)

#Read in the Kobe Bryant data. 
kobe <- read_csv("kobepoints2.csv")

#Create 'ui' "User Interface
#creates a page that adjusts to the size of the browser window
ui <- fluidPage(
  titlePanel("Total Points Kobe Scored in a Game"), 
  sidebarLayout(#creates sidebar and main panel
    sidebarPanel(sliderInput(inputId = "game_score", 
                             label = h3("Choose Number of Points"), 
                             min = 0, max = 80, 
                             value = c(5, 15))),
    
    mainPanel(#"Kobe Game Table", 
      #textOutput(outputId = "sliderValues"),
      tableOutput("gamescore_table")
    )
  ) 
) 

#create a 'server'
server <- function(input, output) {
  
  
  
  #output$
  sliderValues <- reactive({
    kobe_filter <- kobe %>%
      filter(game_score %in% (input$game_score[1]: input$game_score[2])) #%>% 
    #input$game_score
   # gamescore_table <- 
      #kable(kobe_filter, col.names = c("Game Date", "Opponent", "Kobe's Total Score")) %>%
      #kable_styling(
      #font_size = 15,
     # bootstrap_options = c("striped", "hover", "condensed")
    #)
  })
  
  
  #Show the values in an HTML table
  output$gamescore_table <- renderTable({
    sliderValues()
  })
}

#combine the ui and the server into an app
shinyApp(ui, server)


