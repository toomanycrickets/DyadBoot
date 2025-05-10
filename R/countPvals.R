#' Count Significant p-values Across Bootstrapped Models
#'
#' This function counts how many times each predictor was statistically significant
#' (e.g., p-value < 0.05) across bootstrapped models. It supports both bootstrapped model summaries
#' (e.g., from `summary(glm())`) and Analysis of Deviance tables (e.g., from `car::Anova()`).
#'
#' @param bootstrap_results A list of model outputs (either `summary()`-based or `Anova()`-based).
#' @param pval_threshold A numeric value indicating the significance threshold (default = 0.05).
#'
#' @return A named numeric vector giving the **count** of iterations where each predictor's p-value was below the threshold.
#'
#' @examples
#' \dontrun{
#' # Using bootstrapped summaries
#' results <- bootstrap_lm(data, y ~ x, 100)
#' sig_counts <- countPvals(results$bootstrap_results)
#'
#' # Using bootstrapped Anova results
#' results <- list()
#' for (i in 1:1000) {
#'   model <- glm(y ~ x1 * x2, data = some_data, family = binomial)
#'   results[[i]] <- car::Anova(model, type = 2)
#' }
#' sig_counts <- countPvals(results)
#' }
#'
#' @export
countPvals <- function(bootstrap_results, pval_threshold = 0.05) {

  # Detect input type: Anova tables vs model summary
  is_anova <- all(sapply(bootstrap_results, function(x)
    inherits(x, "anova") || all(c("Pr(>Chisq)") %in% colnames(x))))

  # Generalized p-value extractor
  extract_pvals <- function(result) {
    if (is_anova) {
      pcol <- grep("Pr\\(", colnames(result), value = TRUE)
      if (length(pcol) == 1) {
        out <- result[, pcol]
        names(out) <- rownames(result)
        return(out)
      } else {
        warning("No p-value column found in Anova result.")
        return(setNames(rep(NA, nrow(result)), rownames(result)))
      }
    } else {
      pcol <- grep("Pr\\(", colnames(result$summary$coefficients), value = TRUE)
      if (length(pcol) == 1) {
        out <- result$summary$coefficients[, pcol]
        names(out) <- rownames(result$summary$coefficients)
        return(out)
      } else {
        warning("No p-value column found in model summary.")
        return(setNames(rep(NA, nrow(result$summary$coefficients)),
                        rownames(result$summary$coefficients)))
      }
    }
  }

  # Extract p-values from each bootstrap iteration
  pval_lists <- lapply(bootstrap_results, extract_pvals)

  # Get the union of all term names (to handle variation across iterations)
  all_terms <- unique(unlist(lapply(pval_lists, names)))

  # Initialize result vector
  count_significant <- setNames(numeric(length(all_terms)), all_terms)

  # Count how often p-values < threshold
  for (term in all_terms) {
    pvals <- sapply(pval_lists, function(pv) {
      if (term %in% names(pv)) {
        return(pv[term])
      } else {
        return(NA)
      }
    })
    count_significant[term] <- sum(pvals < pval_threshold, na.rm = TRUE)
  }

  return(count_significant)
}
