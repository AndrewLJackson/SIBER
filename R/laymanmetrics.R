#' Calculates the 6 Layman metrics on a vector of x and y data
#' 
#' This function takes two x and y vectors, and calculates the corresponding 
#' 6 Layman metrics based on these points. Note that for generality, the 
#' original metrics of dC_range and dN_range have been renamed dX_range and 
#' dY_range respectively. These modified names represent the x and y axes in 
#' terms of the order in which the data have been entered, and relate typically
#' to how one plots the data. These x and y vectors could represent the means
#' of the group members comprising a community as is preffered under the SIBER
#' model framework. However, one could use them to calculate the point estimates
#' of the 6 Layman metrics for an entire group of data. In fact, you are free
#' to pass this function any set of \code{x} and \code{y} data you wish.
#' 
#' 
#' @param x a vector of locations in the x-axis direction.
#' @param y a vector of locations in the y-axis direction.
#' 
#' @return A vector of the 6 Layman metrics of dX_range, dY_range, TA, 
#' CD, MNND and SDNND
#' 
#' @examples
#' x <- stats::runif(10)
#' y <- stats::runif(10)
#' laymanMetrics(x, y)
#' 
#' @export

# NOTE - i have changed the name of dN_range to dY_range and 
#  dC_range to dX_range to make it more generic.

laymanMetrics <- function(x,y){

  out <- list()
  
  metrics <- double(length=6)
  names(metrics) <- c("dY_range","dX_range",
                      "TA","CD","NND","SDNND")

  # --------------------------------------
  # Layman metric # 1 - dN range
  metrics[1] <- max(y) - min(y)

  # --------------------------------------
  # Layman metric # 2 - dC range
  metrics[2] <- max(x) - min(x)

  # --------------------------------------
  # Layman metric #3 - area of convex hull
  # some convex hull stuff
  # NOTE - should add a condition ehre that only calls this if there are more
  #   than 2 groups.
  hull <- siberConvexhull(x,y)

  metrics[3] <- hull$TA
  
  # --------------------------------------
  # Layman metric # 4 - mean distance to centroid CD
  mean_y <- mean(y)
  mean_x <- mean(x)

  metrics[4] <- mean( ( (mean_x - x)^2 + (mean_y - y)^2 ) ^ 0.5 )

  # --------------------------------------
  # Layman metric # 5 - mean nearest neighbour distance NND
  NNDs <- numeric(length(x))
  for (j in 1:length(x)){
    tmp <- ( (x[j] - x)^2 + (y[j] - y)^2 ) ^ 0.5
    tmp[j] <- max(tmp)
    NNDs[j] <-   min(tmp)
  }

  metrics[5] <- mean(NNDs)

  # --------------------------------------
  # Layman metric # 6 - standard deviation of nearest neighbour distance SDNND
  metrics[6] <- stats::sd(NNDs)

  # --------------------------------------
  out$metrics <- metrics
  out$hull <- hull #output additional information on the hull
  
  return(out)

}