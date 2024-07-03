#' Read in SIBER format data and generate the SIBER object
#'
#' This function takes raw isotope data and creates a SIBER object which
#' contains information in a structured manner that enables other functions to
#' loop over groups and communities, fit Bayesian ellipses, and afterwards,
#' generate various plots, and additional analyses on the posterior
#' distributions.
#' 
#' @name createSiberObject
#' @param data.in Specified In a basic R data.frame or matrix comprising 4
#'   columns. The first two of which are typically isotope tracers, then the
#'   third is a column that indicates the group membership, and the fourth
#'   column indicates the community membership of an observation. Communities
#'   labels should be entered  as sequential numbers. As of v2.0.1 group labels
#'   can be entered as strings and/or numbers and need not be sequential.
#' @return A siber list object, that contains data that helps with various model
#'   fitting and plotting. 
#'   * `original.data` The original data as
#'   passed into this function
#'   * `iso.summary` The max, min, mean and
#'   median of the isotope data useful for plotting
#'   * `sample.sizes` The
#'   number of observations tabulated by group and community
#'   * `raw.data` A list object of length equal to the number of communities
#' @examples
#' data(demo.siber.data)
#' my.siber.data <- createSiberObject(demo.siber.data)
#' names(my.siber.data)
#'
#' @export

## Define a set of global variables so tidyverse calls don't generate
# "no visible binding for global variable" warnings.
# if(getRversion() >= "2.15.1")  utils::globalVariables(c("iso1", 
#                                                         "iso2",
#                                                         "group", 
#                                                         "community"))

createSiberObject2 <- function (dd, group_start_position) {
  
  # create vectors to look up the column positions of tracers and groups
  tracer_idx <- 1:(group_start_position-1)
  group_idx  <- group_start_position:ncol(dd)
  
  # extract the column names of the tracers and groups
  tracer_labels <- names(dd)[tracer_idx]
  group_labels  <- names(dd)[group_idx]
  
  
  # Check that all the tracer data are numeric
  if (!any(is.numeric(as.matrix(dd[,tracer_idx])))){
    error("All tracer data must be numeric. At least one of your 
          entries in the tracer data are non-numeric values. Check that the 
          tracer (isotope) appear as the first 
          columns and any grouping variables in columns to the right. 
          Check also that `group_start_position` correctly identifies
          the first column containing the grouping variables.")
  }
  
  
  # force group and community variable to be factors
  dd <- dd %>% mutate(across(group_idx, as.factor))
  
  # create a grouping column that is unique for all combinations of groups
  dd <- dd %>% 
    unite("master_group", all_of(group_idx), remove = FALSE) %>%
    relocate("master_group", .after = last_col()) %>%
    mutate("master_code" = as.numeric(as.factor(`master_group`)))
  
  # get the means (and ultimately sds for each tracer to allow rescaling back
  # from z scores)
  dd <- dd %>% group_by(master_code) %>% 
    mutate(across(all_of(tracer_idx), mean, .names = "mean_{.col}")) %>%
    mutate(across(all_of(tracer_idx), sd, .names = "sd_{.col}"))
  
  
  # create an object that is a list, into which the raw data, 
  # its transforms, and various calculated metrics can be stored.
  siber <- list()
  
  # AJ - mark for delete.
  # I dont think we need to keep a copy of the original data
  # keep the original data in its original format just in case
  # siber$original_data <- dd
  
  # create some summary statistics of the tracer data
  siber$summary <- dd %>% 
    group_by(across(all_of(group_idx)), `master_code`) %>% 
    summarise(across(all_of(tracer_idx), mean, .names = "mean_{.col}"), 
              across(all_of(tracer_idx), sd, .names = "sd_{.col}"), 
              n = n(),
              .groups = "keep")
  
  if (any(siber$summary$n < 5, na.rm = TRUE)){
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
  
  
  # ----------------------------------------------------------------------------
  # store the Maximum Likelihood estimates of the means and covariances for each
  # group. When selecting the variables, the first columns are the grouping
  # variables and the master_code variable
  nested_means <- siber$summary %>% 
    select(all_of(1:(length(group_idx)+ 1)), 
           starts_with("mean_")) %>% 
    nest(.key = "means")
  
  nested_sds <- siber$summary %>% 
    select(all_of(1:(length(group_idx)+ 1)), 
           starts_with("sd_")) %>% 
    nest(.key = "sds")
  
  # nested data structure of the original data to work with map()
  dd_nested <- dd %>% 
    group_by(across(all_of(group_idx)), `master_code`) %>% 
    nest(.key = "tracer_data")
  
  # map over the data column which are are list with entry for each of the
  # unique groups defined by master_code and calculate covariance matrix for
  # each
  dd_nested$cov <- map(dd_nested$tracer_data,
                      \(x) cov(x %>% select(all_of(tracer_idx))))
  
  ## calculate SEA generalised for the D dimensions
  # the commented out code below is suitable for 2D only and might be brought
  # into a separate function designed to extract more info suitable only for 
  # special but most common case of 2D.
  # dd_nested <- bind_cols(dd_nested,
  #                        map(dd_nested$cov, 
  #                            \(x) unlist(sigmaSEA(x))) %>% bind_rows())
  dd_nested$SEA <- map_vec(dd_nested$cov, 
                                 \(x) siberNSEA(x))
  dd_nested$D <- map_vec(dd_nested$cov, ncol)
  
  ## AJ - problem here is hulls are only relevant for 2d data. There are
  # probably some n-dimensional equivalents, but I might need to call nicheRover
  # pkg to do this. 
  # add convex hull areas 
  # dd_nested$TA <- map(dd_nested$tracer_data, \(x) hullarea(x %>% select(all_of(tracer_idx))))
  
  
  
  # add the ML SEA and SEAc estimates
  # siber$test <- inner_join(dd_nested, nested_means, nested_sds, 
  #                          by = c("group", "community", "master_code"),
  #                          keep = FALSE)
  
  # join all the data together in a series of left_joins
  siber$summary <- left_join(siber$summary %>%
                             select(-starts_with("mean_"), -starts_with("sd_")),
                           nested_means, 
                          by = c(group_labels, "master_code"), 
                          keep = FALSE) %>%
    left_join(., nested_sds, 
              by = c(group_labels, "master_code"), 
              keep = FALSE) %>%
    left_join(.,  dd_nested, 
              by = c(group_labels, "master_code"), 
              keep = FALSE)
  
  # siber$nested_means <- nested_means
  # siber$nested_sds <- nested_sds
  # siber$dd_nested <- dd_nested
  
  # ----------------------------------------------------------------------------
  # create z-score transformed versions of the raw data.
  # we can then use the saved information in the mean and 
  # covariances for each group stored in ML.mu and ML.cov
  # to backtransform them later.
  # AJ - the use of master_code here is going to throw "global variable" warnings
  siber$z_data <- dd %>% group_by(`master_code`) %>% 
    mutate(across(all_of(tracer_idx), scale, 
                  .names = "z_{.col}"), 
           .keep = "none") 
  
  
  
  return(siber)
  
} # end of function




