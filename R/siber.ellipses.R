#' Calculate the point estimates of the Layman metrics for each community
#' 
#' This function loops over each community, determines the centre of mass 
#' (centroid) of each of the groups comprising the community using the basic 
#' \code{\link{mean}} function independently on the marginal x and y vectors,
#' and calculates the corresponding 6 Layman metrics based on these points.
#' 
#' @param siber a siber object as created by create.siber.object.R
#' 
#' @return A 6 x m matrix of the 6 Layman metrics of dX_range, dY_range, TA, 
#' CD, MNND and SDNND in rows, for each community by column
#' 
#' @examples
#' data(demo.siber.data)
#' my.siber.data <- create.siber.object(demo.siber.data)
#' community.metrics.ML(my.siber.data)

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
