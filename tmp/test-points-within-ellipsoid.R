# script to check the calculation of angle and area using the atan rather than 
# asin() method.

set.seed(2)

# n random numbers
n <- 20

# ------------------------------------------------------------------------------
# generate mvtnorm numbers

# means
mu <- c(0,0,0)

# sigma from an inverse wishart distribution
S <- MCMCpack::riwish(length(mu), diag(length(mu)))

# multivariate normal Y
Y <- mvtnorm::rmvnorm(n = n, mean = mu, sigma = S)

pairs(Y, lower.panel = NULL)

# ------------------------------------------------------------------------------

# calculate covariance matrix of the data
S.samp <- cov(Y)

# sample means
mu.samp <- colMeans(Y)

# eigen values and vectors of the data
eig <- eigen(S.samp)

# inverse of sigma
SigSqrt = eig$vectors %*% diag(sqrt(eig$values)) %*% t(eig$vectors)

# function to rotate and translate any data onto this orientation
myfun = function(x) {
  return(solve(SigSqrt, x-mu.samp))
}  

# ------------------------------------------------------------------------------
# some points to check for inside or out
test.these <- matrix(c(0, 0, 0,
                       4, -10, 0),
                     ncol = length(mu),
                     nrow = 2,
                     byrow = TRUE)

# transform these points on the ellipse coordinates 
Z <- t(apply(test.these,1,myfun))

# and test they are within the radius
inside = rowSums(Z ^ 2) < qchisq(0.95,df=2)


