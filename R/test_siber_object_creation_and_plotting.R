# test script to compile the SIBER object and
# plot the data with some ellipses and community-level hulls.

# these are functions required
source("siber.convexhull.R")
source("plot.sigma.ellipse.R")
source("hullarea.R")
source("plot.siber.object.R")
source("siber.convexhull.R")

# this is a script that loads the data and
# produces the SIBER object
source("test.create.siber.object.R")

# and now call the graph making script
# Community 1 comprises 3 groups and drawn as black, red and green circles
# community 2 comprises 3 groups and drawn as black, red and green triangles
# Convex hulls are drawn between the centres of each group within a community.
# Ellipses are drawn for each group independently.
plot.siber.object(siber)