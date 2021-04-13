#' Plot the pairwise distances and angles describing the difference between 
#' centroids of all groups
#' 
#' Plots the posterior densities
#' 
#' @param centroids the list containing distance and angle matrices as returned 
#'   by \code{\link{siberCentroids}}.
#' @param upper a logical determining whether to plot the upper or lower 
#'   triangle of angles. Defaults to TRUE which is the upper triangle and 
#'   returns the angle from the second ellipse to the first by centering on the 
#'   first centroid.
#' @param do.plot a logical indicating whether plotting should be done or not.
#'   Defaults to TRUE.
#' @param ... additional arguments to pass onwards, not currently implemented.
#'   
#' @return A nice plot. You can get the corresponding matrices used to generate 
#'   the plots if you ask for it nicely: the_data <- 
#'   plotCentroidVectors(centroids)
#'   
#' @importFrom magrittr %>%
#' 
#' @export
# magrittr::`%>%`

allCentroidVectors <- function (centroids, upper = TRUE, do.plot = TRUE, ...) {
  
  # appease CRAN checks
  comparison <- NULL
  
  dd <- dim(centroids$r)
  
  # number of pairwise comparisons
  n.comp <- ((dd[1] ^ 2) - dd[1]) / 2
  
  # prep the matrices for passing to the plotting function
  angles <- distances <- matrix(0, dd[3], n.comp)
  
  new.names <- rep("NA", n.comp)
  
  # loop and extract the data in to the matrix
  # AJ - I NEED TO IMPLEMENT A SWITCH FOR THE LOWER TRIANGLE FOR ANGLES
  
  ct <- 1 # a counter
  
  for (i in 1:(dd[1] - 1 )){
    
    for (j in (i+1):dd[1]){
      
      distances[,ct] <- centroids$r[i,j,]
      
      if(upper) {angles[,ct] <- centroids$theta[i,j,]}
      
      if(!upper) {angles[,ct] <- centroids$theta[j,i,]}
      
      
      new.names[ct]<- centroids$labels[i,j]
      
      ct <- ct + 1
      
    }
    
    
    
  }
  
  colnames(distances) <- new.names
  colnames(angles)    <- new.names
  
  if(do.plot){
    siberDensityPlot(distances)
    siberDensityPlot(angles)
  }
  
  # browser()
  
  # convert from wide to long format
  long_data_angles <- tidyr::gather(data.frame(angles),
                             key = comparison, value = angles)
  
  long_data_distances <- tidyr::gather(data.frame(distances),
                                key = comparison, value = distances)
  
  angles_distances <- long_data_angles
  angles_distances$distances <- long_data_distances$distances
  
  
  # return if asked
  invisible(angles_distances)
  
  
}
