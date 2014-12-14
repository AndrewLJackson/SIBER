plot.siber.object <- function(siber, iso.order = c(1,2), ...){

  x <- iso.order[1]
  y <- iso.order[2]

  with(siber,{

    # set up a blank plot
  	plot(0, 0, type = "n",
  		       xlim = c(siber$iso.summary["min", x], 
  		       	        siber$iso.summary["max", x]),
  		       ylim = c(siber$iso.summary["min", y], 
  		       	        siber$iso.summary["max", y])
  		)

    
    for (i in 1:siber$n.communities){

    	points(siber$raw.data[[i]][,x], 
    		   siber$raw.data[[i]][,y], 
    		   col = siber$raw.data[[i]]$group, 
    		   pch = i)
    	
    }



    # --------------------------------------------------------------------------
    # Add a convex hull between the means of each group
    # I might move this out block to its own function in the future
    # --------------------------------------------------------------------------
    for (i in 1:siber$n.communities){

    	ch <- siber.convexhull(siber$ML.mu[[i]][1,1,],
    		                   siber$ML.mu[[i]][1,2,])

    	lines(ch$xcoords, ch$ycoords)
    	
    }

    # --------------------------------------------------------------------------
    # Add a ML ellipse to each group
    # --------------------------------------------------------------------------
    for (i in 1:siber$n.communities){

        for (j in 1:siber$n.groups[2,i]){
        	plot.sigma.ellipse(siber$ML.mu[[i]][,,j],
        		               siber$ML.cov[[i]][,,j], 
        		               col = j, lty = 1, lwd = 1)
        }
    	
    }
  	
  }) # end of with() function




	
} # end function