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
if(getRversion() >= "2.15.1")  utils::globalVariables(c("iso1", 
                                                        "iso2",
                                                        "group", 
                                                        "community"))

createSiberObject2 <- function (dd, group_start_position) {
  
  tracer_idx <- 1:(group_start_position-1)
  group_idx  <- group_start_position:ncol(dd)

  # Check that all the tracer data are numeric
  if (!any(is.numeric(as.matrix(dd[,tracer_idx])))){
    error("All tracer data must be numeric. At least one of your 
          entries in the tracer data are non-numeric values.")
  }
  
  # # Check that the data.in object is a data.frame object only
  # # If it is a tibble, then coerce to data.frame only and 
  # # return a warning.
  # if (any(class(data.in) %in% c("spec_tbl_df","tbl_df","tbl"))){
  #   warning("The data object supplied is of class tibble. 
  #           This has likely occurred owing to use of the 
  #           readr::read_csv() function to import the data. 
  #           The dataset has been coerced to an object of 
  #           class data.frame only using as.data.frame().
  #           You should check that this conversion has no 
  #           unintended consequences, and ideally you should
  #           convert it before passing it to createSiberObject 
  #           which will prevent this warning and allow you to 
  #           check that there has been no undesired change to the 
  #           data.")
  #   data.in <- as.data.frame(data.in)
  # }
  
  # # Check that the column headers have exactly the correct string
  #   if (!all(startsWith(names(tracer_df), "tracer"))){
  #     stop('The header names in your tracer data file must 
  #          start with the text "tracer"')
  #   }
  #   if (!all(startsWith(names(group_df), "group"))){
  #     stop('The header names in your grouping data file must 
  #          start with the text "group"')
  #   }  
  
  # error if community is not a sequential numeric vector
  # if (!is.numeric(data.in$community)){
  #   stop('The community column must be a sequential numeric vector 
  #        indicating the community membership of each observation.')
  # } 
  
  # rename the column headers of the tracer and grouping dataframes
  # tracer_labels <- names(tracer_df)
  # group_labels  <- names(group_df)
  
  # names(tracer_df) <- paste0("tracer", 1:ncol(tracer_df))
  # names(group_df)  <- paste0("group", 1:ncol(group_df))
  
  
    
# force group and community variable to be factors
dd <- dd %>% mutate(across(group_idx, as.factor))

# create a grouping column that is unique for all combinations of groups
dd <- dd %>% 
  unite("master_group", all_of(group_idx), remove = FALSE) %>%
  relocate("master_group", .after = last_col()) %>%
  mutate("master_code" = as.numeric(as.factor(`master_group`)))

# get the means (and ultilmately sds for each tracer to allow rescaling back from z scores)
dd <- dd %>% group_by(master_code) %>% 
  mutate(across(all_of(tracer_idx), mean, .names = "mean_{.col}")) %>%
  mutate(across(all_of(tracer_idx), sd, .names = "sd_{.col}"))

  
# create an object that is a list, into which the raw data, 
# its transforms, and various calculated metrics can be stored.
siber <- list()

# keep the original data in its original format just in case
siber$original_data <- dd

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


# ------------------------------------------------------------------------------
# store the Maximum Likelihood estimates
# of the means and covariances for each group.
siber$ML <- siber$summary %>% select(starts_with("mean_")) %>% nest()

# nested data structure to work with map()
dd_nested <- dd %>% group_by(across(all_of(group_idx))) %>% nest()

siber$ML$cov <- map(dd_nested$data,
    \(x) cov(x %>% select(tracer_idx)))

# ------------------------------------------------------------------------------
# create z-score transformed versions of the raw data.
# we can then use the saved information in the mean and 
# covariances for each group stored in ML.mu and ML.cov
# to backtransform them later.

aj <- dd %>% group_by(master_code) %>% 
  mutate(across(all_of(tracer_idx), scale, .names = "z_{.col}")) 

for (i in 1:siber$n.communities) {
  
  # BUG - discovered 2020/5/11 per emails with Edward Doherty.
  # Incorrect ordering by tapply() meant z-scores were not correctly
  # applied within groups.
  
  
  # -- BUGGED CODE BEGIN --
  # apply z-score transform to each group within the community via tapply()
  # using the function scale()
  # siber$zscore.data[[i]][,1] <- unlist(tapply(siber$raw.data[[i]]$iso1,
  # 	                                          siber$raw.data[[i]]$group,
  # 	                                          scale))
  # siber$zscore.data[[i]][,2] <- unlist(tapply(siber$raw.data[[i]]$iso2,
  # 	                                          siber$raw.data[[i]]$group,
  # 	                                          scale))
  # 
  # -- BUGGED CODE END --
  
  
  
  
  
  ## -- HOT FIX BEGIN -- 
  # (plan to tidyverse the whole package)
  
  # take the raw data, group by "group" and 
  # transform iso1 and iso2 by scaling them and
  # finally converting to data.frame.
  siber$zscore.data[[i]] <- siber$raw.data[[i]] %>%
    group_by(group) %>% mutate(iso1 = scale(iso1),
                               iso2 = scale(iso2)) %>%
    data.frame()
  # 
  ## -- HOT FIX END   --

	
}

return(siber)

} # end of function




