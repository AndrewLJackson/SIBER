fit.ellipses <- function (x, y, method, parms, priors) 
{
    # This is a wrapper function to fit individual multivariarate normal
    # distributions to x,y data where both mean and Sigma are unknown.
    # Ultimately, I want to create a new object class called SIBER
    # in order to standardise the required output.

    if (method == "rmultireg") {
      print("starting rmultireg fitting")
      Y <- cbind(x, y)
      X <- matrix(1, length(x), 1)
      b <- matrix(double(parms$n.iter * 2), ncol = 2)
      S <- matrix(double(parms$n.iter * 4), ncol = 4)
      for (i in 1:parms$n.iter) {
          out <- rmultireg(Y, X, priors$Bbar, priors$A, priors$nu, priors$V)
          b[i, ] <- out$B
          S[i, ] <- out$Sigma
      }
      model <- list()
      model$mu <- b
      model$S <- S
      return(model)}
    
    if (method == "CholeksyJAGS") {
      # I'm leaving this in here for potential future development, though
      # for relatively low dimensional problems with only 2 isotopes, I
      # dont this Cholesky Decomposition will ever provide an improvement
      # in model fit.
    }
    
    if (method == "IWJAGS") {
      
      print("starting IW JAGS fitting")
      
      Y = cbind(x,y)
      n.obs <- nrow(Y)
      n.iso <- ncol(Y)
      
      jags.data <- list("Y"=Y,"n.obs"=n.obs,"n.iso"=n.iso,
                    "R"=priors$R,"k"=priors$k,"tau.mu"=priors$tau.mu)

      inits <- list(
          list(mu=rnorm(2,0,1)),
          list(mu=rnorm(2,0,1))
         )
   

      parameters <- c("mu","Sigma2","rho")

      Iwishart <- jags(jags.data, inits=inits, parameters, 
                        model.file=IWEllipse, n.chains=2, 
                        n.iter=parms$n.iter, n.burnin=parms$n.burnin, n.thin=parms$n.thin, DIC=T)
      
      model <- list()
      model$mu <- Iwishart$BUGSoutput$sims.matrix[,6:7]
      model$S <-  Iwishart$BUGSoutput$sims.matrix[,1:4]
      model$n.samps <- ncol(model$mu)
      return(model)
    }
    #else {
    #error("That method is not recognised. See help files for accepted methods")
    #}
}



# ------------------------------------------------------------------------------
# JAGS code for fitting Inverse Wishart version of SIBER
# ------------------------------------------------------------------------------

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

#inverse of covariance matrix

# calculate correlation coefficient
rho <- Sigma2[1,2]/sqrt(Sigma2[1,1]*Sigma2[2,2])



# AJ - i am pretty sure the priors for the precision and covariance
# matrices are defined below amidst the code.

#tau <- pow(sigma, -2)  # convert to precision inverse(sigma^2)
#sigma ~ dunif (0, 100) 
# uniform prior on SD of the residual error term

#----------------------------------------------------
# specify the likelihood of the observed data
#----------------------------------------------------

for (i in 1:n.obs) {                             
  Y[i,1:2] ~ dmnorm(mu[1:n.iso],tau[1:n.iso,1:n.iso])
}



} # end of model 



