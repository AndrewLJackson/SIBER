# script to check the calculation of angle and area using the atan rather than 
# asin() method.

set.seed(3)

# n random numbers
n <- 20

# ------------------------------------------------------------------------------
# generate mvtnorm numbers

# means
mu <- c(0,0)

# sigma from an inverse wishart distribution
S <- MCMCpack::riwish(length(mu), diag(length(mu)))

# multivariate normal Y
Y <- mvtnorm::rmvnorm(n = n, mean = mu, sigma = S)

plot(Y[,2] ~ Y[,1], type = "p", asp = 1, 
     xlim = c(-7, 7), 
     ylim = c(-7, 7))


# ------------------------------------------------------------------------------

# calculate covariance matrix of the data
S.samp <- cov(Y)

# add this ellipse to the plot
tmp <- SIBER::addEllipse(colMeans(Y),S.samp, p = 0.95, col = "red", lty = 2)

# eigen values and vectors of the data
eig <- eigen(S.samp)

# inverse of sigma
SigSqrt = eig$vectors %*% diag(sqrt(eig$values)) %*% t(eig$vectors)

# function to rotate and translate any data onto this orientation
myfun = function(x) {
  return(solve(SigSqrt,x-mu))
}  

# some points to check for inside or out
test.these <- matrix(c(-5, 0, 4, -5,  2,
                       -5, 0, 3, -2, -4),
                     ncol = 2, nrow = 5)

#points(test.these[,2]~test.these[,1], col = "red", pch = "*")

# transform these points on the ellipse coordinates 
Z <- t(apply(test.these,1,myfun))

# and test they are within the radius
inside = rowSums(Z ^ 2) < qchisq(0.95,df=2)

points(test.these[,2]~test.these[,1], col = inside + 1, pch = "*")




