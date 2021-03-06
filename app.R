
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
  mutate(shot_made = ifelse(shot_made_flag > 0, "Scored", "Missed")) 
         
kobe3 <- read_csv("data.csv") %>%
  drop_na() %>%           
  group_by(shot_zone_range, season, opponent, combined_shot_type, loc_x, loc_y, shot_made_flag) %>%
  summarize(Accuracy=mean(shot_made_flag))



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
                      shiny::HTML("<center><h3>Kobe Bryant was an embodiment of American sports. Picked in 1996 by the Charlotte Hornets at the age of 17, he was the first guard to ever be drafted directly out of high school. The same day he was traded to the Los Angeles Lakers, where he would remain for the next 20 years and become a symbol for Los Angeles and one of the greatest basketball players in the history of the game.")
               ),
               column(2)
             ),
             
             fluidRow(
               column(2),
               column(8,
                      shiny::HTML("<center><h3>This project will explore 25,699 of the 30,699 field goals attempted by Kobe Bryant, from his first scoreless game against the Minnesota Timberwolves to his final 60-point game against the Utah Jazz. You can find a map of the different types of shots that Kobe against opposing teams, across all of his professional career, and table shows the dates, opponents and total points that Kobe scored for each game within the selected range.")

               ),
               
               
             )),
  
    
######Shot Expoloring Tab
                tabPanel("Shot Explorer", 
                         shiny::HTML("<h5>"),
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
                            mainPanel("Explore this visualization on 25,699 of the 30,699 of Kobe's shots he ever attempted.",
                                      plotOutput(outputId = "shot_map_career", inline = TRUE),
                                      plotOutput(outputId = "shot_map_reactive", inline = TRUE))
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

#####Top 5 Moments
tabPanel("Top 5 Moments",
         shiny::HTML("<h5>"),
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
           mainPanel("Kobe had a lot of legendary moments, but check his top 5",
                     br(),
                     (tabsetPanel(type = "tab", #create different tabs
                                  tabPanel("Watch",
                                           br(),
                                           htmlOutput("video_select")), #video embbed
                                  tabPanel("Official Game Recap",
                                           htmlOutput("recap_select")))
                     )
                     
           )
           
         )),
######Accurary Expoloring Tab
tabPanel("Accuracy", 
         shiny::HTML("<h5>"),
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
           mainPanel("Explore this visualization of Kobe's accuracy based on shot zone range",
                     plotOutput(outputId = "accuracy_reactive"))
         )),


                
######References Tab
                tabPanel("References",
                         shiny::HTML("<h5><br>Data was taken from a kaggle competition. Link to the data here: https://www.kaggle.com/c/kobe-bryant-shot-selection/data<br>
                                     ")
                )
                         



))





##########Server###########
server <- function(input, output) {

  
accuracy <- reactive({
  kobe3 %>%
      filter(season %in% (input$season_select)) %>%
      filter(opponent %in% (input$opponent_select)) %>%
      filter(combined_shot_type %in% (input$shot_type_select))
      
  })

# Accuracy by shot zone range
  
  output$accuracy_reactive <- renderPlot({
    courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
    court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                        width=unit(1,"npc"), height=unit(1,"npc"))
    
    ggplot(data = accuracy(), aes(x = loc_x, y = loc_y,as.factor(color = Accuracy))) +
      annotation_custom(court, -250, 250, -50, 420)+
      geom_point() + 
      xlim(-250, 250) +
      ylim(-50, 420) +
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
  
  
  
  ########Video Tab#############
  
  video<- reactive({
    
    if(input$select_moment == "Kobe to Shaq Alley Oop"){
      HTML('<iframe width="680" height="470" src="https://www.youtube.com/embed/mUZjfThbmY8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "81 Points"){
      HTML('<iframe width="680" height="470" src="https://www.youtube.com/embed/o9NILK4OXpo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "No Flinch"){
      HTML('<iframe width="680" height="470" src="https://www.youtube.com/embed/BUdLLdR8Pow" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "Passing Michael Jordan"){
      HTML('<iframe width="680" height="470" src="https://www.youtube.com/embed/c8oDdHjekNY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "Final Game"){
      HTML('<iframe width="680" height="470" src="https://www.youtube.com/embed/GTJwoWHMEw0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    
  })
  
  output$video_select <- renderUI(
    video()
  )
  
  
#########Recap########
  

  recap<- reactive({
    
    if(input$select_moment == "Kobe to Shaq Alley Oop"){
        HTML('<iframe width="680" height="470" src="https://www.basketball-reference.com/boxscores/200006040LAL.html/"></iframe>')
      }
    
    
    else if (input$select_moment == "81 Points"){
      HTML('<iframe width="680" height="470" src="" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "No Flinch"){
      HTML('<iframe width="680" height="470" src="" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "Passing Michael Jordan"){
      HTML('<iframe width="680" height="470" src="" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    else if (input$select_moment == "Final Game"){
      HTML('<iframe width="680" height="470" src="0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
    
    
  })
  
output$recap_select <- renderUI(
    recap()  
)
  
  
  
  
  
  
  
}
  


shinyApp(ui = ui, server = server)
