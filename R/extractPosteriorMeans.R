#' Extract posterior means from call to \code{\link{siberMVN}}
#' 
#' This function extracts the posterior means from a call to 
#' \code{\link{siberMVN}} which can then be used to calculate bayesian layman 
#' metrics. This function is designed to create an array of posterior means 
#' that is more easily interrogated for plotting and summary statistics.
#' 
#' @param siber a siber object as created by \code{\link{createSiberObject}}
#' @param post a list containing the posterior estimated parameters fitted to 
#' each group within every community. See \code{\link{siberMVN}} which creates 
#' this object for details.
#' 
#' @return A list of length n.communities with each entry representing a 
#' \code{n.draws * 2 * n.groups} array of rows equal to the number of posterior
#' samples, 2 columns representing the two means of the multivariate data and 
#' n.groups the number of groups within the focal community.
#' 
#'  @export
#' 


extractPosteriorMeans <- function (siber, post) {
  
  
  # community / group naming 
  tmp.names <- unique(paste(siber$original.data[,"community"],
                            siber$original.data[,"group"],
                            sep=".")
                      )
  
  n.samps <- nrow(post[[1]])
  
  post.means <- list()
  
  ct <- 1 # a counter
  
  for (k in 1:siber$n.communities) {
    
    # create the (n.samp x 2 x n.groups) array
    group.mu <- array(NA, dim=c(n.samps, 2, siber$n.groups[2,k]), 
                      dimnames = list(NULL,
                                      c("mu.x","mu.y"),
                                      paste("group", 
                                            1:siber$n.groups[2,k], 
                                            sep = "")
                                      )
                      )
    
    for (j in 1:siber$n.groups[2,k]) {
      
      group.mu[,,j] <- post[[ct]][,5:6]
      
      ct <- ct + 1 # update the counter
      
    }
    
    post.means[[k]] <- group.mu
    
  }
  
  return(post.means)
                            
}