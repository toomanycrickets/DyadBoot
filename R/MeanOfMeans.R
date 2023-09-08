#' MeanOfMeans function
#'
#' This function takes a data frame containing the mean values of a numerical variable for each level (or combination of levels)
#' of one or two categorical variables across multiple datasets, and computes the overall mean value(s) across all datasets.
#'
#' @param all_means_df A data frame containing the mean values of the numerical variable for each level (or combination of levels) of the categorical variable(s) across multiple datasets.
#' @param num_var The name of the numerical variable as a string.
#' @param cat_var1 The name of the first categorical variable as a string.
#' @param cat_var2 The name of the second categorical variable as a string (optional).
#'
#' @return A data frame containing the overall mean value(s) of the numerical variable for each level (or combination of levels) of the categorical variable(s) across all datasets.
#'
#' @examples
#' \dontrun{
#' MeanOfMeans(each_dataset_means, "dant", "Group")
#' MeanOfMeans(each_dataset_means, "dant", "Group", "Song")
#' }
#'
#' @export
MeanOfMeans <- function(all_means_df, num_var, cat_var1, cat_var2 = NULL) {
  # (Function body goes here)
}

MeanOfMeans <- function(all_means_df, num_var, cat_var1, cat_var2 = NULL) {
  # Ensure the necessary columns are present in the data frame
  if (!is.null(cat_var2)) {
    if (!all(c("Iteration", num_var, cat_var1, cat_var2) %in% colnames(all_means_df))) {
      stop("Data frame does not contain the necessary columns.")
    }
  } else {
    if (!all(c("Iteration", num_var, cat_var1) %in% colnames(all_means_df))) {
      stop("Data frame does not contain the necessary columns.")
    }
  }

  # Remove the 'Iteration' column
  all_means_df$Iteration <- NULL

  # Group the data by the categorical variables and calculate the mean for each group
  if (!is.null(cat_var2)) {
    overall_means <- aggregate(all_means_df[[num_var]], by = list(all_means_df[[cat_var1]], all_means_df[[cat_var2]]), FUN = mean, na.rm = TRUE)
    names(overall_means) <- c(cat_var1, cat_var2, paste(num_var, sep = "_"))
  } else {
    overall_means <- aggregate(all_means_df[[num_var]], by = list(all_means_df[[cat_var1]]), FUN = mean, na.rm = TRUE)
    names(overall_means) <- c(cat_var1, paste(num_var, sep = "_"))
  }

  return(overall_means)
}
