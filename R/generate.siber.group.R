  # a function to generate a single group
  generate.siber.group <- function (mu.range = c(-1, 1, -1, 1), n.obs = 30) {
    
    # pull a random set of means from the appropriate range
    # Code allows for different ranges for each isotope.
    mu <- numeric(2)
    mu[1] <- runif(1, mu.range[1], mu.range[2])
    mu[2] <- runif(1, mu.range[3], mu.range[4])
    
    # pull a covariance matrix from the wishart distribution
    sigma <- rwishart(2, diag(2))
    
    # the data are random normal
    y <- rmnorm(n.obs, mu, sigma$W)  
    
    # output the simulated data for this group
    return(y)
  }
  