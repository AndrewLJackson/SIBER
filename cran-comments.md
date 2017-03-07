A problem on the CRAN side meant that v2.1.1 was not uploaded appropriately. I was advised to resubmit by Kurt Hornik. I have moved on to v2.1.2 which includes very minor updates to only two functions.

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

There were no ERRORS or WARNINGS from win-builder on either release or devel. There was one NOTE:
* checking CRAN incoming feasibility ... NOTE. Maintainer: 'Andrew Jackson <a.jackson@tcd.ie>'. Days since last update: 5

My email address and name is correct. I uploaded this package only 5 days ago. A user spotted a small but important bug in one of the new functions which I have fixed in this version. Please accept my apologies for this.

## CRAN Package Check Results for Package SIBER
There was one error thrown by CRAN's remote checks: https://cran.rstudio.com/web/checks/check_results_SIBER.html. I am not concerned about this error as it occurred on the r-oldrel-windows-ix86+x86_64 build and appears to result from an incorrect, inappropriate or missing installation of JAGS on which SIBER depends via the packatge rjags which also fails on this release with the same error.
+ error: The environment variable JAGS_HOME is set to "c:/Program Files/JAGS/JAGS-4.0.0" but no JAGS installation can be found there.

## Downstream dependencies
There are no downstream dependencies.

