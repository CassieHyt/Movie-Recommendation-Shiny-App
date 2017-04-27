library(shiny)
library(shinydashboard)

# setwd("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/lib")


ui <- dashboardPage(
  dashboardHeader(title = "Movie Recommend"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Recommend by Movie Name", tabName = "MovieSearch", icon = icon("film")),
      menuItem("Recommend by Type", icon = icon("th"), tabName = "widgets"))
  )
  ,
  dashboardBody(

    fluidRow(
      box(
        title = "Movie recommendation", solidHeader = TRUE,
        textInput("text", "Give us a movie!", value ="Star Wars ")
        
      )
    
    ,
    
    box(title = "Movie We recommended",
        tableOutput("table"))
    
    )
  )
)

server <- function(input , output){

  moviename <- reactive({
    input$text
  })
  
  # output$movie <- renderText({
  #    as.vector(unlist(recon(moviename())))
  # })
  
  output$table<-renderTable({
    as.vector(unlist(recon(moviename())))
  })
}

shinyApp(ui, server)