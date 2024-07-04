library(SIBER)
library(tidyverse)
library(geometry)

source("../R/createSiberObject2.R")
source("../R/fitEllipse.R")
source("../R/siberNSEA.R")



aj <- createSiberObject2(demo.siber.data, group_start_position = 3)
aj$z_data <- aj$z_data %>% filter(master_code %in% c(1, 2))

# options for running jags
parms <- list()
parms$n.iter <- 2 * 10^4   # number of iterations to run the model for
parms$n.burnin <- 1 * 10^3 # discard the first set of values
parms$n.thin <- 10     # thin the posterior by this many
parms$n.chains <- 2        # run this many chains

# define the priors
priors <- list()
priors$R <- 1 * diag(2)
priors$kappa <- 2
priors$tau.mu <- 1.0E-3




test <- fitEllipse(Y = aj$z_data %>% ungroup %>% select(all_of(2:3)), 
                   G = aj$z_data$master_code,
                   parms = parms, 
                   priors = priors)


# Number of groups
n_groups <- max(aj$z_data$master_code)

# A function to extract the COVs and put them into nested tibbles
extractCOV <- function(X, n_groups, n_iso){
  
  # calculate the indices to look up for each group
  ff <- matrix(1:(n_iso*n_iso*n_groups), nrow = 2, byrow = TRUE)
  
  # conver to list by row for passing to map()
  location <- lapply(seq_len(nrow(ff)), function(i) x[i,])
  
  # create some labels so we can keep track of which group is which
  names(location) <- paste0("zCOV_", 1:n_groups)
  
  # map over the column index locations of each of the groups' Sigma2 
  # data, extract it, convert it to a nxn matrix, store it as a list within a 
  # tibble and name the column zCOV_1 for z-transformed Covariance matrix for 
  # group with the master_code == 1.
  out <- location %>% 
    imap(~ X %>% as_tibble(., rownames = "index") %>%
          group_by(`index`) %>% 
          select("index", all_of(.x + 1)) %>% 
           # nest(.key = .y) %>%
           nest() %>% 
           ungroup() %>%
           mutate({{.y}} := map(`data`, \(x) matrix(as.matrix(x), 
                                                    ncol = 2, nrow = 2) )) %>% 
           select(all_of(.y))
           
    ) %>%
    bind_cols()
  
}


# 
# 
# bb <- as_tibble(test[[1]][,1:4], rownames = "index") %>% 
#   group_by(index) %>% nest() %>%
#   mutate(data2 = map(data, \(x) matrix(as.matrix(x), ncol = 2, nrow = 2)))
# 
# 
# cc <- as_tibble(test[[1]][,5:8], rownames = "index") %>% 
#   group_by(index) %>% nest() %>%
#   mutate(data2 = map(data, \(x) matrix(as.matrix(x), ncol = 2, nrow = 2)))
