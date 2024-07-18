#' Compute normal data ellipses
#'
#' The method for calculating the ellipses has been modified from
#' `car::dataEllipse` (Fox and Weisberg 2011, Friendly and Monette 2013)
#'
#' @references John Fox and Sanford Weisberg (2011). An \R Companion to Applied
#'   Regression, Second Edition. Thousand Oaks CA: Sage. URL:
#'   \url{https://socialsciences.mcmaster.ca/jfox/Books/Companion/}
#' @references Michael Friendly. Georges Monette. John Fox. "Elliptical
#'   Insights: Understanding Statistical Methods through Elliptical Geometry."
#'   Statist. Sci. 28 (1) 1 - 39, February 2013. URL:
#'   \url{https://projecteuclid.org/journals/statistical-science/volume-28/issue-1/Elliptical-Insights-Understanding-Statistical-Methods-through-Elliptical-Geometry/10.1214/12-STS402.full}
#'
#' @param level The level at which to draw an ellipse, taking a value between 0
#'   and 1 and approximating the proportion of data points inside the ellipse
#'   (behaves better with sample sizes per ellipse >10). Defaults to NULL which
#'   draws the Standard Ellipse area or small size corrected SEAc which contains
#'   approximately 39% of the data.
#'
#' @param type The type of ellipse. The default is the the standard ellipse
#'   `"SEA"`. The alternative is the small sample size corrected `"SEAc"`
#'
#' @param segments The number of segments to be used in drawing the ellipse.
#' @inheritParams layer
#' @inheritParams geom_point
#' @export
#' @examples
#' ggplot(demo.siber.data, 
#' aes(iso1, iso2, 
#' color = factor(group), 
#' shape = factor(community))) + 
#' geom_point() + stat_SIBER_ellipse() + scale_color_viridis_d()
#'
#' ggplot(demo.siber.data, 
#' aes(iso1, iso2, 
#' color = factor(group), shape = factor(community))) + 
#' geom_point() + stat_SIBER_ellipse(level = 0.95) + scale_color_viridis_d()
#'
#' ggplot(demo.siber.data %>% 
#' group_by(group, community) %>%
#' slice_sample(n = 6) %>% ungroup, 
#' aes(iso1, iso2, 
#' color = factor(group), shape = factor(community))) + 
#' geom_point() + stat_SIBER_ellipse(type = "SEA") + 
#' stat_SIBER_ellipse(type = "SEAc", linetype = 2) +
#' scale_color_viridis_d()
#'
stat_siber_ellipse <- function(mapping = NULL, data = NULL,
                         geom = "path", position = "identity",
                         ...,
                         type = "SEA",
                         level = NULL,
                         segments = 51,
                         na.rm = FALSE,
                         show.legend = NA,
                         inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = StatEllipse,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list2(
      type = type,
      level = level,
      segments = segments,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatEllipse <- ggproto("StatEllipse", Stat,
                       required_aes = c("x", "y"),
                       
                       compute_group = function(data, scales, type = "SEA", level = NULL,
                                                segments = 51, na.rm = FALSE) {
                         calculate_ellipse(data = data, vars = c("x", "y"), type = type,
                                           level = level, segments = segments)
                       }
)

calculate_ellipse <- function(data, vars, type, level, segments){
  dfn <- 2
  n <-nrow(data) # sample size
  dfd <- n - 1
  
  
  if (!type %in% c("SEA", "SEAc")) {
    cli::cli_inform("Unrecognized ellipse type")
    ellipse <- matrix(NA_real_, ncol = 2)
  } else if (dfd < 3) {
    cli::cli_inform("Too few points to calculate an ellipse")
    ellipse <- matrix(NA_real_, ncol = 2)
  } else {
    
    v <- stats::cov.wt(data[,vars])
    
    shape <- v$cov
    center <- v$center
    chol_decomp <- chol(shape)
    
    if (is.null(level)) {
      qq <- 1
    }
    
    if (type == "SEA") {
      if (is.null(level)) {
        radius <- 1
      } else {
        radius <- sqrt(stats::qchisq(level, df=2))
        }
      
    } else if (type == "SEAc") {
      if (is.null(level)) {
        radius <- sqrt((n-1)/(n-2))
      } else {
        radius <- sqrt(stats::qchisq(level, df=2) * (n-1) / (n-2))
      }
    }
    
    
    angles <- (0:segments) * 2 * pi/segments
    unit.circle <- cbind(cos(angles), sin(angles))
    ellipse <- t(center + radius * t(unit.circle %*% chol_decomp))
  }
  
  colnames(ellipse) <- vars
  ggplot2:::mat_2_df(ellipse)
}