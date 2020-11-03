#include <Rcpp.h>
#include <numeric> // for std::partial_sum

using namespace Rcpp;

// [[Rcpp::export]]
NumericVector getEWMA(NumericVector x, double alpha = 0.05){

  // initialize the result vector
  NumericVector ewma(x.size() + 1);
  
  // first smoothed value equals to first observed value
  ewma[0] = x[0];
  
  // main loop
  for(int i = 1; i < ewma.size(); i++){  
    ewma[i] = alpha * x[i - 1] + (1 - alpha) * ewma[i - 1]; 
    }
   
   return ewma;
  
  }