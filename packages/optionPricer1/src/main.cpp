#include <Rcpp.h>
#include "runSimpleMonteCarlo1.h"

using namespace Rcpp;
using namespace std;

// [[Rcpp::export]]
double getCallPrice(
    double Expiry = 0.5,
    double Strike = 100,
    double Spot   = 120,
    double Vol    = 0.2,
    double r      = 0.06,
    unsigned long NumberOfPaths = 10000){
  double result = runSimpleMonteCarlo1(Expiry,
                                       Strike,
                                       Spot,
                                       Vol,
                                       r,
                                       NumberOfPaths);

	return result;
}


