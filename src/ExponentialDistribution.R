
#' Pie-sharing algorithm
#'
#' @param N the number of partitions of unity 
#' 
#' @param M the number of sets of random variables desired
#' 
#' @param randomnumbers (optional) vector of uniform distributed random numbers that
#'  will be used to derived the weights (M x (N-1) random numbers provided to retrieve MxN weights)
#' 
#' @return
#' Returns an array w_ji of random, identically distributed weights of size N x M,
#' where the j index refers to a vector of unique set of N weights which sum to 1 
#' and i=1..N is the weight index in each vector  
#'
#' @author James R. Craig, University of Waterloo
#'         based upon Python code of Juliane Mai, University of Waterloo
#'
#' @examples
#'   # to plot uniform distribution on ternary plot
#'   w<-PieShareDistribution(3,5000)
#'   plot(w[,1],w[,2])
#'   
#' @keywords random weights

N=3
M=10000

yi=rexp(N*M) # sample from exponential distribution (the Gamma distribution with alpha=1)
yi=matrix(yi,nrow=M,ncol=N)
rsum<-rowSums(yi)
w_i=yi*0.0; # empty MxN weights matrix
for (i in 1:M){
    w_i[i,]<-yi[i,]/rsum[i] # normalize samples by sum of y
}
plot(w_i[,1],w_i[,2])

