siber.ellipses <- function (corrected.posteriors) {
  
# prep a matrix for storing the results  
  SEA.B <- matrix(NA, 
                  nrow = nrow(corrected.posteriors[[1]]),
                  ncol = length(corrected.posteriors))

  
  for (i in 1:length(corrected.posteriors)){
    tmp <- SEA.posterior(corrected.posteriors[[i]])
    SEA.B[, i] <- tmp
    
  }
  
 return(SEA.B)
}
