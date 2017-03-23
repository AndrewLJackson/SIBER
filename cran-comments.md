An update to the package `spatstat` on which `SIBER` depends has precipiated a minor version update. My package now uses `spatsat.utils` as per the advice of the package maintainers.

## Resubmission
N/A

### Previous NOTES
N/A

## Test environments
* local OS X 10.10.5 install, R 3.3.3
* win-builder (R-release) via devtools::build_win()
* win-builder (R-devel) via devtools::build_win()

## R CMD check results
There were no ERRORs, WARNINGs or NOTES on my local build.

There were no ERRORS and 1 WARNING from win-builder on either release or devel. 
* checking top-level files ... WARNING
Conversion of 'NEWS.md' failed:
pandoc.exe: Could not fetch https://CRAN.R-project.org/web/CRAN_web.css
TlsExceptionHostPort (HandshakeFailed (Error_Protocol ("certificate rejected: [NameMismatch \"CRAN.R-project.org\"]",True,CertificateUnknown))) "CRAN.R-project.org" 443

This warning appears to be on the CRAN side and is not under my control.

## CRAN Package Check Results for Package SIBER
There was one error thrown by CRAN's remote checks: https://cran.rstudio.com/web/checks/check_results_SIBER.html. I am not concerned about this error as it occurred on the r-oldrel-windows-ix86+x86_64 build and appears to result from an incorrect, inappropriate or missing installation of JAGS on which SIBER depends via the package rjags which also fails on this release with the same error.
+ error: The environment variable JAGS_HOME is set to "c:/Program Files/JAGS/JAGS-4.0.0" but no JAGS installation can be found there.

## Downstream dependencies
There are no downstream dependencies.

