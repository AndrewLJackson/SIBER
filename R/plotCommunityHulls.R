#' Adds convex hulls to each community to an existing plot  
#' 
#' This function loops over each community and plots the convex hull
#' based on the centres of each of the groups that make up the community. See 
#' the demonstration scripts for example implementation.
#' 
#' @param siber a siber object as created by createSiberObject.R
#' @param plot.args a list of plotting arguments with the following suggested, 
#'   but non-exhaustive inputs. Additional plotting arguments for passing to the
#'   internal call to \code{\link[graphics]{plot}} can either be specified here,
#'   or as additional arguments under the \code{...} method.
#'  \itemize{
#'    \item{col}{ the color of the lines of the convex hull. See 
#'    \code{\link[graphics]{lines}} for more details.}
#'    \item{lty}{ the line type of the convex hull.See 
#'    \code{\link[graphics]{lines}} for more details.}
#'    \item{lwd}{ the line width of the convex hulls. See 
#'    \code{\link[graphics]{lines} for more details.}}
#'  }
#' @param iso.order a vector of length 2, either c(1,2) or c(2,1). The order 
#'   determines which of the columns of raw data are plotted on the x (1) or y 
#'   (2) axis. N.B. this will be deprecated in a future release, and plotting 
#'   order will be achieved at point of data-entry.
#' @param ... additional arguments for passing to \code{\link[graphics]{plot}}.
#'   
#' @return Convex hulls, drawn as lines on an existing figure.
#' @export


plotCommunityHulls <- function(siber, 
                                 plot.args = list(col = 1, lty = 2),
                                 iso.order = c(1,2),
                                 ...) {
  x <- iso.order[1]
  y <- iso.order[2]
  
  for (i in 1:siber$n.communities) {
    
    # only attempt to draw hulls if there are more than 2 groups
    if (siber$n.groups[2,i] > 2) {
      ch <- siberConvexhull( siber$ML.mu[[i]][1,x,] ,
                              siber$ML.mu[[i]][1,y,] 
                              )
      
      
      # use do.call to pass the list containing the plotting arguments
      # onwards. Need to add plot.args back in here. If it takes NULL
      # then the plotting does not happen
      do.call('lines',
              c(list(x = ch$xcoords, 
                     y = ch$ycoords), 
                plot.args)
              ) # end of do.call
      
    } # end of if statement
  } # end of loop over communities
} # end of function