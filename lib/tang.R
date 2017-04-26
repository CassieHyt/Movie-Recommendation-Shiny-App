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
# Data<-list()
# Data$romance<-data.frame(movie_name = data.cloud[[1]]$movie_name,Freq = data.cloud[[1]]$Freq, ratings=data.cloud[[1]]$ratings)
# Data$adventure<-data.frame(movie_name = data.cloud[[2]]$movie_name,Freq = data.cloud[[2]]$Freq, ratings=data.cloud[[2]]$ratings)
# Data$thrill<-data.frame(movie_name = data.cloud[[3]]$movie_name,Freq = data.cloud[[3]]$Freq, ratings=data.cloud[[3]]$ratings)
# Data$whatever<-data.frame(movie_name = data.cloud[[4]]$movie_name,Freq = data.cloud[[4]]$Freq, ratings=data.cloud[[4]]$ratings)



ui <- dashboardPage(
  dashboardHeader(title = "Movie Recommend"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Recommend by Movie Name", tabName = "MovieSearch", icon = icon("film")),
      menuItem("Recommend by Type", icon = icon("th"), tabName = "widgets"))
  ),
  dashboardBody(
    fluidRow(
      
        plotOutput("wordcloud1")
        
       # plotOutput("wordcloud2")
      )
        # eWordcloud(data.cloud[[2]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Romance",rotationRange = c(1, 1)),
        # eWordcloud(data.cloud[[2]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Romance",rotationRange = c(1, 1)),
        #
        # eWordcloud(data.cloud[[3]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Thriller & Adventure",rotationRange = c(1, 1)),
        # eWordcloud(data.cloud[[3]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Thriller & Adventure",rotationRange = c(1, 1)),
        #
        # eWordcloud(data.cloud[[4]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Action & Crime",rotationRange = c(1, 1)),
        # eWordcloud(data.cloud[[4]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Action & Crime",rotationRange = c(1, 1))

       

      # box(title = "test",
      #     verbatimTextOutput("test")),
      # 
      # box(title = "word clouds",
      #     plotOutput("wordclouds"))
    
  )
 )



server <- function(input, output){
  output$wordcloud1<-renderPlot({
    eWordcloud(data.cloud[[1]], 
                         namevar = ~movie_name, 
                         datavar = ~Freq,
                         size = c(600, 600),
                         title = "frequently rated movies - Comedy",
                         rotationRange = c(1, 1))
    })
  
  output$wordcloud2<-renderPlot({
    eWordcloud(data.cloud[[1]], 
               namevar = ~movie_name, 
               datavar = ~ratings,
               size = c(600, 600),
               title = "frequently rated movies - Comedy",
               rotationRange = c(1, 1))
  })
 
}

shinyApp(ui, server)