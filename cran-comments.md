Some checks highlighted in correspondance from Brian Ripley regarding new checks on vignettes that SIBER failed. I have rectified these in this release. SIBER was removed from CRAN with the note "Archived on 2019-01-23 as check issues were not corrected in time."

## Resubmission
* A submission on 14-Feb-2019 was automatically rejected owing to a failed vignette re-build. I have rectified by adding `library(SIBER)` to this 'Points-Inside-Outside-Ellipse.Rmd'.


### Previous NOTES
* email from Brian Ripley indicated duplicated titles in vignettes (along with some otehr minor issues) which has been rectified.
* there was also an issue noted by Brian Ripley with one or more of the vignettes: 

--- re-building ‘Points-Inside-Outside-Ellipse.Rmd’ using rmarkdown
Warning in engine$weave(file, quiet = quiet, encoding = enc) :
 The vignette engine knitr::rmarkdown is not available, because the rmarkdown package is not installed. Please install it.
Quitting from lines 22-33 (Points-Inside-Outside-Ellipse.Rmd)
Error: processing vignette 'Points-Inside-Outside-Ellipse.Rmd' failed with diagnostics:
could not find function "generateSiberGroup"
--- failed re-building ‘Points-Inside-Outside-Ellipse.Rmd’

* I cant reproduce this warning in either the local or remote test environments, but have added `Suggets: rmarkdown` to DESCRIPTION which from reading various help boards I believe will prevent it.

## Test environments
* local OS X 10.14.2 install, R 3.5.2
* win-builder release
* win-builder development


## R CMD check results
* There were no ERRORs or WARNINGs 
* There were 2 NOTEs. 
    * The first arises owing to this being a new submission that overwrites the archived version of the same name which was removed owing to it failing checks.
    * The second results from 3 instances of "no visible binding for global variable 'VAR'" all relating to the function `kapow()` and `siberKapow()`. These all arise from use of `ggplot2` and 'dplyr'. This note can be ignored as the data.frame object passed into `kapow()` and `siberKapow()` will have these variable names. 

## CRAN Package Check Results for Package SIBER
* As per note at the start, this package failed the latest round of checks owing to vignette title naming bugs. I have rectified all.

## Downstream dependencies
There are no downstream dependencies.

