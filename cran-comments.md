
This release includes some new functions and minor updates.

## Resubmission
N/A

### Previous NOTES
N/A

## Test environments
* local OS X 10.10.5 install, R 3.3.2
* win-builder (R-release) via devtools::build_win()
* win-builder (R-devel) via devtools::build_win()

## R CMD check results
There were no ERRORs, WARNINGs or NOTES on my local build.

There were no ERRORS, WARNINGS or NOTES from win-builder on either release or devel.

## https://cran.rstudio.com/web/checks/check_results_SIBER.html
There was one error thrown by Rstudio's remote checks. I am not concerned about this error as it occurred on the r-oldrel-windows-ix86+x86_64 build and appears to result from an incorrect, inappropriate or missing installation of JAGS on which SIBER depends.
+ error: The environment variable JAGS_HOME is set to "c:/Program Files/JAGS/JAGS-4.0.0" but no JAGS installation can be found there.

## Downstream dependencies
There are no downstream dependencies.

