# NB this file to be not included in the package
# test script for generating random SIBER data

rm(list=ls())
graphics.off()
library('bayesm')
library('mnormt')

set.seed(1)


setwd("/Users/andrewjackson/documents/github/siber/R")

source("generate.siber.data.R")
source("generate.siber.group.R")
source("generate.siber.community.R")


y <- generate.siber.data()



dev.new()
plot(y, pch = 21)

write.csv(y, file = "../data/demo.siber.data.csv")
