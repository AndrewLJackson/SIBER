bayesian.layman <- function(mu.post) {
  
  
  nr <- dim(mu.post[[1]])[1]
  
  layman.B <- list()

  
  # loop over communities
  for (k in 1:length(mu.post)) {
    
    
    layman.B[[k]] <- matrix(NA, nrow = nr, ncol = 6) 
    
    
    # AJ - IM PRETTY SURE THESE ARE NO LONGER REQUIRED
    # some vectors to store layman metrics
#     dNr <- numeric(nr)
#     dCr <- numeric(nr)
#     TA <- numeric(nr)
#     CD <- numeric(nr)
#     MNND <- numeric(nr)
#     SDNND <- numeric(nr)
    
    
    for (i in 1:nr) {
      
      layman <- laymanmetrics(mu.post[[k]][i,1,], mu.post[[k]][i,2,])
      
      layman.B[[k]][i,] <- layman$metrics
      
    }
    
    
  # add in the column names
    colnames(layman.B[[k]]) <- names(layman$metrics)
    
  }
  
  return(layman.B)
}



