add.ellipse <- function(mu, sigma, n = 100, p = NULL, ...){
  
  # mu is the location of the ellipse (its bivariate mean)
  # sigma describes the shape and size of the ellipse
  # p can set the predction interval for the ellipse.
  # n determines how many data points are used to draw 
  #   the ellipse. More points = smoother curves.

  # if p is NULL then plot a standard ellipse with r = 1
  # else generate a prediction ellipse that contains
  # approximately proportion p of data by scaling r
  # based on the chi-squared distribution.
  # p defaults to NULL.
  ifelse(is.null(p), r <- 1, r <- sqrt(qchisq(p,df=2)))

  
  # get the eigenvalues and eigenvectors of sigma
  e = eigen(sigma)
  
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