load("../output/user_movie_mat.RData")
H0<-exp(user_movie_mat)
#H0<-user_movie_mat
K=5
tau=0.1
## initialize variables

c_k<-rep(1/K,K)  # length=k
C<-matrix(1/K,1662,K)  #each row is the same (c_k) 40000 * K
b<-matrix(NA,K,944)
t.denom<-matrix(NA,K,944)
#iter<-1
delta<-1000

## initialize centroids

choose.index<-sample(1:1662,K)
t_k<-H0[choose.index,]   # K * 16

while(delta >= tau)
{
  ## iterate:e steps
  Phi <-  H0 %*% t(t_k) 
  for (i in 1:1662)
  {
    #get matrix C with each row is the same (c_k)
    C[i,]<-c_k
  }
  
  ## save last step A
  if (exists("A")){
    A.former<-A}else{
      A.former<-matrix(0,1662,K)}
  A <- C * Phi ###
  A <- A/rowSums(A)  # 40000 * K
  
  ## iterate:m steps
  
  c_k<-apply(A,2,mean,na.rm=T)
  
  a.rep<-matrix(NA,1662,944)
  for (k in 1:K)
  {
    for (i in 1:944)
    {a.rep[,i]<-A[,k]}
    b[k,]<-colSums( a.rep * H0 ,na.rm=T)
    # output b is a matrix of K * 16
  }
  t_k<-b/rowSums(b)
  
  ## compute delta  
  delta<-norm(A-A.former,"O")
  #print(delta)
  print(table(apply(A,1,which.min)))
  if (length(table(apply(A,1,which.min)))<5)
  { m<-apply(A.former,1,which.min)
  break}
  
  
}

### compute m 

table(m)
load("../output/genres1662.RData")

movies_cl<-cbind(movies,genres,m)
#sapply(movies[,c(2,3)],find_by_title, title = movies[,3],year_of_release=movies[,2])


#movies_cl[,4][movies_cl[,5]==1]
table(unlist(movies_cl[,4][movies_cl[,5]==1]))
table(unlist(movies_cl[,4][movies_cl[,5]==2]))
table(unlist(movies_cl[,4][movies_cl[,5]==3]))
table(unlist(movies_cl[,4][movies_cl[,5]==4]))
table(unlist(movies_cl[,4][movies_cl[,5]==5]))