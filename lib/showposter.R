
setwd("C:\\Users\\yftang\\Documents\\GitHub\\Spr2017-proj5-grp10\\output")
load("dat.Rdata")

devtools::install_github("hrbrmstr/omdbapi",force=TRUE)
library(dplyr)
library(pbapply)
library(omdbapi)
library(RCurl)
library(jpeg)
library(graphics)

G<-find_by_title("GoldenEye")

showposter<-function(moviename){
  ## Input: movie name
  ## Output: movie Poster
  poster<-find_by_title(moviename)$Poster[1]
  poster.url<-getURLContent(poster)
  a<-readJPEG(poster.url)
  p.plot<-plot(c(0,1),c(0,1),type="n",xlab="",ylab="",axes=FALSE)
  poster<-rasterImage(a,0,0,1,1)
  return(print(poster))
}

m.name<-c("GoldenEye")

showposter(m.name)