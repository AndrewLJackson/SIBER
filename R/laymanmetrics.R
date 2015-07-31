# NOTE - i have changed the name of dN_range to dY_range and 
#  dC_range to dX_range to make it more generic.

laymanmetrics <- function(x,y){

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
  hull <- siber.convexhull(x,y)

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
  metrics[6] <- sd(NNDs)

  # --------------------------------------
  out$metrics <- metrics
  out$hull <- hull #output additional information on the hull
  
  return(out)

}