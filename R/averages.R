#' Calculate Averages and Standard Errors from Bootstrap Results
#'
#' This function calculates the averages and standard errors of coefficients from the results of bootstrapped models.
#'
#' @param bootstrap_results A list of model summaries obtained from bootstrapping.
#' @param max_iterations An integer specifying the maximum number of iterations allowed in the function. This helps in preventing infinite recursion. Default is set to 10000.
#'
#' @return A list containing two matrices: 'averages' with the average values of the coefficients and 'standard_errors' with the standard errors of the coefficients.
#' @export
#'
#' @examples
#' \dontrun{
#' data <- data.frame(y = rnorm(100), x = rnorm(100))
#' results <- bootstrap_lm(data, y ~ x, 100)
#' avg_se <- averages(results)
#' }
averages <- function(bootstrap_results, max_iterations = 10000) {
  # ... [rest of the function code]
}


averages <- function(bootstrap_results, max_iterations = 10000) {

  # Helper function to extract the coefficients from a model summary
  extract_coefficients <- function(model_summary) {
    return(model_summary$coefficients)
  }

  # Helper function to compute standard error for each coefficient metric
  compute_se_coefficients <- function(coeff_lists, coeff_names, metrics_names) {
    se_matrix <- matrix(0, nrow = length(coeff_names), ncol = length(metrics_names))
    rownames(se_matrix) <- coeff_names
    colnames(se_matrix) <- metrics_names

    for (coeff in coeff_names) {
      for (metric in metrics_names) {
        iteration <- 0
        values <- sapply(coeff_lists, function(x) {
          iteration <<- iteration + 1
          if(iteration > max_iterations) stop("Maximum iterations reached!")
          return(x[coeff, metric])
        })
        se_matrix[coeff, metric] <- sd(values, na.rm = TRUE) / sqrt(length(values))
      }
    }

    return(se_matrix)
  }

  # Extract full coefficient tables from each summary and store them in a list
  coeff_lists <- lapply(bootstrap_results, function(res) {
    return(extract_coefficients(res$summary))
  })

  # Infer the coefficient names and metrics names from the first bootstrap result
  coeff_names <- rownames(coeff_lists[[1]])
  metrics_names <- colnames(coeff_lists[[1]])

  # Create matrices to store averages and SE
  average_matrix <- matrix(0, nrow = length(coeff_names), ncol = length(metrics_names))
  se_matrix <- matrix(0, nrow = length(coeff_names), ncol = length(metrics_names))

  rownames(average_matrix) <- coeff_names
  colnames(average_matrix) <- metrics_names
  rownames(se_matrix) <- coeff_names
  colnames(se_matrix) <- metrics_names

  # Populate the average_matrix with average values
  for (coeff in coeff_names) {
    for (metric in metrics_names) {
      average_matrix[coeff, metric] <- mean(sapply(coeff_lists, function(x) x[coeff, metric]), na.rm = TRUE)
    }
  }

  # Populate the se_matrix with standard error values
  se_matrix <- compute_se_coefficients(coeff_lists, coeff_names, metrics_names)

  return(list(averages = average_matrix, standard_errors = se_matrix))
}
