#' Calculate metrics corresponding to the Standard Ellipse based on a 
#' covariance matrix
#' 
#' This function takes a covariance 2x2 matrix Sigma and returns various 
#' metrics relating to the corresponding Standard Ellipse. The function is 
#' limited to the 2-dimensional case, as many of the ancillary summary 
#' statistics are not defined for higher dimensions (e.g. eccentricity).
#' 
#' @section Note: This function is currently based on the eigenvalue and 
#'   eigenvector approach which is more flexible for higher dimensional problems
#'   method for calculating the standard ellipse, and replaces the parametric
#'   method used previously in siar and siber. 
#' 
#' @param sigma a 2x2 covariance ellipse.
#' 
#' @return A list comprising the following metrics for summarising the Standard 
#' Ellipse
#' 
#'    * `SEA`  the Standard Ellipse Area (not sample size corrected).
#'    
#'    * `eccentricity` a measure of the elongation of the ellipse.
#'    
#'    * `a` the length of the semi-major axis.
#'    
#'    * `b` the length of the semi-minor axis.
#'
#' 
#' @examples
#' # A perfect circle
#' sigma <- matrix( c(1, 0, 0, 1), 2, 2)
#' sigmaSEA(sigma)
#' 
#' @export
#' 


sigmaSEA <- function(sigma){

  eig <- eigen(sigma)
  
  a <- sqrt(eig$values[1])
  b <- sqrt(eig$values[2])
  
  # As of v2.0.4 I have replaced the asin() line with atan which 
  # returns the angle of correct sign due to the inclusion of the quotient
  # of the vectors.
  theta <- atan(eig$vectors[2,1] / eig$vectors[1,1])
  
  SEA <- pi*a*b
  

  out <- list()
  out$SEA <- pi*a*b
  out$eccentricity <- sqrt(1-((b^2)/(a^2)))
  out$a <- a
  out$b <- b
  out$theta <- theta

  return(out)
}