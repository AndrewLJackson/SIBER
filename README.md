SIBER
=====

[![cran version](http://www.r-pkg.org/badges/version/SIBER)](https://CRAN.R-project.org/package=SIBER ) 
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/SIBER?)](https://github.com/r-hub/cranlogs.app)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/SIBER?color=82b4e8)](https://github.com/r-hub/cranlogs.app)
[![DOI](https://zenodo.org/badge/27975343.svg)](https://zenodo.org/badge/latestdoi/27975343)

Ellipse and convex hull fitting package to estimate niche width for stable isotope data (and potentially other relevant types of bivariate data).

[MixSIAR](https://github.com/brianstock/MixSIAR) is intended to encompass all the mixing model functionality in the now defunct SIAR package. Additionally, we have updated the basic mixing model from SIAR and released this as a standalone package for basic mixing model fitting as [simmr](https://CRAN.R-project.org/package=simmr ). 


## Installation

__NOTE__ you will also need to install [JAGS](https://mcmc-jags.sourceforge.io) which is a standalone software that the R package `rjags` provides an interface for SIBER to fit the models.

The latest stable release package is released on CRAN as v2.1.9. Type `install.packages("SIBER")` in the command line.

Alternatively, you can install directly from github

The stable release can be installed by
  ```R
    # install.packages("devtools") # install if necessary
    devtools::install_github("andrewljackson/SIBER@v2.1.9", 
    build_vignettes = TRUE)
    library(SIBER)
  ```
[Release notes](NEWS.md) are available for each version.

The latest development version is on the master branch. Often this includes some new things that I am working on, but I can't guarantee that the package is stable and it might not install sometimes if I have broken something; usually though I tend to break things on a separate branch and try to keep the master stable as a package even if bits and pieces of the new stuff is not working correctly.

  ```R
    # install.packages("devtools") # install if necessary
    devtools::install_github("andrewljackson/SIBER@master",
    build_vignettes = TRUE)
    library(SIBER)
  ```



## Tutorials

The package vignettes have been expanded to provide working examples of the two main analysis types along with common sub-analyses. Several vignettes have been developed in response to Frequently Asked Questions.

## Frequently Asked Questions (FAQs)
* __How do I make isotope plots in ggplot?__ - see the vignette "Plot-SIA-ggplot2" included in versions >2.1.4
* __Why are my community-level estimates of TA are zero or NA__ - This will arise if you have less than three groups (e.g. species) comprising a community. A triangle with three non-collinear points is the minimum requirement to draw a polygon and so if you have only one or two groups, the area of the TA is zero at best or possibly NA.
* __Error: .onLoad failed in loadNamespace() for 'rjags', details:__ - and similar errors referring to DLLs and dylib etc... This is mostly due to not having the standalone software JAGS installed, or an out of date version that is no longer supported. You can check your latest release and download instructions at [JAGS](https://mcmc-jags.sourceforge.io)

## Help, Assistance and Queries
In the first instance, queries about analyses or problems with the software can be posted [here on github](https://github.com/AndrewLJackson/SIBER/issues). Please post a [minimal worked examples](https://www.r-bloggers.com/2013/05/writing-a-minimal-working-example-mwe-in-r/) so that we can recreate the problem and offer solutions.

Before you contact us, please make sure to check the following:

+ [R](https://cran.r-project.org) is up-to-date: type `version` in your R console window to compare with whats available from CRAN.
+ Ensure all your installed pacakges are up-to-date: type `update.packages(ask = FALSE)` and type `yes` in response to questions about installing pacakges from source.
+ Ensure you have JAGS installed: see FAQs for details.

## Acknowledgements
Some code and much input from my collaborator and co-author [Andrew Parnell](https://www.maynoothuniversity.ie/faculty-science-engineering/our-people/andrew-parnell). Thanks to [Alex Bond](https://alexanderbond.org) for helping identify some problems in model fitting which is now resolved by z-scoring, fitting and back-transforming. Although not affecting every analysis, the potential issue is exemplified in [SIBER-sandbox]( https://github.com/AndrewLJackson/SIBER-sandbox). Thanks to [Edward Doherty](https://github.com/Edward-Doherty) for finding the bug that turned out to be in the creating of z-scores in `createSiberObject`.

## Citation
Jackson, A.L., Parnell, A.C., Inger R., & Bearhop, S. 2011. Comparing isotopic niche widths among and within communities: SIBER – Stable Isotope Bayesian Ellipses in R. Journal of Animal Ecology, 80, 595-602. [doi](https://doi.org/10.1111/j.1365-2656.2011.01806.x)
