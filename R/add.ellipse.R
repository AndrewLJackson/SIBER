add.ellipse <- function(mu, sigma, m = NULL, n = 100, p.interval = NULL , ci.mean = F, ...){
  
  # mu is the location of the ellipse (its bivariate mean)
  # sigma describes the shape and size of the ellipse
  # p can set the predction interval for the ellipse.
  # n determines how many data points are used to draw 
  #   the ellipse. More points = smoother curves.
  
  # if ci.mean is F (default) then we are plotting quantiles of the sample, 
  # i.e. prediction ellipses, and so we set c <- 1 so that it has no effect
  # below. Else it divides the radius calculation below by sqrt(m) to include
  # the conversion from standard deviation to standard error of the mean.
  ifelse(ci.mean, 
           c.scale <- m,
           c.scale <- 1
         )
  
  
  # if p is NULL then plot a standard ellipse with r = 1
  # else generate a prediction ellipse that contains
  # approximately proportion p of data by scaling r
  # based on the chi-squared distribution.
  # p defaults to NULL.
  ifelse(is.null(p.interval), 
           r <- 1, 
           r <- sqrt(qchisq(p.interval, df=2))
         )

  
  # get the eigenvalues and eigenvectors of sigma
  e = eigen(sigma / c.scale)
  
  # 
  SigSqrt = e$vectors %*% diag(sqrt(e$values)) %*% t(e$vectors)
  
  # create a unit radius circle to transform
  cc <- gen.circle(n, r)
  
  # transform the unit circle according to the covariance 
  # matrix sigma
  
  # a function to transform the points
  back.trans <- function(x) {
    return(SigSqrt %*% x + mu)
  }
  
  # apply the transformation to calculate the 
  # Maximum Likelihood estimate of the ellipse.
  
  ML.ellipse = t(apply(cc,1, back.trans))
  
  if(dev.cur() > 1) {lines(ML.ellipse, ...)}

  # optional return of x and y coordinates of the plotted ellipse
  return(ML.ellipse)

}