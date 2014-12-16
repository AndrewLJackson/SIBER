# NB this file to be not included in the package
# test script for generating random SIBER data

#rm(list=ls())
#graphics.off()


#set.seed(1)

source("R/tmp.source.these.R")



y <- generate.siber.data(mu.range = c(-20, 0, 0, 9))



dev.new()
par(mfrow=c(1,2))
with(subset(y, y$community ==1), { 
	plot(iso1, iso2, col = group, pch = community)
})
with(subset(y, y$community ==2), { 
	plot(iso1, iso2, col = group, pch = community)
})

#write.csv(y, file = "data/demo.siber.data.csv", row.names = F)
