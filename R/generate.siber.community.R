 # a function to generate a community comprised of a number of groups
  generate.siber.community <- function (n.groups = 3, community.id = 1, n.obs = 30, mu.range = c(-1,1)){

    y <- NULL
    community <- NULL
    group <- NULL

    for (i in 1:n.groups) {
    	tmp <- generate.siber.group(mu.range, n.obs)
    	y <- cbind(y, tmp)
        group <- c(group, rep(i, n.obs))
    }

    out <- data.frame(iso1 = y[,1], 
    	              iso2 = y[,2],
    	              group = group,
    	              community = rep(community.id, nrow(y)))
    return(out)

  }