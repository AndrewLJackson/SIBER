#' Read in SIBER format data and generate the SIBER object
#'
#' This function takes raw isotope data and creates a SIBER object which
#' contains information in a structured manner that enables other functions to
#' loop over groups and communities, fit Bayesian ellipses, and afterwards,
#' generate various plots, and additional analyses on the posterior
#' distributions.
#' 
#' @name createSiberObject
#' @param data Specified In a basic R data.frame or matrix comprising 4
#'   columns. The first two of which are typically isotope tracers, then the
#'   third is a column that indicates the group membership, and the fourth
#'   column indicates the community membership of an observation. Communities
#'   labels should be entered  as sequential numbers. As of v2.0.1 group labels
#'   can be entered as strings and/or numbers and need not be sequential.
#' @return A siber tibble object, that contains data that helps with various model
#'   fitting and plotting. \itemize{ \item {original.data}{The original data as
#'   passed into this function} \item {iso.summary}{The max, min, mean and
#'   median of the isotope data useful for plotting} \item {sample.sizes}{The
#'   number of observations tabulated by group and community} \item {raw.data}{A
#'   list object of length equal to the number of communities} }
#' @examples
#' data(demo.siber.data)
#' my.siber.data <- createSiberObject(demo.siber.data)
#' names(my.siber.data)
#'
#' @export

## Define a set of global variables so tidyverse calles dont generate
# "no visible binding for global variable" warnings.
if(getRversion() >= "2.15.1")  utils::globalVariables(c("iso1", 
                                                        "iso2",
                                                        "group", 
                                                        "community"))

createSiberObject <- function (data) {

# Check that the column headers have exactly the correct string
if (!all(names(data.in) == c("iso1", "iso2", "group", "community"))){
  stop('The header names in your data file must match 
        c("iso1", "iso2", "group", "community") exactly')
}


# set up the basic tibble
siber <- data %>% group_by(group, community) %>% 
  summarise(n = n(), 
            across(starts_with("iso"), 
                   list(mean = mean, sd = sd, min = min, max = max),
                   .names = "{fn}_{col}"),
            raw_data = list(data.frame(across(starts_with('iso'), ~.x), 
                                       group, community)),
            zscore_data = list(data.frame(across(starts_with("iso"), scale), 
                                          group, community)))
  
# use purrr to add the covariance matrix for each level combination
  

# Report a warning if any group:community sample sizes are less than 5
if (any(siber$n < 5, na.rm = TRUE)){
  warning("At least one of your groups has less than 5 observations.
          The absolute minimum sample size for each group is 3 in order
          for the various ellipses and corresponding metrics to be 
          calculated. More reasonably though, a minimum of 5 data points
          are required to calculate the two means and the 2x2 covariance 
          matrix and not run out of degrees of freedom. Check the item 
          named 'sample.sizes' in the object returned by this function 
          in order to locate the offending group. Bear in mind that NAs in 
          the sample.size matrix simply indicate groups that are not 
          present in that community, and is an acceptable data structure 
          for these analyses.")
}



return(siber)

} # end of function




