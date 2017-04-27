<<<<<<< HEAD
if (!require("readr")) install.packages("readr")
if (!require("dplyr")) install.packages("dplyr")
if (!require("pbapply")) install.packages("pbapply")
if (!require("lda")) install.packages("lda")
#devtools::install_github("hrbrmstr/omdbapi")
require(devtools)
#devtools::install_github("taiyun/recharts")
library(dplyr)
library(pbapply)
library(readr)
library(omdbapi)
library(lda)
library(shiny)
library(shinydashboard)
library(recharts)
setwd("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/doc")
load("../output/data_cloud.RData")
Data<-data.frame(movie_name = data.cloud[[1]]$movie_name,Freq = data.cloud[[1]]$Freq, ratings=data.cloud[[1]]$ratings)


method<-c("Freq","ratings")
#cluster<-c("cluster1","cluster2","cluster3","cluster4")
cluster<-c("romance","adventure","thrill","whatever")


ui <- dashboardPage(
  dashboardHeader(title = "Movie Recommend"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Recommend by Movie Name", tabName = "MovieSearch", icon = icon("film")),
      menuItem("Recommend by Type", icon = icon("th"), tabName = "widgets"))
  ),
  dashboardBody(
    fluidRow(
      box(
        title = "Selection",
        selectInput("method", "method:", choices = method),
        selectInput("cluster", "cluster:", choices = cluster)
        
       ),

      
      box(title = "word clouds",
          plotOutput("wordclouds"))
    
  )
 )
)


server <- function(input, output){
  
  clusterchoice<-reactive({
    input$cluster
  })
  
  methodchoice<-reactive({
    input$method
  })
  
 
  # selectdata<-reactive({
  #   list(cluster1=data.frame(movie_name = data.cloud[[1]]$movie_name,
  #        Freq = data.cloud[[1]]$Freq,
  #        ratings =  data.cloud[[1]]$ratings
  #   ),
  #   cluster2=data.frame(movie_name = data.cloud[[2]]$movie_name,
  #              Freq = data.cloud[[2]]$Freq,
  #              ratings =  data.cloud[[2]]$ratings
  #   ),
  #   cluster3= data.frame(movie_name = data.cloud[[3]]$movie_name,
  #              Freq = data.cloud[[3]]$Freq,
  #              ratings =  data.cloud[[3]]$ratings
  #   ),
  #   cluster4= data.frame(movie_name = data.cloud[[4]]$movie_name,
  #              Freq = data.cloud[[4]]$Freq,
  #              ratings =  data.cloud[[4]]$ratings
  #   ))
  #        
  # })
  
 selectdata<-reactive({
     # list(movie_name=Data[[as.numeric(input$cluster)]]$movie_name,
     #      Freq= Data[[as.numeric(input$cluster)]]$Freq,
     #      ratings=Data[[as.numeric(input$cluster)]]$ratings)
   input$Data
   
 })
 
 
  output$wordclouds<-renderPlot({
    # eWordcloud(data.cloud[cluster()], namevar = ~movie_name(), datavar = ~method(),size = c(600, 600),title = "whatever ",rotationRange = c(-1, 1))
    eWordcloud(selectdata(), namevar = ~selectdata()$movie_name, datavar = ~selectdata()$Freq,size = c(600, 600),title = "whatever ",rotationRange = c(-1, 1))
    
    })  
  
}

=======
if (!require("readr")) install.packages("readr")
if (!require("dplyr")) install.packages("dplyr")
if (!require("pbapply")) install.packages("pbapply")
if (!require("lda")) install.packages("lda")
#devtools::install_github("hrbrmstr/omdbapi")
require(devtools)
#devtools::install_github("taiyun/recharts")
library(dplyr)
library(pbapply)
library(readr)
library(omdbapi)
library(lda)
library(shiny)
library(shinydashboard)
library(recharts)


load("../output/data_cloud.RData")

ui <- dashboardPage(
  dashboardHeader(title = "Movie Recommend"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Recommend by Movie Name", tabName = "MovieSearch", icon = icon("film")),
      menuItem("Recommend by Type", icon = icon("th"), tabName = "widgets"))
  ),
  dashboardBody(
    fluidRow(
      
      eWordcloud(data.cloud[[1]], 
                 namevar = ~movie_name, 
                 datavar = ~Freq,
                 size = c(600, 600),
                 title = "frequently rated movies - Comedy",
                 rotationRange = c(0, 0)),
      
        eWordcloud(data.cloud[[2]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Romance",rotationRange = c(0, 0)),
       

        eWordcloud(data.cloud[[3]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Thriller & Adventure",rotationRange = c(0, 0)),
       

        eWordcloud(data.cloud[[4]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Action & Crime",rotationRange = c(0, 0))
        
      
   )
  )
 )

server <- function(input, output){
  
}

>>>>>>> master
shinyApp(ui, server)