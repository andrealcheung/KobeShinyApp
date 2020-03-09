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
    collapsible = TRUE,
    ###About tab
    tabPanel("About",
             fluidRow(
               column(4),
               column(8,
                      img(src="kobe 3.png",height = 600, width = 365)
               ),
               column(4)
             ),
             
             fluidRow(
               column(3),
               column(6, shiny::HTML("<br><h1><center>Kobe Bryant</h1> <br>"))
             ),
             
             fluidRow(
               column(2),
               column(8,
                      shiny::HTML("<center><h4>Kobe Bryant was an embodiment of American sports. Picked in 1996 by the Chartlotte Hornets at the age of 17, he was the first guard to ever be drafted directly out of high school. The same day he was traded to the Los Angeles Lakers, where he would remain for the next 20 years and become a symbol for Los Angeles and one of the greatest basketball players in the history of the game...")
               ),
               column(2)
             ),
             
             fluidRow(
               column(2),
               column(8,
                      shiny::HTML("<center><h4>This project will explore all 30,699 field goals attempted by Kobe Bryant, from his first scoreless game against the Minnesota Timberwolves to his final 60 points game against the Utah Jazz.<h4><br>")
               ),
               column(2)
             )),
    
    
    ######Shot Expoloring Tab
                tabPanel("Shot Explorer", 
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
                            mainPanel("Explore all of Kobe's shots he ever attempted.",
                                      plotOutput(outputId = "shot_map_career"),
                                      plotOutput(outputId = "shot_map_reactive", height = "100%"))
                            )),
  ######Total Points in a Game Tab
                tabPanel("Total Points Scored in a Game", 
                sidebarLayout(#creates sidebar and main panel
                  sidebarPanel(sliderInput(inputId = "game_score", 
                                           label = h3("Choose Number of Points"), 
                                           min = 0, max = 80, 
                                           value = c(5, 15))),
                  
                  mainPanel(#"Kobe Game Table", 
                    #textOutput(outputId = "sliderValues"),
                    tableOutput("gamescore_table"))))
                  
    
                 
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
    
  
    
  }, height = 400, width = 400 )
  
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
  

  
  
########Points in a Game########
  

#output$
  
kobe2 <- read_csv("kobepoints2.csv")
  sliderValues <- reactive({
    kobe_filter <- kobe2 %>%
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
  


shinyApp(ui = ui, server = server)
