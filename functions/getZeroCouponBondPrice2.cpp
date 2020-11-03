#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double getZeroCouponBondPrice2(
    int n,
    double ytm, 
    double f){
  double price = 0;
  price += f/pow(1+ytm, double(n)) ;
  return price;
}