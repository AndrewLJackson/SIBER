An update to the package `spatstat` on which `SIBER` depends has precipiated a minor version update. My package now uses `spatsat.utils` as per the advice of the dependent package maintainers. There were also some warnings thrown by inappropriate vignette builder options in the yaml headers which have now all been fixed. All issues in the package reports https://cran.r-project.org/web/checks/check_results_SIBER.html have been addressed.

## Resubmission
N/A

### Previous NOTES
* email from Brian Ripley indicated a duplicate link to vignettes which has been rectified.

## Test environments
* local OS X 10.13.6 install, R 3.5.1
* win-builder (R-release) via `devtools::check_win_release()`
* win-builder (R-devel) via `devtools::check_win_devel()`

## R CMD check results
* There were no ERRORs or WARNINGs 
* There were 2 NOTES. The first arises owing to a change in my email address. The second results from 5 instances of "no visible binding for global variable 'VAR'" all relating to the function `kapow()` and `siberKapow()`. These all arise from use of `ggplot2::ggplot(aes=())` in the two functions. This note can be ignored safely as the data.frame object passed into `kapow()` and `siberKapow()` will have these variable names. 

## CRAN Package Check Results for Package SIBER
No ERRORS or WARNINGS.

## Downstream dependencies
There are no downstream dependencies.

