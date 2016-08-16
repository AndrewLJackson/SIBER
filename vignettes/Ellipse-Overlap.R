## ---- echo = FALSE-------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", 
                      fig.width = 6, fig.height = 5)
library(viridis)
palette(viridis(3))

library(SIBER)

## ------------------------------------------------------------------------
# remove previously loaded items from the current environment and remove previous graphics.
rm(list=ls())
graphics.off()

# Here, I set the seed each time so that the results are comparable. 
# This is useful as it means that anyone that runs your code, *should*
# get the same results as you, although random number generators change 
# from time to time.
set.seed(1)

library(SIBER)

# load in the included demonstration dataset
data("demo.siber.data")
#
# create the siber object
siber.example <- createSiberObject(demo.siber.data)


# Or if working with your own data read in from a *.csv file, you would use
# This *.csv file is included with this package. To find its location
# type
# fname <- system.file("extdata", "demo.siber.data.csv", package = "SIBER")
# in your command window. You could load it directly by using the
# returned path, or perhaps better, you could navigate to this folder
# and copy this file to a folder of your own choice, and create a 
# script from this vingette to analyse it. This *.csv file provides
# a template for how your own files should be formatted.

# mydata <- read.csv(fname, header=T)
# siber.example <- createSiberObject(mydata)


# Create lists of plotting arguments to be passed onwards to the  
# plotting functions. With p.interval = NULL, these are SEA. NB not SEAc though
# which is what we will base our overlap calculations on. This implementation 
# needs to be added in a future update. For now, the best way to plot SEAc is to
# add the ellipses manually following the vignette on this topic.
group.ellipses.args  <- list(n = 100, p.interval = NULL, lty = 1, lwd = 2)



par(mfrow=c(1,1))
plotSiberObject(siber.example,
                  ax.pad = 2, 
                  hulls = F, community.hulls.args, 
                  ellipses = T, group.ellipses.args,
                  group.hulls = F, group.hull.args,
                  bty = "L",
                  iso.order = c(1,2),
                  xlab = expression({delta}^13*C~'\u2030'),
                  ylab = expression({delta}^15*N~'\u2030')
                  )


## ------------------------------------------------------------------------
# In this example, I will calculate the overlap between ellipses for groups 2
# and 3 in community 1 (i.e. the green and yellow open circles of data).
c.1 <- 1 # specify the community ID
e.1 <- 2 # specify the first ellipse, i.e. group 2 in this case

c.2 <- c.1 # same community in this example
e.2 <- 3 # specify the second ellipse for comparison; group 3 in this example

# see help file for addEllipse for more information. With p.interval = NULL and 
# extracting the sample size from siber.examples$sample.sizes,
# I am drawing small sample size corrected, Standard Ellipses around the data.
coords.1 <- addEllipse(siber.example$ML.mu[[c.1]][ , , e.1],
                     siber.example$ML.cov[[c.1]][ , , e.1],
                     m = siber.example$sample.sizes[c.1, e.1],
                     small.sample = TRUE,
                     n = 100,
                     p.interval = NULL,
                     ci.mean = FALSE,
                     do.plot = FALSE)

coords.2 <- addEllipse(siber.example$ML.mu[[c.2]][ , , e.2],
                     siber.example$ML.cov[[c.2]][ , , e.2],
                     m = siber.example$sample.sizes[c.1, e.1],
                     n = 100,
                     p.interval = NULL,
                     ci.mean = FALSE,
                     do.plot = FALSE)

# and now we can use the function spatstat::overlap.xypolygon to calculate the 
# overlap, which is expressed in units, in this case permil squared.
overlap <- abs(spatstat::overlap.xypolygon(list(x = coords.1[,1],
                                                y = coords.2[,2]), 
                                           list(x = coords.2[,1],
                                                y = coords.2[,2])
                                           ))

# you could then express this as a proportion of the total area of both these 
# standard ellipses, or as a proportion of one or the other if you liked. 
# There is no obvious choice here, and it depends on your question.

# Calculate sumamry statistics for each group: TA, SEA and SEAc
group.ML <- groupMetricsML(siber.example)
print(group.ML)

# so in this case, the proportional overlap, would be
overlap / (group.ML[3,2] + group.ML[3,3])


