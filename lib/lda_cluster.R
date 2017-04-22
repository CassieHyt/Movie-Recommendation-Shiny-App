load("../output/user_movie_mat.RData")
library(tm)
library(topicmodels)


wordcorpus <- Corpus(VectorSource(user_movie_mat))
dtm <- DocumentTermMatrix(wordcorpus,  
                          control = list(  
                            wordLengths=c(2, Inf),               
                            bounds = list(global = c(5,Inf)),     
                            removeNumbers = TRUE,               
                            weighting = weightTf,                
                            encoding = "UTF-8"))
lda <- LDA(dtm, k = 3, control = list(seed = 1234))
