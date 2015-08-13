#' Read in SIBER format data and generate the SIBER object
#' 
#' This function takes raw isotope data and creates a SIBER object which 
#' contains information in a structured manner that enables other functions to
#' loop over groups and communities, fit Bayesian ellipses, and afterwards, 
#' generate various plots, and additional analyses on the posterior 
#' distributions.
#' 
#' @param data.in Specified In a basic R data.frame or matrix comprising 4 columns. 
#' The first two of which are typically isotope tracers, then the third is a 
#' column that indicates the group membership, and the fourth column indicates
#' the community membership of an observation. Group and communities should be 
#' entered  as sequetial numbers, and groups numbering should restart within a 
#' community
#' @return A siber list object, that contains data that helps with various 
#' model fitting and plotting.
#' \itemize{
#'   \item {original.data}{The original data as passed into this function}
#'   \item {iso.summary}{The max, min, mean and median of the isotope data 
#'   useful for plotting}
#'   \item {sample.sizees}{The number of obsevations tabulated by group and 
#'   community}
#'   \item {raw.data}{A list object of length equal to the number of communities}
#' }
#' @examples
#' data(demo.siber.data)
#' my.siber.data <- createSiberObject(demo.siber.data)
#' names(my.siber.data)
#' 
#'  @export
 
createSiberObject <- function (data.in) {
  
  # create an object that is a list, into which the raw data, 
  # its transforms, and various calculated metrics can be stored.
  siber <- list()
  
  # keep the original data in its original format just in case
  # In fact, it can be easier to work with this format, as tapply
  # works well on it. I half wonder if i could just keep all the data like this
  # if i were able to use tapply more effectively on multiple inputs.
  siber$original.data <- data.in
  
  
  # some basic summary stats helpful for plotting
  my.summary <- function(x){
  	c(min = min(x), max = max(x), mean = mean(x), median = stats::median(x))
  }
  
  siber$iso.summary <- apply(data.in[,1:2], 2, my.summary)
  
  siber$sample.sizes <- tapply(data.in[,1], 
                               list(data.in[,4], data.in[,3]), 
                               length)
  
  # store the raw data as list split by the community variable
  # and rename the list components
  siber$raw.data <- split(data.in, data.in$community)
  names(siber$raw.data) <- paste("community", 
                                 unique(data.in$community), sep = "")
  
  # how many communities are there
  siber$n.communities <- length(unique(data.in$community))
  
  # now many groups are in each community
  siber$n.groups <- matrix(NA, 2, length(siber$raw.data), 
  	                     dimnames = list(c("community", "n.groups"), 
                                         rep("", siber$n.communities)))
  siber$n.groups[1, ] <- unique(data.in$community)
  siber$n.groups[2, ] <- tapply(data.in$group, data.in$community, 
  	                           function(x){length(unique(x))})
  
  # ------------------------------------------------------------------------------
  # create empty arrays in which to store the Maximum Likelihood estimates
  # of the means and covariances for each group.
  siber$ML.mu  <- list()
  siber$ML.cov <- list()
  
  for (i in 1:siber$n.communities){
  
  	siber$ML.mu[[i]]  <- array(NA, dim=c(1, 2, siber$n.groups[2,i]) )
  	siber$ML.cov[[i]] <- array(NA, dim=c(2, 2, siber$n.groups[2,i]) )
  }
  
  
  # loop over each community and extract the Maximum Likelihood estimates
  # of the location (their simple independent means) and covariance 
  # matrix of each group that comprises the community.
  # I hvae done this as a loop, as I cant see how to be clever
  # and use some of the apply() or analogue functions.
  for (i in 1:siber$n.communities) {
  
  	for (j in 1:siber$n.groups[2,i]) {
  
  		  
  		tmp <- subset(siber$raw.data[[i]], siber$raw.data[[i]]$group == j)	
  		
  	    mu.tmp <- colMeans(cbind(tmp$iso1, tmp$iso2))
  	    cov.tmp <- stats::cov(cbind(tmp$iso1, tmp$iso2))
  
  	    siber$ML.mu[[i]][,,j] <- mu.tmp
  	    siber$ML.cov[[i]][,,j] <- cov.tmp
  	
  	} # end of loop over groups
  } # end of loop over
  
  # ------------------------------------------------------------------------------
  # create z-score transformed versions of the raw data.
  # we can then use the saved information in the mean and 
  # covariances for each group stored in ML.mu and ML.cov
  # to backtransform them later.
  
  # first create a copy of the raw data into a list zscore.data
  siber$zscore.data <-  siber$raw.data
  
  for (i in 1:siber$n.communities) {
  
    # apply z-score transform to each group within the community via tapply()
    # using the function scale()
    siber$zscore.data[[i]][,1] <- unlist(tapply(siber$raw.data[[i]]$iso1, 
    	                                          siber$raw.data[[i]]$group,
    	                                          scale))
    siber$zscore.data[[i]][,2] <- unlist(tapply(siber$raw.data[[i]]$iso2, 
    	                                          siber$raw.data[[i]]$group, 
    	                                          scale))
  
  	
  }
  
  return(siber)

} # end of function




