#' Title
#'
#' @param X a list of covariance matrices fitted to the original data
#' @param Z a list comprising the posterior distribution of covariance matrices fitted to the z-scored data 
#'
#' @return a list of posterior distributions of covariance matrices on the same scale as the original data
#' @export
#'
#' @examples
backTransCOV <- function(X,Z){
  
  # get sd of original data X
  a <- diag(X)^0.5
  A <- a %*% t(a)
  
  # rescale the Z score estimated correlation matrix back to covariance matrix
  # on same scale as the original data Xaj
  out <- Z * A
  
  return(out)
  
}