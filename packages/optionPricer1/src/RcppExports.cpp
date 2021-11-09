// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// getCallPrice
double getCallPrice(double Expiry, double Strike, double Spot, double Vol, double r, unsigned long NumberOfPaths);
RcppExport SEXP _optionPricer1_getCallPrice(SEXP ExpirySEXP, SEXP StrikeSEXP, SEXP SpotSEXP, SEXP VolSEXP, SEXP rSEXP, SEXP NumberOfPathsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type Expiry(ExpirySEXP);
    Rcpp::traits::input_parameter< double >::type Strike(StrikeSEXP);
    Rcpp::traits::input_parameter< double >::type Spot(SpotSEXP);
    Rcpp::traits::input_parameter< double >::type Vol(VolSEXP);
    Rcpp::traits::input_parameter< double >::type r(rSEXP);
    Rcpp::traits::input_parameter< unsigned long >::type NumberOfPaths(NumberOfPathsSEXP);
    rcpp_result_gen = Rcpp::wrap(getCallPrice(Expiry, Strike, Spot, Vol, r, NumberOfPaths));
    return rcpp_result_gen;
END_RCPP
}
// rcpp_hello_world
List rcpp_hello_world();
RcppExport SEXP _optionPricer1_rcpp_hello_world() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(rcpp_hello_world());
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_optionPricer1_getCallPrice", (DL_FUNC) &_optionPricer1_getCallPrice, 6},
    {"_optionPricer1_rcpp_hello_world", (DL_FUNC) &_optionPricer1_rcpp_hello_world, 0},
    {NULL, NULL, 0}
};

RcppExport void R_init_optionPricer1(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}