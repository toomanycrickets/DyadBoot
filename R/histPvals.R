#' Plot Histogram of p-values for a Specified Coefficient from Bootstrap Results
#'
#' This function extracts the p-values for a specified coefficient from bootstrapped model results
#' and plots a histogram. It can handle outputs from both `summary()` and `Anova()` functions.
#'
#' @param bootstrap_results A list of model summaries obtained from bootstrapping.
#' @param coeff_name A character string specifying the name of the coefficient for which the histogram of p-values is to be plotted.
#' @param output_type A character string specifying the type of output to handle. It can be either "Summary" or "Anova".
#' @param max_iterations An integer specifying the maximum number of iterations allowed in the function. This helps in preventing infinite recursion. Default is set to 10000.
#'
#' @return A histogram plot showing the distribution of p-values for the specified coefficient.
#' @export
#'
#' @examples
#' \dontrun{
#' data <- data.frame(y = rnorm(100), x = rnorm(100))
#' results <- bootstrap_lm(data, y ~ x, 100)
#' # For summary output
#' histPvals(results$bootstrap_results, "x", "Summary")
#' # For Anova output
#' histPvals(results$anova_results, "x", "Anova")
#' }
histPvals <- function(bootstrap_results, coeff_name, output_type, max_iterations = 10000) {
  # ... (rest of the function code)
}

histPvals <- function(bootstrap_results, coeff_name, output_type, max_iterations = 10000) {

  # Helper function to extract the p-value for a given coefficient from a model summary
  extract_pvalue <- function(model_summary, coeff_name, output_type) {

    if (output_type == "Summary") {
      coeffs <- model_summary$coefficients
      if (is.null(coeffs) || ! (coeff_name %in% rownames(coeffs))) {
        stop(paste("Coefficient", coeff_name, "not found in the model summary."))
      }

      # Specify potential column names for the p-values in summary output
      possible_columns_summary <- c("Pr(>|t|)", "Pr(>|z|)")
      pval_colname <- colnames(coeffs)[colnames(coeffs) %in% possible_columns_summary]

      if (length(pval_colname) == 0) {
        stop("Unable to find a column with p-values in the summary output.")
      }

      return(coeffs[coeff_name, pval_colname])
    }

    if (output_type == "Anova") {
      possible_columns <- c("Pr(>F)", "Pr(>Chisq)", "p.value")
      pval_column <- intersect(colnames(model_summary), possible_columns)

      if (length(pval_column) == 0 || ! (coeff_name %in% rownames(model_summary))) {
        stop(paste("Coefficient", coeff_name, "not found in the Anova summary."))
      }

      pvalue <- model_summary[coeff_name, pval_column]
      return(pvalue[!is.na(pvalue)])  # Filter out NA values
    }

    stop("Unrecognized output type. Please specify 'Summary' or 'Anova'.")
  }

  # Extract p-values for the specified coefficient across all bootstrap iterations
  iteration <- 0
  pvalues <- sapply(bootstrap_results, function(res) {
    iteration <<- iteration + 1
    if(iteration > max_iterations) stop("Maximum iterations reached!")
    if (output_type == "Summary") {
      res <- res$summary
    }
    return(extract_pvalue(res, coeff_name, output_type))
  })

  # Plot a histogram of the p-values
  hist_info <- hist(pvalues, breaks = seq(0, 1, by = 0.05), main = paste("Histogram of p-values for", coeff_name),
                    xlab = "p-value", ylab = "Frequency", col = "#44A2B0", border = "black")
  # Add a dashed vertical line at x = 0.05
  abline(v = 0.05, lty = 2, col = "red")
  # Determine the number of iterations with p < 0.05
  significant_iterations <- sum(pvalues < 0.05)
  # Add the text to the plot
  text(x = 0.8, y = max(hist_info$counts) * 0.9,
       labels = paste("# iterations p < 0.05:", significant_iterations),
       col = "black")
}
