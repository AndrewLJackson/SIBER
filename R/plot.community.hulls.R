# function to loop over the communities, and add lines connecting the convex
# hull defined by the centres of each of their component groups.

plot.community.hulls <- function(siber, 
                                 plot.args = list(col = 1, lty = 2),
                                 iso.order = c(1,2),
                                 ...){
  x <- iso.order[1]
  y <- iso.order[2]
  
  for (i in 1:siber$n.communities){
    
    # only attempt to draw hulls if there are more than 2 groups
    if (siber$n.groups[2,i] > 2) {
      ch <- siber.convexhull( siber$ML.mu[[i]][1,x,] ,
                              siber$ML.mu[[i]][1,y,] 
                              )
      
      
      # use do.call to pass the list containing the plotting arguments
      # onwards. Need to add plot.args back in here. If it takes NULL
      # then the plotting does not happen
#       lines(ch$xcoords, ch$ycoords)
      do.call('lines',
              c(list(x = ch$xcoords, 
                     y = ch$ycoords), 
                plot.args)
      ) # end of do.call
      
    }
  }
}