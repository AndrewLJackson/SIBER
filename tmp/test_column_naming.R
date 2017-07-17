rm(list=ls())
graphics.off()

# Here, I set the seed each time so that the results are comparable. 
# This is useful as it means that anyone that runs your code, *should*
# get the same results as you, although random number generators change 
# from time to time.
set.seed(1)

library("tidyverse")
library("SIBER")

# ******************************************************************************
# change this location per your local setup
load("data/demo.siber.data.2.rda")
# ******************************************************************************


siber.example <- createSiberObject(demo.siber.data.2)


## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## A plot of the data
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

palette(viridis::viridis(sum(siber.example$n.groups[2,])))

# Create lists of plotting arguments to be passed onwards to each 
# of the three plotting functions.
community.hulls.args <- list(col = 1, lty = 1, lwd = 1)
group.ellipses.args  <- list(n = 100, p.interval = 0.95, lty = 1, lwd = 2)
group.hull.args      <- list(lty = 2, col = "grey20")



par(mfrow=c(1,1))
plotSiberObject(siber.example,
                ax.pad = 2, 
                hulls = F, community.hulls.args, 
                ellipses = T, group.ellipses.args,
                group.hulls = T, group.hull.args,
                bty = "L",
                iso.order = c(1,2),
                xlab = expression({delta}^13*C~'\u2030'),
                ylab = expression({delta}^15*N~'\u2030')
)


## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Summaries
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# Calculate summary statistics for each group: TA, SEA and SEAc
group.ML <- groupMetricsML(siber.example)
print(group.ML)

# Calculate the various Layman metrics on each of the communities.
community.ML <- communityMetricsML(siber.example) 
print(community.ML)


## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Bayesian ellipses
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# options for running jags
parms <- list()
parms$n.iter <- 2 * 10^4   # number of iterations to run the model for
parms$n.burnin <- 1 * 10^3 # discard the first set of values
parms$n.thin <- 10     # thin the posterior by this many
parms$n.chains <- 2        # run this many chains

# define the priors
priors <- list()
priors$R <- 1 * diag(2)
priors$k <- 2
priors$tau.mu <- 1.0E-3

# fit the ellipses which uses an Inverse Wishart prior
# on the covariance matrix Sigma, and a vague normal prior on the 
# means. Fitting is via the JAGS method.
ellipses.posterior <- siberMVN(siber.example, parms, priors)




## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## check outputs from siberMVN for correct labelling
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check the contents of ellipses.posterior as output by siberMVN and restrict
# it to the means of the isotopes for easy comparison to the raw data
t(as.data.frame(lapply(ellipses.posterior, colMeans))[5:6,])

# compare the means with those calculated from the raw data
demo.siber.data.2 %>% group_by(community, group) %>% 
  summarise(mu1 = mean(iso1), mu2 = mean(iso2))

# the orders are different, but the values of the means are correct


## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## check SEA.B and SEAc estimates
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# The posterior estimates of the ellipses for each group can be used to
# calculate the SEA.B for each group.
SEA.B <- siberEllipses(ellipses.posterior)

# as per the introduction-to-siber vignette under the plotting, these columns
# are labelled in the same order as contained in the group.ML object
colnames(SEA.B) <- colnames(group.ML)

# we can calculate the mean SEA.B for each
colMeans(SEA.B)

# which seem to match the SEAc estimates close enough as they should
# certainly the order seems to be right!
group.ML[3,]
