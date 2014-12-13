  # a function to generate a single group
  generate.siber.group <- function (mu.range = c(-1, 1), n.obs = 30) {
    # pull a random set of means from the appropriate range
    mu <- runif(2, mu.range[1], mu.range[2])

    # pull a covariance matrix from the wishart distribution
    sigma <- rwishart(2, diag(2))

    y <- rmnorm(n.obs, mu, sigma$W)  
    
    return(y)
  }