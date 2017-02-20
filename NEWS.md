# SIBER 2.0.4.xxx

# SIBER 2.0.4
+ Added functions to calculate whether arbitrary points are inside or outside ellipses or higher dimensional ellipsoids along with illustrative vignettes.
+ Changed method of calculation of angle of ellipse with x-axis to using `atan` in place of `asin` which is a more elegant way of ensuring the sign of the returned angle is correct.
+ Small sample size correction for drawing ellipses can now be toggled using addEllipse(small.sample = TRUE, m = m) effectively meaning SEAc or SEA can be illustrated.
+ New vignette added illustrating how to calculate overlap between two ellipses. The new process is not as straight forward as under SIAR, but I will work to improve the interface in future releases.
+ Fixed three bugs in the ellise overlap vignette.

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