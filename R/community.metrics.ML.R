# function to calculate the point estimates of the various Layman metrics
# for comparing among communities. This is not the same as the function for
# the corresponding Bayesian estimates of these same metrics. The values
# returned by this function are just the point estimates based on the 
# maximum likelihood estimates of the underlying statistics.

community.metrics.ML <- function(siber) {
  
  out <- matrix(NA, nrow = 6,  ncol = siber$n.communities,
                dimnames = list(c("dY_range", "dX_range",
                                  "TA", "CD", "MNND", "SDNND"), 
                                paste("community", 
                                      1:siber$n.communities, sep = "")
                                )
                )
  
  for (i in 1:siber$n.communities){
    
    tmp <- laymanmetrics(siber$ML.mu[[i]][1,1,] ,
                  siber$ML.mu[[i]][1,2,])
    
      
  out[,i] <- tmp$metrics
  }
  
  return(out)
  
}
  

