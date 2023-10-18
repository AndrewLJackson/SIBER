#' Test whether a set of points are inside or outside a defined circle
#' 
#' Takes a 
#' 
#' @param Z the `i x d` matrix of data points to be tested.
#' @param p the percentile of the ellipse to be tested.
#' @param r a manually defined radius of the circle to be used. Setting `r` 
#' to be anything other than NULL will override the choice of `p`.
#' 
#' @return A logical vector indicating whether the point is inside or outside 
#' the circle
#' 
#' @export

ellipseInOut <- function(Z, p = 0.95, r = NULL){
  
  # if r is NULL as per default, calculate it based on p
  if(is.null(r)) {r <- stats::qchisq(p, df = ncol(Z))}
  
  # determine if each point is inside this radius or not
  inside <- rowSums(Z ^ 2) < r
  
  # return this logical vector
  return(inside)
  
}