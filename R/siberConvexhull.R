#' Calculate metrics and plotting information for convex hulls
#' 
#' This function calculates the area of the convex hull describing a set of 
#' bivariate points, and returns other information useful for plotting the hull.
#' 
#' @param x a vector of x-axis data
#' @param y a vector of y-axis data
#' 
#' @return A list of length four comprising:
#' 
#'    * `TA` the area of the convex hull.
#'    
#'    * `hullX` the x-coordinates of the points describing the convex hull.
#'    
#'    * `hullY` the y-coordinates of the points describing the convex hull.
#'    
#'    * `ind` the indices of the original data in `x` and `y` that
#'                form the boundaries of the convex hull.
#'  
#' 
#' @examples
#' x <- stats::rnorm(15)
#' y <- stats::rnorm(15)
#' siberConvexhull(x, y)
#' 
#' @export

siberConvexhull <- function(x,y){

chI <- grDevices::chull(x,y)
chI <- c(chI,chI[1])
hullX <- x[chI]
hullY <- y[chI]

TA <- hullArea(hullX,hullY)

out <- list()
out$TA <- TA
out$xcoords <- hullX
out$ycoords <- hullY
out$ind <- chI

out

}