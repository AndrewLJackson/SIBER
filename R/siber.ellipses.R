siber.ellipses <- function (siber, parms, priors) 
{
  
  
  # NB in all cases, fitting is performed on mean centred, sd standardised
  # transformation to the data. Code at the end then back-transforms the
  # covariance matrix and location of the ellipse for downstream plotting
  # and calculation of the SEA.
  
  
  # ? NO LONGER NEEDED AS SEA WILL BE CALCULATED AFTER THIS FUNCTION IS CALLED
  # prep the matrix to collect posterior samples of the SEA measures
  #n.samps <- parms$n.chains * (parms$n.iter - parms$n.burnin) / parms$n.thin
  #SEA.B <- matrix(data = 0, nrow = n.samps, ncol = ngroups)
  
  
  
  # creat the SIBER ellipse object to be returned by this function
  siber.posterior <- list()
  
  # loop over communities
  for (k in 1:siber$n.communities) {
    
    # loop over groups within each community
    for (j in 1:siber$ngroups[2,k]) {
      
      grp.j <- siber$zscore.data[,"group"] == j
      
      x.zscore <- siber$zscore.data[[k]][grp.j, 1]
      y.zscore <- siber$zscore.data[[k]][grp.j, 2]
      
      
      # fit the ellipses to each group in the dataset
      model <- fit.ellipses(x.zscore,y.zscore,parms,priors)
      
      
      # after fitting, scale the covariance matrix back to the original
      # raw data.
      
      # first the two diagonal variances
      model$S[,1] <- model$S[,1] * siber$ML.cov[[k]][1,1,j]
      model$S[,4] <- model$S[,4] * siber$ML.cov[[k]][2,2,j]
      
      # then the covariances
      model$S[,2] <- (model$S[,2] * 
                        siber$ML.cov[[k]][1,1,j] ^ 0.5 * 
                        siber$ML.cov[[k]][2,2,j] ^ 0.5)
      model$S[,3] <- model$S[,2] # off-diagonals are the same
      
      # now correct the means        
      model$mu[,1] <- model$mu[,1] + siber$ML.cov[[k]][1,1,j]
      model$mu[,2] <- model$mu[,2] + siber$ML.cov[[k]][1,2,j]
      
      # -- START --
      # This code snippet calculates the actual SEA
      # Think i might move this out of the MVN fitting
      # process to keep the code cleaner here.
      #print(dim(model$mu))
      #print(dim(model$S))
  #     Nobs <- nrow(model$mu)
  #     for (i in 1:Nobs) {
  #       estS <- model$S[i, ]
  #       dim(estS) <- c(2, 2)
  #       SEA.B[i, j] <- popSEA(estS)$SEA
  #     }
      
      # THE POSTERIORS HAVE TO BE ADDED INTO THE SIBER OBJECT AND RETURNED
      # I NEED TO CHECK TO SEE IF S3 CLASSES MEAN I DONT HAVE TO PASS IN AND OUT
      # THE SAME OBJECT EACH TIME WHICH IS WASTEFUL.
      siber.posterior[[k]][[j]] <- model
      
    }
}
  
  
  return(siber.posterior)
}