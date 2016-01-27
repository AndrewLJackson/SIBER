#' Fit Bayesian bivariate normal distributions to each group in each community
#' 
#' This function loops over each community and then loops over each group 
#' member, fitting a Bayesian multivariate (bivariate in this case) normal 
#' distribution to each group of data. Not intended for direct calling by users.
#' 
#' @param siber a siber object as created by \code{\link{createSiberObject}}
#' @param parms a list containing four items providing details of the
#'  \code{\link[rjags]{rjags}} run to be sampled.
#' \itemize{
#'    \item {n.iter}{The number of iterations to sample}
#'    \item {n.burnin}{The number of iterations to discard as a burnin from the
#'                      start of sampling.}
#'    \item {n.thin}{The number of samples to thin by.}
#'    \item {n.chains}{The number of chains to fit.}
#' }
#' @param priors a list of three items specifying the priors to be passed to 
#' the jags model.
#' \itemize{
#'    \item {R}{The scaling vector for the diagonal of Inverse Wishart
#'    distribution prior on the covariance matrix Sigma. Typically 
#'    set to a 2x2 matrix matrix(c(1, 0, 0, 1), 2, 2).}
#'    \item {k}{The degrees of freedom of the Inverse Wishart distribution for 
#'    the covariance matrix Sigma. Typically set to the dimensionality of Sigma,
#'    which in this bivariate case is 2.}
#'    \item {tau}{The precision on the normal prior on the means mu.}
#' }
#' 
#' @return A list of length equal to the total number of groups in all 
#' communities. Each entry is named 1.1 1.2... 2.1.. with the first number
#' designating the community, and the second number the group within that 
#' community. So, 2.3 would be the third group within the second community. 
#' Each list entry is a 6 x n matrix representing the back-transformed posterior 
#' distributions of the bivariate normal distribution, where n is the number of
#' posterior draws in the saved sample. The first two columns are the back-
#' transformed means, and the remaining four columns are the covariance matrix
#' Sigma in vector format. This vector converts to the covariance matrix as
#' \code{matrix(v[1:4], nrow = 2, ncol = 2)}. 
#' 
#' @export

siberMVN <- function (siber, parms, priors) 
{
  
  
  # NB in all cases, fitting is performed on mean centred, sd standardised
  # transformation to the data. Code at the end then back-transforms the
  # covariance matrix and location of the ellipse for downstream plotting
  # and calculation of the SEA.
  
  
  
  
  
  # create the SIBER ellipse object to be returned by this function
  siber.posterior <- list()

  
  ct <- 1 # a counter
  
  # loop over communities
  for (k in 1:siber$n.communities) {
    
    # loop over groups within each community
    for (j in 1:siber$n.groups[2,k]) {
      
      grp.j <- siber$zscore.data[[k]][,"group"] == j
      
      x.zscore <- siber$zscore.data[[k]][grp.j, 1]
      y.zscore <- siber$zscore.data[[k]][grp.j, 2]
      
      
      # fit the ellipses to each group in the dataset
      model <- fitEllipse(x.zscore,y.zscore,parms,priors)
      
      corrected.posteriors <- ellipseBackTransform(model, siber, k, j)
      

      
      # THE POSTERIORS HAVE TO BE ADDED INTO THE SIBER OBJECT AND RETURNED
      # I NEED TO CHECK TO SEE IF S3 CLASSES MEAN I DONT HAVE TO PASS IN AND OUT
      # THE SAME OBJECT EACH TIME WHICH IS WASTEFUL.
      siber.posterior[[ct]] <- corrected.posteriors
      
      ct <- ct + 1 # update the counter
      
    }
}
  
  
  # give the list objects names for easier retrieval
  tmp.names <- unique(paste(siber$original.data[,"community"],
                            siber$original.data[,"group"],
                            sep=".")
  )
  names(siber.posterior) <- tmp.names
  
  return(siber.posterior)
}







