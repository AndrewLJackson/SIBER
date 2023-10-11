## ----echo = FALSE-------------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", 
                      fig.width = 6, fig.height = 5)


## ----gendata, echo = TRUE-----------------------------------------------------

library(dplyr)
library(magrittr)
library(purrr)
library(SIBER)
library(ggplot2)

# set the random seed generator so we get consistent results each time 
# we run this code.
set.seed(3)

# n random numbers
n <- 100

# some random multivariate data
Y <- generateSiberGroup(n.obs = n)


## ----warpdata, echo = TRUE----------------------------------------------------

# plot this example data with column 2 by column 1
# plot(Y[,2] ~ Y[,1], type = "n", asp = 1,
#      xlim = c(-10, 10),
#      ylim = c(-10, 10))

plot(Y[,2] ~ Y[,1], type = "n", asp = 1)

# add an ellipse, in this case a 95% ellipse
mu <- colMeans(Y) # centre of the ellipse
Sigma <- cov(Y) # covariance matrix of the ellipse

# percentile of the ellipse
p <- 0.95 

# draw the ellipse
tmp <- addEllipse(mu, Sigma, p.interval = p, col = "red", lty = 2)

# Determine which of the samples are inside the ellipse
Z_samp <- pointsToEllipsoid(Y, Sigma, mu) # convert to circle space
inside_samp <- ellipseInOut(Z_samp, p = p) # test if inside

# inside points are marked TRUE which corresponds to 1 in numeric terms, and 
# outside marked FALSE which corresponds to 0. 
# So below I calculate (1 + !inside_test) which makes 1 correspond to inside 
# and coloured black, and 2 correspond to outside and coloured red.
# and plot them with colour coding for whether they are inside or outside
points(Y[,2] ~ Y[,1], col = 1 + !inside_samp)


## ----manually-test-points, eval = TRUE----------------------------------------
# Define a matrix of 5 data points to test against our ellipse.
# For ease of interpretation of this code, I have built this matrix by 
# specifying each row on a separate line and do this by adding the option 
# byrow = FALSE (by default R fills down the rows first of a matrix).
test_these <- matrix(c(-2,  2,
                        0,  0,
                       -5,  2,
                        1, -2,
                        4,  0),
                     byrow = TRUE,
                     ncol = 2, nrow = 5)

# transform these points onto ellipsoid coordinates
Z_test <- pointsToEllipsoid(test_these, Sigma, mu)

# determine whther or not these points are inside or outside the ellipse drawn 
# with same p as above (percentile).
inside_test <- ellipseInOut(Z_test, p = p)

# inside points are marked TRUE which corresponds to 1 in numeric terms, and 
# outside marked FALSE which corresponds to 0. 
# So below I calculate (1 + !inside_test) which makes 1 correspond to inside 
# and coloured black, and 2 correspond to outside and coloured red.
# and plot them with colour coding for whether they are inside or outside
plot(test_these[,2] ~ test_these[,1],
       col = 1 + !inside_test,
       pch = "*",
       cex = 2, 
     xlim = c(-6, 6), 
     ylim = c(-6, 6))

# and add the ellipse same as the one above
tmp <- addEllipse(mu, Sigma, p.interval = p, col = "red", lty = 2)

## -----------------------------------------------------------------------------

# a wrapper function to simulate a population, fit the ellipses and 
# determine the proportion of samples inside.

testEllipse <- function(n, p) {
  
  # generate the samples
  Y <- generateSiberGroup(n.obs = n)
  
  # sample moments
  mu <- colMeans(Y) # centre of the ellipse
  Sigma <- cov(Y) # covariance matrix of the ellipse
  
  # Determine which of the samples are inside the ellipse
  Z_samp <- pointsToEllipsoid(Y, Sigma, mu) # convert to circle space
  
  # test if inside
  inside_samp <- ellipseInOut(Z_samp, p = p)
  
  # return propotion inside
  return(sum(inside_samp) / length(inside_samp))

  
}


## -----------------------------------------------------------------------------

# define the prediciton interval to use
prediction_interval <- 0.95

# specify a range of n
do_these_n <- c(5, 10, 15, 20, 50, 100, 320, 1000)

# how many replicates per n to simulate
reps_per_n <- 200

# replicate a range of n and sort on n
simExperiment <- tibble(n = rep(do_these_n, reps_per_n ),
                        p = prediction_interval) %>% arrange(n)


## -----------------------------------------------------------------------------

simExperiment %<>% mutate(p_inside = pmap(list(n = n, p = p), testEllipse) %>% unlist)

# and summarise the results
summaries_simExperiment <- simExperiment %>% group_by(n) %>% 
  summarise(mu_p_inside = mean(p_inside),
            min_p_inside = min(p_inside),
            max_p_inside = max(p_inside))


## -----------------------------------------------------------------------------
# and plot p_inside against n
g3 <- ggplot(data = simExperiment, mapping = aes(x = n, y = p_inside)) + 
  geom_jitter() + 
  scale_x_log10() + 
  geom_point(data = summaries_simExperiment, mapping = aes(y = mu_p_inside),
             color = "red") + 
  geom_path(data = summaries_simExperiment, mapping = aes(y = mu_p_inside),
             color = "red")

print(g3)


## ----highdim, eval = TRUE-----------------------------------------------------
# set the random seed generator so we get consistent results each time 
# we run this code.
set.seed(2)

# n random numbers
n_d <- 10^3

# number of dimensions
d <- 3

# vector of d means between -1 and +1
mu_d <- stats::runif(d, -1, +1)
  
# a (d x d) covariance matrix
# pull a precision matrix from the wishart distribution and invert it to 
# get the corresponding covariance matrix.
sigma_d <- solve(matrix(stats::rWishart(1, d, diag(d)), d, d))

# n-dimensional multivariate random numbers for this test
Y_d <- mnormt::rmnorm(n_d, mu_d, sigma_d)  

# sample mean and covariance matrix
mu_samp_d <- colMeans(Y_d) # centre of the ellipse
Sigma_samp_d <- cov(Y_d) # covariance matrix of the ellipse

# percentile of the ellipsoid to test
p <- 0.95 

# here i am just going to test whether my actual data points are inside
# or outside the 95% ellipsoid but you could replace with your own 
# data points as above

# transform these points onto ellipsoid coordinates
Z_d <- pointsToEllipsoid(Y_d, Sigma_samp_d, mu_d)

# determine whther or not these points are inside or outside the ellipse drawn 
# with same p as above (percentile).
inside_d <- ellipseInOut(Z_d, p = p)

# how many of our points are inside our ellipse?
p_d_inside <- sum(inside_d) / length(inside_d)


