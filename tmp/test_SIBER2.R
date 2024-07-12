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




test <- fitEllipse(Y = aj$z_data %>% ungroup %>% select(all_of(2:3)), 
                   G = aj$z_data$master_code,
                   parms = parms, 
                   priors = priors)


# Number of groups
n_groups <- max(aj$z_data$master_code)


kk <- siberEllipses2(test, aj)

# extract the COV data from the fitted jags model
# ajCOV <- extractCOV(test, siber_obj = aj)

# backtransform these correlation matrices to covariance matrices on the 
# original scale of the data.
# kk <- map2(ajCOV, aj$summary$cov, 
#            \(x,y) x %>% map_vec(\(z) siberNSEA(backTransCOV(z,y))) %>% 
#              as_tibble()
#            )



# kk %>% mutate(mu = map_vec(SEA_B_post, mean))

# kk <- map(ajCOV, \(x) x %>% map(\(z) class(z)))

# bind them into a single tibble
# mm <- kk %>% bind_rows(., .id = "master_code")
# 
# ggplot(mm, 
#        aes(x = master_code, y = SEA_B_post)) + 
#   geom_boxplot()

ggplot(kk, 
       aes(x = master_code %>% as.factor, y = SEA_B_post)) + 
  geom_boxplot()


SEA_B_summaries = kk %>% group_by(master_code) %>% 
  summarise(mean = mean(SEA_B_post), 
            median = median(SEA_B_post),
            sd = sd(SEA_B_post), 
            hdr = list(hdrcde::hdr(den = density(SEA_B_post, from = 0), 
                                   prob= 0.95)$hdr))

print(SEA_B_summaries)


