library(shiny)
library(shinydashboard)
library(omdbapi)
library(dplyr)
library(rvest)
library(RCurl)
library(jpeg)
library(shinyBS)

ui <- dashboardPage(
  dashboardHeader(title = "Movie Recommend"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About This App",tabName = "info", icon=icon("id-card")),
      menuItem("Top Movie",tabName = "top",icon = icon("thumbs-up")),
      menuItem("Recommend by Type", icon = icon("th"), tabName = "words"),
      menuItem("Recommend by Movie Name", tabName = "MovieSearch", icon = icon("film"))
      
    ))
  ,
  dashboardBody(
     tabItems(
       tabItem(tabName = "info",h2("About this app:...")),
       tabItem(tabName = "top",fluidRow(
         box(title = "Top 1", 
             background = "red",
             status = "danger", 
             width = 3,
             solidHeader = TRUE,
             plotOutput("top1", height = 250)),
         box(title = "Top 2", 
             background = "red",
             status = "danger", 
             width = 3,
             solidHeader = TRUE,
             plotOutput("top2", height = 250)),
         box(title = "Top 3",
             background = "red",
             width = 3,
             status = "danger",
             plotOutput("top3"), height = 250),
         box(title = "Top 4",
             background = "red",
             width = 3,
             status = "danger",
             plotOutput("top4"),height = 250),
         box(title = "Top 50",
             status = "primary",
             solidHeader = TRUE,
             collapsible = TRUE,
             verbatimTextOutput("top50")),
         box(title = "Popular but bad movies",
             status = "success",
             solidHeader = T,
             verbatimTextOutput("pop_lrated")),
         box(title = "Not popular but great movies",
             status = "danger",
             solidHeader = T,
             verbatimTextOutput("nopop_hrated")) )),
       tabItem(tabName = "words",h2("Mercury's")),
       tabItem(tabName = "MovieSearch", 
               fluidRow(
               sidebarSearchForm(textId = "searchText", 
                                 buttonId = "searchButton",
                                 label = "Search the Movie..."))
               )
     )

      
    )
)







  

server <- function(input, output) { 
  output$tiles <- renderUI({
    fluidRow(
      lapply(top50_df$poster[1:8], function(i) {
        a(box(width=3,
              title = img(src = i, height = 350, width = 250),
              footer = top50_df$top50[top50_df$poster == i]
        ), href= top50_df$imbdLink[top50_df$poster == i] , target="_blank")
      }) ##end of lappy
    )
  })##end of renderUI
  
  output$top50 <- renderText({top50_s })
  output$pop_lrated <- renderText({pop_lrated_s})
  output$nopop_hrated <- renderText({nopop_hrated_s})
  
  
  
  }

shinyApp(ui, server)