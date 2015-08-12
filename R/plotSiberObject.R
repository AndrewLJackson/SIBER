#' Creates an isotope biplot and provides a wrapper to ellipse and hull plotting
#' 
#' This function takes a SIBER object as created by 
#' \code{\link{createSiberObject}}, and loops over communities and their 
#' groups, creating a biplot, and adding ellipses and hulls as desired. Ellipses 
#' can be added to groups, while convex hulls can be added at both the group 
#' and community level (the former for illustrative purposes only, with no
#' analytical tools in SIBER to fit Bayesian hulls to individual groups. This is 
#' not mathematically possible in a Bayesian framework.).
#' @param siber a siber object as created by \code{\link{createSiberObject}}.
#' @param ax.pad a padding amount to apply to the x-axis either side of the 
#' extremes of the data. Defaults to 1.
#' @param iso.order a vector of length 2, either c(1,2) or c(2,1). The order 
#'   determines which of the columns of raw data are plotted on the x (1) or y
#'   (2) axis. N.B. this will be deprecated in a future release, and plotting 
#'   order will be acheived at point of data-entry.
#' @param hulls a logical defaulting to TRUE determining whether or not hulls 
#' based on the means of groups within communities should be drawn. That is, a
#' community-level convex hull.
#' @param community.hulls.args a list of plotting arguments to pass to 
#' \code{\link{plotCommunityHulls}}. See \code{\link{plotCommunityHulls}} 
#' for further details.
#' @param ellipses a logical defaulting to TRUE determining whether or not an
#' ellipse should be drawn around each group within each community.
#' @param group.ellipses.args a list of plotting arguments to pass to 
#' \code{\link{plotGroupEllipses}}. See \code{\link{plotGroupEllipses}} for 
#' further details.
#' @param group.hulls a logical defaulting to FALSE determining whether or not
#' convex hulls should be drawn around each group within each community.
#' @param group.hulls.args a list of plotting options to pass to 
#' \code{\link{plotGroupHulls}}. See \code{\link{plotGroupHulls}} for 
#' further details.
#' @param bty a string specifying the box type for the plot. See 
#'   \code{\link[graphics]{par}} for details.
#' @param xlab a string for the x-axis label.
#' @param ylab a string for the y-axis label.
#' @param las a scalar determining the rotation of the y-axis labels. Defaults 
#'   to horizontal with \code{las = 1}. See \code{\link[graphics]{par}} for more
#'   details.
#' @param ... additional arguments to be passed to \code{\link[graphics]{plot}}.
#'   
#' @return An isotope biplot.
#' @export


plotSiberObject <- function(siber, 
                              iso.order = c(1,2), 
                              ax.pad = 1,
                              hulls = TRUE, community.hulls.args = NULL, 
                              ellipses = TRUE, group.ellipses.args = NULL,
                              group.hulls = FALSE, group.hulls.args = NULL,
                              bty = "L", 
                              xlab = "Isotope 1", 
                              ylab = "Isotope 2",
                              las = 1,
                              ...){
  
  # NOTE - this isotope ordering needs to be passed onwards to the plotting
  # functions called below. Im not convinced its that straightforward.
  x <- iso.order[1]
  y <- iso.order[2]
  
  with(siber,{
    
    # set up a blank plot. X and Y limits are set by padding
    # the plot by a fixed amount ax.pad beyond the extremes of 
    # all the data.
    plot(0, 0, type = "n",
         xlim = c(siber$iso.summary["min", x] - ax.pad , 
                  siber$iso.summary["max", x] + ax.pad ),
         ylim = c(siber$iso.summary["min", y] - ax.pad , 
                  siber$iso.summary["max", y] + ax.pad ),
         ylab = ylab,
         xlab = xlab,
         bty = bty,
         las = las
         
    )
    
    
    # add each of the data points
    for (i in 1:siber$n.communities){
      
      points(siber$raw.data[[i]][,x], 
             siber$raw.data[[i]][,y], 
             col = siber$raw.data[[i]]$group, 
             pch = i)
      
    }
    
    
    
    # --------------------------------------------------------------------------
    # Add a convex hull between the means of each group, i.e. a convex hull
    # for the community. Only applicable if there are more than 2 
    # members for a community
    # I might move this out block to its own function in the future
    # --------------------------------------------------------------------------
    if (hulls) {
      plotCommunityHulls(siber, community.hulls.args, iso.order)
    } # end of if statement for community convex hull drawing
    
    # --------------------------------------------------------------------------
    # Add a ML ellipse to each group
    # --------------------------------------------------------------------------
    if (ellipses) {
      plotGroupEllipses(siber, group.ellipses.args, iso.order)
    } # end of if statement for ellipse drawing
    
    # --------------------------------------------------------------------------
    # Add convex hulls to each group here
    # --------------------------------------------------------------------------
    if (group.hulls){
      # code similar to group ellipses to go here
      plotGroupHulls(siber, group.hull.args, iso.order)
    } # end of if statement for group hull drawing
    
  }) # end of with() function
  
  
  
  
  
} # end function