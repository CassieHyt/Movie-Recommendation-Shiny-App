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
data.cloud<-load("../output/data_cloud.RData")

# eWC.F-NULL
# eWC.R<-NULL
# for(i in 1:4){
#   eWC.F[i] <- eWordcloud(data.cloud[[i]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Comedy",rotationRange = c(1, 1))
#   eWC.R[i] <- eWordcloud(data.cloud[[i]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Comedy",rotationRange = c(-1, 1))
# }

method<-c("Freq","ratings")
cluster<-seq(1,4,1)

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
      box( textOutput("test") ),
      
      
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
  
  output$test<-renderPrint({
    input$cluster
  })
 
  output$wordclouds<-renderPlot({
    # eWordcloud(data.cloud[cluster()], namevar = ~movie_name(), datavar = ~method(),size = c(600, 600),title = "whatever ",rotationRange = c(-1, 1))
    eWordcloud(data.cloud[clusterchoice()], namevar = ~movie_name, datavar = ~methodchoice(),size = c(600, 600),title = "whatever ",rotationRange = c(-1, 1))
    
    })  
  
}

shinyApp(ui, server)