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
#' @importFrom magrittr "%>%"
#' @importFrom magrittr "%<>%
#' @import dplyr
#' @export

# DONT THINK I NEED THESE GLOBAL VARIABLES ANYMORE AS THEY ARE PARTIAL STRING
# MATCHED USING starts_with() syntax.
## Define a set of global variables so tidyverse calles dont generate
# "no visible binding for global variable" warnings.
# if(getRversion() >= "2.15.1")  utils::globalVariables(c("iso1", 
#                                                         "iso2",
#                                                         "group", 
#                                                         "community"))

createSiberObject <- function (data) {

  # INPUT CHECKING CURRENTLY SWITCHED OFF. NEED TO IMPLEMENT
  # Check that the column headers have exactly the correct string
  if (0){
    stop('At a minimum, the header names in your data file must contain two 
         columns of numeric data prepended with the letter "Y", e.g. "Y1" and 
         "Y2" and at least one column that can be interpreted as a factor type 
         vector indicating to which level the data belong, e.g. "level1", and 
         or "level2" etc... ')
  }
  
  
  
  # set up the basic tibble with summaries of the data
  siber <- data %>% group_by(across(starts_with("level"))) %>% 
    summarise(n = n(), 
              across(starts_with("Y"), 
                     list(mean = mean, sd = sd, min = min, max = max),
                     .names = "{fn}_{col}"), 
              .groups = "drop")
  
  # keep track of the raw data for each group by adding it as a list to 
  # each row of the summarised tibble.
  siber %<>% 
    mutate(raw_data = data %>% 
             group_by(across(starts_with("level"))) %>% 
             group_split())
  
  
  # A helper function to extract the iso headers from the raw_data which is a 
  # grouped tibble and return the covariance matrix
  do_Sigma <- function(x) {
    # select the data columns, bind them into a matrix and return the 
    # full covariance matrix.
    x %>% select(starts_with("Y")) %>% bind_cols %>% cov
  }
  
  # A helper function to mean centre and then scale the data to 1 standard 
  # deviation.
  do_scale <- function(x) {
    # mutate the data starting with "Y" by zscoring them.
    x %>% mutate(across(starts_with("Y"), ~(.x - mean(.x)) / sd(.x)))
  }
  
  # use purrr to add the covariance matrix for row, and generate the zscored
  # data which will be used later for model fitting.
  siber %<>% mutate(Sigma = map(raw_data, do_Sigma),
                            zscore_data = map(raw_data, do_scale))
  
  # add the maximum likelihood estimates for the ellipses
  siber %<>% mutate(map_df(Sigma, sigmaSEA))
  
  # add class "siber" to the object. This is useful if we write summary or
  # plotting methods or similar later on.
  class(siber) <- append(class(siber), "siber")
  
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




