#' Calculate the pairwise distances and angles describing the difference between
#' centroids of paired groups
#' 
#' Plots the posterior densities
#' 
#' @param centroids the list containing distance and angle matrices as returned 
#'   by [siberCentroids()].
#' @param do.these a character vector of the pattern used to find paired matches in
#'   the matrix of all comparisons. Usually the group names within any of the 
#'   communities.
#' @param upper a logical determining whether to plot the upper or lower 
#'   triangle of angles. Defaults to TRUE which is the upper triangle and 
#'   returns the angle from the second ellipse to the first by centering on the 
#'   first centroid.
#' @param do.plot a logical indicating whether plotting should be done or not. 
#'   Defaults to TRUE.
#' @param ... additional arguments to pass onwards, not currently implemented.
#'   
#' @return A nice plot. You can get the corresponding matrices used to generate 
#'   the plots if you ask for it nicely: thedata <- 
#'   plotCentroidVectors(centroids)
#' @importFrom magrittr %>%
#' 
#' @export
# magrittr::`%>%`

specificCentroidVectors <- function (centroids, do.these, upper = TRUE, 
                                   do.plot = TRUE, ...) {
  
  # appease CRAN checks
  comparison <- NULL
  
  # how big is the data array
  dd <- dim(centroids$r)
  
  # find the names that match
  idx <- centroids$labels %in% do.these
  
  matrix.idx <- matrix(FALSE, dd[1], dd[2])
  matrix.idx[idx] <- TRUE
  
    
  # number of pairwise comparisons
  n.comp <- length(do.these)
  
  # prep the matrices for passing to the plotting function
  angles <- distances <- matrix(0, dd[3], n.comp)
  
  new.names <- rep("NA", n.comp)
  
  # loop and extract the data in to the matrix
  # AJ - I NEED TO IMPLEMENT A SWITCH FOR THE LOWER TRIANGLE FOR ANGLES
  
  ct <- 1 # a counter
  
  for (i in 1:dd[1]){
    
    for (j in 1:dd[2]){
      
      if (matrix.idx[i,j]){
        
        distances[,ct] <- centroids$r[i,j,]
        
        angles[,ct] <- centroids$theta[i,j,]
        
        new.names[ct]<- centroids$labels[i,j]
        
        ct <- ct + 1
        
      } # end of if statement
      
      
      
    } # end j loop
  } # end i loop
  
  
  # browser()
  colnames(distances) <- new.names
  colnames(angles)    <- new.names
  
  if(do.plot){
    siberDensityPlot(distances)
    siberDensityPlot(angles)
  }
  
  
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
