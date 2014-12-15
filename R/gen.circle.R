# function to generate a circle of data points which
# can be transformed to form an ellipse. Intended for
# generating various SIBER ellipses.
# Not intended for calling on its own.

gen.circle = function(n,r) {
  # a uniform series of angles from 0 -> 2*pi
  theta = seq(0, 2*pi, length = n)
  
  # x and y coordinates on the circle
  x = r*cos(theta)
  y = r*sin(theta)
  
  # return the coordinates
  return(cbind(x,y))
}