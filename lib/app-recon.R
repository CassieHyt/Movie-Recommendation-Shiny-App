library(shiny)
library(shinydashboard)

setwd("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/lib")

source("rec.R")
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
        textInput("text", "Give us a movie!")
        
      )
    )
    ,
    tabItem(tabName = "widgets",
            verbatimTextOutput("movie")
    )
    
  )
)

server <- function(input , output){

  moviename <- reactive({
    input$text
  })
  
  output$movie <- renderText({
   # input$text
     as.vector(unlist(recon(movie)))
  })
}

shinyApp(ui, server)