
plot.siber.object <- function(siber, 
                              iso.order = c(1,2), 
                              ax.pad = 1,
                              hulls = T, community.hulls.args = NULL, 
                              ellipses = T, group.ellipses.args = NULL,
                              group.hulls = F, group.hulls.args = NULL,
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
      plot.community.hulls(siber, community.hulls.args, iso.order)
    } # end of if statement for community convex hull drawing

    # --------------------------------------------------------------------------
    # Add a ML ellipse to each group
    # --------------------------------------------------------------------------
    if (ellipses) {
      plot.group.ellipses(siber, group.ellipses.args, iso.order)
    } # end of if statement for ellipse drawing
    
  	# --------------------------------------------------------------------------
  	# Add convex hulls to each group here
  	# --------------------------------------------------------------------------
    if (group.hulls){
      # code similar to group ellipses to go here
      plot.group.hulls(siber, group.hull.args, iso.order)
    } # end of if statement for group hull drawing
    
  }) # end of with() function




	
} # end function