# Here I specify a new version of the siber.ellipses function
# that performs a z-score transformation on the data prior to fitting
# and then rescales the covariance matrix back up to the original scale.

bayesian.ellipses <- function (x, y, group, 
                                 method=c("rmultireg","CholeskyJAGS","IWJAGS"), parms,priors) 
{
  
  
  # NB in all cases, fitting is performed on mean centred, sd standardised
  # transformation to the data. Code at the end then back-transforms the
  # covariance matrix and location of the ellipse for downstream plotting
  # and calculation of the SEA.
  
  ngroups <- length(unique(group))
  spx <- split(x, group)
  spy <- split(y, group)
  
  # prep the matrix to collect posterior samples of the SEA measures
  n.samps <- parms$n.chains * (parms$n.iter - parms$n.burnin) / parms$n.thin
  SEA.B <- matrix(data = 0, nrow = n.samps, ncol = ngroups)
  
  
  
  # creat the SIBER ellipse object to be returned by this function
  ellipses<-list()
  
  for (j in 1:ngroups) {
    
    mu.x <- mean(spx[[j]])
    var.x <- var(spx[[j]])
    sd.x <- sd(spx[[j]])
    
    mu.y <- mean(spy[[j]])
    var.y <- var(spy[[j]])
    sd.y <- sd(spy[[j]])
    
    x.zscore <- (spx[[j]] - mu.x) / sd.x
    y.zscore <- (spy[[j]] - mu.y) / sd.y
    
    # This line is where the actual fitting happens
    #model <- bayesMVN(x.zscore, y.zscore, R = R)
    
    # this is a generic function to allow easy specification of 
    # alternative methods for fitting ellipses to data.
    # The input variable "parms" will hold information for 
    # passing to the appropriate fitting function, such as
    # number of reps, burnin, etc...
    # I will retain compatability with the function rmultireg() function
    # for now, but will phase out to prefer JAGS / BUGS specification in 
    # future releases.
    
    model <- fit.ellipses(x.zscore,y.zscore,method,parms,priors)
    
    
    #model.Cholesky <- fit.ellipses(x,y,method="rmultireg",parms)
    
    # after fitting, scale the covariance matrix back to the original
    # raw data.
    
    # first the two diagonal variances
    model$S[,1] <- model$S[,1] * var.x
    model$S[,4] <- model$S[,4] * var.y
    
    # then the covariances
    model$S[,2] <- model$S[,2] * sd.x * sd.y
    model$S[,3] <- model$S[,2]
    
    # now correct the means        
    model$mu[,1] <- model$mu[,1] + mu.x
    model$mu[,2] <- model$mu[,2] + mu.y
    
    # -- START --
    # This code snippet calculates the actual SEA
    # Think i might move this out of the MVN fitting
    # process to keep the code cleaner here.
    #print(dim(model$mu))
    #print(dim(model$S))
    Nobs <- nrow(model$mu)
    for (i in 1:Nobs) {
      estS <- model$S[i, ]
      dim(estS) <- c(2, 2)
      SEA.B[i, j] <- popSEA(estS)$SEA
    }
    
    # save all posterior estimates of means and sigma matrix
    ellipses$S[[j]] <- model$S
    ellipses$mu[[j]] <- model$mu
    
  }
  
  
  
  
  # collect data for output as SIBER ellipse object
  ellipses$ngroups <- ngroups
  ellipses$SEA.B <- SEA.B
  ellipses$method <- method
  ellipses$priors <- priors
  ellipses$parms <- parms
  
  return(ellipses)
}