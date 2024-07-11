library(SIBER)
library(tidyverse)
library(geometry)

source("R/createSiberObject2.R")
source("R/fitEllipse.R")
source("R/siberNSEA.R")



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

# A function to extract the COVs and put them into nested tibbles
extractCOV <- function(X, siber_obj){
  
  # calculate the indices to look up for each group
  ff <- matrix(1:(siber_obj$n.iso^2*n_groups), 
               nrow = siber_obj$n.groups, byrow = TRUE)
  
  # convert to list by row for passing to map()
  location <- lapply(seq_len(nrow(ff)), function(i) ff[i,])
  
  # create some labels so we can keep track of which group is which
  names(location) <- paste0(1:siber_obj$n.groups)
  
  # map over the column index locations of each of the groups' Sigma2 
  # data, extract it, convert it to a nxn matrix, store it as a list within a 
  # tibble and name the column using master_code as character of numeric 
  # for z-transformed Covariance matrix for 
  # group with the master_code == 1.
  out <- location %>% 
    imap(~ X %>% 
           as.matrix() %>% 
           as_tibble(., rownames = "index") %>%
          group_by(`index`) %>% 
          select("index", all_of(.x + 1)) %>% 
           # nest(.key = .y) %>%
           nest() %>% 
           ungroup() %>%
           mutate({{.y}} := map(`data`, \(x) matrix(as.matrix(x), 
                                                    ncol = 2, nrow = 2) )) %>% 
           select(all_of(.y)) %>%
           tibble()
           
    ) %>%
    bind_cols()
  
  
  out <- map2(out, siber_obj$summary$cov, 
       \(x,y) x %>% map(\(z) backTransCOV(z,y))
       ) %>% as_tibble()
  
  return(out)
  
}

backTransCOV <- function(X,Z){
  
  # get sd of original data X
  a <- diag(X)^0.5
  A <- a %*% t(a)
  
  # rescale the Z score estimated correlation matrix back to covariance matrix
  # on same scale as the original data Xaj
  out <- Z * A
  
  return(out)
  
}


# extract the COV data from the fitted jags model
ajCOV <- extractCOV(test, siber_obj = aj)

# backtransform these correlation matrices to covariance matrices on the 
# original scale of the data.
# kk <- map2(ajCOV, aj$summary$cov, 
#            \(x,y) x %>% map_vec(\(z) siberNSEA(backTransCOV(z,y))) %>% 
#              as_tibble()
#            )

kk <- map(ajCOV, \(x) x %>% map_vec(\(z) siberNSEA(z)) %>% data.frame()) %>%
  bind_rows(.id = "master_code") %>% 
  mutate(master_code = as.numeric(master_code)) %>%
  rename("SEA_B_post" = ".")

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


