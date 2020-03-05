
library(tidyverse)
library(shiny)
library(shinythemes)
library(here)

#reading in the data
kobe <- read_csv(here("data", "data.csv")) %>%
  drop_na() %>%
  mutate(shot_made = ifelse(shot_made_flag  > 0, "scored", "missed")) #This is dropping the na values in the shots_made_flag category

#Defining the ui as a multi-tab app

ui <- navbarPage("Kobe Bryant",
                 tabPanel("First tab"),
                 tabPanel("Second tab",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId = "season_select",
                                          label = "Choose a Season",
                                          choices = unique(kobe$season)),
                              selectInput(inputId = "opponent_select",
                                          label = "Choose an Opponent",
                                          choices = unique(kobe$opponent)),
                              selectInput(inputId = "shot_type_select",
                                          label = "Choose a Shot Type",
                                          choices = unique(kobe$combined_shot_type))
                            ),
                            mainPanel("Shot's Taken",
                                      plotOutput(outputId = "shot_map"))
                          )),
                 tabPanel("Third tab"),
                 tabPanel("Fourth tab"))


# This is defining the server for the shiny app
server <- function(input, output) {
  
  
}

shinyApp(ui = ui, server = server)
