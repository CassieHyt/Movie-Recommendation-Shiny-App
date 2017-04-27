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
library(readr)
library(omdbapi)
setwd("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/lib")
source("information.R")
source("rec.R")
source("MovieRelation.R")

load("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/output/dat2.RData")
dat <- dat2

load("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/data/label.RData")
load("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/data/MovieRec.RData")
load("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/output/wang_workspace.RData")
load("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/output/data_cloud.RData")
load("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/data/edges.RData")
load("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/data/nodes.RData")
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
                box(title = "Top 22",
                    status = "primary",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    uiOutput("top50")),
                box(title = "Popular but bad movies",
                    status = "success",
                    solidHeader = T,
                    uiOutput("pop_lrated")),
                box(title = "Not popular but great movies",
                    status = "warning",
                    solidHeader = T,
                    uiOutput("nopop_hrated"))
              )##end of fluidRow
      )##end of tabItem
      ,
      tabItem(tabName = "words",
              
              
              fluidPage(
                
                titlePanel("Recommend by Type"),
                
                navlistPanel(
                  
                  tabPanel(" Comedy",   eWordcloud(data.cloud[[1]], 
                                        namevar = ~movie_name, 
                                        datavar = ~Freq,
                                        size = c(600, 600),
                                        title = "frequently rated movies - Comedy",
                                        rotationRange = c(0, 0))
                           ),
                  tabPanel("Romance",   eWordcloud(data.cloud[[2]], 
                                                  namevar = ~movie_name, 
                                                  datavar = ~Freq,
                                                  size = c(600, 600),
                                                  title = "frequently rated movies - Romance",
                                                  rotationRange = c(0, 0)) ),
                  tabPanel("Thriller & Adventure",eWordcloud(data.cloud[[3]], 
                                              namevar = ~movie_name, 
                                              datavar = ~Freq,
                                              size = c(600, 600),
                                              title = "frequently rated movies - Thriller & Adventure",
                                              rotationRange = c(0, 0)) ),
                  tabPanel("Action & Crime",eWordcloud(data.cloud[[4]], 
                                              namevar = ~movie_name, 
                                              datavar = ~Freq,
                                              size = c(600, 600),
                                              title = "frequently rated movies - Action & Crime",
                                              rotationRange = c(0, 0)) )
                )
              )
     
      )
      
      
      
      
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
                
                box(title="NetWork",plotOutput("MovieNetwork")),
                
                box(title="Movie Actors Relation",
                    plotOutput("movie.actor"))
                
              )
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
  
  output$top50 <- renderUI({ 
    lapply(top50_df$top50[1:22], function(j){
      br(a(top50_df$top50[j], href = top50_df$imbdLink[top50_df$top50 == j], target = "_blank"))
    })
  })##end of renderUI
  
  output$pop_lrated <- renderUI({
    lapply(pop_lrated$x[1:10], function(m){
      br(a(pop_lrated$x[m], href = pop_lrated$link[pop_lrated$x == m], target = "_blank"))
    })
  })
  output$nopop_hrated <- renderUI({
    lapply(nopop_hrated$x[1:10], function(n){
      br(a(nopop_hrated$x[n], href = nopop_hrated$link[nopop_hrated$x == n], target = "_blank"))
    })
  })
  
  
  
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
    Movie.index<-grep(substr(moviename(),start = 1,stop=(nchar(moviename())-1)),label)
    Rele.Movie.index<-MovieRec[Movie.index,]
    
    Movie.Net<-c(Movie.index,Rele.Movie.index)
    Rele.Movie.index<-MovieRec[Movie.Net,]
    Rele.Movie.index<-unique(as.vector(Rele.Movie.index))
    
    
    suppressPackageStartupMessages(library(threejs, quietly=TRUE))
    nodes.rec<-nodes[Rele.Movie.index,]
    num<-paste("^",Movie.Net,"$",sep="")
    ind<-sapply(num,grep,edges$from)
    ind<-unique(as.vector(ind))
    edges.rec<-edges[ind,]
    
    graphjs(edges.rec,nodes.rec)
  })
  
  output$movie.actor<-renderPlot({
    chordDiagram(data.movie.actor, transparency = 0.5)
  })
  
}

shinyApp(ui, server)
