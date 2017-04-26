library(shiny)
library(shinydashboard)
library(omdbapi)
library(dplyr)
library(rvest)
library(RCurl)
library(jpeg)
library(shinyBS)
library(readr)
load("../output/dat2.RData")
dat <- dat2
load("../output/top50_df.RData")
load("../output/wang.RData")
load("../data/MovieRec.Rdata")

label<-read_table("../data/Movie rating/movies.txt",col_names = FALSE)
label<-unlist(label)

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
       tabItem(tabName = "top",
               fluidRow(
                 box(width = NULL,
                     title = "Top 8 Movies",
                     status = "danger",
                     collapsible = TRUE,
                     solidHeader = FALSE,
                     background = "black",
                     uiOutput("tiles")),
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
                     status = "warning",
                     solidHeader = T,
                     verbatimTextOutput("nopop_hrated"))
               )##end of fluidRow
       )##end of tabItem
       ,
       tabItem(tabName = "words",h2("Mercury's")),
       tabItem(tabName = "MovieSearch", 
               fluidRow(
               sidebarSearchForm(textId = "searchText", 
                                 buttonId = "searchButton",
                                 label = "Star War"),
               plotOutput("MovirNetwork"))
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
  
  output$MovieNetwork<-renderPlot({
    Movie.index<-grep(input$searchText,label)
    Rele.Movie.index<-MovieRec[Movie.index,]
    
    Movie.Net<-c(Movie.index,Rele.Movie.index)
    Rele.Movie.index<-MovieRec[Movie.Net,]
    Rele.Movie.index<-unique(as.vector(Rele.Movie.index))
    
    
    suppressPackageStartupMessages(library(threejs, quietly=TRUE))
    nodes.rec<-nodes[Rele.Movie.index,]
    num<-paste("^",Movie.Net,"$",sep="")
    ind<-sapply(num,grep,from)
    ind<-unique(as.vector(ind))
    edges.rec<-edges[ind,]
    
    
    suppressPackageStartupMessages(library(threejs, quietly=TRUE))
    nodes.rec<-nodes[c(Movie.index,Rele.Movie.index),]
    num<-paste("^",Movie.index,"$",sep="")
    edges.rec<-edges[grep(num,from),]
    
    graphjs(edges.rec,nodes.rec)
  })
  
  
  }

shinyApp(ui, server)