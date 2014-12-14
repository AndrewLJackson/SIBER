hullarea <- function (x,y) {
ne <- length(x)
harea <- abs (0.5 * ( (x[1:(ne-1)] %*% y[2:ne]) - ( y[1:(ne-1)] %*% x[2:ne]) ) )
harea
}