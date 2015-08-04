ellipse.back.transform <- function (jags.output, siber, idx.community, idx.group) {
  
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
