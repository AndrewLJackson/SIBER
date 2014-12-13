# test script for generating random SIBER data

rm(list=ls())
graphics.off()

set.seed(1)


setwd("/Users/andrewjackson/documents/github/siber/R")

source("generate.siber.data.R")
source("generate.siber.group.R")
source("generate.siber.community.R")


y <- generate.siber.data()



dev.new()
plot(y, pch = 21)
