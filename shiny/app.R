library(shiny)
library(shinydashboard)
library(omdbapi)
library(dplyr)
library(rvest)
library(RCurl)
library(jpeg)
library(shinyBS)
library(pbapply)
library(readr)
library(omdbapi)
library(lda)
library(recharts)

source("/Users/jinruxue/Documents/ADS/Spr2017-proj5-grp10/lib/information.R")
source("/Users/jinruxue/Documents/ADS/Spr2017-proj5-grp10/lib/rec.R")

load("/Users/jinruxue/Documents/ADS/Spr2017-proj5-grp10/output/dat2.RData")
dat <- dat2

#load("/Users/jinruxue/Documents/ADS/Spr2017-proj5-grp10/output/wang.RData")
load("/Users/jinruxue/Documents/ADS/Spr2017-proj5-grp10/output/data_cloud.RData")
load("/Users/jinruxue/Documents/ADS/Spr2017-proj5-grp10/data/edges.RData")
load("/Users/jinruxue/Documents/ADS/Spr2017-proj5-grp10/data/nodes.RData")
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
      tabItem(tabName = "info",h2(info)),
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
      tabItem(tabName = "words",fluidRow(
        
        eWordcloud(data.cloud[[1]], 
                   namevar = ~movie_name, 
                   datavar = ~Freq,
                   size = c(600, 600),
                   title = "frequently rated movies - Comedy",
                   rotationRange = c(0, 0)),
        
        eWordcloud(data.cloud[[2]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Romance",rotationRange = c(0, 0)),
        
        
        eWordcloud(data.cloud[[3]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Thriller & Adventure",rotationRange = c(0, 0)),
        
        
        eWordcloud(data.cloud[[4]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Action & Crime",rotationRange = c(0, 0))
        
        
      ))
      
      
      
      
      ,
      tabItem(tabName = "MovieSearch", 
              fluidRow(
                box(
                  title = "Movie recommendation", solidHeader = TRUE,
                  textInput("text", "Give us a movie!", value ="Star Wars ")
                  
                )
                
                ,
                
                box(title = "Movie We recommended",
                    tableOutput("table")),
                plotOutput("MovieNetwork")
                
              )
      )
    )
    
    
  )
)









server <- function(input, output) { 
  # output$tiles <- renderUI({
  #   fluidRow(
  #     lapply(top50_df$poster[1:8], function(i) {
  #       a(box(width=3,
  #             title = img(src = i, height = 350, width = 250),
  #             footer = top50_df$top50[top50_df$poster == i]
  #       ), href= top50_df$imbdLink[top50_df$poster == i] , target="_blank")
  #     }) ##end of lappy
  #   )
  # })##end of renderUI
  
  # output$top50 <- renderText({top50_s })
  # output$pop_lrated <- renderText({pop_lrated_s})
  # output$nopop_hrated <- renderText({nopop_hrated_s})
  moviename <- reactive({
    input$text
  })
  
  # output$movie <- renderText({
  #    as.vector(unlist(recon(moviename())))
  # })
  
  output$table<-renderTable({
    as.vector(unlist(recon(moviename())))
  })
  
  output$MovieNetwork<-renderPlot({
    Movie.index<-grep(substr(moviename,start = 1,stop=(nchar(moviename)-1)),label)
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
    
    graphjs(edges.rec,nodes.rec)
  })
  
  
  
}

shinyApp(ui, server)
