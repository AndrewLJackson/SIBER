#' Back-transform a z-score siber ellipse to original location and scale.
#' 
#' Back-transforms a bivariate siber ellipse fitted to z-scored data to the 
#' original location and scale. Not intended for direct call by users.
#'
#' @param jags.output a mcmc.list object of posterior samples created by 
#' \code{\link[rjags]{rjags}}. In siber this is created typically by 
#' \code{\link{fitEllipse}}
#' @param siber a siber object as created by createSiberObject.
#' @param idx.community an integer specifying which community to back-transform.
#' @param idx.group an integer specifyging which group to back-transform.
#' 
#' 
#' @return A 6 x n matrix representing the back-transformed posterior 
#' distributions of the bivariate normal distribution for a specified group 
#' within a specified community, where n is the number of
#' posterior draws in the saved sample. The first four columns are the 
#' covariance matrix Sigma in vector format. This vector converts to the 
#' covariance matrix as \code{matrix(v[1:4], nrow = 2, ncol = 2)}. The 
#'remaining two columns are the back-transformed means.
#' 

ellipseBackTransform <- function (jags.output, siber, idx.community, idx.group) {
  
  # function to back transform Bayesian estimated covariance matrices.
  # This function also collates the posterior draws into a single matrix
  # for each group, nested within a community.
  
  all.draws <- as.matrix(jags.output)
  
  # first the two diagonal variances
  all.draws[,1] <- all.draws[,1] * siber$ML.cov[[idx.community]][1,1,idx.group] 
  all.draws[,4] <- all.draws[,4] * siber$ML.cov[[idx.community]][2,2,idx.group]
  
  # then the covariances
  all.draws[,2] <- (all.draws[,2] * 
                      siber$ML.cov[[idx.community]][1,1,idx.group] ^ 0.5 * 
                      siber$ML.cov[[idx.community]][2,2,idx.group] ^ 0.5)
  all.draws[,3] <- all.draws[,2]
  
  # now correct the ellipse locations (i.e. their means)
  all.draws[,5] <- all.draws[,5] + siber$ML.mu[[idx.community]][1,1,idx.group]
  all.draws[,6] <- all.draws[,6] + siber$ML.mu[[idx.community]][1,2,idx.group]
  
  return(all.draws)
  
} # end of function
