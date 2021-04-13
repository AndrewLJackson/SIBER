#' Calculate the Bayesian Standard Ellipse Area for all groups
#' 
#' This function loops over each group within each community and calculates the 
#' posterior distribution describing the corresponding Standard Ellipse Area.
#' 
#' @param corrected.posteriors the Bayesian ellipses as returned by
#'   \code{\link{siberMVN}}.
#'   
#' @return A matrix of with each column containing the posterior estimates of 
#'   the SEA.
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
