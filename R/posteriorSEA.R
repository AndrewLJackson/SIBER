#' Calculate the SEA based on a posterior distribution of Sigma
#' 
#' This function loops over each posterior draw of a single group's 
#' Bayesian bivariate ellipse and calculates the Standard Ellipse Area (SEA) 
#' for each draw, thereby generating a distribution of SEA esimates. Not 
#' intended for direct calling outside of \code{\link{siberEllipses}}.
#' 
#' @param post a matrix of postior covariance matrix and mean estimates for a 
#' bivariate ellipse. In SIBER, this is typically one list element of the
#' object returned by \code{link{siberMVN}}.
#' 
#' @return A vector of posterior Bayesian Standard Ellipse Areas (SEA_B)
#' 
#' @export
#' 

 
posteriorSEA <- function (post) {
  
  # Function to calculate the SEA based on a posterior distribution of Sigma
  
  
  Nobs <- nrow(post)
  
  SEA.B <- numeric(Nobs) 
  
  # loop over all posterior draws
  for (i in 1:Nobs) {
    
    # extract the covariance matrix parameters
    estS <- post[i, 1:4]
    
    # reshape to matrix of 2x2
    dim(estS) <- c(2, 2)
    
    # calculate the corresponding standard ellipse area
    # AJ change from popSEA to sigmaSEA
    SEA.B[i] <- sigmaSEA(estS)$SEA
    
  } # end loop over posterior draws
  
  
  return(SEA.B)

}
