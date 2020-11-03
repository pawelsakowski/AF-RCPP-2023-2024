library(tidyverse)

getSpotLastPrices <- function(Spot   = 95,
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
  # return(price)
  return(thisSpot)
  # return(movedSpot)
}

p <- getSpotLastPrices(nReps = 100000)

p %>%
  enframe() %>%
  ggplot(aes(x = value)) +
  geom_histogram(binwidth = 1, 
                 fill = "pink",
                 col  = "black")

mean(p)
(exp(rootVariance^2) - 1)*exp(rootVariance^2)
var(p - mean(p)) 



95*1.03
96.91913