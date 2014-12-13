generate.siber.data <- function(n.groups = 3, n.communities = 2, n.obs = 30, mu.range = c(-1, 1) ){
  
  nn <- n.obs * n.groups * n.communities
  dummy <- rep(NA, nn)

  simulated.data <- data.frame(iso1 = dummy,
  	                           iso2 = dummy,
  	                           group = dummy,
  	                           community = dummy)

  idx.counter <- 1

  for (i in 1:n.communities){

  	y <- generate.siber.community(n.groups = 3, community.id = i, n.obs = n.obs, mu.range = mu.range)

  	simulated.data[idx.counter:(idx.counter+nrow(y)-1), ] <- y

  	idx.counter <- idx.counter + nrow(y)

  }
  

 return(simulated.data)


}