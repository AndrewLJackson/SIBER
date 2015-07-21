
# this utility script is just used to source a set of files
# while i work on this package
# these are functions required

# function to source the contents of the directory
sourceDir <- function(path, trace = TRUE, ...) {
  for (nm in list.files(path, pattern = "[.][RrSsQq]$")) {
    if(trace) cat(nm,":")
    source(file.path(path, nm))
    if(trace) cat("\n")
  }
}

dir.path <- paste(getwd(), "/R", sep = "")
sourceDir(dir.path, trace = F)

# source("R/siber.convexhull.R")
# source("R/hullarea.R")
# source("R/plot.siber.object.R")
# source("R/siber.convexhull.R")
# source("R/create.siber.object.R")
# source("R/gen.circle.R")
# source("R/add.ellipse.R")

# load dependent libraries
library('bayesm')
library('mnormt')
library('R2jags')
