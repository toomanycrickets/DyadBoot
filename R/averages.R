#' Calculate Averages and Standard Errors from Bootstrap Results or Anova Tables
#'
#' This function calculates the averages and standard errors of coefficients or test statistics
#' from the results of bootstrapped models. It supports both model summaries (e.g., from `summary(lm())`)
#' and Analysis of Deviance tables (e.g., from `car::Anova()`).
#'
#' @param bootstrap_results A list of model summaries or Anova tables obtained from bootstrapping.
#' @param max_iterations An integer specifying the maximum number of iterations allowed in the function. This helps in preventing infinite recursion. Default is 10000.
#'
#' @return A list containing two matrices: 'averages' with the average values of the coefficients or test statistics,
#' and 'standard_errors' with the corresponding standard errors.
#' 
#' @examples
#' \dontrun{
#' # For bootstrapped model summaries
#' data <- data.frame(y = rnorm(100), x = rnorm(100))
#' results <- bootstrap_lm(data, y ~ x, 100)
#' avg_se <- averages(results$bootstrap_results)
#'
#' # For bootstrapped Anova results
#' results <- list()
#' for (i in 1:1000) {
#'   model <- glm(y ~ x1 * x2, data = some_data, family = binomial)
#'   results[[i]] <- car::Anova(model, type = 2)
#' }
#' avg_se <- averages(results)
#' }
#'
#' @export
averages <- function(bootstrap_results, max_iterations = 10000) {

  # Detect input type: summary coefficients vs Anova tables
  is_anova <- all(sapply(bootstrap_results, function(x)
    inherits(x, "anova") || all(c("LR Chisq", "Pr(>Chisq)") %in% colnames(x))))

  # Generalized extractor: extracts the matrix from either type
  extract_matrix <- function(result) {
    if (is_anova) {
      return(result)
    } else {
      return(result$summary$coefficients)
    }
  }

  # Extract all term/statistic tables
  term_lists <- lapply(bootstrap_results, function(res) extract_matrix(res))

  # Infer row and column names from the first iteration
  term_names <- rownames(term_lists[[1]])
  metric_names <- colnames(term_lists[[1]])

  # Initialize matrices for output
  average_matrix <- matrix(0, nrow = length(term_names), ncol = length(metric_names))
  se_matrix <- matrix(0, nrow = length(term_names), ncol = length(metric_names))
  rownames(average_matrix) <- term_names
  colnames(average_matrix) <- metric_names
  rownames(se_matrix) <- term_names
  colnames(se_matrix) <- metric_names

  # Fill the average and SE matrices
  for (term in term_names) {
    for (metric in metric_names) {
      iteration <- 0
      values <- sapply(term_lists, function(x) {
        iteration <<- iteration + 1
        if (iteration > max_iterations) stop("Maximum iterations reached!")
        return(x[term, metric])
      })
      average_matrix[term, metric] <- mean(values, na.rm = TRUE)
      se_matrix[term, metric] <- sd(values, na.rm = TRUE) / sqrt(sum(!is.na(values)))
    }
  }

  return(list(averages = average_matrix, standard_errors = se_matrix))
}
