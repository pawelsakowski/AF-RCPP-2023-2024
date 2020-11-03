#include <Rcpp.h>
#include <numeric> // for std::partial_sum

using namespace Rcpp;

// [[Rcpp::export]]
NumericVector getCumSum(NumericVector x){
  // initialize an accumulator variable
  double acc = 0;
  
  // initialize the result vector
  NumericVector result(x.size());
  
  for(int i = 0; i < x.size(); i++){
    acc += x[i];
    result[i] = acc;
    }
    
    return result;
  }