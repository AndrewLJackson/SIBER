\name{popSEA}
\alias{popSEA}
\title{ Standard Ellipse Metrics for the Population }
\description{
  Returns statistics on the standard ellipse based on a population 
  (as opposed to a sample).
}
\usage{
popSEA(sigma)
}
\arguments{
  \item{sigma}{A 2x2 matrix defining the correlation structure of bivariate 
  data.}

}

\value{
  \item{SEA}{The area of the standard ellipse.}
  \item{eccentricity}{The eccentricity of the ellipse.}
  \item{a}{The length of the semi-major axis of the ellipse a.}
  \item{b}{The length of the semi-minor axis of the ellipse b.}
}



\author{ Andrew Jackson }
\keyword{ programming}
