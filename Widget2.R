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
               
             ))
    ))



########Server###### 
server <- shinyServer(function(input, output){

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

})








shinyApp(ui, server)
