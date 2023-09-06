#' Randomized Bootstrap Function
#'
#' This function performs a randomized bootstrap analysis on dyadic data.
#' It returns both bootstrap model results and ANOVA results.
#'
#' @param data A data frame containing the dyadic data.
#' @param dyad_id_col A character string specifying the column name which identifies the dyad.
#' @param model_formula A formula specifying the model to be run.
#' @param model_type A character string specifying the type of model. One of "lm", "glm", "lmer", or "glmer".
#' @param family A family object passed to glm or glmer, if applicable.
#' @param n_bootstraps An integer specifying the number of bootstraps to run. Default is 1000.
#' @param focal_cols A character vector of column names for the focal individual.
#' @param opposite_cols A character vector of column names for the opposite individual.
#' @param RE_formula A formula specifying the random effects, if using a mixed-effects model.
#' @param control Control arguments passed to lmer or glmer.
#' @param max_iterations An integer specifying the maximum number of iterations. Default is 10000.
#' @param max_time_seconds An integer specifying the maximum execution time in seconds. Default is 3600.
#'
#' @return A list containing two lists:
#' \itemize{
#'   \item bootstrap_results: A list of models and their summaries for each bootstrap iteration.
#'   \item anova_results: A list of ANOVA results for each model.
#' }
#'
#' @examples
#' \dontrun{
#' data <- data.frame(dyad_id = rep(1:10, each = 2),
#'                    x = rnorm(20),
#'                    y = rnorm(20))
#' results <- randBoot(data, "dyad_id", y ~ x, model_type = "lm",
#'                     focal_cols = "x", opposite_cols = "y")
#' }
#' @export
randBoot <- function(data, dyad_id_col, model_formula,
                     model_type = "lm", family = NULL,
                     n_bootstraps = 1000,
                     focal_cols, opposite_cols,
                     RE_formula = NULL, control = NULL,
                     max_iterations = 10000, # New parameter
                     max_time_seconds = 3600) { # New parameter: max execution time in seconds
  # ... [rest of the function code]
}

randBoot <- function(data, dyad_id_col, model_formula,
                     model_type = "lm", family = NULL,
                     n_bootstraps = 1000,
                     focal_cols, opposite_cols,
                     RE_formula = NULL, control = NULL,
                     max_iterations = 10000, # New parameter
                     max_time_seconds = 3600) { # New parameter: max execution time in seconds

  start_time <- Sys.time() # Record the starting time

  # Ensure the car package is loaded
  if (!requireNamespace("car", quietly = TRUE)) {
    stop("The 'car' package is required for Anova analysis. Please install it using install.packages('car').")
  }

  # Check for valid focal_cols and opposite_cols
  if (!all(focal_cols %in% colnames(data))) {
    stop("Some of the focal_cols are not found in the provided data.")
  }

  if (!all(opposite_cols %in% colnames(data))) {
    stop("Some of the opposite_cols are not found in the provided data.")
  }

  # Split data by dyad
  dyad_groups <- split(data, data[[dyad_id_col]])

  # Function to create focal and opposite data
  create_focal_opposite_data <- function(dyad_groups) {
    focal_opposite_data_list <- lapply(dyad_groups, function(dyad) {
      # Shuffle dyad members to randomly assign roles
      shuffled_dyad <- dyad[sample(1:2), ]

      # Create a new data frame with 'focal' and 'opposite' columns
      focal_data <- shuffled_dyad[1, , drop = FALSE]
      colnames(focal_data) <- paste0("focal_", colnames(focal_data))

      opposite_data <- shuffled_dyad[2, , drop = FALSE]
      colnames(opposite_data) <- paste0("opposite_", colnames(opposite_data))

      # Combine the data into a single row
      combined_data <- cbind(focal_data, opposite_data)
      return(combined_data)
    })

    # Combine all dyads back into a single data frame
    focal_opposite_data <- do.call(rbind, focal_opposite_data_list)
    return(focal_opposite_data)
  }

  # Bootstrap function
  bootstrap_glmp <- function(dyad_groups, n_bootstraps = 1000) {
    bootstrapped_results <- vector("list", length = n_bootstraps)
    anova_results <- vector("list", length = n_bootstraps)

    iteration_count <- 0 # Initialize the iteration counter

    for (i in 1:n_bootstraps) {

      # Check if maximum iterations or maximum time has been reached
      iteration_count <- iteration_count + 1
      if (iteration_count > max_iterations) {
        stop("Maximum iteration limit reached.")
      }
      if (difftime(Sys.time(), start_time, units = "secs") > max_time_seconds) {
        stop("Maximum execution time limit reached.")
      }

      focal_opposite_data <- create_focal_opposite_data(dyad_groups)

      model <- NULL  # Reset the model object for each iteration

      # Determine which model to run based on model_type
      if (model_type == "lm") {
        model <- lm(model_formula, data = focal_opposite_data)
      } else if (model_type == "glm") {
        if (is.null(family)) stop("Please specify a family for the glm model.")
        model <- glm(model_formula, data = focal_opposite_data, family = family)
      } else if (model_type == "lmer") {
        if (!requireNamespace("lme4", quietly = TRUE)) {
          stop("The 'lme4' package is required for mixed-effects models. Please install it using install.packages('lme4').")
        }
        if (is.null(RE_formula)) stop("Please specify random effects for the lmer model.")
        full_formula <- update(model_formula, . ~ . + (RE_formula))
        model <- lme4::lmer(full_formula, data = focal_opposite_data, control = control)
      } else if (model_type == "glmer") {
        if (!requireNamespace("lme4", quietly = TRUE)) {
          stop("The 'lme4' package is required for mixed-effects models. Please install it using install.packages('lme4').")
        }
        if (is.null(family)) stop("Please specify a family for the glmer model.")
        if (is.null(RE_formula)) stop("Please specify random effects for the glmer model.")
        full_formula <- update(model_formula, . ~ . + (RE_formula))
        model <- lme4::glmer(full_formula, data = focal_opposite_data, family = family, control = control)
      } else {
        stop("Invalid model_type specified. Choose 'lm', 'glm', 'lmer', or 'glmer'.")
      }

      if (!is.null(model)) {
        bootstrapped_results[[i]] <- list(model = model, summary = summary(model))
        anova_results[[i]] <- car::Anova(model)
      }
    }

    return(list(bootstrap_results = bootstrapped_results, anova_results = anova_results))
  }

  return(bootstrap_glmp(dyad_groups, n_bootstraps))
}
