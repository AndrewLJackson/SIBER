fit.ellipses <- function (x, y, parms, priors) 
{
  # This is a wrapper function to fit individual multivariarate normal
  # distributions to x,y data where both mean and Sigma are unknown.
  # Ultimately, I want to create a new object class called SIBER
  # in order to standardise the required output.
  
  # ----------------------------------------------------------------------------
  # JAGS code for fitting Inverse Wishart version of SIBER
  # ----------------------------------------------------------------------------
  
  IWEllipse <- function() {
    
    # ----------------------------------
    # define the priors
    # ----------------------------------
    
    # this loop defines the priors for the means
    for (i in 1:n.iso){
      mu[i] ~ dnorm (0, tau.mu)
    }
    
    # prior for the precision matrix
    tau[1:n.iso,1:n.iso] ~ dwish(R[1:n.iso,1:n.iso],k)
    
    # convert to covariance matrix
    Sigma2[1:n.iso, 1:n.iso] <- inverse(tau[1:n.iso, 1:n.iso]) 
    
    # calculate correlation coefficient
    # rho <- Sigma2[1,2]/sqrt(Sigma2[1,1]*Sigma2[2,2])
    
    #----------------------------------------------------
    # specify the likelihood of the observed data
    #----------------------------------------------------
    
    for (i in 1:n.obs) {                             
      Y[i,1:2] ~ dmnorm(mu[1:n.iso],tau[1:n.iso,1:n.iso])
    }
    
    
    
  } # end of jags model script
  
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
  parameters <- c("mu","Sigma2","rho")
  
  Iwishart <- jags(jags.data, inits=inits, parameters, 
                   model.file=IWEllipse, n.chains=2, 
                   n.iter=parms$n.iter, n.burnin=parms$n.burnin, n.thin=parms$n.thin, DIC=T)
  
  # collect data for output
  model- list ( mu = Iwishart$BUGSoutput$sims.matrix[,6:7],
                S = Iwishart$BUGSoutput$sims.matrix[,1:4],
                n.samps = ncol(model$mu)
                )

  return(model)


}






