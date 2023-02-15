## New submission
* this is a minor update to address a request to remove import/suggests/depends on package `tidyverse` and also features some minor text edits and improved vignettes.


### Previous NOTES
* N/A

## Test environments
* local OS X 13.1 install, R 4.2.2 - OK
* win-builder development
    * R devel   - OK
    * R release - 1 NOTE Found the following (possibly) invalid URLs:
  URL: https://doi.org/10.1111/ele.12933
    From: inst/doc/kapow-example.html
    Status: 503
    Message: Service Unavailable
    _**Maintainer confirms this link is a valid doi**_
* R-hub
     * ubuntu-gcc-release - OK
     * some of the other OS checks return errors apparently owing to lack of JAGS installation on those systems. 


## R CMD check results
* There were no ERRORs or WARNINGs or NOTEs on my local environment.

## CRAN Package Check Results for Package SIBER
* All OK

## Downstream dependencies
Checked with `revdepcheck`
* Reverse depends `subniche` - OK
* Reverse suggests `dartR` - OK

