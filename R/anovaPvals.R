#' Extract P-values for a Specified Factor from Anova Results
#'
#' This function extracts p-values for a specific factor from a list of Anova results.
#' It returns a list of numeric p-values for the specified factor, excluding any NA values.
#'
#' @param anova_results A list of Anova results, typically obtained from the `car::Anova()` function.
#' @param factor_name A character string specifying the name of the factor to extract p-values for.
#'
#' @return A list of numeric p-values for the specified factor from each Anova result in the input list.
#'
#' @examples
#' \dontrun{
#' data <- data.frame(dyad_id = rep(1:10, each = 2),
#'                    x = rnorm(20),
#'                    y = rnorm(20))
#' results <- randBoot(data, "dyad_id", y ~ x, model_type = "lm",
#'                     focal_cols = "x", opposite_cols = "y")
#' pvalues <- anovaPvals(results$anova_results, "opposite_group")
#' }
#' @export
anovaPvals <- function(anova_results, factor_name) {
  # Function to extract p-values for a specific factor from a single Anova result
  get_pvalues <- function(anova_res, factor_name) {
    if (!(factor_name %in% rownames(anova_res))) {
      stop(paste("The factor", factor_name, "was not found in the Anova result."))
    }

    # Extract p-values for the specified factor
    possible_columns <- c("Pr(>F)", "Pr(>Chisq)", "p.value")
    pval_column <- intersect(colnames(anova_res), possible_columns)

    if (length(pval_column) == 0) {
      stop("Unable to find a column with p-values in the Anova result.")
    }

    pvalue <- anova_res[factor_name, pval_column]
    return(pvalue[!is.na(pvalue)])  # Filter out NA values
  }

  # Apply the function to each Anova result in the list
  pvalues_list <- lapply(anova_results, get_pvalues, factor_name = factor_name)

  return(pvalues_list)
}
