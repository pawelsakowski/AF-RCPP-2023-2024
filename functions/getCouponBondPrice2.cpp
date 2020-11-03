#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double getCouponBondPrice2(
    int n,
    double coupon, 
    int m, 
    double ytm, 
    double f){
  
  double price = 0;
  
  for (int i = 1; i <= (n*m); ++i){
    price += (coupon*f/m)/pow((1+ytm/m), double(i));
  }
  
  price += f/pow(1+ytm/m, double(n*m)) ;
  
  return price;
  
}
