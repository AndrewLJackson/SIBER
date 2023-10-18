#' Create a sequence of points on a circle
#' 
#' This is a helper function that creates a sequence of points on a circle of 
#' radius `r` as a resolution determined by `n`. It is not intended 
#' for direct calling, and is used by the ellipse plotting function 
#' [addEllipse()]. NB not an exported function.
#' 
#' @param n the number of points to create around the circle. Defaults to 100.
#' @param r the radius of the circle to create.
#' 
#' @return A 2 x n matrix of x and y coordinates of points on a circle.
#' 

# function to generate a circle of data points which
# can be transformed to form an ellipse. Intended for
# generating various SIBER ellipses.
# Not intended for calling on its own.

genCircle = function(n = 100, r) {
  # a uniform series of angles from 0 -> 2*pi
  theta = seq(0, 2*pi, length = n)
  
  # x and y coordinates on the circle
  x = r*cos(theta)
  y = r*sin(theta)
  
  # return the coordinates
  return(cbind(x,y))
}