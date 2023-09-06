#' Multiple Random Dyad Assignments
#'
#' This function takes a dataset and, based on dyad identifiers, randomly assigns roles of "focal"
#' and "opposite" to each dyad. It repeats this process for a specified number of iterations.
#'
#' @param data A data frame containing the original dataset.
#' @param dyad_id_col The name of the column in the data that contains the dyad identifiers.
#' @param num_iterations An integer specifying the number of iterations for the random assignment. Default is 1.
#' @param max_iterations An integer specifying the maximum number of allowed iterations. Default is 10000.
#'
#' @return A list containing:
#' \itemize{
#'   \item \code{results_list}: A list of data frames, each representing an iteration of the random assignments.
#' }
#'
#' @examples
#' \dontrun{
#' result <- randMult(my_data, "dyad_column")
#' }
#'
#' @export
randMult <- function(data, dyad_id_col, num_iterations = 1, max_iterations = 10000) {
  # Function body remains unchanged
}

randMult <- function(data, dyad_id_col, num_iterations = 1, max_iterations = 10000) {
  # Use a counter to track the number of function calls
  if (!exists(".dyad_rand_counter")) {
    .dyad_rand_counter <<- 0
  }

  .dyad_rand_counter <<- .dyad_rand_counter + 1

  if (.dyad_rand_counter > max_iterations) {
    stop("Maximum number of allowed iterations reached!")
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

  # List to store results of each iteration
  results_list <- list()

  # Loop for the specified number of iterations
  for(i in 1:num_iterations) {
    # Call the function to create the data
    focal_opposite_data <- create_focal_opposite_data(dyad_groups)

    # Store the result in the list
    results_list[[i]] <- focal_opposite_data
  }

  return(list(results_list = results_list))
}
