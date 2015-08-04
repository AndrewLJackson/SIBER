extract.posterior.means <- function (siber, post) {
  
  # function to extract the posterior means from a call to siber.MVN which can
  # then be used to calculate bayesian layman metrics
  
  # community / group naming 
  tmp.names <- unique(paste(siber$original.data[,"community"],
                            siber$original.data[,"group"],
                            sep=".")
                      )
  
  n.samps <- nrow(post[[1]])
  
  post.means <- list()
  
  ct <- 1 # a counter
  
  for (k in 1:siber$n.communities) {
    
    # create the (n.samp x 2 x n.groups) array
    group.mu <- array(NA, dim=c(n.samps, 2, siber$n.groups[2,k]), 
                      dimnames = list(NULL,
                                      c("mu.x","mu.y"),
                                      paste("group", 
                                            1:siber$n.groups[2,k], 
                                            sep = "")
                                      )
                      )
    
    for (j in 1:siber$n.groups[2,k]) {
      
      group.mu[,,j] <- post[[ct]][,5:6]
      
      ct <- ct + 1 # update the counter
      
    }
    
    post.means[[k]] <- group.mu
    
  }
  
  return(post.means)
                            
}