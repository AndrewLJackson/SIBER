#' Calculate maximum likelihood based measures of dispersion of bivariate data
#' 
#' This function loops over each group within each community and calculates the 
#' convex hull total area, Standard Ellipse Area (SEA) and its corresponding 
#' small sample size corrected version SEAc based on the maximum likelihood 
#' estimates of the means and covariance matrices of each group.
#' 
#' @param siber a siber object as created by createSiberObject.
#' 
#' @return A 3 x m matrix of the 6 Layman metrics of dX_range, dY_range, TA, 
#' CD, MNND and SDNND in rows, where each column is a different group nested
#' within a community.
#' 
#' @examples
#' data(demo.siber.data)
#' my.siber.data <- createSiberObject(demo.siber.data)
#' groupMetricsML(my.siber.data)
#' 
#'  @export

groupMetricsML <- function(siber){
  
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
      tmp.SEA <- sigmaSEA(siber$ML.cov[[i]][,,j])
      
      out["SEA", cnt] <- tmp.SEA$SEA
      
      # extract the sample size for this group
      n <- siber$sample.sizes[i,j]
      
      out["SEAc", cnt] <- tmp.SEA$SEA * (n - 1) / ( n - 2) 
      
      
      # ------------------------------------------------------------------------
      # calculate the hull area around the jth group in the 
      # ith community
      # find the indices for the jth group
      idx <- siber$raw.data[[i]]$group == j
      
      ch <- siberConvexhull( siber$raw.data[[i]][idx, 1], 
                              siber$raw.data[[i]][idx, 2])
                              
      out["TA",cnt] <- ch$TA
      
      # update the counter to keep track of which column we are in.
      cnt <- cnt + 1
      
    }
    
  }
  return(out)
}