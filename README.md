SIBER
=====

ellipse and convex hull fitting package for stable isotope data

[MixSIAR](https://github.com/brianstock/MixSIAR) is intended to encompass all the mixing model functionality in the [SIAR package](http://www.tcd.ie/Zoology/research/research/theoretical/siar.php). SIAR development will stop,
and the SIBER routines will become orphaned. This is the start of a full recode of SIBER to be a standalone package. 
Also intended are some major improvements to model fitting, via z-scoring and back-transforming to improve fitting 
via MCMC in JAGS. 

Comments and suggestions welcome. If anyone wants to contribute code, please let me know and we can chat about how 
to proceed.

## Instructions
Download this repo and set your working directory to the parent folder SIBER. Then open and/or source the file "test_siber_object_creation_and_plotting.R" which will source the functions it needs, load some example data, plot it and calculate some basic maximum likelihood based summary statistics. I am working on this example to add the Bayesian fitting and subsequent analyses for both the ellipse, and hull based metrics for among group and among community comparisons respectively. More information and examples from the current version of SIBER which is part of the SIAR package is available from [my website](http://www.tcd.ie/Zoology/research/research/theoretical/Rpodcasts.php#siber).

##Acknowledgments
Some code and much input from my collaborator and co-author [Andrew Parnell](http://mathsci.ucd.ie/people/parnell_a). Thanks to Alex Bond [@thelabandfield](https://twitter.com/thelabandfield) for helping identify some problems in model fitting which will be resolved by z-scoring, fitting and back-transforming. This functionality is yet to be implemented here, but is currently available in my repo [SIBER-sandbox]( https://github.com/AndrewLJackson/SIBER-sandbox)

## Citation
Jackson, A.L., Parnell, A.C., Inger R., & Bearhop, S. 2011. Comparing isotopic niche widths among and within communities: SIBER – Stable Isotope Bayesian Ellipses in R. Journal of Animal Ecology, 80, 595-602. [doi](http://dx.doi.org/10.1111/j.1365-2656.2011.01806.x)
