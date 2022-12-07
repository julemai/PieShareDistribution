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
#' @author Oct 2019 - James R. Craig, University of Waterloo
#'                    based upon Python code of Juliane Mai, University of Waterloo
#'         Dec 2022 - Rezgar Arabzadeh, University of Waterloo
#'                    making adjustments if "randomnumbers" are provided
#'
#'
#' @examples
#'   # to plot uniform distribution on ternary plot
#'   w<-PieShareDistribution(3,5000)
#'   plot(w[,1],w[,2])
#'
#' @keywords random weights
#' @export PieShareDistribution
#' @importFrom stats runif

PieShareDistribution<-function(N,M=1,randomnumbers=NA)
{
    if (any(is.na(randomnumbers)))
    {
	  if(any(!is.na(randomnumbers))) warning("the provided randomnumbers contain missing values: the randomnumbers is disregarded!")
      rr<-runif((N-1)*M,0,1);
    }else{
       if (prod(dim(randomnumbers)) != M*(N-1))
	   {
         print("PieShareDistribution: invalid number of terms in randomnumbers argument")
         return (NA)
       }
       else if ((max(randomnumbers)>1) || (min(randomnumbers)<0))
	   {
         print("PieShareDistribution: random numbers provided need to be uniform distributed between 0 and 1")
         return (NA)
       }
       rr<-randomnumbers;
    }
  dim(rr)<-c(M,N-1); #convert to matrix
  # initialize matrix of weights
  ww<-array(NA,dim=c(M,N));
  ww[,]<-0; #initially zero
  # derive the first (N-1) weights
  for (i in (1:N-1))
  {
    if (i==1){ss<-0     }
    if (i==2){ss<-ww[,1]} # accounts for inability of rowSums to handle 0 or 1 row
    if (i>2) {ss<-rowSums(ww[,1:i-1])}
    ww[,i]<-( 1.0 - ss ) *( 1.0 - (1.0 - rr[,i])^(1.0/(N-i)) )
  }
  ww[,N] = 1.0-rowSums(ww[,1:N-1,drop=FALSE])
  return (ww)
}
