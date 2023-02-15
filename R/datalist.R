#' Simulated d13C and d15N isotope-space data
#'
#' Data for two communities, created by \code{\link{generateSiberData}} used
#' to generate the vignette and illustrates the main functionality of SIBER.
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



#' Simulated d13C and d15N isotope-space data
#'
#' Data for two communities, created by \code{\link{generateSiberData}} used
#' to generate the vignette and illustrates the main functionality of SIBER.
#'
#' @docType data
#'
#' @usage data(demo.siber.data.2)
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
"demo.siber.data.2"

#' A single group of the geese data
#'
#' A dataset for a single group of geese (as consumers) for two isotope tracers.
#' Intended for use in a Stable Isotope Mixing Model.
#'
#' @docType data
#'
#' @usage data(geese1demo)
#'
#' @format A 2 column, 9 row matrix containing the plasma data for the first
#'   group of geese. Columns are in the order d13C and d15N. Retained here as
#'   legacy from now defunct package siar. Note that the order of the data has
#'   been swapped since siar in order to present d13C as the first isotope and
#'   hence on the x-axis by default.
#'
#' @keywords datasets
#' @author Rich Inger
"geese1demo"


#' A single group of the geese data
#'
#' A dataset for a single group of geese (as consumers) for two isotope tracers.
#' Intended for use in a Stable Isotope Mixing Model.
#'
#' @docType data
#'
#' @usage data(geese2demo)
#'
#' @format A 3 column, 251 row matrix containing the plasma data for the 8
#'   groups of gees as consumers. Columns are in the order Group which is an
#'   integer that determines which of the 8 groups the observation belongs. The
#'   second and third columns are d13C and d15N values derived from the blood
#'   plasma for each observation. Retained here as legacy from now defunct
#'   package siar. Note that the order of the isotope data has been swapped
#'   since siar in order to present d13C as the first isotope and hence on the
#'   x-axis by default.
#'
#' @keywords datasets
#' @author Rich Inger
"geese2demo"


#' A set of trophic discrimination factors for brent geese feeding on their
#' sources.
#'
#' A dataset of estimated trophic discrimination factors for brent geese. The
#' data assume the same TDF for each food source. Intended for use in a Stable
#' Isotope Mixing Model.
#'
#' @docType data
#'
#' @usage data(correctionsdemo)
#'
#' @format A 5 column, 4 row data.frame object containing the trophic
#'   discrimination factors for brent geese consumers relative to 4 of their food
#'   sources (in Ireland). The first column Source is a factor determining the
#'   name of the source. The second and third columns are the mean d13C and mean
#'   d15N TDF values for each source respectively. Columns 3 and 5 are the standard
#'   deviations of the d13C and d15N TDF values respectively. Note that the order of
#'   the isotope data has been swapped since siar in order to present d13C as
#'   the first isotope and hence on the x-axis by default.
#'
#' @keywords datasets
#' @author Rich Inger
"correctionsdemo"


#' A set of concentration dependence values for stable isotope analysis
#'
#' A dataset of concentration dependent corrections for 4 food sources of brent
#' geese. Intended for use in a Stable Isotope Mixing Model.
#'
#' @docType data
#'
#' @usage data(concdepdemo)
#'
#' @format A 5 column, 4 row data.frame object containing the concentration
#'   dependence data for the geese1demo and geese2demo datasets. The first
#'   column Source is a factor determining the name of the source. The second
#'   and third columns are the mean d13C and mean d15N concentration values for
#'   each source respectively. Columns 3 and 5 are the standard deviations but
#'   these are not currently implemented in either simmr or MixSIAR stable
#'   isotope mixing models. Note that the order of the isotope data has been
#'   swapped since siar in order to present d13C as the first isotope and hence
#'   on the x-axis by default.
#'
#' @keywords datasets
#' @author Rich Inger
"concdepdemo"

#' A set of isotope observations on food sources of brent geese
#'
#' A dataset of isotope observations on 4 food sources of brent geese comprising
#' their mean and standard deviations. Intended for use in a Stable Isotope
#' Mixing Model.
#'
#' @docType data
#'
#' @usage data(sourcesdemo)
#'
#' @format A 5 column, 4 row data.frame object containing 4 different plants and
#'   their measurements on 2 different isotopes. The first column Sources is a
#'   factor determining the name of the source. The second and third columns are
#'   the mean d13C and mean d15N values for each source respectively. Columns 3
#'   and 5 are the standard deviations of the d13C and d15N values respectively.
#'   Note that the order of the isotope data has been swapped since siar in
#'   order to present d13C as the first isotope and hence on the x-axis by
#'   default.
#'
#' @keywords datasets
#' @author Rich Inger
"sourcesdemo"


#' A set of isotope observations for mongooses nested within packs
#'
#' A dataset of multiple isotopes per individual mongooses nested within packs 
#' where the goal is to understand isotopic niche occupancy of individuals 
#' with respect to their own pack.
#'
#' @docType data
#'
#' @usage data(mongoose)
#'
#' @format A 4 column, 783 row data.frame object containing unique individual 
#' mongoose identifiers in the first column "indiv.id"; an integer identifier for 
#' the pack to which each individual belongs in "pack"; Delta 13 Carbon values 
#' "c13; and Delta 15 Nitrogen values in "n15". See the paper Sheppard et al 
#' 2018 https://doi.org/10.1111/ele.12933 for more details, although N.B. 
#' the data here are provided as an example, not as a reproducible analysis of 
#' that paper. 
#'
#' @keywords datasets
#' @author Harry Marshall
"mongoose"
