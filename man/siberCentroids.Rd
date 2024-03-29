% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/siberCentroids.R
\name{siberCentroids}
\alias{siberCentroids}
\title{Calculate the polar form of the vector between pairs of ellipse centroids}
\usage{
siberCentroids(corrected.posteriors)
}
\arguments{
\item{corrected.posteriors}{the Bayesian ellipses as returned by
\code{\link[=siberMVN]{siberMVN()}}.}
}
\value{
A list containing two arrays, one \code{r} contains the pairwise
distances between ellipse centroids in as the first two dimensions, with
the third dimension containing the same for each posterior draw defining
the ellipse. The second array \code{theta} has the same structure and
contains the angle in radians (from 0 to 2*pi) between the pairs. A third
object \code{labels} refers to  which community.group combination is in
each of the first two dimensions of the arrays.
}
\description{
This function loops over each group within each community and calculates the
vector in polar form between the estimated centroids of each ellipse to each
other ellipse.
}
