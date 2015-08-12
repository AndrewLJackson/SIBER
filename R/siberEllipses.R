#' Calculate the point estimates of the Layman metrics for each community
#' 
#' This function loops over each community, determines the centre of mass 
#' (centroid) of each of the groups comprising the community using the basic 
#' \code{\link[base]{mean}} function independently on the marginal x and y vectors,
#' and calculates the corresponding 6 Layman metrics based on these points.
#' 
#' @param corrected.posteriors the Bayesian ellipses as fitted to z-score 
#' transformed data returned by \code{\link{siberMVN}}.
#' 
#' @return A matrix of with each column representing a unique community.group 
#' combination, and each row an independent posterior estimate of the 
#' Standard Ellipse Area SEA_B.
#' 
#' @export

siberEllipses <- function (corrected.posteriors) {
  
# prep a matrix for storing the results  
  SEA.B <- matrix(NA, 
                  nrow = nrow(corrected.posteriors[[1]]),
                  ncol = length(corrected.posteriors))

  
  for (i in 1:length(corrected.posteriors)){
    tmp <- posteriorSEA(corrected.posteriors[[i]])
    SEA.B[, i] <- tmp
    
  }
  
 return(SEA.B)
}
