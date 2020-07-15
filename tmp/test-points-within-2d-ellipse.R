# script to check the calculation of angle and area using the atan rather than 
# asin() method.

# set.seed(3)

# n random numbers
n <- 100

# ------------------------------------------------------------------------------
# generate mvtnorm numbers

# means
mu <- c(0,0)

# sigma from an inverse wishart distribution
S <- MCMCpack::riwish(length(mu), diag(length(mu)))

# multivariate normal Y
Y <- mvtnorm::rmvnorm(n = n, mean = mu, sigma = S)

plot(Y[,2] ~ Y[,1], type = "n", asp = 1, 
     xlim = c(-7, 7), 
     ylim = c(-7, 7))


# ------------------------------------------------------------------------------

# sample mean
mu_samp <- colMeans(Y)

# calculate covariance matrix of the data
S.samp <- cov(Y)

# add this ellipse to the plot
tmp <- SIBER::addEllipse(colMeans(Y), S.samp, p = 0.95, col = "red", lty = 2)

# eigen values and vectors of the data
eig <- eigen(S.samp)

# inverse of sigma
SigSqrt = eig$vectors %*% diag(sqrt(eig$values)) %*% t(eig$vectors)

# function to rotate and translate any data onto this orientation
myfun = function(x, mu) {
  return(solve(SigSqrt,x-mu))
}  

# how many of these samples are inside the ellipse?
Z.samp <- t(apply(Y, 1, myfun, mu = mu_samp))

samp_inside = rowSums(Z.samp ^ 2) < qchisq(0.95, df=2)


points(Y[,2] ~ Y[,1], col = (!samp_inside) + 1)


# some points to check for inside or out
test.these <- matrix(c(-5, 0, 4, -5,  2,
                       -5, 0, 3, -2, -4),
                     ncol = 2, nrow = 5)

#points(test.these[,2]~test.these[,1], col = "red", pch = "*")

# transform these points on the ellipse coordinates 
Z.test <- t(apply(test.these,1,myfun, mu = mu_samp))

# and test they are within the radius
inside = rowSums(Z.test ^ 2) < qchisq(0.95, df=2)

points(test.these[,2]~test.these[,1], col = (!inside) + 1, pch = "*")


# Test whether the SIBER functions match the manually calculated values here
Z_aj <- SIBER::pointsToEllipsoid(X = Y, Sigma = S.samp, mu = mu_samp)

# are all the transformed points the same?
all(Z_aj == Z.samp)

# calculate whether the points are inside / out
inside_aj <- SIBER::ellipseInOut(Z = Z_aj, p = 0.95)

all(inside_aj == samp_inside)


# what proportion of our samples are inside
print(sum(samp_inside) / length(samp_inside))