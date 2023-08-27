#' Bootstrap Random Dyad Data and Model
#'
#' This function bootstraps dyad data by randomly assigning roles to the members
#' of each dyad and then fits the specified model to the bootstrapped data.
#'
#' @param data A data frame containing the dyad data.
#' @param dyad_id_col The column name in the data frame that identifies dyads.
#' @param model_formula The formula for the model to be fit.
#' @param model_type The type of model to be fit. This can be one of 'lm', 'glm', 'lmer', or 'glmer'.
#' @param family For 'glm' and 'glmer' models, the family object describing the error distribution and link function.
#' @param n_bootstraps The number of bootstrap iterations.
#' @param focal_cols The columns in the data that pertain to the focal member of the dyad.
#' @param opposite_cols The columns in the data that pertain to the opposite member of the dyad.
#' @param RE_formula The random effects formula for 'lmer' and 'glmer' models.
#' @param control A list of control parameters for 'lmer' and 'glmer' models.
#' @param max_iterations The maximum number of iterations allowed for the bootstrap process (default is 10,000).
#' @param max_time_seconds The maximum execution time in seconds allowed for the bootstrap process (default is 3,600 seconds or 1 hour).
#'
#' @return A list containing the bootstrapped model results for each iteration.
#'
#' @examples
#' \dontrun{
#' data <- data.frame(dyad_id = rep(1:50, each = 2), x = rnorm(100), y = rnorm(100))
#' result <- randboot(data, dyad_id_col = "dyad_id", model_formula = y ~ x, model_type = "lm",
#'                          focal_cols = "x", opposite_cols = "y")
#' }
#'
#' @export
randboot <- function(data, dyad_id_col, model_formula,
                           model_type = "lm", family = NULL,
                           n_bootstraps = 1000,
                           focal_cols, opposite_cols,
                           RE_formula = NULL, control = NULL,
                           max_iterations = 10000, # New parameter
                           max_time_seconds = 3600) {
  # ... [rest of the function code]
}


randboot <- function(data, dyad_id_col, model_formula,
                           model_type = "lm", family = NULL,
                           n_bootstraps = 1000,
                           focal_cols, opposite_cols,
                           RE_formula = NULL, control = NULL,
                           max_iterations = 10000, # New parameter
                           max_time_seconds = 3600) { # New parameter: max execution time in seconds

  start_time <- Sys.time() # Record the starting time

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

      bootstrapped_results[[i]] <- list(model = model, summary = summary(model))
    }

    return(bootstrapped_results)
  }

  # Ensure warnings from underlying functions are displayed immediately
  results <- withCallingHandlers({
    bootstrap_glmp(dyad_groups, n_bootstraps = n_bootstraps)
  }, warning = function(w) {
    # Print warnings immediately
    print(w)
    invokeRestart("muffleWarning")
  })

  return(list(bootstrap_results = results))
}
