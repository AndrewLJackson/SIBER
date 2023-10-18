#' A utility function to simulate a single group of data
#' 
#' This function simulates data for a single group by sampling from a normal
#' distribution with different means for each group within some specified 
#' boundaries.
#' 
#' @param mu.range a vector of length 4, specifying the mix and max x and y 
#' values to sample means from. Group means are sampled from a uniform 
#' distribution within this range. The first two entries are the min and max of 
#' the x-axis, and the second two the min and max of the y-axis.
#' @param n.obs the number of observations to draw per group. Defaults to 30.
#' @param wishSigmaScale is a simple multiplier for the call to
#'   [stats::rWishart()] which scales the diagonal sigma matrix using
#'   `wishSigmaScale * diag(2)`.
#' 
#' @return A data.frame object comprising a column of x and y data, a group 
#' identifying column and a community identifying column, all of which are 
#' numeric.
#' 
#' @examples
#' # generateSiberGroup()
#' 
#' @export


# a function to generate a single group
generateSiberGroup <- function (mu.range = c(-1, 1, -1, 1), n.obs = 30, 
                                wishSigmaScale = 1) {
  
  # pull a random set of means from the appropriate range
  # Code allows for different ranges for each isotope.
  mu <- numeric(2)
  mu[1] <- stats::runif(1, mu.range[1], mu.range[2])
  mu[2] <- stats::runif(1, mu.range[3], mu.range[4])
  
  # pull a precision matrix from the wishart distribution and invert it to 
  # get the corresponding covariance matrix.
  sigma <- solve(matrix(stats::rWishart(1, 2, 
                                        wishSigmaScale*diag(2)), 
                        nrow = 2, ncol = 2))
  
  # the data are random normal
  y <- mnormt::rmnorm(n.obs, mu, sigma)  
  
  # output the simulated data for this group
  return(y)
}
