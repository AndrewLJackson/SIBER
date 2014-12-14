generate.siber.data <- function(n.groups = 3, n.communities = 2, n.obs = 30, mu.range = c(-1, 1, -1, 1) ){
  
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
  	y <- generate.siber.community(n.groups = 3, community.id = i, n.obs = n.obs, mu.range = mu.range)

    # add the random community to the dataframe "simulated.data"
  	simulated.data[idx.counter:(idx.counter+nrow(y)-1), ] <- y

    # update the counter
  	idx.counter <- idx.counter + nrow(y)

  }
  

 # output the dataframe "simulated.data"
 return(simulated.data)


}
