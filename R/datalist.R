#' Simulated d13C and d15N isotope-space data
#'
#' Data for two communities, created by \code{\link{generateSiberData}} used
#' to generate the vingette and illustrates the main functionality of SIBER.
#'
#' @docType data
#'
#' @usage data(demo.siber.data)
#'
#' @format An object of class \code{"data.frame"} containing four variables. 
#' The first and second variables are generic isotopes called \code{iso1} 
#' and \code{iso2}. The third variable \code{group} identifies which group 
#' within a community an observation belongs. Group are required to be 
#' integers in sequential order starting at \code{1} and numbering should
#' restart within each community. The fourth variable \code{community} 
#' identifies which community an observation belongs, and again is required 
#' to be an integer in sequential order staring at \code{1}.
#'
#' @keywords datasets
#' @author Andrew Jackson
"demo.siber.data"