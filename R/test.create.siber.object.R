# Read in SIBER format data and generate the SIBER object
# This script to be turned into a function in time.

rm(list=ls())

setwd("/Users/andrewjackson/documents/github/siber/R")



mydata <- read.csv("../data/demo.siber.data.csv", header=T)

# create an object that is a list, into which the raw data, 
# its transforms, and various calculated metrics can be stored.
siber <- list()

# store the raw data as list split by the community variable
# and rename the list components
siber$raw.data <- split(mydata, mydata$community)
names(siber$raw.data) <- paste("community", unique(mydata$community), sep = "")

# how many communities are there
siber$n.communities <- length(unique(mydata$community))

# now many groups are in each community
siber$n.groups <- matrix(NA, 2, length(siber$raw.data), 
	                     dimnames = list(c("community", "n.groups"), c("","")))
siber$n.groups[1, ] <- unique(mydata$community)
siber$n.groups[2, ] <- tapply(mydata$group, mydata$community, 
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

		  
		tmp <- subset(siber$raw.data[[i]], group == j)	
		
	    mu.tmp <- colMeans(cbind(tmp$iso1, tmp$iso2))
	    cov.tmp <- cov(tmp$iso1, tmp$iso2)

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



