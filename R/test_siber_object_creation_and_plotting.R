# test script for the main SIBER functionality

rm(list=ls())
graphics.off()


# this script itself sources the functions needed
source("R/tmp.source.these.R")

# read in the example dataset
mydata <- read.csv("data/demo.siber.data.csv", header=T)

# create the siber object
siber.example <- create.siber.object(mydata) 

# and now call the basic graph making script
# Community 1 comprises 3 groups and drawn as black, red and green circles
# community 2 comprises 3 groups and drawn as black, red and green triangles
#
# ax.pad determines the padding applied around the extremes of the data.
#
# iso.order is a vector of length 2 specifying which isotope should be
#  plotted on the x and y axes.
#  N.B. though there is currently a problem with the addition of the
#  group ellipses using if you deviate from the default of 
#  iso.order = c(1,2). This needs to be fixed.
#
# Convex hulls are drawn between the centres of each group within a community
#   with hulls = T.
#
# Ellipses are drawn for each group independently
#  with ellipses = T.
#  These ellipses can be made to be maximum likelihood standard ellipses
#  by setting p = NULL, or can be made to be predicition ellipses that
#  contain approximately p proportion of data. For example, p = 0.95
#  will draw an ellipse that encompasses approximately 95% of the data.
#  The parameter n determines how many points are used to make each ellipse
#  and hence how smooth the curves are.
#
# Convex hulls are draw around each group independently
# with group.hulls = T.

par(mfrow=c(1,1))
plot.siber.object(siber.example,
                  ax.pad = 2, 
                  hulls = F, 
                  ellipses = T, n = 100, p = 0.95, lty = 2,
                  group.hulls = T, bty = "L",
                  iso.order = c(1,2))





