## New submission
* This package was on CRAN until recently. This version fixes calling of functions previously in package `spatstat` that was split into smaller sub-packages. The server based checks raised NOTES relating to the previous version being removed: These are detailed below. I believe they can be ignored. 


### Previous NOTES
* N/A

## Test environments
* local OS X 11.2.3 install, R 4.0.5
* win-builder development
    * R relese - NOTE - X-CRAN-Comment: Archived on 2021-03-29 as check problems were not
    corrected in time.
    * R devel - NOTE - X-CRAN-Comment: Archived on 2021-03-29 as check problems were not
    corrected in time.
* R-hub
    * Windows Server 2008 R2 SP1, R-devel, 32/64 bit - NOTE - "X-CRAN-Comment: Archived on 2021-03-29 as check problems were not
    corrected in time." This submission directly fixes this.
    * Ubuntu Linux 20.04.1 LTS, R-release, GCC - NOTE - "X-CRAN-Comment: Archived on 2021-03-29 as check problems were not
    corrected in time." This submission directly fixes this.
    * Fedora Linux, R-devel, clang, gfortran - ERROR. This package is dependent on external software JAGS which appears to be not available on this platform / instance. 


## R CMD check results
* There were no ERRORs or WARNINGs or NOTEs on my local environment.

## CRAN Package Check Results for Package SIBER
* "Archived on 2021-03-29 as check problems were not corrected in time."

## Downstream dependencies
There are no downstream dependencies.

