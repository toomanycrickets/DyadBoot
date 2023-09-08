#' Plot Bootstrapped Data Alongside Overall Means and p-value Histogram
#'
#' This function takes in a dataset of bootstrapped data along with calculated overall means and optionally a list of p-values,
#' and generates a multi-part plot that includes a raincloud plot of the data, black and grey points representing the overall means,
#' and optionally a histogram of the p-values. The raincloud plot is a combination of a box plot, a half-violin plot (from the ggdist package),
#' and individual data points. The color aesthetic of the plot is mapped to the levels of a categorical variable, and the plot can
#' accommodate a secondary categorical variable for additional grouping.
#'
#' @param closest_data A data frame containing the closest dataset obtained from bootstrapping.
#' @param num_var The name of the numeric variable to be plotted on the y-axis (as a string).
#' @param cat_var1 The name of the primary categorical variable to group the data by (as a string).
#' @param cat_var2 The name of the secondary categorical variable for additional grouping (as a string). Default is NULL, indicating no secondary grouping.
#' @param overall_means A data frame containing the overall means calculated across all bootstrapped datasets.
#' @param xlab_name The label for the x-axis. Default is the name of `cat_var1`.
#' @param ylab_name The label for the y-axis. Default is the name of `num_var`.
#' @param main_title The main title for the plot. Default is NULL, indicating no title.
#' @param p_values A list of p-values to be plotted as a histogram alongside the raincloud plot. Default is NULL, indicating no p-value histogram.
#'
#' @return A ggplot object representing the multi-part plot. If `p_values` is provided, the plot includes both the raincloud plot and the p-value histogram. Otherwise, only the raincloud plot is returned.
#'
#' @examples
#' \dontrun{
#' plotBoot(closest_data = your_data, num_var = "variable1", cat_var1 = "variable2",
#'          overall_means = your_overall_means, p_values = your_p_values)
#' }
#'
#' @importFrom ggplot2 ggplot aes geom_boxplot geom_point labs theme_minimal
#' @importFrom ggdist stat_halfeye stat_dots
#' @importFrom RColorBrewer brewer.pal
#' @importFrom cowplot plot_grid
#' @import ggplot2
#' @import ggdist
#' @import RColorBrewer
#' @import cowplot
#'
#' @export

plotBoot <- function(closest_data, num_var, cat_var1, cat_var2 = NULL, overall_means,
                     xlab_name = cat_var1, ylab_name = num_var, main_title = NULL,
                     p_values = NULL) {
  library(ggplot2)
  library(ggdist)
  library(RColorBrewer)
  library(cowplot) # For plot_grid function

  # Convert the categorical variables to factors
  closest_data[[cat_var1]] <- as.factor(closest_data[[cat_var1]])
  if (!is.null(cat_var2)) {
    closest_data[[cat_var2]] <- as.factor(closest_data[[cat_var2]])
  }

  # Define the columns for the new data frame based on the names of the overall_means data frame
  cat_col_name1 <- names(overall_means)[1]
  cat_col_name2 <- if(!is.null(cat_var2)) names(overall_means)[2] else NULL
  mean_col_name <- names(overall_means)[3]

  # Create a new data frame for the overall means
  overall_means_df <- data.frame(
    cat1 = overall_means[[cat_col_name1]],
    cat2 = if(!is.null(cat_var2)) overall_means[[cat_col_name2]] else NULL,
    mean = overall_means[[mean_col_name]]
  )

  # Get the label for the second categorical variable, removing 'focal_' or 'opposite_' if present
  if (!is.null(cat_var2)) {
    cat_var2_label <- sub("^focal_|^opposite_", "", cat_var2)
  } else {
    cat_var2_label <- NULL
  }

  # Raincloud plot using tidy evaluation
  raincloud <- ggplot(closest_data, aes(.data[[cat_var1]], .data[[num_var]])) +
    ggdist::stat_halfeye(
      aes(fill = .data[[if (!is.null(cat_var2)) cat_var2 else cat_var1]]),
      adjust = .5,
      width = .6,
      .width = 0,
      point_colour = NA,
      position = position_dodge(width = 0.4)  # Added dodging here
    ) +
    geom_boxplot(
      aes(fill = .data[[if (!is.null(cat_var2)) cat_var2 else cat_var1]]),
      width = .15,
      outlier.color = NA,
      position = position_dodge(width = 0.4)
    ) +
    ggdist::stat_dots(
      aes(fill = .data[[if (!is.null(cat_var2)) cat_var2 else cat_var1]]),
      side = "left",
      justification = 1.12,
      binwidth = 1,
      position = position_dodge(width = 0.4)
    ) +
    geom_point(data = overall_means_df, aes(x = cat1, y = mean, color = factor(cat2)),
               size = 2, shape = 16, position = position_dodge(width = 0.4)) +
    labs(title = main_title, x = xlab_name, y = ylab_name, fill = cat_var2_label) +
    theme_minimal() +
    scale_fill_brewer(palette = "Paired") +
    scale_color_manual(name = "overall mean", values = c("black", "#646464"))

  # If p_values are provided, create a histogram
  if (!is.null(p_values)) {
    p_values_vector <- unlist(p_values) # Convert list to numeric vector
    p_hist <- ggplot(data.frame(p_values = p_values_vector), aes(x = p_values)) +
      geom_histogram(fill = "#44A2B0", color = "white", bins = 30) +
      geom_vline(aes(xintercept = 0.05), color = "red", linetype = "dashed") + # Add the red dashed line at x=0.05
      labs(title = "Histogram of p-values", x = "p-value", y = "Frequency") +
      theme_minimal() +
      theme(plot.title = element_text(size = 10, hjust = 0.5)) # Adjust the size and center the histogram title

    # Combine the two plots using plot_grid
    combined_plot <- cowplot::plot_grid(raincloud, p_hist, ncol = 2, rel_widths = c(2, 1))
    return(combined_plot)
  } else {
    return(raincloud)
  }
}
