#' Test whether a set of points are inside or outside a defined ellipse
#' 
#' Takes a \code{i x d} matrix of points where \code{d} is the dimension of the 
#' space considered, and \code{i} is the number of points and returns 
#' \code{TRUE} or \code{FALSE} for whether each point is inside or outside a 
#' d-dimensional ellipsoid defined by a covariance matrix \code{Sigma} and 
#' vector of means \code{mu}.
#' 
#' @param X the \code{i x d} matrix of data points to be transformed
#' @param Sigma the \code{d x d} covariance matrix of the ellipsoid 
#' @param mu the vector of means of the ellipse of length \code{d}
#' 
#' @return A matrix of transformed data points corresponding to \code{X}
#' 
#' @examples 
#' X <- matrix(runif(200,-2.5, 2.5), ncol = 2, nrow = 100)
#' SIG <- matrix(c(1,0,0,1), ncol = 2, nrow = 2)
#' mu <- c(0, 0)
#' Z <- pointsToEllipsoid(X, SIG, mu)
#' test <- ellipseInOut(Z, p = 0.95)
#' plot(X, col = test + 1, xlim = c(-3, 3), ylim = c(-3, 3), asp = 1)
#' addEllipse(mu, SIG, p.interval = 0.95)
#' 
#' @export

pointsToEllipsoid <- function(X, Sigma, mu){
  
  # ----------------------------------------------------------------------------
  # some input checking
  
  # check Sigma is a square matrix
  if(ncol(Sigma) != nrow(Sigma)) stop("Sigma must be a square matrix")
  
  # check X matches Sigma
  if(ncol(X) != ncol(Sigma)) stop("number of columns in X must 
                                  be of same dimension as Sigma")
  
  # check mu matches Sigma
  if(length(mu) != ncol(Sigma)) stop("length of mu must 
                                  be of same dimension as Sigma")
  
  # ----------------------------------------------------------------------------
  
  # eigen values and vectors of the covariance matrix
  eig <- eigen(Sigma)
  
  # inverse of sigma
  SigSqrt = eig$vectors %*% diag(sqrt(eig$values)) %*% t(eig$vectors)
  
  # transform the points
  Z <- t(apply(X, 1, ellipsoidTransform, SigSqrt, mu))
  
  return(Z)
  
  
}