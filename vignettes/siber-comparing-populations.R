## ---- echo=FALSE, message = FALSE, fig.width = 7, fig.height = 7--------------

library(SIBER, quietly = TRUE,
        verbose = FALSE,
        logical.return = FALSE)

library(viridis)
palette(viridis(4))

# read in the data
# Replace this line with a call to read.csv() or similar pointing to your 
# own dataset.
data("demo.siber.data")
mydata <- demo.siber.data

# create the siber object
siber.example <- createSiberObject(mydata)

# Create lists of plotting arguments to be passed onwards to each 
# of the three plotting functions.
community.hulls.args <- list(col = 1, lty = 1, lwd = 1)
group.ellipses.args  <- list(n = 100, p.interval = 0.95, lty = 1, lwd = 2)
group.hull.args      <- list(lty = 2, col = "grey20")

# plot the raw data
par(mfrow=c(1,1))
plotSiberObject(siber.example,
                  ax.pad = 2, 
                  hulls = F, community.hulls.args, 
                  ellipses = F, group.ellipses.args,
                  group.hulls = F, group.hull.args,
                  bty = "L",
                  iso.order = c(1,2),
                  xlab = expression({delta}^13*C~'\u2030'),
                  ylab = expression({delta}^15*N~'\u2030')
                  )


## ----import-data, fig.width = 6, fig.height = 6-------------------------------

rm(list = ls()) # clear the memory of objects

# load the siar package of functions
library(SIBER)

# read in the data
# Replace this line with a call to read.csv() or similar pointing to your 
# own dataset.
data("demo.siber.data")
mydata <- demo.siber.data

# create the siber object
siber.example <- createSiberObject(mydata)

# Create lists of plotting arguments to be passed onwards to each 
# of the three plotting functions.
community.hulls.args <- list(col = 1, lty = 1, lwd = 1)
group.ellipses.args  <- list(n = 100, p.interval = 0.95, 
                             lty = 1, lwd = 2)
group.hull.args      <- list(lty = 2, col = "grey20")


# ellipses and group.hulls are set to TRUE or T for short to force
# their plotting. 
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

# You can add more ellipses by directly calling plot.group.ellipses()
# Add an additional p.interval % prediction ellilpse
plotGroupEllipses(siber.example, n = 100, p.interval = 0.95,
                    lty = 1, lwd = 2)

# or you can add the XX% confidence interval around the bivariate means
# by specifying ci.mean = T along with whatever p.interval you want.
plotGroupEllipses(siber.example, n = 100, p.interval = 0.95,
                  ci.mean = T, lty = 1, lwd = 2)

# Calculate sumamry statistics for each group: TA, SEA and SEAc
group.ML <- groupMetricsML(siber.example)
print(group.ML)

# add a legend
legend("topright", colnames(group.ML), 
       pch = c(1,1,1,2,2,2), col = c(1:3, 1:3), lty = 1)


## ----fit-bayes----------------------------------------------------------------

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


## ----plot-data, fig.width = 10, fig.height = 6--------------------------------
# 
# ----------------------------------------------------------------
# Plot out some of the data and results
# ----------------------------------------------------------------

# The posterior estimates of the ellipses for each group can be used to
# calculate the SEA.B for each group.
SEA.B <- siberEllipses(ellipses.posterior)

siberDensityPlot(SEA.B, xticklabels = colnames(group.ML), 
                xlab = c("Community | Group"),
                ylab = expression("Standard Ellipse Area " ('\u2030' ^2) ),
                bty = "L",
                las = 1,
                main = "SIBER ellipses on each group"
                )

# Add red x's for the ML estimated SEA-c
points(1:ncol(SEA.B), group.ML[3,], col="red", pch = "x", lwd = 2)

# Calculate some credible intervals 
cr.p <- c(0.95, 0.99) # vector of quantiles

# call to hdrcde:hdr using lapply()
SEA.B.credibles <- lapply(
  as.data.frame(SEA.B), 
  function(x,...){tmp<-hdrcde::hdr(x)$hdr},
  prob = cr.p)

print(SEA.B.credibles)

# do similar to get the modes, taking care to pick up multimodal posterior
# distributions if present
SEA.B.modes <- lapply(
  as.data.frame(SEA.B), 
  function(x,...){tmp<-hdrcde::hdr(x)$mode},
  prob = cr.p, all.modes=T)

print(SEA.B.modes)

## ----prob-diff-g12------------------------------------------------------------
Pg1.1_lt_g1.2 <- sum( SEA.B[,1] < SEA.B[,2] ) / nrow(SEA.B)
print(Pg1.1_lt_g1.2)

## ----prob-diff-g13------------------------------------------------------------
Pg1.1_lt_g1.3 <- sum( SEA.B[,1] < SEA.B[,3] ) / nrow(SEA.B)
print(Pg1.1_lt_g1.3)

## ----prob-diff-all------------------------------------------------------------
Pg1.1_lt_g2.1 <- sum( SEA.B[,1] < SEA.B[,4] ) / nrow(SEA.B)
print(Pg1.1_lt_g2.1)

Pg1.2_lt_g1.3 <- sum( SEA.B[,2] < SEA.B[,3] ) / nrow(SEA.B)
print(Pg1.2_lt_g1.3)

Pg1.3_lt_g2.1 <- sum( SEA.B[,3] < SEA.B[,4] ) / nrow(SEA.B)
print(Pg1.3_lt_g2.1)

Pg2.2_lt_g2.3 <- sum( SEA.B[,5] < SEA.B[,6] ) / nrow(SEA.B)
print(Pg2.2_lt_g2.3)


## ----ML-overlap---------------------------------------------------------------

overlap.G1.2.G1.3 <- maxLikOverlap("1.2", "1.3", siber.example, p = 0.95, n =)


## ----ML-overlap-proportions---------------------------------------------------
prop.of.first <- as.numeric(overlap.G1.2.G1.3["overlap"] / overlap.G1.2.G1.3["area.1"])
print(prop.of.first)

prop.of.second <- as.numeric(overlap.G1.2.G1.3["overlap"] / overlap.G1.2.G1.3["area.2"])
print(prop.of.second)

prop.of.both <- as.numeric(overlap.G1.2.G1.3["overlap"] / (overlap.G1.2.G1.3["area.1"] + overlap.G1.2.G1.3["area.2"]))
print(prop.of.both)

## ----bayesian-overlap---------------------------------------------------------
bayes.overlap.G2.G3 <- bayesianOverlap("1.2", "1.3", ellipses.posterior, 
                                       draws = 10, p.interval = 0.95,
                                       n = 360)
print(bayes.overlap.G2.G3)


