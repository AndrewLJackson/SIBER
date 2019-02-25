## Resubmission
* Thanks Uwe for responding to my last submission on 19-FEB-2019 clarifying the need to remove the "no visible binding for variable 'xyz'" arising from my use of piped syntax with dplyr. I have removed these two NOTEs. Not by adding global variables, but in both instances by using base syntax and directly naming the variable using dollar sign notation within the data.frame, e.g. `df$group`. Thanks for taking the time to resond in person and hopefully now my submission on all CRAN test environments be O errors, 0 warnings and 0 notes as per my local environment.
* win-builder reports 1 NOTE under "checking CRAN incoming feasibility ... NOTE" pointing out, I believe, that this is a New submission that overrides a version that was removed owing to check issues not corrected in time.


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

* I cant reproduce this warning in either the local or remote test environments, but have added `Suggets: rmarkdown` to DESCRIPTION which from reading various help boards I believe  prevents it.

## Test environments
* local OS X 10.14.2 install, R 3.5.2
* win-builder release - generates 1 NOTE pointing out this is a New submission that overrides a version that was removed owing to check issues not corrected in time.
* win-builder development - generates 1 NOTE pointing out this is a New submission that overrides a version that was removed owing to check issues not corrected in time.


## R CMD check results
* There were no ERRORs or WARNINGs or NOTEs on my local environment.

## CRAN Package Check Results for Package SIBER
* As per note at the start, this package failed the latest round of checks owing to vignette title naming bugs. I have rectified all.

## Downstream dependencies
There are no downstream dependencies.

