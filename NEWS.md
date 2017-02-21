# SIBER 2.1.0.xxx

# SIBER 2.1.0
+ Added functions to calculate whether arbitrary points are inside or outside ellipses or higher dimensional ellipsoids along with illustrative vignettes.
+ Changed method of calculation of angle of ellipse with x-axis to using `atan` in place of `asin` which is a more elegant way of ensuring the sign of the returned angle is correct.
+ Small sample size correction for drawing ellipses can now be toggled using addEllipse(small.sample = TRUE, m = m) effectively meaning SEAc or SEA can be illustrated.
+ New vignette added illustrating how to calculate overlap between two ellipses. Two new functions detailed below greatly improve the ease with which this can be applied.
+ Fixed three bugs in the ellipse overlap vignette. Thanks to [Sarina](https://github.com/AndrewLJackson/SIBER/issues/13) for pointing this out. These are no longer an issue as the new functions detailed below replace this code in the vignette, but it was helpful for me during the creation of these functions. Thanks.
+ Added a new function `bayesianOverlap()` that calculates the posterior overlap between ellipses fitted to two groups. Thanks to Josh Stewart for forcing my hand on this long-overdue feature. 
+ Added a new function `maxLikOverlap()` to ease the calculation of overlap between ellipses using the ML estimated ellipses which previously required more manually coding than was ideal.
+ added new functions `ellipseInOut()` and `pointsToEllipsoid` to enable testing of whether points lie inside or outside an n-dimensinoal ellipsoid, including the bivariate ellipse. These are useful for testing that the quantile prediction ellipses do indeed contain the expected number of data points from a sample. It might also be useful for assignment, identification of outliers, or measures of overlap of individual data points with other ellipses.

# SIBER 2.0.3
+ Added a new vignette illustrating how to add custom ellipses to each group manually using the function `addEllipse`

# SIBER 2.0.2
+ Bug in Group labels as character strings fixed
+ Community labels as character strings now implemented

# SIBER 2.0.1
+ Group labels can now be strings and do not have to be sequential integers (#14)

# SIBER 2.0
+ Major overhaul of all code and underlying fitting algorithms
+ Fitting is now via JAGS
+ Data are z-score transformed prior to fitting to improve convergence
+ Data structures have now changed from previous versions embedded within SIAR 
so you will have to reformat your data and write new scripts to interface with 
the new code