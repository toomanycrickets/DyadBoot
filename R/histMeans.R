#' Plot Histogram for a Specific Level
#'
#' This function plots a histogram for the means of a specified numerical variable for a specific level of
#' a specified categorical variable.
#'
#' @param all_means A data frame containing means for each dataset and level (typically the \code{all_means}
#' output from the \code{repData} function).
#' @param num_var The name of the numerical variable for which the means should be plotted.
#' @param cat_var The name of the categorical variable which determines the different levels.
#' @param level The specific level of the categorical variable for which the histogram should be plotted.
#'
#' @return A ggplot object representing the histogram.
#'
#' @examples
#' \dontrun{
#' histMeans(result$all_means, "focal_dant", "focal_morph", "Fw")
#' }
#'
#' @export

histMeans <- function(all_means, num_var, cat_var, level) {
  library(ggplot2)

  # Extract the means for the specified level
  means_for_level <- all_means[[level]]

  # Calculate the overall mean for the specified level
  overall_mean <- mean(means_for_level, na.rm = TRUE)

  # Plot the histogram
  p <- ggplot(data.frame(means = means_for_level), aes(x = means)) +
    geom_histogram(binwidth = 0.1, fill = "lightblue", color = "black", alpha = 0.7) +
    geom_vline(aes(xintercept = overall_mean), color = "red", linetype = "dashed", size = 1) +
    labs(title = paste("Distribution of means for", num_var, "when", cat_var, "is", level),
         x = "Mean", y = "Count")

  return(p)
}
