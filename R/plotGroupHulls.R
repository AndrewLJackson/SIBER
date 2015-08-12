#' Plots illustrative convex hulls for each group within all communities
#' 
#' This function loops over each community and group within, and plots a 
#' convex hull around the data. N.B. use of convex hulls to compare isotopic 
#' niche width among groups within or between communities is not recommended 
#' owing to strong sample size bias. Use of ellipse area is recommended instead. 
#' This feature is provided for illustrative purposes only, and because some 
#' people have expressed a desire for this feature for figure generation. See 
#' demonstration scipts for more examples.
#' 
#' @param siber a siber object as created by createSiberObject
#' @param plot.args a list of plotting arguments for passing to 
#'   \code{\link[graphics]{lines}}. See \code{\link[graphics]{lines}} for
#'   details of the options. See also the demonstration scripts for examples of
#'   use.
#' @param iso.order a vector of length 2, either \code{c(1,2)} or \code{c(2,1)}.
#'   The order determines which of the columns of raw data are plotted on the x
#'   (1) or y (2) axis. N.B. this will be deprecated in a future release, and
#'   plotting order will be acheived at point of data-entry.
#'   
#' @return A series of convex hulls added to an existing plot.
#' @export


plotGroupHulls <- function(siber, plot.args = NULL, iso.order = c(1,2)) {
  
  # iso.order used to specify which data goes on which axis.
  x <- iso.order[1]
  y <- iso.order[2]
  
  for (i in 1:siber$n.communities){
    
    for (j in 1:siber$n.groups[2,i]){
      
      # find the indices for the jth group
      idx <- siber$raw.data[[i]]$group == j
      
      # calculate the hull around the jth group in the 
      # ith community
      ch <- siberConvexhull( siber$raw.data[[i]][idx, x], 
                              siber$raw.data[[i]][idx, y]
      )
      
      # add the lines
      do.call('lines', c(list(x = ch$xcoords, y = ch$ycoords), plot.args))

    }
    
  }
}