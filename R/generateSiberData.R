#' A utility function to simulate isotope data for several communities
#' 
#' This function simulates data for a specified number of communities. It is a 
#' wrapper function for \code{\link{generateSiberCommunity}}.
#' 
#' @param n.groups the an integer specifying the number of groups per community 
#'   to simulate. Defaults to 3.
#' @param n.communities the number of communities to simulate data for. Defaults
#'   to 2.
#' @param n.obs the number of observations to draw per group.
#' @param mu.range a vector of length 4, specifying the mix and max x and y 
#'   values to sample means from. Group means are sampled from a uniform 
#'   distribution within this range. The first two entries are the min and max
#'   of the x-axis, and the second two the min and max of the y-axis. Defaults
#'   to \code{c(-1, 1, -1, 1)}.
#' @param wishSigmaScale is a simple multiplier for the call to
#'   \code{\link[stats]{rWishart}} which scales the diagonal sigma matrix using
#'   \code{wishSigmaScale * diag(2)} that is ultimately passed on to 
#'   \code{\link{generateSiberGroup}}.
#'   
#' @return A data.frame object comprising a column of x and y data, a group 
#'   identifying column and a community identifying column, all of which are 
#'   numeric.
#'   
#' @examples
#' generateSiberData()
#' 
#' @export

generateSiberData <- function(n.groups = 3, n.communities = 2, n.obs = 30, 
                                mu.range = c(-1, 1, -1, 1),
                              wishSigmaScale = 1){
  
  # calculate the number of observations (rows) to be created
  nn <- n.obs * n.groups * n.communities
  
  # a vector of dummy NA entries to use to populate the dataframe
  dummy <- rep(NA, nn)

  # the dataframe that will hold the simulated data
  simulated.data <- data.frame(iso1 = dummy,
  	                           iso2 = dummy,
  	                           group = dummy,
  	                           community = dummy)

  # a counter to keep track of how many communities have been created, and to allow
  # appropriate indexing of the dataframe "simulated.data"
  idx.counter <- 1

  # loop over communities
  for (i in 1:n.communities){

    # create a random community
  	y <- generateSiberCommunity(n.groups = 3, community.id = i, n.obs = n.obs, 
  	                            mu.range = mu.range, 
  	                            wishSigmaScale = wishSigmaScale)

    # add the random community to the dataframe "simulated.data"
  	simulated.data[idx.counter:(idx.counter+nrow(y)-1), ] <- y

    # update the counter
  	idx.counter <- idx.counter + nrow(y)

  }
  

 # output the dataframe "simulated.data"
 return(simulated.data)


}
