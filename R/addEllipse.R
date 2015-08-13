#' Adds an ellipse around some data to an existing plot
#' 
#' This function adds an ellipse based on means and covariance to an existing 
#' plot. The ellipse can be scaled so as to represent any prediction interval 
#' of the data you wish, or alternatively any confidence interval of the 
#' bivariate means.
#' 
#' @param mu a vector of length two specifying the bivariate means
#' @param sigma a 2x2 covariance matrix for the data
#' @param m is the sample size of the dataset on which the ellipse is to be 
#' plotted. This is only informative if calculating the confidence interval of 
#' the bivariate mean, which requires a correction of \code{1/sqrt(m)}. 
#' Defaults to NULL and has no effect.
#' @param n the number of data points to be used to plot the ellipse. More 
#' points makes for a smoother ellipse, especially if it has high eccentricity. 
#' Defaults to \code{n = 100}.
#' @param p.interval the quantile to be used to construct a prediction ellipse 
#' that contains p.interval proportion of the data. By default, 
#' \code{p.interval = NULL} and the Standard Ellipse is drawn which contains 
#' approximately 40\% of the data. Setting \code{p.interval = 0.95} will result 
#' in an ellipse that contains approximately 95\% of the data.
#' @param ci.mean a logical that determines whether the ellipse drawn is a 
#' prediction ellipse of the entire data, or a confidence interval of the 
#' bivariate means. Defaults to \code{FALSE}. If set to \code{TRUE}, then 
#' \code{p.interval} can be used to generate an appropriate \% confidence 
#' interval of the bivariate means.
#' @param ... additional arguments as a list to be passed to 
#' \code{\link[graphics]{plot}}.
#' 
#' @return A 6 x m matrix of the 6 Layman metrics of dX_range, dY_range, TA, 
#' CD, MNND and SDNND in rows, for each community by column
#' 
#' @examples
#' data(demo.siber.data)
#' my.siber.data <- createSiberObject(demo.siber.data)
#' communityMetricsML(my.siber.data)
#'  @export

addEllipse <- function(mu, sigma, m = NULL, n = 100, p.interval = NULL , 
                        ci.mean = FALSE, ...){
  
  # mu is the location of the ellipse (its bivariate mean)
  # sigma describes the shape and size of the ellipse
  # p can set the predction interval for the ellipse.
  # n determines how many data points are used to draw 
  #   the ellipse. More points = smoother curves.
  
  # if ci.mean is F (default) then we are plotting quantiles of the sample, 
  # i.e. prediction ellipses, and so we set c <- 1 so that it has no effect
  # below. Else it divides the radius calculation below by sqrt(m) to include
  # the conversion from standard deviation to standard error of the mean.
  ifelse(ci.mean, 
           c.scale <- m,
           c.scale <- 1
         )
  
  
  # if p is NULL then plot a standard ellipse with r = 1
  # else generate a prediction ellipse that contains
  # approximately proportion p of data by scaling r
  # based on the chi-squared distribution.
  # p defaults to NULL.
  ifelse(is.null(p.interval), 
           r <- 1, 
           r <- sqrt(stats::qchisq(p.interval, df=2))
         )

  
  # get the eigenvalues and eigenvectors of sigma
  # if ci.mean = T then the covariance matrix is divided by the sample size
  # so as to produce confidence ellipses for the mean. Else it has no 
  # effect with c.scale = 1.
  e = eigen(sigma / c.scale)
  
  # 
  SigSqrt = e$vectors %*% diag(sqrt(e$values)) %*% t(e$vectors)
  
  # create a unit radius circle to transform
  cc <- genCircle(n, r)
  
  # transform the unit circle according to the covariance 
  # matrix sigma
  
  # a function to transform the points
  back.trans <- function(x) {
    return(SigSqrt %*% x + mu)
  }
  
  # apply the transformation to calculate the 
  # Maximum Likelihood estimate of the ellipse.
  
  ML.ellipse = t(apply(cc,1, back.trans))
  
  if(grDevices::dev.cur() > 1) {graphics::lines(ML.ellipse, ...)}

  # optional return of x and y coordinates of the plotted ellipse
  return(ML.ellipse)

}