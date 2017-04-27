

setwd("C:/Users/yftang/Documents/GitHub/Spr2017-proj5-grp10/lib")

ratings<-read.csv("../data/ratings.csv",header=F,col.names=c("user_id","movie_id","rating"))
movies.ori<-read_tsv("../data/movies.txt")[[1]]
movies.ori2<-c("Toy Story (1995)",movies.ori)
time<-substr(movies.ori2,nchar(movies.ori2)-4,nchar(movies.ori2)-1)
movie_name<-substr(movies.ori2,1,nchar(movies.ori2)-6)
movies<-cbind(movie_id=seq(1:length(movies.ori2)),time,movie_name)

movies<-rbind(movies[1:116,],movies[118:1682,])
movies<-rbind(movies[1:182,],movies[184:1681,])
movies<-rbind(movies[1:277,],movies[279:1680,])
movies<-rbind(movies[1:957,],movies[959:1679,])
movies<-rbind(movies[1:1010,],movies[1012:1678,])
movies<-rbind(movies[1:1028,],movies[1030:1677,])
movies<-rbind(movies[1:1314,],movies[1319:1676,])
movies<-rbind(movies[1:1333,],movies[1337:1672,]) 
movies<-rbind(movies[1:1359,],movies[1361:1669,])
movies<-rbind(movies[1:1374,],movies[1376:1668,])
movies<-rbind(movies[1:1382,],movies[1384:1667,])
movies<-rbind(movies[1:1392,],movies[1395:1666,])
movies<-rbind(movies[1:1471,],movies[1473:1664,])
movies<-movies[1:1662,]

load("../output/actors1512.RData")
movies1512<-movies[1:1512,]
data.circle<-cbind(movies1512,actors)

### 2000 movies
data.circle.test<-data.circle[400:404,]
n<-length(unlist(data.circle.test[,4]))
mat<-matrix(NA,nrow=n,ncol=2)
#length(unique(unlist(data.circle.test[,4])))
k<-1
for (i in 1:nrow(data.circle.test))
{
  for (j in 1:length(unlist(data.circle.test[i,4])))
  {
    mat[k+j-1,2]<-unlist(data.circle.test[i,4])[j]
    mat[k+j-1,1]<-unlist(data.circle.test[i,3])
  }
  k<-k+length(unlist(data.circle.test[i,4]))
}

#Create data
dat <- data.frame(movie_name=mat[,1],actors=mat[,2])
dat <- with(dat, table(actors,movie_name))
data.movie.actor<-as.data.frame(dat)
# Charge the circlize library
library(circlize)

# Make the circular plot
# chordDiagram(as.data.frame(dat), transparency = 0.5)
