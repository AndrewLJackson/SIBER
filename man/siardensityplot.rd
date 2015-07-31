\name{siardensityplot}
\alias{siardensityplot}
\title{ SIAR's Custom Density Plot }
\description{
  generates a custom density plot of the a matrix of data, 
  usually but not exclusively representing the posterior draws of 
  esimated parameters. Based on \code{\link{hdr.boxplot}} in the 
  \code{\link{hdr}} package.
}
\usage{
siardensityplot(dat, probs = c(95, 75, 50),
    xlab = "Group", ylab= "Value", xticklabels = NULL, yticklabels = NULL,
    type = "boxes", clr = gray((9:1)/10), scl = 1,
    xspc = 0.5, prn = F, leg = FALSE, ct = "mode",ylims=NULL,
    lbound = -Inf, ubound = Inf, main="",...)
}
\arguments{
  \item{dat}{ Data to be plotted as a matrix.}
  \item{probs}{ Define the extent probability intervals for a given parameter.}
  \item{xlab}{ Specifies the text to print on the x-axis.}
  \item{ylab}{ Specifies the text to print on the y-axis.}
  \item{xticklabels}{ Specifies the text to associate with each group defined 
  as ticks on the x-axis.}
  \item{yticklabels}{ Specifies the text to associate with each tickmark on the
  y-axis.}
  \item{type}{ Determines the style of graph. type="boxes" draws boxplot style
  (default), type="lines" draws overlain lines increasing in thickness}
  \item{clr}{	Determines the set of colours to use for the boxes. Default is
  greyscale.}
  \item{scl}{ Specifies a proportional scaling factor to increase (scl > 1) or
  decrease (scl < 1) the default width of lines or boxes. Default = 1.}
  \item{xspc}{ Sets the amount of blank space either side of the first and last
  (on the x-axis) graphic object.}
  \item{prn}{ If prn=TRUE the values for the defined probability densities
  (probs) are returned to the command window. Default is prn=FALSE with no such
  output.}
  \item{leg}{ Determines whether a legend is to be drawn (leg=TRUE) or not
  (default leg=FALSE). Note, currently only supported for type="lines".}
  \item{ct}{Plots the specified measure of central tendancy, taking one of:
  'mode', 'mean', 'median'}
  \item{ylims}{Sets the y axis limits. By default this is inferred from the
  data}
  \item{lbound}{Sets a strict limit on the lower extent of the posterior
  distribution. E.g. useful for values that must be strictly positive.}
  \item{ubound}{Sets a strict limit on the upper extent of the posterior
  distribution. E.g. useful for proportions that must be strictly less than 
  one.}
  \item{main}{A title for the figure.}
  \item{...}{Additional parameters to be passed to \code{\link{plot}}}.
}
\author{ Andrew Jackson }
\keyword{ programming}
