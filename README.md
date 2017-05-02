SIBER
=====

[![cran version](http://www.r-pkg.org/badges/version/SIBER)](http://cran.rstudio.com/web/packages/SIBER) 
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/SIBER?)](https://github.com/metacran/cranlogs.app)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/SIBER?color=82b4e8)](https://github.com/metacran/cranlogs.app)
[![DOI](https://zenodo.org/badge/27975343.svg)](https://zenodo.org/badge/latestdoi/27975343)

Ellipse and convex hull fitting package to estimate niche width for stable isotope data (and potentially other relevant types of bivariate data).

[MixSIAR](https://github.com/brianstock/MixSIAR) is intended to encompass all the mixing model functionality in the [SIAR package](http://www.tcd.ie/Zoology/research/research/theoretical/siar.php). Additionally, we have updated the basic mixing model from SIAR and released this as a standalone pacakge for basic mixing model fitting as [simmr](https://cran.r-project.org/web/packages/simmr/). 


## Important!!
SIAR development has stopped as of late 2015 (except for important bug fixes and compatability fixes),
and the SIBER routines will become deprecated and then defunct. This is the start of a full recode of SIBER to be a standalone package.  Model fitting is much improved via JAGS in the new code within SIBER.

Comments and suggestions welcome. If anyone wants to contribute code, please let me know and we can chat about how 
to proceed.

## Installation
The latest stable release package is released on CRAN as v2.1.3. Type `install.packages("SIBER")` in the command line.

Alternatively, you can install directly from github

The stable release can be installed by
  ```R
    # install.packages("devtools") # install if necessary
    devtools::install_github("andrewljackson/SIBER@v2.1.3", 
    build_vingettes = TRUE)
    library(SIBER)
  ```

The latest development version is on the master branch. Often this includes some new things that I am working on, but I can't guarantee that the package is stable and it might not install sometimes if I have broken something; usually though I tend to break things on a separate branch and try to keep the master stable as a package even if bits and pieces of the new stuff is not working correctly.

  ```R
    # install.packages("devtools") # install if necessary
    devtools::install_github("andrewljackson/SIBER@master",
    build_vingettes = TRUE)
    library(SIBER)
  ```


## Tutorials
More information and examples from the previous version of SIBER which is part of the SIAR package is available from [my website](http://www.tcd.ie/Zoology/research/research/theoretical/Rpodcasts.php#siber). Much of this instructional content remains true, although the implementation of the code has changed substantially (for the better I hope).

The package vingettes provide working examples of the two main analysis types.

## Help, Assistance and Queries
In the first instance, queries about analyses or problems with the software can be posted [here on github](https://github.com/AndrewLJackson/SIBER/issues). Failing  If you are convinced you have discovered a bug or major problem in the software, you can raise an [issue here on github](https://github.com/AndrewLJackson/SIBER/issues).

##Acknowledgments
Some code and much input from my collaborator and co-author [Andrew Parnell](http://mathsci.ucd.ie/people/parnell_a) [@aparnellstats](https://twitter.com/aparnellstats). Thanks to Alex Bond [@thelabandfield](https://twitter.com/thelabandfield) for helping identify some problems in model fitting which is now resolved by z-scoring, fitting and back-transforming. Although not affecting every analysis, the potential issue is exemplified in [SIBER-sandbox]( https://github.com/AndrewLJackson/SIBER-sandbox).

## Citation
Jackson, A.L., Parnell, A.C., Inger R., & Bearhop, S. 2011. Comparing isotopic niche widths among and within communities: SIBER – Stable Isotope Bayesian Ellipses in R. Journal of Animal Ecology, 80, 595-602. [doi](http://dx.doi.org/10.1111/j.1365-2656.2011.01806.x)
