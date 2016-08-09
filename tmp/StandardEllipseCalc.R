# Some code for Andrew J to calculate standard ellipses

# Use the mvtnorm package to simulate some data
library(mvtnorm)

# Generate a load of data
mu = c(1,2)
Sigma = matrix(c(1,0.8,0.8,2),2,2)
n = 200
X = rmvnorm(n,mu,Sigma)

# Plot the data
plot(X)

# Now standardise it by calculating Z = Sigma^{-1/2}%*%(X-mu) for each pair. Must be a quicker way of doing this!
# The standardised data should have mean 0 and var matrix I
e = eigen(Sigma)
SigSqrt = e$vectors %*% diag(sqrt(e$values)) %*% t(e$vectors)
myfun = function(x) {
  return(solve(SigSqrt,x-mu))
}  
Z = t(apply(X,1,myfun))
plot(Z)

# Generate some points uniformly on a circle
gencircle = function(n,r) {
  theta = seq(0,2*pi,length=n)
  x = r*cos(theta)
  y = r*sin(theta)
  return(cbind(x,y))
}
circ = gencircle(100,1)
plot(circ)

# Now Generate points on disc of radius e.g. sqrt(qchisq(0.95,df=2)) for a percentage
p=0.9
circ = gencircle(100,sqrt(qchisq(p,df=2)))
myfun2 = function(x) {
  return(SigSqrt%*%x+mu)
}
standard.ellipse = t(apply(circ,1,myfun2))
plot(standard.ellipse)

# Create a nicer plot which includes the original data to check that things are inside
plot(X)
lines(standard.ellipse,col='red',lwd=3)

# Check that 95% of points are inside it
inside = Z[,1]^2+Z[,2]^2 < qchisq(p,df=2)
points(X[inside,],col='red',pch=19)
prop.inside = sum(inside)/length(inside)
print(prop.inside)


