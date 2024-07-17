#' Test whether a set of points are inside or outside a defined circle
#'
#' Takes a
#'
#' @param Z the `i x d` matrix of data points to be tested.
#' @param p the percentile of the ellipse to be tested.
#' @param r a manually defined radius of the circle to be used. Setting `r` to
#'   be anything other than NULL will override the choice of `p`.
#' @param method must be one of either "qChi" the default, or "qF" which
#'   calculates the prediction ellipse based on either the Chi square or F
#'   distribution method.
#'
#' @return A logical vector indicating whether the point is inside or outside
#'   the circle
#'
#' @export

ellipseInOut <- function(Z, p = 0.95, r = NULL, method = "qChi"){
  
  
  # if r is NULL as per default, calculate it based on p
  if(is.null(r)) {
    if (!method %in% c("qF", "qChi")) {
      cli::cli_inform("Unrecognised method.")} else {
        if(method == "qF") {
          # sample size
          n <- nrow(Z)
          
          r <- (ncol(Z)*(n+1)*(n-1)) * 
          stats::qf(p = p, df1 = ncol(Z), df2 = n-2) / (n*(n-2))}
        
        if(method == "qChi"){r <- stats::qchisq(p = p, df = ncol(Z))}  
      }
    
  }
  
  # determine if each point is inside this radius or not
  inside <- rowSums(Z ^ 2) < r
  
  # return this logical vector
  return(inside)
  
}