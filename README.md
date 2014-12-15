SIBER
=====

ellipse and convex hull fitting package for stable isotope data

MixSIAR is intended to encompass all the mixing model functionality in the SIAR package. SIAR development will stop,
and the SIBER routines will become orphaned. This is the start of a full recode of SIBER to be a standalone package. 
Also intended are some major improvements to model fitting, via z-scoring and back-transforming to improve fitting 
via MCMC in JAGS. 

Comments and suggestions welcome. If anyone wants to contribute code, please let me know and we can chat about how 
to proceed.

Instructions
download this repo and set your working directory to the parent folder SIBER. Then open and/or source the file "test_siber_object_creation_and_plotting.R" which will open some example data and plot it.

Acknowledgments: some code and much input from my collaborator and co-author Andrew Parnell. Thanks to Alex Bond @thelabandfield for helping identify some problems in model fitting which will be resolved by z-scoring, fitting and back-transforming (this functionality is yet to be implemented here, but is currently available in my repo SIBER-sandbox https://github.com/AndrewLJackson/SIBER-sandbox)
