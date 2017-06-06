## ----setup, echo = FALSE-------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", 
                      fig.width = 6, fig.height = 5)

library(viridis)
palette(viridis(3))

## ----load-data-----------------------------------------------------------
# remove previously loaded items from the current environment and remove previous graphics.
rm(list=ls())
graphics.off()

# Here, I set the seed each time so that the results are comparable. 
# This is useful as it means that anyone that runs your code, *should*
# get the same results as you, although random number generators change 
# from time to time.
set.seed(1)

library(SIBER)
library(ggplot2)
library(magrittr) # to enable piping
library(dplyr)


# load in the included demonstration dataset
data("demo.siber.data")
#
# create the siber object
siber.example <- createSiberObject(demo.siber.data)

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



## ----fit-mvn-------------------------------------------------------------

# options for running jags
parms <- list()
parms$n.iter <- 2 * 10^4   # number of iterations to run the model for
parms$n.burnin <- 1 * 10^3 # discard the first set of values
parms$n.thin <- 10     # thin the posterior by this many
parms$n.chains <- 2        # run this many chains

parms$save.output = FALSE
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


## ----extract-centroids---------------------------------------------------
# extract the centroids from the fitted model object
centroids <- siberCentroids(ellipses.posterior)

# calculate pairwise polar vectors among all groups
# this is not actually used in this example
angles_distances <- allCentroidVectors(centroids, do.plot = FALSE)



## ----ggplot-polar, fig.width=9-------------------------------------------

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
# function to do the histograms on each group
my.hist <- function(df){
  test <- hist(df$angles, 
             breaks = seq(from = -pi, to = pi, length = 60), 
             plot = FALSE)

X <- data.frame(counts = test$counts, mids = test$mids, dens = test$density, 
                counts.stdzd = test$counts / max(test$counts))

return(X)

}
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

# calculate the points for each group's ellipse
hist.by.groups <- angles_distances %>% group_by(comparison) %>%
                             do(my.hist(.))

all.roses <- ggplot(data = hist.by.groups, aes(x = mids, y = counts.stdzd)) +
  geom_bar(stat = "identity") + 
  coord_polar(start = pi / 2, direction = -1) +
  facet_wrap( ~ comparison) +
  theme(axis.ticks.y = element_blank(), 
         axis.text.y = element_blank()) + 
  scale_x_continuous( breaks = c(-pi, -pi/2, 0, pi/2, pi),
                      labels = c("","-\u03C0/2","0","\u03C0/2", "\u03C0"))
print(all.roses)


## ----polar-density, fig.width = 10, fig.height = 7-----------------------

median_vectors <- dplyr::summarise(group_by(angles_distances, comparison),
          medAngle = median(angles), medDist = median(distances))

origins <- data.frame(comparison = median_vectors$comparison, 
                      x = 0, y = 0)

ends    <- with(median_vectors, data.frame(comparison = comparison,
                                           x = medDist * cos(medAngle),
                                           y = medDist * sin(medAngle)))

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# generate the start and end points of the medians for the arrows
for_arrows <- dplyr::bind_rows(origins, ends)

# rename the comparison label for nice plot labels below
# aa <- unlist(strsplit(as.character(for_arrows$comparison), "[.]"))
# aa <- aa[seq(3,length(aa),5)]
# for_arrows$comparison2 <- factor(aa)


# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
# create the cartesian points for the estimated tips of the arrows
cart_positions <- with(angles_distances, data.frame(x = distances * cos(angles),
                             y = distances * sin(angles),
                             comparison = comparison ))

# rename as above
# bb <- unlist(strsplit(as.character(angles_distances$comparison), "[.]"))
# bb <- bb[seq(3,length(bb),5)]
# cart_positions$comparison2 <- factor(bb)



# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
# plot it
ggplot(cart_positions, aes(x,y) ) + 
  geom_bin2d(bins = 20) +
  scale_fill_gradient(low = "white", high = "black") +
  coord_cartesian(xlim = c(-20, +20), ylim = c(-20, +20)) +
  facet_wrap( ~ comparison, scales = "fixed") + 
  theme_classic() +
  geom_path(data = for_arrows, 
            arrow = arrow(type = "open", length = unit(0.2, "cm")),
            col = "red", alpha = 0.6) +
  ylab(expression(paste(delta^{15}, "N (\u2030)"))) +
  xlab(expression(paste(delta^{13}, "C (\u2030)"))) + 
  theme(text = element_text(size=15))


