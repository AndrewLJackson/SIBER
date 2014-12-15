plot.siber.object <- function(siber, iso.order = c(1,2), 
                              ax.pad = 1, hulls = T, ellipses = T,
                              group.hulls = F, bty = "L", ...){

  x <- iso.order[1]
  y <- iso.order[2]

  with(siber,{

    # set up a blank plot
  	plot(0, 0, type = "n",
  		       xlim = c(siber$iso.summary["min", x] - ax.pad , 
  		       	        siber$iso.summary["max", x] + ax.pad ),
  		       ylim = c(siber$iso.summary["min", y] - ax.pad , 
  		       	        siber$iso.summary["max", y] + ax.pad ),
             ylab = paste('iso', y, sep = ""), 
             xlab = paste('iso', x, sep = ""), 
             bty = bty
             
  		)

    
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
      for (i in 1:siber$n.communities){
  
        # only attempt to draw hulls if there are more than 2 groups
        if (siber$n.groups[2,i] > 2) {
        	ch <- siber.convexhull( siber$ML.mu[[i]][1,1,] ,
        		                      siber$ML.mu[[i]][1,2,] 
                                  )
    
        	lines(ch$xcoords, ch$ycoords, col = "black")
        }
      }
    } # end of if statement for community convex hull drawing

    # --------------------------------------------------------------------------
    # Add a ML ellipse to each group
    # --------------------------------------------------------------------------
    if (ellipses) {
      for (i in 1:siber$n.communities){
  
          for (j in 1:siber$n.groups[2,i]){
          	add.ellipse(siber$ML.mu[[i]][,,j],
          		               siber$ML.cov[[i]][,,j],
          		               col = j, ...)
          }
      	
      }
    } # end of if statement for ellipse drawing
    
  	# --------------------------------------------------------------------------
  	# Add convex hulls to each group here
  	# --------------------------------------------------------------------------
    if (group.hulls){
      # code similar to group ellipses to go here
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
          lines(ch$xcoords, ch$ycoords, col = j)
        }
        
      }
    } # end of if statement for group hull drawing
    
  }) # end of with() function




	
} # end function