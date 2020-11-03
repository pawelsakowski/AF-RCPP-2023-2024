sourceCpp("solutions/getEWMA.cpp")

nObs  <- 1000
alpha <- 0.03

ewmaData <-
  tibble(
    obs = 1:nObs,
    r   = rnorm(nObs)
  ) %>%
  mutate(rw  = getCumSum(r),
         ewma = getEWMA(x = rw, alpha = alpha) %>% head(-1)) 

ewmaData %>%
  select(-r) %>%
  pivot_longer(cols = !obs) %>%
  ggplot(aes(x = obs, y = value, col = as_factor(name))) +
  geom_line() + 
  labs(
    x = "observations",
    y = "value",
    title = "Random walk simulation and its Exponentially Weighted Moving Average",
    subtitle = paste0("cumulative sum of ~N(0,1) simulated increments and their EWMA with alpha = ",
                      alpha),
    caption = "source: own calculations",
    colour = "variable"
  )
