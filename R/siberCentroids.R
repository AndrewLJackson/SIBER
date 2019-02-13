#' Calculate the polar form of the vector between pairs of ellipse centroids
#' 
#' This function loops over each group within each community and calculates the 
#' vector in polar form between the estimated centroids of each ellipse to each 
#' other ellipse.
#' 
#' @param corrected.posteriors the Bayesian ellipses as returned by 
#'   \code{\link{siberMVN}}.
#'   
#' @return A list containing two arrays, one \code{r} contains the pairwise 
#'   distances between ellipse centroids in as the first two dimensions, with 
#'   the third dimension containing the same for each posterior draw defining 
#'   the ellipse. The second array \code{theta} has the same structure and
#'   contains the angle in radians (from 0 to 2*pi) between the pairs. A third
#'   object \code{labels} refers to  which community.group combination is in
#'   each of the first two dimensions of the arrays.
#' @export

siberCentroids <- function (corrected.posteriors) {
  
  # prep a list for storing the results  
  centroids <- list()

  n.ellipses <- length(corrected.posteriors)
  
  n.draws <- nrow(corrected.posteriors[[1]])
  
  # prep the three matrices
  r      <- array(0, dim = c(n.ellipses, n.ellipses, n.draws))
  theta  <- r
  labels <- array("NA", dim = c(n.ellipses, n.ellipses))
  
  # loop over pairs of ellipses to calculate the vectors between their centroids
  # we can just do one half of the pair-wise matrix for efficiency
  for (i in 1:(n.ellipses-1)){
    
    for (j in (i+1):(n.ellipses)){
      
      # store the labels of the comparisons
      labels[i,j] <- paste(names(corrected.posteriors[i]),
                           names(corrected.posteriors[j]),
                           sep = "|")
      
      labels[j,i] <- paste(names(corrected.posteriors[j]),
                           names(corrected.posteriors[i]),
                           sep = "|")
      
      # extract x and y for the ith ellipse
      x1 <- corrected.posteriors[[i]][,5]
      y1 <- corrected.posteriors[[i]][,6]
      
      # extract x and y for the jth ellipse
      x2 <- corrected.posteriors[[j]][,5]
      y2 <- corrected.posteriors[[j]][,6]
      
      # distances are symmetrical
      r[j,i,] <- r[i,j,] <-  sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
      
      # angles are in opposite directions for each comparison
      
      # upper triangle for angle with first ellipse moved to the origin
      theta[i,j,] <- atan2(y2-y1, x2-x1)
      
      # lower triangle for angle with second ellipse moved to origin
      theta[j,i,] <- atan2(y1-y2, x1-x2)
      
    }
    
  }
  
  # bundle the arrays for output
  centroids$r      <- r
  centroids$theta  <- theta
  centroids$labels <- labels
  
  return(centroids)
}
