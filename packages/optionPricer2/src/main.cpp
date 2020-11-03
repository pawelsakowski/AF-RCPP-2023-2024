#include<Rcpp.h>
#include<vector>
#include<ctime>
#include<cstdlib>
#include"AsianOption.h"
#include"getVecMean.h"
#include"getVecStdDev.h"

using namespace Rcpp;
using std::vector;

// [[Rcpp::export]]
double getArithmeticAsianCallPrice(
  int nInt,
  double Strike,
  double Spot,
  double Vol,
  double Rfr,
  double Expiry,
  int nReps = 1000){

	// set the seed
	srand( time(NULL) );

	// create a new instance of a class
	AsianOption myAsian(nInt, Strike, Spot, Vol, Rfr, Expiry);

	// call the method to get option price
	double price = myAsian.getArithmeticAsianCallPrice(nReps);
	
	// return option price  
	return price;
}
