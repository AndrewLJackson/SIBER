# script to check the calculation of angle and area using the atan rather than 
# asin() method.

set.seed(1)

# n random numbers
n <- 20

# x
x <- rnorm(n, 0, 2)

# intercept and slope
b <- c(0, 1)

# y 
y <- cbind(rep(1,n), x) %*% b + rnorm(n,0,1)

# plot
plot(y~x, type = "p")

# covariance matrix
S <- cov(cbind(x,y))

# eigen values and vectors
eig <- eigen(S)

# SEA 
SEA <- pi * prod(eig$values ^ 0.5)

# angle of y with x axis
theta <- asin(eig$vectors[1,2])
theta.tan <- atan(eig$vectors[2,1]/eig$vectors[1,1])

# SIBER estimates
ss <- sigmaSEA(S)
ss$theta <- sign(S[1, 2]) * asin(abs(eig$vectors[1, 2]))

cat("Eigen values and vectors\n")
eig

cat("Hardcoded estimates\n")
SEA
theta
theta.tan

cat("SIBER estimates\n")
ss$SEA
ss$theta