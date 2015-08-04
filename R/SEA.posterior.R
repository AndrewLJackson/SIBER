SEA.posterior <- function (post) {
  
  # Function to calculate the SEA based on a posterior distribution of Sigma
  
  
  Nobs <- nrow(post)
  
  SEA.B <- numeric(Nobs) 
  
  # loop over all posterior draws
  for (i in 1:Nobs) {
    
    # extract the covariance matrix parameters
    estS <- post[i, 1:4]
    
    # reshape to matrix of 2x2
    dim(estS) <- c(2, 2)
    
    # calculate the corresponding standard ellipse area
    SEA.B[i] <- popSEA(estS)$SEA
    
  } # end loop over posterior draws
  
  
  return(SEA.B)

}
