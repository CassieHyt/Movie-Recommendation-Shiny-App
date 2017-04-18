library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Movie Recommend"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Recommend by Movie Name", tabName = "MovieSearch", icon = icon("film")),
      menuItem("Recommend by Type", icon = icon("th"), tabName = "widgets"))
  ),
  dashboardBody(
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                      label = "Search for Movie Name...")
  )
  
)

server <- function(input, output) { }

shinyApp(ui, server)