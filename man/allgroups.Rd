\name{allgroups}
\alias{allgroups}
\docType{data}
\title{ The entire set of Geese isotope data }
\description{
  A 5 column matrix containing isotopic estimates for 251 geese collected at 8
  different time points. 
  The first column indicates the time point group, the second and third are 
  d15N (Nitrogen) and d13C 
  (Carbon) isotopic values for the Geese plasma, the third and fourth are 
  d15N and d13C values for 
  the Geese cells. Note that these are raw values; they have not undergone
  fractionation correction.  
}
\usage{data(allgroups)}
\format{
  A data frame with 251 observations on the following 5 variables.
  \describe{
    \item{\code{Group}}{Group number / time point}
    \item{\code{d15NPl}}{d15N plasma}
    \item{\code{d13CPl}}{d13C plasma}
    \item{\code{d15NCe}}{d15N cells}
    \item{\code{d13CCe}}{d13C cells}
  }
}
\examples{
#see siarmenu() and option 9 for a demo using part of this data
}
\keyword{datasets}
