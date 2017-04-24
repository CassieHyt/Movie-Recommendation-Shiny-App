if (!require("readr")) install.packages("readr")
if (!require("dplyr")) install.packages("dplyr")
if (!require("pbapply")) install.packages("pbapply")
if (!require("lda")) install.packages("lda")
devtools::install_github("hrbrmstr/omdbapi")
require(devtools)
devtools::install_github("taiyun/recharts")
library(dplyr)
library(pbapply)
library(readr)
library(omdbapi)
library(lda)
library(shiny)
library(shinydashboard)
library(recharts)
setwd("~/Documents/ADS/Spr2017-proj5-grp10/doc")
load("../output/data_cloud.RData")

ui <- dashboardPage(
  dashboardHeader(title = "Movie Recommend"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Recommend by Movie Name", tabName = "MovieSearch", icon = icon("film")),
      menuItem("Recommend by Type", icon = icon("th"), tabName = "widgets"))
  ),
  dashboardBody(
    #sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
    #                  label = "Search for Movie Name...")
    
    eWordcloud(data.cloud[[1]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Comedy",rotationRange = c(-1, 1)),
    eWordcloud(data.cloud[[1]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Comedy",rotationRange = c(-1, 1))
    
    #eWordcloud(data.cloud[[2]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Romance",rotationRange = c(-1, 1))
    #eWordcloud(data.cloud[[2]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Romance",rotationRange = c(-1, 1))
    
    #eWordcloud(data.cloud[[3]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Thriller & Adventure",rotationRange = c(-1, 1))
    #eWordcloud(data.cloud[[3]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Thriller & Adventure",rotationRange = c(-1, 1))
    
    #eWordcloud(data.cloud[[4]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Action & Crime",rotationRange = c(-1, 1))
    #eWordcloud(data.cloud[[4]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Action & Crime",rotationRange = c(-1, 1))
  )
  
)

server <- function(input, output) {
  
  
  
  
}

shinyApp(ui, server)