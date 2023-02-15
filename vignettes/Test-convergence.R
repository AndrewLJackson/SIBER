## ----setup--------------------------------------------------------------------

library(SIBER)
library(coda)


## ----basic-model--------------------------------------------------------------
# load in the included demonstration dataset
data("demo.siber.data")
#
# create the siber object
siber.example <- createSiberObject(demo.siber.data)

# Calculate summary statistics for each group: TA, SEA and SEAc
group.ML <- groupMetricsML(siber.example)

# options for running jags
parms <- list()
parms$n.iter <- 2 * 10^4   # number of iterations to run the model for
parms$n.burnin <- 1 * 10^3 # discard the first set of values
parms$n.thin <- 10     # thin the posterior by this many
parms$n.chains <- 3        # run this many chains

# set save.output = TRUE
parms$save.output = TRUE

# you might want to change the directory to your local directory or a 
# sub folder in your current working directory. I have to set it to a 
# temporary directory that R creates and can use for the purposes of this 
# generic vignette that has to run on any computer as the package is 
# built and installed.
parms$save.dir = tempdir()

# define the priors
priors <- list()
priors$R <- 1 * diag(2)
priors$k <- 2
priors$tau.mu <- 1.0E-3

# fit the ellipses which uses an Inverse Wishart prior
# on the covariance matrix Sigma, and a vague normal prior on the 
# means. Fitting is via the JAGS method.
ellipses.posterior <- siberMVN(siber.example, parms, priors)



## ----test-convergence---------------------------------------------------------

# get a list of all the files in the save directory
all.files <- dir(parms$save.dir, full.names = TRUE)

# find which ones are jags model files
model.files <- all.files[grep("jags_output", all.files)]

# test convergence for the first one
do.this <- 1

load(model.files[do.this])

gelman.diag(output, multivariate = FALSE)
gelman.plot(output, auto.layout = FALSE)


