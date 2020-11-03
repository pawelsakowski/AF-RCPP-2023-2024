sourceCpp("solutions/getSMA.cpp")

nObs <- 1000
k    <- 30
smaData <-
  tibble(
    obs = 1:nObs,
    r   = rnorm(nObs)
  ) %>%
  mutate(rw  = getCumSum(r),
         sma = getSMA(x = rw, k = k)) 

smaData %>%
  select(-r) %>%
  pivot_longer(cols = !obs) %>%
  ggplot(aes(x = obs, y = value, col = as_factor(name))) +
  geom_line() + 
  labs(
    x = "observations",
    y = "value",
    title = "Random walk simulation and its Simple Moving Average",
    subtitle = paste0("cumulative sum of ~N(0,1) simulated increments and their SMA with k = ",
                      k),
    caption = "source: own calculations",
    colour = "variable"
  )

