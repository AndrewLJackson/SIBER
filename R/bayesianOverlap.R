#' Calculate the overlap between two ellipses based on their posterior 
#' distributions.
#' 
#' This function loops over the posterior distribution of the means and 
#' covariances matrices of two specified groups.
#' 
#' @param ellipse1 character code of the form \code{"x.y"} where \code{x} is an 
#'   integer indexing the community, and \code{y} an integer indexing the group 
#'   within that community. This specifies the first of two ellipses whose 
#'   overlap will be compared.
#'   
#' @param ellipse2 same as \code{ellipse1} specifying a second ellipse.
#'   
#' @param ellipses.posterior a list of posterior means and covariances fitted 
#'   using \code{\link{siberEllipses}}.
#'   
#' @param draws an integer specifying how many of the posterior draws are to be 
#'   used to estimate the posterior overlap. Defaults to \code{10} which uses 
#'   the first 10 draws. In all cases, the selection will be \code{1:draws} so 
#'   independence of the posterior draws is assumed. Setting to \code{NULL} will
#'   use all the draws (WARNING - like to be very slow).
#'   
#' @param p.interval the prediction interval used to scale the ellipse as per 
#'   \code{\link{addEllipse}}.
#'   
#' @param n the number of points on the edge of the ellipse used to define it. 
#'   Defaults to \code{100} as per \code{\link{addEllipse}}.
#'   
#' @param do.plot logical switch to determine whether the corresponding ellipses
#'   should be plotted or not. A use-case would be in conjunction with a low 
#'   numbered \code{draws} so as to visualise a relatively small number of the 
#'   posterior ellipses. Defaults to \code{FALSE}.
#'   
#' @return A data.frame comprising three columns: the area of overlap, the area 
#'   of the first ellipse and the area of the second ellipse and as many rows as
#'   specified by \code{draws}.
#'   
#' @export


bayesianOverlap <- function(ellipse1, ellipse2, ellipses.posterior, 
                           draws = 10, p.interval = 0.95, n = 100,
                           do.plot = FALSE) {
  
  
  if (is.null(draws)) draws = nrow(ellipses.posterior[[1]])
  
  # prepare the dataframe for collecting results
  out <- data.frame(area1 = double(draws), 
                    area2 = double(draws), 
                    overlap = double(draws))
  
  
  for (i in 1:draws){
    
    # --------------------------------------------------------------------------
    # generate the coordinates for the first ellipse
    coords.1 <- addEllipse(ellipses.posterior[[ellipse1]][i, 5:6], 
                           matrix(ellipses.posterior[[ellipse1]][i , 1:4], 
                                  nrow = 2, ncol = 2),
                           p.interval = p.interval,
                           n = n,
                           do.plot = do.plot,
                           small.sample = FALSE)
    
    # calculate the area of this ellipse using the triangle method.
    area.1 <- hullArea(coords.1[,1], coords.1[,2])
    
    # --------------------------------------------------------------------------
    # generate the coordinates for the second ellipse
    coords.2 <- addEllipse(ellipses.posterior[[ellipse2]][i, 5:6], 
                           matrix(ellipses.posterior[[ellipse2]][i, 1:4], 
                                  nrow = 2, ncol = 2),
                           p.interval = p.interval,
                           n = n,
                           do.plot = do.plot,
                           small.sample = FALSE)
    
    # calculate the area of this ellipse using the triangle method.
    area.2 <- hullArea(coords.2[,1], coords.2[,2])
    
    # --------------------------------------------------------------------------
    # and then the overlap between the two
    # and now we can use the function spatstat.utils::overlap.xypolygon to 
    # calculate the overlap, which is expressed in units, in this case permil 
    # squared.
    overlap <- abs(spatstat.utils::overlap.xypolygon(list(x = coords.1[,1],
                                                    y = coords.1[,2]), 
                                               list(x = coords.2[,1],
                                                    y = coords.2[,2]) ) )
    
    out[i,1:3] <- c(area.1, area.2, overlap)
  }
  
  
  return(out)
}



