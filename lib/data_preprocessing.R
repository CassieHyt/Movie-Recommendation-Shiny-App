setwd("~/Spr2017-proj5/doc")

ratings<-read.csv("../data/ratings.csv",header=F,col.names=c("user_id","movie_id","rating"))
movies.ori<-read_tsv("../data/movies.txt")[[1]]
movies.ori2<-c("Toy Story (1995)",movies.ori)
time<-substr(movies.ori2,nchar(movies.ori2)-4,nchar(movies.ori2)-1)
movie_name<-substr(movies.ori2,1,nchar(movies.ori2)-6)
movies<-cbind(movie_id=seq(1:length(movies.ori2)),time,movie_name)
dat<-merge(movies,ratings)
save(dat,file="../output/dat.RData")


movies1<-cbind(movie_id=seq(1:length(movies.ori2)),movie_name)
save(movies1,file="../output/movies1.RData")
