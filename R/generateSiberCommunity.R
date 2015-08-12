#' A utility function to simulate a single community comprised of groups
#' 
#' This function simulates data for a single community by sampling from a normal
#' distribution with different means for each group within some specified 
#' boundaries.
#' 
#' @param n.groups the an integer specifying the number of groups to simulate. 
#' Defaults to 3.
#' @param community.id an integer identifying the community's ID number. 
#' Defaults to 1.
#' @param n.obs the number of observations to draw per group.
#' @param mu.range a vector of length 4, specifying the mix and max x and y 
#' values to sample means from. Group means are sampled from a uniform 
#' distribution within this range. The first two entries are the min and max of 
#' the x-axis, and the second two the min and max of the y-axis.  Defaults to 
#' \code{c(-1, 1, -1, 1)}.
#' 
#' @return A data.frame object comprising a column of x and y data, a group 
#' indentifying column and a community identifying column, all of which are 
#' numeric.
#' 
#'  @export
#' 


# a function to generate a community comprised of a number of groups
generateSiberCommunity <- function (n.groups = 3, community.id = 1, 
                                      n.obs = 30, 
                                      mu.range = c(-1, 1, -1, 1)) {
  
  # create some random vectors which will be built as we go
  # I dont like this and will pre-define them at full length
  # in a later update.
  y <- NULL
  community <- NULL
  group <- NULL
  
  # loop over each group that comprises the community
  for (i in 1:n.groups) {
    
    # create each group one-by-one
    tmp <- generateSiberGroup(mu.range, n.obs)
    
    # add it on to the previous group
    y <- rbind(y, tmp)
    
    # assign each cluster of data to an appropriate group identifier
    group <- c(group, rep(i, n.obs))
  }
  
  # create the dataframe to be output
  out <- data.frame(iso1 = y[,1], 
                    iso2 = y[,2],
                    group = group,
                    community = rep(community.id, nrow(y)))
  
  # return the dataframe
  return(out)
  
}
  