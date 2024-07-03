#' Title
#'
#' @param x a covariance matrix
#'
#' @return the multidimensional Standard Ellipsoid Volume (Area for 2d)
#' @export
#'
#' @examples

siberNSEA <- function(x){
  
  # dimensionality
  n <- ncol(x)
  
  eig <- eigen(x)
  
  if(any(is.complex(eig$values))){stop("The provided covariance matrix 
  appears to not be 'positive definite' as is required. At least 
  one of the associated eigen values is complex.")}
  
  SEA <- sqrt(prod(eig$values)) * (pi^(n/2)) / gamma((n/2) + 1)
  
  return(SEA)
  
}