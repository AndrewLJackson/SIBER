plot.group.hulls <- function (siber, plot.args = NULL, iso.order = c(1,2)){
  
  # iso.order used to specify which data goes on which axis.
  x <- iso.order[1]
  y <- iso.order[2]
  
  for (i in 1:siber$n.communities){
    
    for (j in 1:siber$n.groups[2,i]){
      
      # find the indices for the jth group
      idx <- siber.example$raw.data[[i]]$group == j
      
      # calculate the hull around the jth group in the 
      # ith community
      ch <- siber.convexhull( siber.example$raw.data[[i]][idx, x], 
                              siber.example$raw.data[[i]][idx, y]
      )
      
      # add the lines
      do.call('lines', c(list(x = ch$xcoords, y = ch$ycoords), plot.args))
#       lines(ch$xcoords, ch$ycoords, col = j)
    }
    
  }
}