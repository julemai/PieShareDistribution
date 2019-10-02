
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
PieShareDistribution<-function(N,M=1,randomnumbers=NA)
{

  if (is.na(randomnumbers)){
    rr<-runif((N-1)*M,0,1);
  } else {
    if (prod(dim(randomnumbers)) != M*(N-1)){
      print("PieShareDistribution: invalid number of terms in randomnumbers argument")
      return (NA)
    }
    else if ((max(randomnumbers)>1) || (min(randomnumbers)<0)){
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
    if      (i==1){ss<-0     }
    else if (i==2){ss<-ww[,1]} # accounts for inability of rowSums to handle 0 or 1 row
    else{
      ss<-rowSums(ww[,1:i-1]);
    }

    ww[,i]<-( 1.0 - ss ) *( 1.0 - (1.0 - rr[,i])^(1.0/(N-i)) )
  
  }
  ww[,N] = 1.0-rowSums(ww[,1:N-1]);

  return (ww)
}

