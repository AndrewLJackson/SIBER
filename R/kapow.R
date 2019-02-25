#' KAPOW!
#' 
#' This function packs a punch and makes a pretty figure.
#' 
#' @param cd sets the random seed to this
#' @param ng the number of ellipses to draw
#' @param n the number of data points to simulate per group, but never displayed
#' @param sc the scaling factor the rwishart sigma called by 
#'   \code{\link[stats]{rWishart}}
#' @param do.plot a logical indicating whether the plot should be printed
#'   (defaults to TRUE).
#'   
#' @return A ggplot object
#'   
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr "%>%"
#' 
#' @export

kapow <- function(cd = 7, ng = 25, n = 50, sc = 10, do.plot = TRUE) {
  
  # 7 seem pretty good with the other defaults above.
  set.seed(cd)
  
  Y <- generateSiberCommunity(n.groups = ng, n.obs = n, wishSigmaScale = sc)
  
  # dplyr version causes NOTE to be generated with
  # "no visible binding for global variable ‘group’"
  # Y <- Y %>% mutate(group = factor(group))
  Y$group <- factor(Y$group)
  
  # myScale <- function(x){ (x - mean(x)) / sd(x)}
  # Y <- Y %>% group_by(group) %>% mutate(iso1 = myScale(iso1), 
  #                                       iso2 = myScale(iso2))
  
  ellY <- siberKapow(Y, isoNames = c("iso1","iso2"), group = "group")
  
  p <- ggplot(ellY$ell.coords, 
              mapping = aes_string(x = 'X1', y = 'X2', color = 'group', fill = 'group')) + 
    geom_polygon(alpha = 0.1) + 
    scale_color_discrete(guide = FALSE) + 
    annotate("text", x = 0, y = 0, label = "KAPOW!",
              size = 30, angle = 10, 
             color = "#F3F315") + 
    theme_classic() + 
    theme(axis.text.x  = element_blank(),
          axis.text.y  = element_blank(),
          axis.ticks   = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.line    = element_blank()) + 
    theme(legend.position="none")
  
  if (do.plot) print(p)
  
  return(p)
  
}

