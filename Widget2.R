#Attach necessary packages
library(shiny)
library(shinythemes)



ui <- fluidRow(
  navbarPage(
    theme =shinytheme("journal"),
    title=div(img(src="logo.png",height = 20, width = 35), "Kobe Bryant"), 
    collapsible = TRUE,
    tabPanel("Top 5 Moments",
             sidebarLayout(
               sidebarPanel(
                 selectInput(inputId = "select_moment",
                             label = "Select a Moment",
                             choices = list("Kobe to Shaq Alley Oop" = 1,
                                            "81 Points" = 2,
                                            "No Flinch" = 3, 
                                            "Passing Michael Jordan" = 4, 
                                            "Final Game" = 5)
                 )),
               mainPanel(
                 (tabsetPanel(type = "tab", #create different tabs
                                      tabPanel("What Happened",
                                               htmlOutput("recap_select")),
                                      tabPanel("Watch",
                                               htmlOutput("video_select")), #video embbed
                                      tabPanel("Official Game Recap"))
                 )
                 
               )
               
             ))
    ))



########Server#########
server <- shinyServer(function(input, output){


video<- reactive({
  
  if(input$select_moment == 1){
     HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/mUZjfThbmY8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
  
  else if (input$select_moment == 2){
    HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/o9NILK4OXpo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
  
  else if (input$select_moment == 3){
    HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/aYLR4BcX7Rg" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
  
  else if (input$select_moment == 4){
    HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/X6Rz0TSprFc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
  
  else if (input$select_moment == 5){
    HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/GTJwoWHMEw0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')}
  

})

output$video_select <- renderUI(
  video
)


recap <- reactive({
  
  if(input$select_moment == 2){
    HTML('blah blah blah')}
  
  
})


output$recap_select <- renderUI(
  recap
)

  
  
})






shinyApp(ui, server)
