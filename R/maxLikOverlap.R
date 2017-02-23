#' Calculate the overlap between two ellipses based on the maximum likelihood 
#' fitted ellipses.
#' 
#' This function uses the ML estimated means and covariances matrices of two 
#' specified groups to calculate the area of overlap.
#' 
#' @param ellipse1 character code of the form \code{"x.y"} where \code{x} is an 
#'   integer indexing the community, and \code{y} an integer indexing the group 
#'   within that community. This specifies the first of two ellipses whose 
#'   overlap will be compared.
#'   
#' @param ellipse2 same as \code{ellipse1} specifiying a second ellipse.
#'   
#' @param siber.object an object created by  \code{\link{createSiberObject}} 
#'   which contains the ML estimates for the means and covariance matrices for 
#'   each group.
#'   
#' @param p.interval the prediction interval used to scale the ellipse as per 
#'   \code{\link{addEllipse}}.
#'   
#' @param n the number of points on the edge of the ellipse used to define it. 
#'   Defaults to \code{100} as per \code{\link{addEllipse}}.
#'   
#' @param do.plot logical switch to determine whether the corresponding ellipses
#'   should be plotted or not. A use-case would be in conjunction with a low 
#'   numebr od \code{draws} so as to visualise a relatively small number of the 
#'   posterior ellipses. Defaults to \code{FALSE}.
#'   
#' @return A vector comprising three columns: the area of overlap, the area of 
#'   the first ellipse and the area of the second ellipse and as many rows as 
#'   specified by \code{draws}.
#'   
#' @examples 
#' # load in the included demonstration dataset data("demo.siber.data")
#' siber.example <- createSiberObject(demo.siber.data) 
#' 
#' # The first ellipse is referenced using a character string representation 
#' # where in "x.y", "x" is the community, and "y" is the group within that 
#' # community.
#' ellipse1 <- "1.2" 
#' 
#' # Ellipse two is similarly defined: community 1, group3 
#' ellipse2 <- "1.3"
#' 
#' # the overlap betweeen the corresponding 95% prediction ellipses is given by: 
#' ellipse95.overlap <- maxLikOverlap(ellipse1, ellipse2, siber.example,
#' p.interval = 0.95, n = 100)
#' 
#' @export


maxLikOverlap <- function(ellipse1, ellipse2, siber.object, 
                           p.interval = 0.95, n = 100,
                           do.plot = FALSE) {
  
  # ----------------------------------------------------------------------------
  # community code for the first ellipse
  tmp <- strsplit(ellipse1, "[.]")
  c.1 <- tmp[[1]][1]
  e.1 <- tmp[[1]][2]
  
  # see help file for addEllipse for more information. With p.interval = NULL 
  # and extracting the sample size from siber.examples$sample.sizes,
  # I am drawing small sample size corrected, Standard Ellipses around the data.
  coords.1 <- addEllipse(siber.object$ML.mu[[c.1]][ , , e.1],
                         siber.object$ML.cov[[c.1]][ , , e.1],
                         m = siber.object$sample.sizes[c.1, e.1],
                         small.sample = TRUE,
                         n = n,
                         p.interval = p.interval,
                         ci.mean = FALSE,
                         do.plot = FALSE)
  
  # calculate the area of this ellipse using the triangle method.
  area.1 <- hullArea(coords.1[,1], coords.1[,2])
  
  # ----------------------------------------------------------------------------
  # community code for the first ellipse
  tmp <- strsplit(ellipse2, "[.]")
  c.2 <- tmp[[1]][1]
  e.2 <- tmp[[1]][2]
  
  coords.2 <- addEllipse(siber.object$ML.mu[[c.2]][ , , e.2],
                         siber.object$ML.cov[[c.2]][ , , e.2],
                         m = siber.object$sample.sizes[c.2, e.2],
                         small.sample = TRUE,
                         n = n,
                         p.interval = p.interval,
                         ci.mean = FALSE,
                         do.plot = FALSE)
  
  # calculate the area of this ellipse using the triangle method.
  area.2 <- hullArea(coords.2[,1], coords.2[,2])
  
  # ----------------------------------------------------------------------------
  # and now we can use the function spatstat::overlap.xypolygon to calculate the 
  # overlap, which is expressed in units, in this case permil squared.
  overlap <- abs(spatstat::overlap.xypolygon(list(x = coords.1[,1],
                                                  y = coords.1[,2]), 
                                             list(x = coords.2[,1],
                                                  y = coords.2[,2])
                                             )
                 )
  
  out <- c(area.1 = area.1, area.2 = area.2, overlap = overlap)
  
  return(out)
}



