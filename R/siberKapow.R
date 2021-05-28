#' Calculates the boundary of a union of ellipses
#' 
#' Intended to calculate the area of an ellipse as a proportion of a group of 
#' ellipses represented by their union, i.e. the total area encompassed by all 
#' ellipses superimposed.
#' 
#' @param dtf a data.frame object comprising bivariate data as a requirement, 
#'   and possibly other variables too but these are currently ignored.
#' @param isoNames a character vector of length 2 providing the names of the 
#'   variables containing the x and y data respectively.
#' @param group a character vector of length 1 providing the name of the 
#'   grouping variable on which to calculate the KAPOW ellipse.
#' @param pEll the probability ellipse to draw for each group. Defaults to the 
#'   Standard Ellipse with \code{pEll = stats::pchisq(1, df = 2)}.
#'   
#' @return an object of class \code{spatstat.geom::owin} containing the numerically calculated
#'   ellipses and their union along with the raw ellipse boundaries in both raw
#'   and \code{spatstat.geom::owin} format.
#' 
#' @import ggplot2
#' @import dplyr
#' @import spatstat
#' @importFrom magrittr "%>%"
#'   
#' @export

siberKapow <- function(dtf, isoNames = c("iso1", "iso2"), 
                       group = "group", pEll = stats::pchisq(1, df = 2)){
 
  # a function to calculate the boundaries of an individual ellipse
  calcBoundaries <- function(dd){
    
    mu <- dd %>% select(isoNames) %>% colMeans()
    
    Sigma <- dd  %>% select(isoNames) %>% stats::cov()
    
    # turn the mean and covariance matrix into a set of xy coordinates 
    # demarcating the ellipse boundary. SIBER::addellipse()
    out <- addEllipse(mu, Sigma,
                      m = nrow(dd),
                      n = 360 * 1,
                      p.interval = pEll,
                      ci.mean = FALSE,
                      lty = 3,
                      lwd = 2,
                      small.sample = TRUE,
                      do.plot = FALSE)
    
    # remove the last, and replicated point as the subsequent 
    # spatstat functions dont want any replicates.
    return(slice(data.frame(out), -n()))
  }
  
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  
  # apply our function to each group to calcluate the ellipse boundaries
  ellCoords <- dtf %>% ungroup() %>% droplevels() %>% 
    # group_by_(.dots = "group") %>%
    group_by_(.dots = group) %>%
    do(calcBoundaries(.data))
  
  # split the dataset by the defined grouping parameter
  # The piped version causes NOTEs
  # "no visible binding for global variable ‘group’"
  # ellCoords.list <- ellCoords %>% split(., .[,group])
  # ellCoords.list <- split(ellCoords, ellCoords$group)
  ellCoords.list <- split(ellCoords, ellCoords[`group`])
  
  # Define a short custom function and then apply it over the list
  # using map()
  ell2owin <- function(x){spatstat.geom::owin(poly = list(x = x$X1, y = x$X2))}
  owin.coords <- purrr::map(ellCoords.list, ell2owin)
  
  # pass the list of ellipses for each individal to spatstat::union.owin
  # using do.call, which i dont really like but it is the only way i have 
  # found to parse the list correctly into union.owin. That is, I want 
  # this.list <- list(a,b,c) to be passed as union.owin(a,b,c)
  boundaries <- do.call(get("union.owin", asNamespace("spatstat.geom")),
                        owin.coords)
  
  # bundle these coordinates into the boundaries object for later recall
  boundaries$owin.coords <- owin.coords
  boundaries$ell.coords <- ellCoords
  names(boundaries$owin.coords) <- names(ellCoords.list)
  
  return(boundaries)
  
}







