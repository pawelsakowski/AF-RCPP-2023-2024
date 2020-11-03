####################################################################
# APPLIED FINANCE                                                  #
# Path-dependent option pricing with Monte Carlo and Rcpp package  #
# labs02: application of the Rcpp package                          #
# Paweł Sakowski                                                   #
# University of Warsaw                                             #
####################################################################

# loading packages
library(tidyverse)

# 1. remove package if it exists ===============================================
remove.packages("optionPricer2")
detach("package:optionPricer2", unload = TRUE) # if it still is in memory

# 2. install package and load to memory ========================================
# (adjust file names and/or paths, if necessary)

# from binaries (no need to rebuild)
install.packages("packages/optionPricer2_1.0_R_x86_64-pc-linux-gnu.tar.gz",
                 type = "binaries",
                 repos = NULL)

# or from source (rebuilt automatically)
install.packages("packages/optionPricer2_1.0.tar.gz",
                 type = "source",
                 repos = NULL)

# 3. call the function from the package ========================================
optionPricer2::getArithmeticAsianCallPrice(126, 100, 95, 0.2, 0.06, 0.5, 10000)

# 4. build an R wrapping function: option price vs. time to maturity ===========
getMCAsianCallPriceWithExpiry <- function (expiry) {
  return(
    optionPricer2::getArithmeticAsianCallPrice(126, 100, 95, 0.2, 0.06, expiry, 10000)
    )
}

# call the wrapping function 
getMCAsianCallPriceWithExpiry(0.5)

# arguments values of values of function 
expiry <- seq(0.01, 1, by = 0.01)
prices <- sapply(expiry, getMCAsianCallPriceWithExpiry)

# visualization: options price vs. expiry 
tibble( expiry, prices) %>%
  ggplot(aes(expiry, prices)) +
  geom_point(col = "red") +
  labs(
    x     = "time to maturity",
    y     = "option price",
    title = "price of arithmetic Asian call option vs. time  to maturity",
    caption = "source: own calculations with the optionPricer2 package")

# 5. build an R wrapping function: option price vs. number of loops ============
getMCAsianCallPriceWithLoops <- function (loops) {
  return(
    optionPricer2::getArithmeticAsianCallPrice(126, 100, 95, 0.2, 0.06, 0.5, loops)
    )
}

# call the wrapping function 
getMCAsianCallPriceWithLoops(500)

# arguments values of values of function 
loops  <- seq(100, 10000, by = 100)
prices <- sapply(loops, getMCAsianCallPriceWithLoops)

# visualization: options price vs. numbers of loops 
tibble(expiry, prices) %>%
  ggplot(aes(expiry, prices)) +
  geom_point(col = "blue") +
  labs(
    x     = "number of loops",
    y     = "option price",
    title = "price of arithmetic Asian call option vs. number of loops",
    caption = "source: own calculations with the optionPricer2 package")

# note the same seed within one second!

# 6. build an R wrapping function: option price vs. spot and volatility =======
getMCAsianCallPriceWithSpotAndVol <- function (spot, vol) {
  return(
    optionPricer2::getArithmeticAsianCallPrice(126, 100, spot, vol, 0.06, 0.5, 500))
}

# call function once
getMCAsianCallPriceWithSpotAndVol(100, 0.2)

# sequences of argument values
spot <- seq(90, 105, by = 0.5)
vol  <- c(0.001, 0.01, 0.02, 0.05, 0.1, 0.15, 0.2, 0.3, 0.5, 1)

grid      <- expand.grid(spot = spot, vol = vol)
prices    <- mapply(getMCAsianCallPriceWithSpotAndVol, 
                    spot = grid$spot, vol = grid$vol)
result.df <- data.frame(grid, result)
head(result.df)

# visualization: options price vs. spot price and volatility
grid %>% 
  as_tibble() %>%
  bind_cols(price = prices) %>%
  ggplot(aes(x = spot, y = price, group = vol, colour = vol)) +
  geom_line() +
  geom_point(size = 1, shape = 21, fill = "white") +
  labs(
    x     = "spot price",
    y     = "option price",
    title = "price of arithmetic Asian call option vs. spot price and volatility",
    caption = "source: own calculations with the optionPricer2 package")

  

