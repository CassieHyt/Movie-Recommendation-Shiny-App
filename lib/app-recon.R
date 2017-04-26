library(shiny)
library(shinydashboard)

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
        textInput("text", "Give us a movie!", "star war "),
        actionButton("search", "Search movie")
      )
    )
    ,
    tabItem(tabName = "widgets",
            tableOutput("movie")
    )
    
  )
)

server <- function(input, output){
  
  
  
  moviename <- reactive({
    input$text
  })
  output$movie <- renderText({
    recon(moviename())
  })
}

shinyApp(ui, server)