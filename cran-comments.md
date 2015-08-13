
## Resubmission

* This is a resubmission. I have made the changes to the NOTES generated last time detailed below. Thanks.
* The additional quoteations from the URL in the vingette have been removed.
* I have dealt with *no visible global function* NOTES by directly calling the function with package::function notation throughout the code, rather than using importFrom in NAMESPACE.


### Previous NOTES

Fixed have strikethrough. The notes on importFrom below have been avoided by direction calling via package::function notation.

~~Found the following (possibly) invalid URLs:
  URL: "http://andrewljackson.github.io/siar"
    From: inst/doc/Introduction-to-SIBER.html
    Message: Invalid URI scheme~~

* checking R code for possible problems ... NOTE
   * ~~addEllipse: no visible global function definition for ‘qchisq’~~
   * ~~addEllipse: no visible global function definition for ‘dev.cur’~~
   * ~~addEllipse: no visible global function definition for ‘lines’~~
   * ~~createSiberObject : my.summary: no visible global function definition
  for ‘median’~~
   * ~~createSiberObject: no visible global function definition for ‘cov’~~
   * ~~fitEllipse: no visible global function definition for ‘rnorm’~~
   * ~~generateSiberGroup: no visible global function definition for ‘runif’~~
   * ~~laymanMetrics: no visible global function definition for ‘sd’~~
   * ~~siberConvexhull: no visible global function definition for ‘chull’~~
   * ~~siberDensityPlot: no visible global function definition for ‘gray’~~
   * ~~siberDensityPlot: no visible global function definition for ‘plot’~~
   * ~~siberDensityPlot: no visible global function definition for ‘title’~~
   * ~~siberDensityPlot: no visible global function definition for ‘axis’~~
   * ~~siberDensityPlot: no visible global function definition for ‘bw.nrd0’~~
   * ~~siberDensityPlot: no visible global function definition for ‘median’~~
   * ~~siberDensityPlot: no visible global function definition for ‘polygon’~~
   * ~~siberDensityPlot: no visible global function definition for ‘points’~~
* Undefined global functions or variables:
  axis bw.nrd0 chull cov dev.cur gray lines median plot points polygon
  qchisq rnorm runif sd title
* Consider adding
   * importFrom("grDevices", "chull", "dev.cur", "gray")
   * importFrom("graphics", "axis", "lines", "plot", "points", "polygon",
             "title")
   * importFrom("stats", "bw.nrd0", "cov", "median", "qchisq", "rnorm",
             "runif", "sd") to your NAMESPACE.


## Test environments
* local OS X 10.9.5 install, R 3.2.0
* win-builder (release)

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE (on my local OS X build and check):

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Andrew Jackson <a.jackson@tcd.ie>’
New submission

This is a new submission and I am a first time maintainer, though i have been involved in co-maintaining the package siar.

There were no NOTES from win-builder.

## Downstream dependencies
There are no downstream dependencies.

