setwd("~/Spr2017-proj5/doc")

ratings<-read.csv("../data/ratings.csv",header=F,col.names=c("user_id","movie_id","rating"))
movies.ori<-read_tsv("../data/movies.txt")[[1]]
movies.ori2<-c("Toy Story (1995)",movies.ori)
time<-substr(movies.ori2,nchar(movies.ori2)-4,nchar(movies.ori2)-1)
movie_name<-substr(movies.ori2,1,nchar(movies.ori2)-6)
movies<-cbind(movie_id=seq(1:length(movies.ori2)),time,movie_name)
dat<-merge(movies,ratings)
#save(dat,file="../output/dat.RData")

user_movie_mat<-t(read.csv("../data/foo.csv",header=F)[,-1])
user_movie_mat<-rbind(user_movie_mat[1:116,],user_movie_mat[118:1682,])
user_movie_mat<-rbind(user_movie_mat[1:182,],user_movie_mat[184:1681,])
user_movie_mat<-rbind(user_movie_mat[1:277,],user_movie_mat[279:1680,])
user_movie_mat<-rbind(user_movie_mat[1:957,],user_movie_mat[959:1679,])
user_movie_mat<-rbind(user_movie_mat[1:1010,],user_movie_mat[1012:1678,])
user_movie_mat<-rbind(user_movie_mat[1:1028,],user_movie_mat[1030:1677,])
user_movie_mat<-rbind(user_movie_mat[1:1314,],user_movie_mat[1319:1676,])
user_movie_mat<-rbind(user_movie_mat[1:1333,],user_movie_mat[1337:1672,]) 
user_movie_mat<-rbind(user_movie_mat[1:1359,],user_movie_mat[1361:1669,])
user_movie_mat<-rbind(user_movie_mat[1:1374,],user_movie_mat[1376:1668,])
user_movie_mat<-rbind(user_movie_mat[1:1382,],user_movie_mat[1384:1667,])
user_movie_mat<-rbind(user_movie_mat[1:1392,],user_movie_mat[1395:1666,])
user_movie_mat<-rbind(user_movie_mat[1:1471,],user_movie_mat[1473:1664,])
user_movie_mat<-user_movie_mat[1:1662,]
save(user_movie_mat,file="../output/user_movie_mat.RData")

result<-kmeans(user_movie_mat, centers=4, iter.max = 10, nstart = 1,trace=FALSE)


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

## need input: movies
genres<-list()
for (i in 1:(nrow(movies)))
{
  genres[[i]]<-get_genres(find_by_title(movies[i,3], year_of_release = movies[i,2]))
}
save(genres,file="../output/genres1662.RData")

genres1<-list()
for (i in 1:length(genres))
{
  index<- genres[[i]] != "Drama" 
  if (length(genres[[i]]) > 1)
  {genres1[[i]]<-genres[[i]][index]}
}

genres2<-list()
for (i in 1:length(genres1))
{
  ifelse(length(genres1[[i]]) == 0,genres2[[i]]<- "other",logic1<-sum(genres1[[i]] == "Comedy")>0)
  if(length(genres2)==i){next}
  ifelse(logic1,genres2[[i]]<- "comedy",logic2<-sum(genres1[[i]] == "Romance")>0)
  if(length(genres2)==i){next}
  ifelse(logic2,genres2[[i]]<- "romance",logic3<-sum(genres1[[i]] == "Thriller" | genres1[[i]] == "Adventure")>0)
  if(length(genres2)==i){next}
  ifelse(logic3,genres2[[i]]<- "thriller & adventure",logic4<-sum(genres1[[i]] == "Action" | genres1[[i]] == "Crime")>0)
  if(length(genres2)==i){next}
  ifelse(logic4,genres2[[i]]<- "action & crime",genres2[[i]]<- "other")
}


movies_cl<-cbind(movies,genres1,class=result$cluster)
#sapply(movies[,c(2,3)],find_by_title, title = movies[,3],year_of_release=movies[,2])


#movies_cl[,4][movies_cl[,5]==1]
round(sort(table(unlist(movies_cl[,4][movies_cl[,5]==1]))/sum(unname(table(unlist(movies_cl[,4][movies_cl[,5]==1])))),decreasing = T),3)
round(sort(table(unlist(movies_cl[,4][movies_cl[,5]==2]))/sum(unname(table(unlist(movies_cl[,4][movies_cl[,5]==2])))),decreasing = T),3)
round(sort(table(unlist(movies_cl[,4][movies_cl[,5]==3]))/sum(unname(table(unlist(movies_cl[,4][movies_cl[,5]==3])))),decreasing = T),3)
round(sort(table(unlist(movies_cl[,4][movies_cl[,5]==4]))/sum(unname(table(unlist(movies_cl[,4][movies_cl[,5]==4])))),decreasing = T),3)


## first : comedy
## second: romance
## third: thriller & adventure 
## fourth: action & crime

label<-rep(NA,1662)
label[movies_cl[,5]==1]<-"comedy"
label[movies_cl[,5]==2]<-"romance"
label[movies_cl[,5]==3]<-"thriller & adventure"
label[movies_cl[,5]==4]<-"action & crime"
label<-unlist(genres2)
movies_label<-cbind(movies,label)
dat2<-merge(movies_label,ratings)
save(dat2,file="../output/dat2.RData")


## prepare the data for word cloud
label<-unlist(genres2)
movies_label<-cbind(movies,label)
dat2<-merge(movies_label,ratings)
dat2.class1<-dat2[dat2$label == "comedy",]
dat2.class2<-dat2[dat2$label == "romance",]
dat2.class3<-dat2[dat2$label == "thriller & adventure",]
dat2.class4<-dat2[dat2$label == "action & crime",]

t11<-table(dat2.class1$movie_name)
t12<-tapply(dat2.class1$rating,dat2.class1$movie_name,mean,na.rm=T)
dat.cloud1<-data.frame(movie_name= names(t11),rated_time<-round(unname(t11),2),ratings=round(100*exp(unname(t12)),2))
dat.cloud1<-na.omit(dat.cloud1[,-2])

t21<-table(dat2.class2$movie_name)
t22<-tapply(dat2.class2$rating,dat2.class2$movie_name,mean,na.rm=T)
dat.cloud2<-data.frame(movie_name= names(t21),rated_time<-round(unname(t21),2),ratings=round(100*exp(unname(t22)),2))
dat.cloud2<-na.omit(dat.cloud2[,-2])

t31<-table(dat2.class3$movie_name)
t32<-tapply(dat2.class3$rating,dat2.class3$movie_name,mean,na.rm=T)
dat.cloud3<-data.frame(movie_name= names(t31),rated_time<-round(unname(t31),2),ratings=round(100*exp(unname(t32)),2))
dat.cloud3<-na.omit(dat.cloud3[,-2])

t41<-table(dat2.class4$movie_name)
t42<-tapply(dat2.class4$rating,dat2.class4$movie_name,mean,na.rm=T)
dat.cloud4<-data.frame(movie_name= names(t41),rated_time<-round(unname(t41),2),ratings=round(100*exp(unname(t42)),2))
dat.cloud4<-na.omit(dat.cloud4[,-2])

data.cloud<-list(dat.cloud1,dat.cloud2,dat.cloud3,dat.cloud4)
save(data.cloud,file="../output/data_cloud.RData")

eWordcloud(dat.cloud[[1]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Comedy",rotationRange = c(-1, 1))
eWordcloud(dat.cloud[[1]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Comedy",rotationRange = c(-1, 1))

eWordcloud(dat.cloud[[2]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Romance",rotationRange = c(-1, 1))
eWordcloud(dat.cloud[[2]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Romance",rotationRange = c(-1, 1))

eWordcloud(dat.cloud[[3]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Thriller & Adventure",rotationRange = c(-1, 1))
eWordcloud(dat.cloud[[3]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Thriller & Adventure",rotationRange = c(-1, 1))

eWordcloud(dat.cloud[[4]], namevar = ~movie_name, datavar = ~Freq,size = c(600, 600),title = "frequently rated movies - Action & Crime",rotationRange = c(-1, 1))
eWordcloud(dat.cloud[[4]], namevar = ~movie_name, datavar = ~ratings,size = c(600, 600),title = "frequently rated movies - Action & Crime",rotationRange = c(-1, 1))
