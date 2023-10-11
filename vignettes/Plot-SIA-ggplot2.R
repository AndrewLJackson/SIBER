## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, fig.width = 9, fig.height = 6)

## ----import-data--------------------------------------------------------------

library(SIBER)
library(dplyr)
library(ggplot2)

# import the data. Replace this line with a read.csv() or similar call
# to you own local file.
data("demo.siber.data")

# make a copy of our data for use here in this example, and 
# set the columns group and community to be factor type using dplyr.
# Additionally rename the isotope data columns and drop the iso1 and iso2
# columns using the .keep option to keep only those that were not used to 
# create the new variables, i.e. keep only ones on the left of the "=". 
demo_data <- demo.siber.data %>% mutate(group = factor(group), 
                                        community = factor(community),
                                        d13C = iso1, 
                                        d15N = iso2,
                                        .keep = "unused") 


## ----first-gg-----------------------------------------------------------------

# when plotting colors and shapes, we need to tell ggplot that these are to 
# be treated as categorical factor type data, and not numeric.
first.plot <- ggplot(data = demo_data, 
                     aes(x = d13C, 
                         y = d15N)) + 
  geom_point(aes(color = group, shape = community), size = 5) +
  ylab(expression(paste(delta^{15}, "N (permille)"))) +
  xlab(expression(paste(delta^{13}, "C (permille)"))) + 
  theme(text = element_text(size=16)) + 
  scale_color_viridis_d()

# And print our plot to screen
print(first.plot)


## ----classic-theme------------------------------------------------------------

classic.first.plot <- first.plot + theme_classic() + 
  theme(text = element_text(size=18))

# and print to screen
print(classic.first.plot)

# options to add to point the axis tick marks inwards
# theme(axis.ticks.length = unit(0.1, "cm"))

## ----classic-scatterplot------------------------------------------------------

# Summarise By Group (sbg)
sbg <- demo_data %>% 
  group_by(group, community) %>% 
  summarise(count = n(),
            mC = mean(d13C), 
            sdC = sd(d13C), 
            mN = mean(d15N), 
            sdN = sd(d15N))

# make a copy of the first.plot object
# second.plot <- first.plot

# add the layers using the summary data in sbg
second.plot <- first.plot +
  geom_errorbar(data = sbg, 
                mapping = aes(x = mC, y = mN,
                              ymin = mN - 1.96*sdN, 
                              ymax = mN + 1.96*sdN), 
                width = 0) +
  geom_errorbarh(data = sbg, 
                 mapping = aes(x = mC, y = mN,
                               xmin = mC - 1.96*sdC,
                               xmax = mC + 1.96*sdC),
                 height = 0) + 
  geom_point(data = sbg, aes(x = mC, 
                             y = mN,
                             fill = group), 
             color = "black", shape = 22, size = 5,
             alpha = 0.7, show.legend = FALSE) + 
  scale_fill_viridis_d()


print(second.plot)
  

## ----nice-ellipses------------------------------------------------------------
# use our ellipse function to generate the ellipses for plotting

# decide how big an ellipse you want to draw
p.ell <- 0.95

# create our plot based on first.plot above adding the stat_ellipse() geometry.
# We specify thee ellipse to be plotted using the polygon geom, with fill and
# edge colour defined by our column "group", using the normal distribution and
# with a quite high level of transparency on the fill so we can see the points
# underneath. In order to get different ellipses plotted by both columns "group"
# and "community" we have to use the interaction() function to ensure both are
# considered in the aes(group = XYZ) specification. Note also the need to
# specify the scale_fill_viridis_d() function as the mapping of colors for
# points and lines is separate to filled objects and we want them to match.
ellipse.plot <- first.plot + 
  stat_ellipse(aes(group = interaction(group, community), 
                   fill = group, 
                   color = group), 
               alpha = 0.25, 
               level = p.ell,
               type = "norm",
               geom = "polygon") + 
  scale_fill_viridis_d()

print(ellipse.plot)


