<<<<<<< Updated upstream
plot.siber.object <- function(siber, 
                              iso.order = c(1,2), 
                              ax.pad = 1,
                              hulls = T, community.hulls.args = NULL, 
                              ellipses = T, group.ellipses.args = NULL,
                              group.hulls = F, group.hulls.args = NULL,
                              bty = "L", 
                              xlab = "Isotope 1", 
                              ylab = "Isotope 2",
=======
plot.siber.object <- function(siber, iso.order = c(1,2), 
                              ax.pad = 1, hulls = T, ellipses = T,
                              group.hulls = F, bty = "L", 
                              xlab = "x",
                              ylab = "y",
                              las = 1,
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
             xlab = xlab, 
             ylab = ylab, 
             bty = bty
=======
             ylab = ylab,
             xlab = xlab,
             bty = bty,
             las = las
>>>>>>> Stashed changes
             
  		)

    
    # add each of the data points
    for (i in 1:siber$n.communities){

    	points(siber$raw.data[[i]][,x], 
    		   siber$raw.data[[i]][,y], 
    		   col = siber$raw.data[[i]]$group, 
    		   pch = i)
    	
    }

    # ==========================================================================
  	# I might move this plotting block out to their own functions in the future
    # This will be easy since they only require object siber to be passed.
    # It should also make passing arguments specific to each plot-type
    # more straight forward, through this wrapper function and onwards.
    # The challenge is that they should be allowed to take a list of different
    # options for each plot. How best to pass theses on i dont know. 
    # I could just pass in a list, and then un-pack it.
  	# ==========================================================================

    # --------------------------------------------------------------------------
    # Add a convex hull between the means of each group, i.e. a convex hull
    # for the community. Only applicable if there are more than 2 
    # members for a community
    # --------------------------------------------------------------------------
    if (hulls) {
      # NOTE currently not working
      plot.community.hulls(siber, community.hulls.args)
    } # end of if statement for community convex hull drawing

    # --------------------------------------------------------------------------
    # Add a ML ellipse to each group
    # --------------------------------------------------------------------------
    if (ellipses) {
      plot.group.ellipses(siber, group.ellipses.args)
    } # end of if statement for ellipse drawing
    
  	# --------------------------------------------------------------------------
  	# Add convex hulls to each group here
  	# --------------------------------------------------------------------------
    if (group.hulls){
      # code similar to group ellipses to go here
      plot.group.hulls(siber, group.hull.args)
    } # end of if statement for group hull drawing
    
  	# ==========================================================================
    # END OF PLOTTING BLOCK
  	# ==========================================================================
    
  }) # end of with() function




	
} # end function