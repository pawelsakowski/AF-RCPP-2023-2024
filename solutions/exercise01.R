# define the function
source("solutions/getBondPrice.R")

# call the function
getCouponBondPrice(10, 0.1, 12, 0.11, 1000)

# build an R function
getCouponBondPrice1 <- function (r) {
  return(getCouponBondPrice(10, 0.05, 12, r, 1000))
}

ytm <- seq(0.001, 0.1, by = 0.001)
getCouponBondPrice1(0.05)
couponBondPrices <- sapply(ytm, getCouponBondPrice1)

# plot
tibble(
  ytm    = ytm,
  prices = couponBondPrices
) %>%
  ggplot(aes(x = ytm, y = couponBondPrices)) +
  geom_point(col = "red") +
  labs(
    x = "yield to maturity",
    y = "price of coupon bond",
    title = "Coupon bond price vs. yield to maturity",
    caption = "source: own calculations"
  )

