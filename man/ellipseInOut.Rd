% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ellipseInOut.R
\name{ellipseInOut}
\alias{ellipseInOut}
\title{Test whether a set of points are inside or outside a defined circle}
\usage{
ellipseInOut(Z, p = 0.95, r = NULL)
}
\arguments{
\item{Z}{the \verb{i x d} matrix of data points to be tested.}

\item{p}{the percentile of the ellipse to be tested.}

\item{r}{a manually defined radius of the circle to be used. Setting \code{r}
to be anything other than NULL will override the choice of \code{p}.}
}
\value{
A logical vector indicating whether the point is inside or outside
the circle
}
\description{
Takes a
}
