siber.MVN <- function (siber, parms, priors) 
{
  
  
  # NB in all cases, fitting is performed on mean centred, sd standardised
  # transformation to the data. Code at the end then back-transforms the
  # covariance matrix and location of the ellipse for downstream plotting
  # and calculation of the SEA.
  
  
  
  
  
  # create the SIBER ellipse object to be returned by this function
  siber.posterior <- list()

  
  ct <- 1 # a counter
  
  # loop over communities
  for (k in 1:siber$n.communities) {
    
    # loop over groups within each community
    for (j in 1:siber$n.groups[2,k]) {
      
      grp.j <- siber$zscore.data[[k]][,"group"] == j
      
      x.zscore <- siber$zscore.data[[k]][grp.j, 1]
      y.zscore <- siber$zscore.data[[k]][grp.j, 2]
      
      
      # fit the ellipses to each group in the dataset
      model <- fit.ellipse(x.zscore,y.zscore,parms,priors)
      
      corrected.posteriors <- ellipse.back.transform(model, siber, k, j)
      

      
      # THE POSTERIORS HAVE TO BE ADDED INTO THE SIBER OBJECT AND RETURNED
      # I NEED TO CHECK TO SEE IF S3 CLASSES MEAN I DONT HAVE TO PASS IN AND OUT
      # THE SAME OBJECT EACH TIME WHICH IS WASTEFUL.
      siber.posterior[[ct]] <- corrected.posteriors
      
      ct <- ct + 1 # update the counter
      
    }
}
  
  
  # AJ - NEED TO RETURN corrected.posteriors aswell, as this information is
  # required for convex hull estimation, and might be useful to some users
  
  # give the list objects names for easier retrieval
  tmp.names <- unique(paste(siber$original.data[,"community"],
                            siber$original.data[,"group"],
                            sep=".")
  )
  names(siber.posterior) <- tmp.names
  
  # add on the SEA.B estimates
  #siber.posterior$SEA.B <- SEA.B
  return(siber.posterior)
}







