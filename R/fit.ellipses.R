fit.ellipse <- function (x, y, parms, priors) 
{

  # ----------------------------------------------------------------------------
  # JAGS code for fitting Inverse Wishart version of SIBER to a single group
  # ----------------------------------------------------------------------------
  
  modelstring <- '
    
    model {
    # ----------------------------------
    # define the priors
    # ----------------------------------
    
    # this loop defines the priors for the means
    for (i in 1:n.iso) {
      mu[i] ~ dnorm (0, tau.mu)
    }
    
    # prior for the precision matrix
    tau[1:n.iso,1:n.iso] ~ dwish(R[1:n.iso,1:n.iso],k)
    
    # convert to covariance matrix
    Sigma2[1:n.iso, 1:n.iso] <- inverse(tau[1:n.iso, 1:n.iso]) 
    
    # calculate correlation coefficient
    # rho <- Sigma2[1,2]/sqrt(Sigma2[1,1]*Sigma 2[2,2])
    
    #----------------------------------------------------
    # specify the likelihood of the observed data
    #----------------------------------------------------
    
    for(i in 1:n.obs) {                             
      Y[i,1:2] ~ dmnorm(mu[1:n.iso],tau[1:n.iso,1:n.iso])
    }
    
    
    
  }' # end of jags model script
  
  
  # ----------------------------------------------------------------------------
  # Prepare objects for passing to jags
  # ----------------------------------------------------------------------------
  
  
  Y = cbind(x,y)
  n.obs <- nrow(Y)
  n.iso <- ncol(Y)
  
  jags.data <- list("Y"= Y, "n.obs" = n.obs, "n.iso" = n.iso,
                    "R"= priors$R, "k" = priors$k, "tau.mu" = priors$tau.mu)
  
  inits <- list(
    list(mu=rnorm(2,0,1)),
    list(mu=rnorm(2,0,1))
  )
  
  
  # monitor all the parameters
  parameters <- c("mu","Sigma2")
  
  model <- jags.model(textConnection(modelstring),
                      data = jags.data, n.chains = 2)
  
  output <- coda.samples(model = model,
                      variable.names = c("mu",'Sigma2'),
                      n.iter = parms$n.iter,
                      thin = 10
                      )
  
  print(summary(output))
  print(dim(output[[1]]))
  
  


  return(output)


}






