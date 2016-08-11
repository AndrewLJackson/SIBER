#' Apply a normalisation transformation to vectors of data onto ellipsoids
#' 
#' Takes a vector \code{x} and transforms the points onto the same geometry of 
#' a normalised ellipse given by the inverse of the covariance matrix 
#' \code{SigSqrt} and the location \code{mu}
#' 
#' @param x the vector of data points to be transformed
#' @param SigSqrt the inverse of the covariance matrix
#' @param mu the vector of means of the ellipse
#' 
#' @return A vector of transformed data points
#' 
#' @export

ellipsoidTransform = function(x, SigSqrt, mu) {
  # input error checking is handled upstream in pointsToEllipsoid()
  return(solve(SigSqrt,x-mu))
}  