 # a function to generate a community comprised of a number of groups
  generate.siber.community <- function (n.groups = 3, community.id = 1, n.obs = 30, mu.range = c(-1,1)){

    # create some random vectors which will be built as we go
    # I dont like this and will pre-define them at full length
    # in a later update.
    y <- NULL
    community <- NULL
    group <- NULL

    # loop over each group that comprises the community
    for (i in 1:n.groups) {
    	
    	# create each group one-by-one
    	tmp <- generate.siber.group(mu.range, n.obs)
    	
    	# add it on to the previous group
    	y <- cbind(y, tmp)
    	
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
  