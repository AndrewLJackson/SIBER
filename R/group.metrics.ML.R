# function to calculate ML-based metrics on each group:
# Hull Total Area, SEA, and SEAc

group.metrics.ML <- function(siber, plot.args = NULL, iso.order = c(1,2),
                                ...){
  
  # prepare a matrix for storing the results.
  # Each column is a group. Each row a different metric
  
  # community / group naming 
  tmp.names <- unique(paste(siber$original.data[,"community"],
                            siber$original.data[,"group"],
                            sep=".")
                      )
  
  out <- matrix(NA, nrow = 3, ncol = sum(siber$n.groups[2,]),
                dimnames = list(c("TA", "SEA", "SEAc"), tmp.names)
                )
  
  cnt <- 1
  
  for (i in 1:siber$n.communities){
    
    for (j in 1:siber$n.groups[2,i]){
      
      # ------------------------------------------------------------------------
      # Calculate the SEA and SEAc on the jth group in the ith community
      tmp.SEA <- sigma.SEA(siber$ML.cov[[i]][,,j])
      
      out["SEA", cnt] <- tmp.SEA$SEA
      
      # extract the sample size for this group
      n <- siber$sample.sizes[i,j]
      
      out["SEAc", cnt] <- tmp.SEA$SEA * (n - 1) / ( n - 2) 
      
      
      # ------------------------------------------------------------------------
      # calculate the hull area around the jth group in the 
      # ith community
      # find the indices for the jth group
      idx <- siber.example$raw.data[[i]]$group == j
      
      ch <- siber.convexhull( siber.example$raw.data[[i]][idx, 1], 
                              siber.example$raw.data[[i]][idx, 2])
                              
      out["TA",cnt] <- ch$TA
      
      # update the counter to keep track of which column we are in.
      cnt <- cnt + 1
      
    }
    
  }
  return(out)
}