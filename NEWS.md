# SIBER 2.1.3
+ Contains a hotfix owing to a change to 'spatstat' detailed below
+ swapped package `spatstat` for `spatstat.utils` as per instructions from their package maintainers 23/03/2017
+ New functions `siberCentroids`, `specificCentroidVectors` and `allCentoidVectors` added to allow pairwise comparison of the locations of two groups using vectors. Illustrated in an accompanying vignette.

# SIBER 2.1.2
+ added ability to specify custom pch point orders in `plotSiberObject()`
+ added `...` to plotGroupHulls

# SIBER 2.1.1
+ N.B. an error during uploading to CRAN meant a release was never lodged. I have moved on to v2.1.2 for the next release as above.
+ hotfix for bug in bayesianOverlap - thanks Mark Nowak for spotting this.
+ **Important:** install from github if you want to use `bayesianOverlap` for now until I can push a hotfix to CRAN. `devtools::install_github("andrewljackson/SIBER", build_vingettes = TRUE)`
+ examples added to `maxLikOverlap()` and `pointsToEllipsoid()`.


# SIBER 2.1.0
+ Added functions to calculate whether arbitrary points are inside or outside ellipses or higher dimensional ellipsoids along with illustrative vignettes.
+ Changed method of calculation of angle of ellipse with x-axis to using `atan` in place of `asin` which is a more elegant way of ensuring the sign of the returned angle is correct.
+ Small sample size correction for drawing ellipses can now be toggled using addEllipse(small.sample = TRUE, m = m) effectively meaning SEAc or SEA can be illustrated.
+ New vignette added illustrating how to calculate overlap between two ellipses. Two new functions detailed below greatly improve the ease with which this can be applied.
+ Fixed three bugs in the ellipse overlap vignette. Thanks to [Sarina](https://github.com/AndrewLJackson/SIBER/issues/13) for pointing this out. These are no longer an issue as the new functions detailed below replace this code in the vignette, but it was helpful for me during the creation of these functions. Thanks.
+ Added a new function `bayesianOverlap()` that calculates the posterior overlap between ellipses fitted to two groups. Thanks to Josh Stewart for forcing my hand on this long-overdue feature. 
+ Added a new function `maxLikOverlap()` to ease the calculation of overlap between ellipses using the ML estimated ellipses which previously required more manually coding than was ideal. Thanks Mark Nowak and SarinaJ for spotting some bugs and helping work them out.
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