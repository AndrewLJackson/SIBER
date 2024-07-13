library(SIBER)
library(tidyverse)
library(geometry)

source("R/createSiberObject2.R")
source("R/fitEllipse.R")
source("R/siberNSEA.R")
source("R/backTransCOV.R")
source("R/extractCOV.R")
source("R/siberEllipses2.R")



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
kk <- siberEllipses2(test, aj)

## plot the SEAB values
ggplot(kk, 
       aes(x = master_code %>% as.factor, y = SEA_B_post)) + 
  geom_boxplot()


# Summarise the SEAB values
SEA_B_summaries = kk %>% group_by(master_code) %>% 
  summarise(mean = mean(SEA_B_post), 
            median = median(SEA_B_post),
            sd = sd(SEA_B_post), 
            hdr = list(hdrcde::hdr(den = density(SEA_B_post, from = 0), 
                                   prob= 0.95)$hdr))

print(SEA_B_summaries)


