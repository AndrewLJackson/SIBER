#' Calculate Layman metrics on Bayesian posterior samples of a community
#' 
#' This function loops over the posterior distribution of group means within
#' each community and generates the corresponding Bayesian estimate of the 6 
#' Layman metrics.
#'
#' @param mu.post a list of length n.communities, with each list element 
#' containing the estimated means of the groups comprising that community. The
#' typical workflow to generate mu.post follows. The 
#' Bayesian ellipses are fitted using [siberEllipses()], then the 
#' posterior means (centre of mass of each group) is extracted using
#' [extractPosteriorMeans()]. See the example below.
#' 
#' @return A list of length n.communities, with each element containing a 
#' matrix of 6 columns, each representing the Bayesian posterior distribution 
#' of the 6 Layman metrics for each of the posterior draws recorded by the 
#' fitting process (i.e. which determines the number of rows in this matrix).
#' 
#' @export


bayesianLayman <- function(mu.post) {
  
  
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
      
      layman <- laymanMetrics(mu.post[[k]][i,1,], mu.post[[k]][i,2,])
      
      layman.B[[k]][i,] <- layman$metrics
      
    }
    
    
  # add in the column names
    colnames(layman.B[[k]]) <- names(layman$metrics)
    
  }
  
  return(layman.B)
}



