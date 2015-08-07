#' Calculate metrics corresponding to the Standard Ellipse based on a 
#' covariance matrix
#' 
#' This function takes a covariance 2x2 matrix Sigma and returns various 
#' metrics relating to the corresponding Standard Ellipse.
#' 
#' @section Note:
#' This function is currently based on the parametric method for calculating 
#' the standard ellipse, but it needs to be updated to the eigenvalue and 
#' eigenvector approach which is more flexible for higher dimensional problems.
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
#' popSEA(sigma)

popSEA <- function(sigma){

A <- sigma[2,2]
C <- sigma[1,1]

B <- -sigma[1,2]

cr <- cov2cor(sigma)

D <- (1-(cr[1,2]^2))*A*C

R <- sqrt((A-C)^2 + 4*B^2)

a <- sqrt(2*D/(A+C-R))
b <- sqrt(2*D/(A+C+R))


out <- list()
out$SEA <- pi*a*b
out$eccentricity <- sqrt(1-((b^2)/(a^2)))
out$a <- a
out$b <- b

return(out)
}