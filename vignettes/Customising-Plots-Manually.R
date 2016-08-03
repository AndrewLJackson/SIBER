## ---- echo = FALSE-------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", 
                      fig.width = 6, fig.height = 5)


## ---- echo = TRUE--------------------------------------------------------
# remove previously loaded items from the current environment and remove previous graphics.
rm(list=ls())
graphics.off()

# Here, I set the seed each time so that the results are comparable. 
# This is useful as it means that anyone that runs your code, *should*
# get the same results as you, although random number generators change 
# from time to time.
set.seed(1)

library(SIBER)

# Load the viridis package and create a new palette with 3 colours, one for 
# each of the 3 groups we have in this dataset.
library(viridis)
palette(viridis(3))

# load in the included demonstration dataset
data("demo.siber.data")


#
# create the siber object
siber.example <- createSiberObject(demo.siber.data)



## ---- echo=TRUE----------------------------------------------------------
plotSiberObject(siber.example,
                  ax.pad = 2, 
                  hulls = FALSE, 
                  ellipses = FALSE,
                  group.hulls = FALSE,
                  bty = "L",
                  iso.order = c(1,2),
                  xlab = expression({delta}^13*C~'\u2030'),
                  ylab = expression({delta}^15*N~'\u2030')
                  )
# Call addEllipse directly on each group to customise the plot fully

# change c.id and g.id to select the group of data you want
# you could embed this in a loop easily enough if you wanted to 
# set up the order of lines and simply loop through them.
c.id <- 1 # specify the community ID
g.id <- 1 # specify the group ID within the community

# see help file for addEllipse for more information
# NB i am using the group identifier g.id to select the colour
# of the ellipse line so that it matches the one created by 
# plotSiberObject(), but you could override this if you wish.
# The function addEllipse returns the coordinates it used for plotting, 
# but more than likely you dont need this information. Here I store these in
# a new variable coords for clarity, but you could just as easily call this tmp.
# See help file for addEllipse for more details on the options, but in short:
# the first two entries look up the means and covariance matrix of the data you
# specified using the group and commmunity indices above.
# m = NULL is used as we are not plotting an ellipse around the mean.
# n = 100 just determines how many points are used to draw a smooth ellipse.
# p.interval = 0.95 for a 95% ellipse of the data
# ci.mean = FALSE as we are not plotting an ellipse around the mean.
# col = your choice of colour.
# lty = your choice of line type.
# lwd = your choice of line width.
coords <- addEllipse(siber.example$ML.mu[[c.id]][ , , g.id],
                     siber.example$ML.cov[[c.id]][ , , g.id],
                     m = NULL,
                     n = 100,
                     p.interval = 0.95,
                     ci.mean = FALSE,
                     col = g.id,
                     lty = 3,
                     lwd = 2)

