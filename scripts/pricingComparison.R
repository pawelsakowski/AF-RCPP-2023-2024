####################################################################
# APPLIED FINANCE                                                  #
# Path-dependent option pricing with Monte Carlo and Rcpp package  #
# lecture02: comparison of option pricing techniques               #
# Paweł Sakowski                                                   #
# University of Warsaw                                             #
####################################################################

# loading packages
library(tidyverse)


# 1. European Call pricing using loops in R ====================================

# define option parameters 
Spot   <- 95
Strike <- 100
r      <- 0.06
Vol    <- 0.2
Expiry <- 0.5
nReps  <- 100

runningSum <- 0

variance      <- Vol * Vol * Expiry;
rootVariance  <- sqrt(variance);
itoCorrection <-  -0.5 * variance;
movedSpot     <- Spot * exp(r * Expiry + itoCorrection);

for (i in 1:nReps) {
  thisGaussian = rnorm(1);
  thisSpot = movedSpot * exp(rootVariance * thisGaussian);
  thisPayoff = thisSpot - Strike;
  if (thisPayoff > 0) {
    runningSum = runningSum + thisPayoff
  }
}

price <- runningSum / nReps * exp(-r * Expiry);
price


# the same as above in a single function
getCallPrice <- function(Spot   = 95,
                         Strike = 100,
                         r      = 0.06,
                         Vol    = 0.2,
                         Expiry = 0.5,
                         nReps  = 100) {
  runningSum <- 0
  
  variance <- Vol * Vol * Expiry;
  rootVariance <- sqrt(variance);
  itoCorrection <-  -0.5 * variance;
  movedSpot <- Spot * exp(r * Expiry + itoCorrection);
  
  for (i in 1:nReps) {
    thisGaussian = rnorm(1);
    thisSpot = movedSpot * exp(rootVariance * thisGaussian);
    thisPayoff = thisSpot - Strike;
    if (thisPayoff > 0) {
      runningSum = runningSum + thisPayoff
    }
  }
  
  price <- runningSum / nReps * exp(-r * Expiry);
  return(price)
}

time0 <- Sys.time()
getCallPrice(nReps = 1000000)
time1 <- Sys.time()
time1 - time0



# 2. European Call pricing using vectors in R ==================================

getCallPrice2 <- function(Spot   = 95,
                          Strike = 100,
                          r      = 0.06,
                          Vol    = 0.2,
                          Expiry = 0.5,
                          nReps  = 100) {
  
  variance <- Vol * Vol * Expiry
  rootVariance <- sqrt(variance)
  itoCorrection <-  -0.5 * variance
  movedSpot <- Spot * exp(r * Expiry + itoCorrection)
  
  thisGaussian <- rnorm(nReps)
  thisSpot     <- movedSpot * exp(rootVariance * thisGaussian)
  thisPayoff   <- thisSpot - Strike
  thisPayoff[thisPayoff < 0] <- 0
  
  price <- mean(thisPayoff) * exp(-r * Expiry);
  return(price)
}

time0 <- Sys.time()
getCallPrice2(nReps = 1000000)
time1 <- Sys.time()
time1 - time0


# 3. European Call pricing using loops in C++, via Rcpp ========================
# (see other project in optionPricing folder)

# install from binary package
# (please correct filename if necessary!)
install.packages("packages/optionPricer1_1.0_R_x86_64-pc-linux-gnu.tar.gz", 
                 type = "binaries", repos = NULL)

# install from source package
# (please correct filename if necessary!)
install.packages("packages/optionPricer1_1.0.tar.gz", 
                 type = "source", repos = NULL)

# Call the function
time0 <- Sys.time()
optionPricer1::getCallPrice(NumberOfPaths = 1000000)
time1 <- Sys.time()
time1 - time0

# build an R function: option price vs. time to maturity
getCallPrice3 <- function(expiry) {
  return(optionPricer1::getCallPrice(Expiry = expiry, 
                                     Strike = Strike,
                                     Spot   = Spot,
                                     Vol    = Vol,
                                     r      = r,
                                     NumberOfPaths = 1000000))
}

# call the function
getCallPrice3(0.5)

# arguments values of values of function
expiry <- seq(0.01, 0.1, by = 0.001)
prices <- sapply(expiry, getCallPrice3)

# relationship between expiry and option price
tibble(
  expiry = expiry,
  prices = prices
) %>%
  ggplot(aes(expiry, prices)) +
  geom_point(col = "red") +
  labs(
    x     = "time to maturity",
    y     = "price of European call option",
    title = "price of European call option vs. time  to maturity",
    caption = "source: own calculations with the optionPricer1 package")

detach("package:optionPricer1")
remove.packages("optionPricer1")


# 4. vectors in R with antithetic sampling =====================================
getCallPrice4 <- function(Spot   = 95,
                          Strike = 100,
                          r      = 0.06,
                          Vol    = 0.2,
                          Expiry = 0.5,
                          nReps  = 100,
                          antithetic = T) {
  
  variance      <- Vol * Vol * Expiry
  rootVariance  <- sqrt(variance)
  itoCorrection <- -0.5 * variance
  movedSpot     <- Spot * exp(r * Expiry + itoCorrection)
  
  thisGaussian <- rnorm(nReps)
  thisSpot     <- movedSpot * exp(rootVariance * thisGaussian)
  thisPayoff   <- thisSpot - Strike
  thisPayoff[thisPayoff < 0] <- 0
  
  if (antithetic) {
    thisAntitheticGaussian <- -thisGaussian
    thisAntitheticSpot     <- 
      movedSpot * exp(rootVariance * thisAntitheticGaussian)
    thisAntitheticPayoff   <- thisAntitheticSpot - Strike
    thisAntitheticPayoff[thisAntitheticPayoff < 0] <- 0
    price <- mean((thisAntitheticPayoff + thisPayoff) / 2) * exp(-r * Expiry)
  } else {
    price <- mean(thisPayoff) * exp(-r * Expiry)
  }
  
  return(price)
}

time0 <- Sys.time()
getCallPrice4(nReps = 10000, antithetic = T)
time1 <- Sys.time()
time1 - time0


# 5. comparison of standard deviation of option prices approximations ==========

nReplications <- 1000

# 5.1 no antithetic sampling, 1000 paths
prices1 <- replicate(nReplications, 
                     getCallPrice2(nReps = 1000))
mean(prices1)
sd(prices1)

prices1a <- replicate(nReplications, 
                      getCallPrice4(nReps = 1000, antithetic = F))
mean(prices1a)
sd(prices1a)

# 5.2 no antithetic sampling, 100000 paths
prices2 <- replicate(nReplications, 
                     getCallPrice2(nReps = 100000))
mean(prices2)
sd(prices2)

prices2a <- replicate(nReplications, 
                      getCallPrice4(nReps = 100000, antithetic = F))
mean(prices2a)
sd(prices2a)

# 5.3 with antithetic sampling, 500 paths
prices3 <- replicate(nReplications, 
                     getCallPrice4(nReps = 500, antithetic = T))
mean(prices3)
sd(prices3)

# 5.4 with antithetic sampling, 50000 paths
prices4 <- replicate(nReplications, 
                     getCallPrice4(nReps = 50000, antithetic = T))
mean(prices4)
sd(prices4)


pricesData <-
  tibble(
  prices = prices1,
  group  = "prices1"
) %>%
  bind_rows(
    tibble(
      prices = prices1a,
      group  = "prices1a"
    )
  ) %>%
  bind_rows(
    tibble(
      prices = prices2,
      group  = "prices2"
    )
  )%>%
  bind_rows(
    tibble(
      prices = prices2a,
      group  = "prices2a"
    )
  )%>%
  bind_rows(
    tibble(
      prices = prices3,
      group  = "prices3"
    )
  )%>%
  bind_rows(
    tibble(
      prices = prices4,
      group  = "prices4"
    )
  ) 

pricesData %>%
  group_by(group) %>%
  summarize(n = n(),
            mean = mean(prices),
            sd   = sd(prices))

pricesData%>%
  ggplot(aes(prices, group)) +
  geom_boxplot() +
  labs(
    title = "Dispersion of option prices approximations",
    caption = "source: own calculations with the optionPricer1 package")



