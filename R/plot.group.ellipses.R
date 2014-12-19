# function to add ellipses to each group

plot.group.ellipses <- function(siber, plot.args = NULL, iso.order = c(1,2),
                                ...){
  
  # iso.order is used to relocate and reorientate the covariance matrix
  # in the call to add.ellipse below.
  x <- iso.order[1]
  y <- iso.order[2]
  
  for (i in 1:siber$n.communities){
    
    for (j in 1:siber$n.groups[2,i]){
      
      do.call('add.ellipse',
                c(list(mu = siber$ML.mu[[i]][,c(x,y),j],
                     sigma = siber$ML.cov[[i]][c(x,y),c(x,y),j]),
                     plot.args,
                     col = j,
                     ...))
#       add.ellipse(siber$ML.mu[[i]][,,j],
#                   siber$ML.cov[[i]][,,j],
#                   col = j, ...)
    }
    
  }
}