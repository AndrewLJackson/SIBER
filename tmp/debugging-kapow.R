# the plot object
# p <- ggplot(data = ee, aes(c13, n15, color = indiv.id)) + 
#   geom_point() +
#   viridis::scale_color_viridis(discrete = TRUE, guide = "legend", name = "Individual") +
#   geom_polygon(data = bdry, mapping = aes(x, y, color = NULL), alpha = 0.2) +
#   viridis::scale_fill_viridis(discrete = TRUE, guide = FALSE) +
#   theme_bw() +
#   ggtitle(paste0("Pack: ", as.character(ee$pack[1]) ))
#   # geom_polygon(data = dd$ell.coords[[1]], aes(X1, X2),
#   #              alpha = 0.2, fill = NA, color = "red")
# 
# 
# plot(p)

# ------------------------------------------------------------------------------

testKapow <- function (dtf, isoNames = c("iso1", "iso2"), group_var = group, 
          pEll = stats::pchisq(1, df = 2)) 
{
  calcBoundaries <- function(dd) {
    mu <- dd %>% select(isoNames) %>% colMeans()
    Sigma <- dd %>% select(isoNames) %>% stats::cov()
    out <- addEllipse(mu, Sigma, m = nrow(dd), n = 360 * 
                        1, p.interval = pEll, ci.mean = FALSE, lty = 3, lwd = 2, 
                      small.sample = TRUE, do.plot = FALSE)
    return(slice(data.frame(out), -n()))
  }
  
  group_var = enquo(group_var)
  ellCoords <- dtf %>% ungroup() %>% droplevels() %>% group_by(!!group_var) %>%
    do(calcBoundaries(.data))  
  
  ellCoords.list <- split(ellCoords, select(ellCoords, !!group_var))
  # ell2owin <- function(x) {
  #   spatstat.geom::owin(poly = list(x = x$X1, y = x$X2))
  # }
  # owin.coords <- purrr::map(ellCoords.list, ell2owin)
  # boundaries <- do.call(get("union.owin", asNamespace("spatstat.geom")),
  #                       owin.coords)
  # boundaries$owin.coords <- owin.coords
  # boundaries$ell.coords <- ellCoords
  # names(boundaries$owin.coords) <- names(ellCoords.list)
  # return(boundaries)
  
  return(ellCoords.list)
}

# ------------------------------------------------------------------------------

testFoo <- function(dtf, group_var){
  group_var = enquo(group_var)
  ellCoords <- dtf %>% ungroup() %>% droplevels() %>% group_by(!!group_var) %>% 
    do(calcBoundaries(.data))
  return(ellCoords)
}

aa <- testFoo(dtf, group_var = pack)

bb <- testKapow(dtf, isoNames = c("dC", "dN"), group_var = pack, pEll = 0.95)

bb.list <- split(bb, select(bb,pack))



library(tidyverse)

cd = 7
ng = 25
n = 50
sc = 10
do.plot = TRUE

# 7 seem pretty good with the other defaults above.
set.seed(cd)

Y <- generateSiberCommunity(n.groups = ng, n.obs = n, wishSigmaScale = sc)

names(Y) <- c("dC", "dN", "pack", "comm")

bounds <- testKapow(Y, isoNames = c("dC", "dN"), group = "pack")

plot(bounds)
