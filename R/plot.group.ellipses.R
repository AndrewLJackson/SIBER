#' Adds ellipses to an existing plot for each of your groups 
#' 
#' This function loops over each community and group within, and plots an 
#' ellipse around the data. See demonstration scipts for more examples.
#' 
#' @param siber a siber object as created by create.siber.object.R
#' @param plot.args a list of plotting arguments for passing to 
#' \code{\link{add.ellipse}}. See \code{\link{add.ellipse}} for details of the 
#' options, and you can also pass additional arguments such as line widths
#' and styles. See also the demonstration scripts for examples of use.
#' @param iso.order a vector of length 2, either c(1,2) or c(2,1). The order 
#'   determines which of the columns of raw data are plotted on the x (1) or y
#'   (2) axis. N.B. this will be deprecated in a future release, and plotting 
#'   order will be acheived at point of data-entry.
#' @param ... additional arguments to be passed to \code{\link{add.ellipse}}.
#' 
#' @return Ellipses, drawn as lines on an existing figure.
#' 



plot.group.ellipses <- function(siber, plot.args = list(), iso.order = c(1,2),
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
                       m = siber$sample.sizes[i,j],
                       plot.args,
                       col = j,
                       ...))
      
#       add.ellipse(siber$ML.mu[[i]][,,j],
#                   siber$ML.cov[[i]][,,j],
#                   col = j, ...)
    }
    
  }
}