


load("../data/V.RData")
load("../data/movies1.RData")
recon <- function(movie_name_given){
  moviedf <- as.data.frame(movies1, stringsAsFactors = FALSE)
  movie_id_row = filter(moviedf, movie_name == movie_name_given)
  movie_id_given = movie_id_row$movie_id
  movie_id_given = as.numeric(movie_id_given) + 1
  distancelist <- list()
  for(i in 1:nrow(V_matrix)){
    distance = (V_matrix[movie_id_given,]-V_matrix[i,])^2
    distance = sum(distance)
    distancelist = append(distancelist, distance)
  }
  distancedf = as.data.frame(distancelist)
  minimum = order(distancedf, decreasing=FALSE)[2:11]
  minimum = minimum - 1
  #print(minimum)
  
  movie_recommended <- moviedf[moviedf$movie_id %in% minimum,]
  movie_recommended <- subset(movie_recommended, select=c("movie_name"))
  return(as.data.frame(movie_recommended))
}

#cat(unlist(recon("Star Wars ")))
