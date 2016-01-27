#' Calculate metrics corresponding to the Standard Ellipse based on a 
#' covariance matrix
#' 
#' This function takes a covariance 2x2 matrix Sigma and returns various 
#' metrics relating to the corresponding Standard Ellipse.
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
#' #' \itemize{
#'    \item {SEA}{the Standard Ellise Area (not sample size corrected)}
#'    \item {eccentricity}{a measure of the elongation of the ellipse.}
#'    \item {a}{the length of the semi-major axis}
#'    \item {b}{the length of the semi-minor axis}
#' }
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
  
  # NB this is the line causing odd ellipses to be drawn occasionally
  # I suspect there is an internal re-ordering of the axes going on 
  # underlying this. This behaviour is similar to what Mike Fowler and I
  # are struggling with in our linear system stability research.
  #theta <- asin(eig$vectors[1,2]) # OLD LINE #
  theta <- sign(sigma[1,2]) * asin(abs(eig$vectors[2,1])) # NEW LINE 11/07/2011
  
  SEA <- pi*a*b
  
  


  out <- list()
  out$SEA <- pi*a*b
  out$eccentricity <- sqrt(1-((b^2)/(a^2)))
  out$a <- a
  out$b <- b

  return(out)
}