#' Calculate the area of a convex hull given its coordinates
#' 
#' Given the coordinates of a convex hull (i.e. a polygon), this function
#' calculates its area. Not intended for direct use outside of 
#' \code{\link{siberConvexhull}}.
#' 
#' @param x a vector of x-axis data
#' @param y a vector of y-axis data
#' 
#' @return a scalar representing the area of the convex hull in units of 
#' \code{x * y}; i.e. most commonly in permille squared for isotope data.
#' 


hullArea <- function (x,y) {
ne <- length(x)
harea <- abs (0.5 * ( (x[1:(ne-1)] %*% y[2:ne]) - ( y[1:(ne-1)] %*% x[2:ne]) ) )
harea
}