#' Calculate Overall Means from a Data Frame of Means
#'
#' This function computes the overall mean for each group in a data frame that
#' already contains means for each group across multiple iterations. It groups
#' by the provided categorical variables and calculates the mean for each group.
#'
#' @param all_means_df A data frame containing the mean of a numerical variable
#'        for each combination of categorical variables across multiple iterations.
#' @param num_var The name of the numerical variable whose mean has been computed.
#' @param cat_var1 The name of the primary categorical variable.
#' @param cat_var2 The name of the secondary categorical variable (default is NULL, i.e., not provided).
#' @param cat_var3 The name of the tertiary categorical variable (default is NULL, i.e., not provided).
#'
#' @return A data frame containing the overall mean for each group, grouped by the
#'         provided categorical variables.
#'
#' @examples
#' \dontrun{
#'   # Assuming you have a data frame `all_means` with means for each group
#'   overall_means <- MeanOfMeans(all_means, "numericalVar", "catVar1", "catVar2", "catVar3")
#'   print(head(overall_means))
#' }
#'
#' @export
MeanOfMeans <- function(all_means_df, num_var, cat_var1, cat_var2 = NULL, cat_var3 = NULL) {
  ...
}

MeanOfMeans <- function(all_means_df, num_var, cat_var1, cat_var2 = NULL, cat_var3 = NULL) {
  # Ensure the necessary columns are present in the data frame
  if (!is.null(cat_var3)) {
    if (!all(c("Iteration", num_var, cat_var1, cat_var2, cat_var3) %in% colnames(all_means_df))) {
      stop("Data frame does not contain the necessary columns.")
    }
  } else if (!is.null(cat_var2)) {
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
  if (!is.null(cat_var3)) {
    overall_means <- aggregate(all_means_df[[num_var]], by = list(all_means_df[[cat_var1]], all_means_df[[cat_var2]], all_means_df[[cat_var3]]), FUN = mean, na.rm = TRUE)
    names(overall_means) <- c(cat_var1, cat_var2, cat_var3, num_var)
  } else if (!is.null(cat_var2)) {
    overall_means <- aggregate(all_means_df[[num_var]], by = list(all_means_df[[cat_var1]], all_means_df[[cat_var2]]), FUN = mean, na.rm = TRUE)
    names(overall_means) <- c(cat_var1, cat_var2, num_var)
  } else {
    overall_means <- aggregate(all_means_df[[num_var]], by = list(all_means_df[[cat_var1]]), FUN = mean, na.rm = TRUE)
    names(overall_means) <- c(cat_var1, num_var)
  }

  return(overall_means)
}
