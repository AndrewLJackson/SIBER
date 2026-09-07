library(SIBER)

# select the first group of data to test
Y <- demo.siber.data[1:30,1:2]



# Mean, marginal sd and cov of the raw data
mu_Y = colMeans(Y)
sd_Y = apply(Y,1,sd)
cov_Y = cov(Y)



# Z transformed (centred and scaled) data
Z <- cbind(scale(Y[,1]), scale(Y[,2]))


# Mean, marginal sd and cov of the centered data
mu_Z  = colMeans(Z)
sd_Z  = apply(Z,1,sd)
cov_Z = cov(Z)

draw <- c(as.vector(cov_Z) , mu_Z )

# back transform "draw" according to ellipseBackTransform approach
back <- numeric(6)
# first the two diagonal variances
back[1] <- draw[1] * cov_Y[1,1]
back[4] <- draw[4] * cov_Y[2,2]  
  
# then the covariances
back[2] <- draw[2] * cov_Y[1,1] ^ 0.5 * cov_Y[2,2] ^ 0.5
back[3] <- back[2]

# now correct the ellipse locations (i.e. their means)

back[5] <- draw[5] + mu_Y[1]
back[6] <- draw[6] + mu_Y[2]

orig <- c(as.vector(cov_Y), mu_Y)

back - orig



