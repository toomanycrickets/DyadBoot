#' Raincloud Plot with Optional P-value Histogram
#'
#' This function generates a raincloud plot of the provided data. If p-values are also
#' provided, it generates an additional histogram of the p-values alongside the raincloud plot.
#'
#' @param closest_data A dataframe containing the data to be plotted.
#' @param num_var The name of the numeric variable in the `closest_data` dataframe.
#' @param cat_var The name of the categorical variable in the `closest_data` dataframe.
#' @param overall_means A named vector of overall means for each level of the categorical variable.
#' @param xlab_name Optional. Name of the x-axis. Defaults to the name of `cat_var`.
#' @param ylab_name Optional. Name of the y-axis. Defaults to the name of `num_var`.
#' @param main_title Optional. Main title for the raincloud plot.
#' @param p_values Optional. A list or vector of p-values. If provided, a histogram of the p-values
#' is generated alongside the raincloud plot.
#'
#' @return A ggplot2 plot object. If `p_values` are provided, the returned plot will include
#' both the raincloud plot and the p-value histogram side by side.
#'
#' @examples
#' \dontrun{
#' plotBoot(df, "numeric_var", "categorical_var", overall_means = means_vec, p_values = pvals)
#' }
#'
#' @importFrom ggplot2 ggplot aes geom_boxplot labs theme_minimal
#' @importFrom ggdist stat_halfeye stat_dots
#' @importFrom RColorBrewer brewer.pal
#' @importFrom cowplot plot_grid
#' @export
plotBoot <- function(closest_data, num_var, cat_var, overall_means,
                     xlab_name = cat_var, ylab_name = num_var, main_title = NULL,
                     p_values = NULL) {
  # ... rest of the function
}

plotBoot <- function(closest_data, num_var, cat_var, overall_means,
                     xlab_name = cat_var, ylab_name = num_var, main_title = NULL,
                     p_values = NULL) {
  library(ggplot2)
  library(ggdist)
  library(RColorBrewer)
  library(cowplot) # For plot_grid function

  # Convert the categorical variable to a factor
  closest_data[[cat_var]] <- as.factor(closest_data[[cat_var]])

  # Generate the Set2 color palette based on the number of levels
  colours <- brewer.pal(n = length(unique(closest_data[[cat_var]])), name = "Set2")

  # Raincloud plot
  raincloud <- ggplot(closest_data, aes(x = get(cat_var), y = get(num_var))) +
    ggdist::stat_halfeye(
      aes(fill = get(cat_var)),
      adjust = .5,
      width = .6,
      justification = -.2,
      .width = 0,
      point_colour = NA
    ) +
    geom_boxplot(
      aes(fill = get(cat_var)),
      width = .15,
      outlier.color = NA
    ) +
    ggdist::stat_dots(
      aes(fill = get(cat_var)),
      side = "left",
      justification = 1.12,
      binwidth = 1
    ) +
    geom_point(data = data.frame(cat = names(overall_means), mean = overall_means),
               aes(x = cat, y = mean), color = "black", size = 4, shape = 18) +
    labs(title = main_title, x = xlab_name, y = ylab_name, fill = NULL) +
    theme_minimal() +
    scale_fill_brewer(palette = "Set2")

  # If p_values are provided, create a histogram
  if (!is.null(p_values)) {
    p_values_vector <- unlist(p_values) # Convert list to numeric vector
    p_hist <- ggplot(data.frame(p_values = p_values_vector), aes(x = p_values)) +
      geom_histogram(fill = "skyblue", color = "white", bins = 30) +
      geom_vline(aes(xintercept = 0.05), color = "darkred", linetype = "dashed") + # Add the red dashed line at x=0.05
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
