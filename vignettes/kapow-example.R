## ----message=FALSE------------------------------------------------------------
library(dplyr)
library(purrr)
library(ggplot2)
library(SIBER)


## ----import-data--------------------------------------------------------------

# This loads a pre-saved object called mongoose that comprises the 
# dataframe for this analysis.
data("mongooseData")


# Ordinarily we might typically use code like this to import our data from a 
# csv file. 
# mongoose <- read.csv("mongooseFullData.csv", header = TRUE, 
#                      stringsAsFactors = FALSE)



## ----remove-small-n-----------------------------------------------------------

# min sample size for individual replicates per pack.
min.n <- 4

mongoose_2 <- mongoose %>% group_by(indiv.id, pack) %>% 
  filter(n() >= min.n) %>% ungroup()

# convert pack and indiv.id to factor
mongoose_2 <- mongoose_2 %>% mutate(indiv.id = factor(indiv.id),
                                    pack = factor(pack))

# count observations 
id_pack_counts <- mongoose %>% count(pack)

knitr::kable(id_pack_counts)


## ----plot-raw-data, fig.height = 10, eval = FALSE, include = FALSE------------
#  
#  p1 <- ggplot(data = mongoose_2, aes(c13, n15, color = indiv.id)) +
#    geom_point()  +
#    viridis::scale_color_viridis(discrete = TRUE, guide = FALSE) +
#    facet_wrap(~pack)
#  
#  print(p1)
#  

## ----make-packs, results = "hide"---------------------------------------------

# split by pack
packs <- mongoose_2 %>% split(.$pack)

# use purrr::map to apply siberKapow across each pack.
pack_boundaries <- purrr::map(packs, siberKapow, isoNames = c("c13","n15"), 
                             group = "indiv.id", pEll = 0.95)


# Define afunction to strip out the boundaries of the union of the 
# ellipses and plot them. This function returns the ggplot2 object
# but doesnt actually do the plotting which is handled afterwards.
plotBoundaries <- function(dd, ee){
  
  # exdtract the boundary points for each KAPOW shape.
  bdry <- data.frame(dd$bdry)
  
  # the plot object
  p <- ggplot(data = ee, aes(c13, n15, color = indiv.id)) + 
  geom_point()  + 
  viridis::scale_color_viridis(discrete = TRUE, guide = "legend", name = "Individual") + 
    geom_polygon(data = bdry, mapping = aes(x, y, color = NULL), alpha = 0.2) + 
    viridis::scale_fill_viridis(discrete = TRUE, guide = FALSE) + 
    theme_bw() + 
    ggtitle(paste0("Pack: ", as.character(ee$pack[1]) )) + 
    geom_polygon(data = dd$ell.coords, aes(X1, X2, group = indiv.id), 
                 alpha = 0.2, fill = NA)
  return(p)
  
}


# map this function over packs and return the un-printed ggplot2 objects
bndry_plots <- purrr::map2(pack_boundaries, packs, plotBoundaries)

# print them to screen / file
print(bndry_plots)




## ----print-areas--------------------------------------------------------------

# KAPOW areas for each pack
total.area <- map(pack_boundaries, spatstat.geom::area)

# a function to extract ellipse coordinates, calculate areas and return
# as a vector not a list.
extractProportions <- function(x){unlist(map(x$owin.coords, spatstat.geom::area))}

# map our individual ellipse area function over packs
ellipse.areas <- map(pack_boundaries, . %>% extractProportions)

# calculate ellipses as proportions of the KAPOW for that pack by mapping
# over both the individual ellipses and pack totals and dividing.
ellipse_proportions <- map2(ellipse.areas, total.area, `/`)

# print(ellipse_proportions)

# convert to table with a nested map_df call for easier printing. 
# Probably possible to use at_depth() to simplify this, but possibly
# not as i use map_df() here.
df_proportions <- map_df(ellipse_proportions, 
                         . %>% map_df(data.frame, .id = "individual"), 
                         .id = "pack" )

# rename the ugly variable manually
df_proportions <- rename(df_proportions, Proportion = ".x..i..")

# print a nice table
knitr::kable(df_proportions, digits = 2)

# Optional code to save to csv file
# write.csv(df_proportions, file = "mongoose_kapow_niche_proportions.csv",
#           row.names = FALSE)


