library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Movie Recommend"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Recommend by Movie Name", tabName = "MovieSearch", icon = icon("film")),
      menuItem("Recommend by Type", icon = icon("th"), tabName = "widgets")),
    menuItem("Top Movies", icon = icon("bar-charts"), tabName = "top")
    )
  ,
  dashboardBody(
    

      
        fluidRow(
          box(
          title = "Inputs", solidHeader = TRUE,
          "Box content here", br(), "More box content",
          sliderInput("slider", "Slider input:", 1, 100, 50),
          textInput("text", "Text input:")
        )
      )
        
    ,
      
      tabItem(tabName = "widgets",
              h2("Widgets tab content")
      )
    
  )
)
  

server <- function(input, output) { }

shinyApp(ui, server)