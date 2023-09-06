#' Calculate Overall Means for Each Level
#'
#' This function computes the overall mean for each level of the categorical variable
#' using the provided dataframe that contains the means for each dataset.
#'
#' @param all_means_df A dataframe containing the mean values for each level of the categorical variable
#' for each dataset. This dataframe is typically obtained from the \code{repDataSet} function.
#'
#' @return A named numeric vector where names are the levels of the categorical variable and
#' the values are the overall means for each level.
#'
#' @export
#'
#' @examples
#' # Assuming you have the 'all_means_df' dataframe from the 'repDataSet' function:
#' # overall_means_vector <- MeanOfMeans(all_means_df)
MeanOfMeans <- function(all_means_df) {
  # Remove the 'Iteration' column if it exists
  if ("Iteration" %in% colnames(all_means_df)) {
    all_means_df$Iteration <- NULL
  }

  # Compute the overall mean for each column (which represents a level of the categorical variable)
  MeanOfMeans <- colMeans(all_means_df, na.rm = TRUE)

  return(MeanOfMeans)
}
