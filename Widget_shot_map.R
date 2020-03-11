
#Load Necessary packages

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
  mutate(shot_made = ifelse(shot_made_flag > 0, "Scored", "Missed")
  )
kobe$loc_x <- as.numeric(as.character(kobe$loc_x))
kobe$loc_y <- as.numeric(as.character(kobe$loc_y))

court <- knitr::include_graphics("images/nbacourt.jpg")

##########User Interface############

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
                      shiny::HTML("<center><h4>Kobe Bryant was an embodiment of American sports. Picked in 1996 by the Charlotte Hornets at the age of 17, he was the first guard to ever be drafted directly out of high school. The same day he was traded to the Los Angeles Lakers, where he would remain for the next 20 years and become a symbol for Los Angeles and one of the greatest basketball players in the history of the game.")
               ),
               column(2)
             ),
             
             fluidRow(
               column(2),
               column(8,
                      shiny::HTML("<center><h4>This project will explore 25,699 of the 30,699 field goals attempted by Kobe Bryant, from his first scoreless game against the Minnesota Timberwolves to his final 60-point game against the Utah Jazz.<h4><br>In this interactive application, you can find a map of the different types of shots that Kobe against opposing teams, across all of his professional career.")

               ),
               column(2)
             )),
    
#####Top 5 Moments
    tabPanel("Top 5 Moments",
             sidebarLayout(
               sidebarPanel(
                 selectInput(inputId = "select_moment",
                             label = "Select a Moment",
                             choices = list("Kobe to Shaq Alley Oop",
                                            "81 Points",
                                            "No Flinch", 
                                            "Passing Michael Jordan", 
                                            "Final Game")
                 )),
               mainPanel(
                 (tabsetPanel(type = "tab", #create different tabs
                              tabPanel("What Happened",
                                       imageOutput("happen_select")),
                              tabPanel("Watch",
                                       htmlOutput("video_select")), #video embbed
                              tabPanel("Official Game Recap",
                                       uiOutput("recap_select")))
                 )
                 
               )
               
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
                                      plotOutput(outputId = "shot_map_reactive"))
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
                    tableOutput("gamescore_table")))),
                
######References Tab
                tabPanel("References",
                         shiny::HTML("<h5><br>Data was taken from a kaggle competition. Link to the data here: https://www.kaggle.com/c/kobe-bryant-shot-selection/data<br>
                                     blahblah")
                )
                         



))

##########Server###########
server <- function(input, output) {

####Shot Map
  output$shot_map_career <- renderPlot({
    courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
    court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                        width=unit(1,"npc"), height=unit(1,"npc"))
    
    ggplot(data = kobe, aes(x = loc_x, y = loc_y)) +
      annotation_custom(court, -250, 250, -50, 420)+
      geom_point(aes(color = shot_made)) + 
      xlim(-250, 250) +
      ylim(-50, 420) +
      scale_color_manual(name = "Shot Result",
                         breaks = c("Missed", "Scored"),
                         values = c("goldenrod1", "purple3"))+
      theme(axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.background=element_blank(),
            legend.background = element_blank(),
            legend.key = element_blank(),
            legend.title = element_text(size = 15),
            legend.text = element_text(size = 12)
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
      geom_point(aes(color = shot_made), size = 4)  + 
      xlim(-250, 250) +
      ylim(-50, 420) +
      scale_color_manual(name = "Shot Result",
                         breaks = c("Missed", "Scored"),
                         values = c("goldenrod1", "purple3")) +
      theme(axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.background=element_blank(),
            legend.background = element_blank(),
            legend.key = element_blank(),
            legend.title = element_text(size = 15),
            legend.text = element_text(size = 12),
            aspect.ratio = 1) 
     
      
    
  }, height = 800, width = 800)
  

  
  
########Points in a Game########
  
  
kobe2 <- read_csv("kobepoints2.csv")
  sliderValues <- reactive({
    kobe_filter <- kobe2 %>%
      filter(game_score %in% (input$game_score[1]: input$game_score[2])) %>% 
      rename("Game Date"= game_date, "Opponent"= opponent, "Game Score"= game_score)
    
  })
  
  
  #Show the values in an HTML table
  output$gamescore_table <- renderTable({
    sliderValues()
  }
           )
  
########Top 5 Moments

  #######What Happened########
  
  
  
  happened <- reactive({
    
    if(input$select_moment == "Kobe to Shaq Alley Oop"){
      img(src = "kobe to shaq.jpg")}
  })
  
  
  
  
  output$happen_select <- renderImage(
    happened()
  )
  
  
  ########Video Tab#############
  
  video<- reactive({
    
    if(input$select_moment == "Kobe to Shaq Alley Oop"){
      HTML('<iframe width="615" height="420" src="https://www.youtube.com/embed/mUZjfThbmY8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "81 Points"){
      HTML('<iframe width="615" height="420" src="https://www.youtube.com/embed/o9NILK4OXpo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "No Flinch"){
      HTML('<iframe width="615" height="420" src="https://www.youtube.com/watch?v=BUdLLdR8Pow" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "Passing Michael Jordan"){
      HTML('<iframe width="615" height="420" src="https://www.youtube.com/embed/X6Rz0TSprFc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "Final Game"){
      HTML('<iframe width="615" height="420" src="https://www.youtube.com/embed/GTJwoWHMEw0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    
  })
  
  output$video_select <- renderUI(
    video()
  )
  
  
}
  


shinyApp(ui = ui, server = server)
