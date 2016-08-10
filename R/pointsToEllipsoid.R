#' Test whether a set of points are inside or outside a defined ellipse
#' 
#' Takes a \code{i x d} matrix of points where \code{d} is the dimension of the 
#' space considered, and \code{i} is the number of points and returns 
#' \code{TRUE} or \code{FALSE} for whether each point is inside or outside a 
#' d-dimensional ellipsoid defined by a covariance matrix \code{Sigma} and 
#' vector of means \code{mu}.
#' 
#' @param X the \code{i x d} matrix of data points to be transformed
#' @param Sigma the \code{d x d} covariance matrix of the ellipsoid 
#' @param mu the vector of means of the ellipse of length \code{d}
#' 
#' @return A matrix of transformed data points corresponding to \code{X}
#' 
#' @export

pointsToEllipsoid <- function(X, Sigma, mu){
  
  # eigen values and vectors of the covariance matrix
  eig <- eigen(Sigma)
  
  # inverse of sigma
  SigSqrt = eig$vectors %*% diag(sqrt(eig$values)) %*% t(eig$vectors)
  
  # transform the points
  Z <- t(apply(X, 1, ellipsoidTransform, SigSqrt, mu))
  
  return(Z)
  
  
}