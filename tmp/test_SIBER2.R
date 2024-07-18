library(SIBER)
library(tidyverse)
library(geometry)

source("R/createSiberObject2.R")
source("R/fitEllipse.R")
source("R/siberNSEA.R")
source("R/backTransCOV.R")
source("R/extractCOV.R")
source("R/siberEllipses2.R")
source("R/stat_siber_ellipse.R")



aj <- createSiberObject2(demo.siber.data, group_start_position = 3)
# aj$z_data <- aj$z_data %>% filter(master_code %in% c(1, 2))

# options for running jags
parms <- list()
parms$n.iter <- 2 * 10^4   # number of iterations to run the model for
parms$n.burnin <- 1 * 10^3 # discard the first set of values
parms$n.thin <- 10     # thin the posterior by this many
parms$n.chains <- 2        # run this many chains

# define the priors
priors <- list()
priors$R <- 1 * diag(aj$n.iso)
priors$kappa <- aj$n.iso
priors$tau.mu <- 1.0E-3



# Fit bayesian ellipses to each group
test <- fitEllipse(Y = aj$z_data %>% ungroup %>% select(all_of(2:3)), 
                   G = aj$z_data$master_code,
                   parms = parms, 
                   priors = priors)


# Number of groups
n_groups <- max(aj$z_data$master_code)

# generate a tibble of SEAB values for each group
# this fits the Bayesian model
kk <- siberEllipses2(test, aj)

## plot the SEAB values
ggplot(kk, 
       aes(x = master_code %>% as.factor, y = SEA_B_post)) + 
  geom_boxplot() + 
  
  geom_point(data = aj$summary, 
             mapping = aes(x = master_code, 
                           y = SEAc), col = "red")


# Summarise the SEAB values
SEA_B_summaries = kk %>% group_by(master_code) %>% 
  summarise(mean = mean(SEA_B_post), 
            median = median(SEA_B_post),
            sd = sd(SEA_B_post), 
            hdr = list(hdrcde::hdr(den = density(SEA_B_post, from = 0), 
                                   prob= 0.95)$hdr))

print(SEA_B_summaries)


## Plot the raw data and try to add stat_SIBER_ellipse()

# rlang needed to run the 
library(rlang)

g1 <- ggplot(data = demo.siber.data %>% mutate(group = factor(group), 
                                               community = factor(community)), 
             mapping = aes(x = iso1, y = iso2, 
                           color = group, 
                           shape = community)) + 
  geom_point() + 
  scale_color_viridis_d(end = 0.9) + 
  stat_siber_ellipse(type = "SEA", level = 0.95)

print(g1)


# This comparison takes a small subset of each group (n=6) and 
# illustrates that SEAc tends to be slightly larger than SEA
ggplot(demo.siber.data %>%
         group_by(group, community) %>%
         slice_sample(n = 6) %>% ungroup,
       aes(iso1, iso2, color = factor(group), shape = factor(community))) +
  geom_point() + stat_siber_ellipse(type = "SEA") +
  stat_SIBER_ellipse(type = "SEAc", linetype = 2) + 
  scale_color_viridis_d()




