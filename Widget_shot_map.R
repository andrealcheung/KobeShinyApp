#Widget Shot Map
#Robert Saldivar

#The relavent code can be copy and pasted into the shiny app.


library(tidyverse)
library(shiny)
library(shinythemes)
library(here)
library(grid)
library(jpeg)
library(RCurl)


#Reading in the data, this is going to be commented out at first
kobe <- read_csv("data.csv") %>%
  drop_na() %>%
  mutate(shot_made = ifelse(shot_made_flag > 0, "scored", "missed")
  )
kobe$loc_x <- as.numeric(as.character(kobe$loc_x))
kobe$loc_y <- as.numeric(as.character(kobe$loc_y))

court <- knitr::include_graphics("images/nbacourt.jpg")

#Defining the ui as a multi-tab app

ui <- fluidRow(
  navbarPage(
    theme =shinytheme("journal"),
    title=div(img(src="logo.png",height = 20, width = 35), "Kobe Bryant"),
    fluid = TRUE, 
    collapsible = TRUE,
                tabPanel("About",
                         column(6, img(src="kobe 3.png",height = 800, width = 525))
                      
                         
                         
                         ),
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
                                      plotOutput(outputId = "shot_map_career"),
                                      plotOutput(outputId = "shot_map_reactive", height = "100%")
                          )),
                 tabPanel("Third tab"),
                 tabPanel("Fourth tab"))
  ))


# This is defining the server for the shiny app
server <- function(input, output) {
  
  output$shot_map_career <- renderPlot({
    courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
    court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                        width=unit(1,"npc"), height=unit(1,"npc"))
    
    ggplot(data = kobe, aes(x = loc_x, y = loc_y)) +
      annotation_custom(court, -250, 250, -50, 420)+
      geom_point(aes(color = shot_made)) + 
      xlim(-250, 250) +
      ylim(-50, 420) +
      scale_color_manual(breaks = c("missed", "scored"),
                         values = c("goldenrod1", "purple3"))+
      theme(axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.background=element_blank()
            ) 
    
  
    
  }, height = 800, width = 800 )
  
  shots_taken <- reactive({
    kobe_filter <- kobe %>%
      filter(season %in% (input$season_select)) %>%
      filter(opponent %in% (input$opponent_select)) %>%
      filter(combined_shot_type %in% (input$shot_type_select))
    
    kobe_filter   
  })
  
  output$shot_map_reactive <- renderPlot({
    courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
    court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                        width=unit(1,"npc"), height=unit(1,"npc"))
    
    ggplot(data = shots_taken(), aes(x = loc_x, y = loc_y)) +
      annotation_custom(court, -250, 250, -50, 420)+
      geom_point(aes(color = shot_made))  + 
      xlim(-250, 250) +
      ylim(-50, 420) +
      scale_color_manual(breaks = c("missed", "scored"),
                         values = c("goldenrod1", "purple3"))+
      theme(axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.background=element_blank(),
            aspect.ratio = 1)
    
  }, height = 600, width = 600)
  

}
  


shinyApp(ui = ui, server = server)
