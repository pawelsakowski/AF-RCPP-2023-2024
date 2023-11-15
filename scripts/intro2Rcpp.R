z####################################################################
# APPLIED FINANCE                                                  #
# Path-dependent option pricing with Monte Carlo and Rcpp package  #
# labs01: Introduction to the Rcpp package                         #
# Paweł Sakowski                                                   #
# University of Warsaw                                             #
####################################################################


# loading packages
library(inline) # allows to use C++ inline - within R code
library(Rcpp)   # Rccp package by Dirk Eddelbuettel
library(tidyverse) 
library(xts)
library(dygraphs)

# 1. USING cppFunction() FUNCTION ==============================================
cppFunction("
  double getZeroCouponBondPrice(int n,
                                double ytm, 
                                double f){
    double price = 0;
    price += f/pow(1+ytm, double(n)) ;
	  return price;
  }
")

# call the function
getZeroCouponBondPrice(10, 0.1, 1000)

# build an R function
getZeroCouponBondPrice1 <- function (r) {
  return(getZeroCouponBondPrice(10, r, 1000))
}

ytm <- seq(0.001, 0.1, by = 0.001)
getZeroCouponBondPrice1(0.05)
zeroCouponBondPrices <- sapply(ytm, getZeroCouponBondPrice1)

# a simple plot
plot(ytm, zeroCouponBondPrices)

# same plot using ggplot2 package
tibble(
  ytm    = ytm,
  prices = zeroCouponBondPrices
) %>%
  ggplot(aes(x = ytm, y = zeroCouponBondPrices)) +
  geom_point(col = "red") +
  labs(
    x = "yield to maturity",
    y = "price of zero-coupon bond",
    title = "Zero-coupon bond price vs. yield to maturity",
    caption = "source: own calculations"
    )

  

# EXERCISE 1 ===================================================================

# Write and implement in R a similar function for coupon bonds.
# Build an R function based on that function and 
# give it a name "getBondPrice1', as it will be used in the next steps.

source("solutions/exercise01.R")


# 2. VISUALISATION OF TWO RELATIONSHIPS ========================================
tibble(
  ytm = ytm,
  zeroCouponBondPrices = zeroCouponBondPrices,
  couponBondPrices = couponBondPrices
) %>%
  pivot_longer(cols = !ytm) %>%
  ggplot(aes(ytm, value, col = name)) +
  geom_point() +
  labs(
    x = "yield to maturity",
    y = "price of a bond",
    title = "Bond price vs. yield to maturity",
    caption = "source: own calculations",
    colour = "type of a bond"
  )



# 3. USING sourceCpp() FUNCTION ================================================

# compile c++ functions from external source file using sourceCpp() 
sourceCpp("functions/getZeroCouponBondPrice2.cpp")
sourceCpp("functions/getCouponBondPrice2.cpp")

# call the functions
getZeroCouponBondPrice2(10, 0.06, 1000)
getCouponBondPrice2(10, 0.05, 12, 0.06, 1000)


# 4. MEASURING EFFICIENCY OF MONTE CARLO SIMULATIONS ===========================
# Example: finding approximation of the Pi value

# first, let's make a visualization of the task
N <- 10000
tibble(
  x = runif(N), 
  y = runif(N)
) %>% 
  mutate(d = sqrt(x ^ 2 + y ^ 2),
         d = as_factor(d < 1)) %>%
  ggplot(aes(x, y, col = d)) +
  geom_point(size = 0.5) +
  coord_fixed(ratio = 1) +
  labs(
    x = "",
    y = "",
    title = paste0(N, " points with random cooridnates"),
    subtitle = "x ~ U(0,1), y ~ U(0,1)",
    caption = "source: own calculations", 
    colour = "d < 1"
  ) +
  theme_bw()


# 4a. An R function based on loop
getPiR1 <- function(N) {
  counter = 0;
  for (i in 1:N){
    x <- runif(1)
    y <- runif(1)
    d <- sqrt(x^2 + y^2)
    if (d <= 1)  counter = counter + 1;
  }
  return(4 * counter / N)
}

# 4b. An R function based on vectors
getPiR2 <- function(N) {
  x <- runif(N)
  y <- runif(N)
  d <- sqrt(x ^ 2 + y ^ 2)
  return(4 * sum(d <= 1.0) / N)
}

# 4c. A C++ function based on loop
cppFunction("
            double getPiCpp1(const int N) {
            //RNGScope scope; // ensure RNG gets set/reset
            
            double x;
            double y;
            double d;
            
            int long counter = 0;
            
            for(int i = 0; i < N; i++){
              x = ((double)rand()/RAND_MAX);
              y = ((double)rand()/RAND_MAX);
              d = sqrt(x * x + y * y);
              if (d <= 1) counter++;
            }
            
            return (4.0 * counter) / N;
            
            }
            ")

# verification
getPiCpp1(N = 1000000)

# 4d. A C++ function based on vector
cppFunction("
  double getPiCpp2(const int N) {
    RNGScope scope; // ensure RNG gets set/reset
    NumericVector x = runif(N);
    NumericVector y = runif(N);
    NumericVector d = sqrt(x * x + y * y);
    
    return 4.0 * sum(d <= 1.0) / N;
  }")

# verification
getPiCpp2(N = 1000000)


# comparison
library(rbenchmark)
N <- 10000
set.seed(123)
benchmark(getPiR1(N), getPiR2(N), getPiCpp1(N), getPiCpp2(N))[, 1:4]


# 5. SIMPLE FUNCTION with rolling windows ======================================
# compile c++ code with a function definition
sourceCpp("functions/getCumSum.cpp")

nObs <- 1000
randomWalkData <-
  tibble(
    obs = 1:nObs,
    r   = rnorm(nObs)
  ) %>%
  mutate(rw = getCumSum(r)) 

randomWalkData %>%
  pivot_longer(cols = !obs) %>%
  ggplot(aes(x = obs, y = value, col = as_factor(name))) +
  geom_line() + 
  facet_grid(name ~ ., scales = "free") +
  labs(
    x = "observations",
    y = "value",
    title = "Random walk simulation",
    subtitle = " ~N(0,1) simulated increments and their cumulative sum",
    caption = "source: own calculations",
    colour = "variable"
  )

# the same plot using the dygraphs package
xts(randomWalkData$rw,
    order.by = as.Date(Sys.Date() - nObs + randomWalkData$obs)
) %>%
  dygraph(
    main = "Random walk simulation"
  ) %>% 
  dyRangeSelector(height = 40)

# EXERCISE 2 ===================================================================
# On basis of the example above (6.) create a function which calculates 
# simple moving average with given memory: getSMA(x, k).

source("solutions/exercise02.R")

# EXERCISE 3 ===================================================================
# On basis of the example above (6.) create a function which calculates 
# exponentially weighted moving average with given memory: getEWMA(x, k).

source("solutions/exercise03.R")

# EXERCISE 4 ===================================================================
# On basis of the example above (6.) create a function which calculates 
# moving window standard deviation with given memory: getRunningSD(x, k).

# EXERCISE 5 ===================================================================
# On basis of the example above (6.) create a function which calculates 
# moving window median with given memory: getRunningMedian(x, k).

# EXERCISE 6 ===================================================================
# On basis of the example above (6.) create a function which calculates 
# moving window quartile with given memory: getRunningQuartile(x, k, alpha).



