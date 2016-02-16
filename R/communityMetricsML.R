#' Calculate the point estimates of the Layman metrics for each community
#' 
#' This function loops over each community, determines the centre of mass 
#' (centroid) of each of the groups comprising the community using the basic 
#' \code{\link[base]{mean}} function independently on the marginal x and y vectors,
#' and calculates the corresponding 6 Layman metrics based on these points.
#' 
#' @param siber a siber object as created by createSiberObject.R
#' 
#' @return A 6 x m matrix of the 6 Layman metrics of dX_range, dY_range, TA, 
#' CD, MNND and SDNND in rows, for each community by column
#' 
#' @examples
#' data(demo.siber.data)
#' my.siber.data <- createSiberObject(demo.siber.data)
#' communityMetricsML(my.siber.data)
#' 
#' @export

communityMetricsML <- function(siber) {
  
  out <- matrix(NA, nrow = 6,  ncol = siber$n.communities,
                dimnames = list(c("dY_range", "dX_range",
                                  "TA", "CD", "MNND", "SDNND"), 
                                siber$all.communities
                                )
                )
  
  for (i in 1:siber$n.communities){
    
    tmp <- laymanMetrics(siber$ML.mu[[i]][1,1,] ,
                  siber$ML.mu[[i]][1,2,])
    
      
  out[,i] <- tmp$metrics
  }
  
  return(out)
  
}
  

