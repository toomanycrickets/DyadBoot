#' Compute Means and Identify Closest Dataset
#'
#' This function computes the means for a numerical variable across different levels of a categorical variable.
#' Additionally, it identifies the dataset that has values closest to the calculated means.
#'
#' @param resultsMult A list containing multiple datasets as a result of multiple iterations.
#' @param num_var The name of the numerical variable for which means are to be calculated.
#' @param cat_var The name of the categorical variable that defines the levels across which means are to be computed.
#'
#' @return A list containing:
#' \itemize{
#'   \item \code{each_dataset_means} - A dataframe containing the means for each iteration and level of the categorical variable.
#'   \item \code{closest_dataset} - The dataset from the list of input datasets that has values closest to the calculated means.
#' }
#' @export
#'
#' @examples
#' # Assuming you have a list `results` containing multiple datasets
#' # and you want to compute means for the variable 'value' across levels of 'category':
#' # result_data <- repDataSet(results, "value", "category")
repDataSet <- function(resultsMult, num_var, cat_var) {
  # ... [Function code remains unchanged]
}


repDataSet <- function(resultsMult, num_var, cat_var) {
  # Compute the means for each level of the categorical variable across all iterations
  all_means_list <- lapply(resultsMult$results_list, function(data) {
    tapply(data[[num_var]], data[[cat_var]], mean, na.rm = TRUE)
  })

  levels <- unique(unlist(lapply(resultsMult$results_list, function(data) unique(data[[cat_var]]))))

  # Construct the all_means data frame
  all_means_df <- data.frame(Iteration = 1:length(resultsMult$results_list))
  for (level in levels) {
    all_means_df[[level]] <- sapply(all_means_list, function(m) m[level], USE.NAMES = FALSE)
  }

  # Calculate the absolute difference for each dataset
  diffs <- sapply(resultsMult$results_list, function(data) {
    means <- tapply(data[[num_var]], data[[cat_var]], mean, na.rm = TRUE)
    sum(means, na.rm = TRUE)  # Changed this line, removed subtraction with overall_means
  })

  # Return the dataset that has the minimum cumulative absolute difference
  closest_data <- resultsMult$results_list[[which.min(diffs)]]

  # Return the desired data in a list
  return(list(each_dataset_means = all_means_df, closest_dataset = closest_data))
}
